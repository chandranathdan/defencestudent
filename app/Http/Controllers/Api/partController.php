<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\ProfileUploadRequest;
use App\Http\Requests\UpdateUserFlagSettingsRequest;
use App\Http\Requests\UpdateUserProfileSettingsRequest;
use App\Http\Requests\UpdateUserRatesSettingsRequest;
use App\Http\Requests\UpdateUserSettingsRequest;
use App\Http\Requests\VerifyProfileAssetsRequest;
use App\Http\Requests\VerifyTwoFactorCodeRequest;
use App\Model\Attachment;
use App\Model\UserList;
use App\Model\UserListMember;
use App\Model\Country;
use App\Model\CreatorOffer;
use App\Model\ReferralCodeUsage;
use App\Model\Subscription;
use App\Model\Transaction;
use App\Model\UserDevice;
use App\Model\UserVerify;
use App\Providers\AttachmentServiceProvider;
use App\Providers\AuthServiceProvider;
use App\Providers\EmailsServiceProvider;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\SettingsServiceProvider; 
use App\Providers\StreamsServiceProvider;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\MembersHelperServiceProvider;
use App\Model\UserCode;
use App\Model\Post;
use App\Model\UserGender;
use App\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Illuminate\Support\Facades\Validator; 
use App\Model\Stream;
use App\Rules\MatchOldPassword;
use JavaScript;
use Jenssegers\Agent\Agent;
use Ramsey\Uuid\Uuid;

class SearchController extends Controller
{
    public $filters = [
        'live',
        'top',
        'latest',
        'photos',
        'videos',
        'people',
    ];

    protected function processFilterParams($request)
    {
        $searchTerm = $request->input('query');
        $postsFilter = $request->get('filter', 'people');

        $mediaType = 'image';
        $sortOrder = '';

        switch ($postsFilter) {
            case 'videos':
                $mediaType = 'video';
                break;
            case 'photos':
                $mediaType = 'image';
                break;
            case 'top':
            case 'latest':
            case 'live':
                $sortOrder = $postsFilter;
                $mediaType = false;
                break;
        }

        return [
            'searchTerm' => $searchTerm,
            'postsFilter' => $postsFilter,
            'mediaType' => $mediaType,
            'sortOrder' => $sortOrder
        ];
    }

    public function search(Request $request)
    {
        if (!Auth::check()) {
            return response()->json(['status' => 401, 'message' => 'Unauthorized'], 401);
        }
    
        $userID = Auth::id();
        $activeFilters = [
            'people' => (int) $request->post('people'),
            'latest' => (int) $request->post('latest'),
            'top' => (int) $request->post('top'),
            'photos' => (int) $request->post('photos'),
            'videos' => (int) $request->post('videos'),
            'postsFilter' => $request->post('postsFilter', 'people'),
        ];
    
        $filters = $this->processFilterParams($request);
    
        // Prepare the response data
        $responseData = [
            'people' => [],
            'top' => [],
            'latest' => [],
            'photos' => [],
            'videos' => [],
        ];
    
        // Fetch users if the people filter is active
        $userIds = [];
        if ($activeFilters['people']) {
            $users = MembersHelperServiceProvider::getSearchUsers(['searchTerm' => $filters['searchTerm']]);
            $userIds = $users->pluck('id')->toArray();
            $responseData['people'] = $users->map(function ($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'username' => $user->username,
                    'bio' => $user->bio,
                    'avatar' => $user->avatar,
                ];
            });
        }
    
        // Start the posts query
        $postsQuery = Post::with('user', 'attachments');
        $perPage = 6; // Number of posts per page
        $page = $request->post('page', 1);
        $offset = ($page - 1) * $perPage; 
    
        $activeType = array_keys($activeFilters, 1, true);
    
        // Apply filters based on postsFilter
        switch ($filters['postsFilter']) {
            case 'following':
            case 'all':
                $postsQuery->join('user_list_members as following', function ($join) use ($userID) {
                    $join->on('following.user_id', '=', 'posts.user_id');
                    $join->on('following.list_id', '=', DB::raw(Auth::user()->lists->firstWhere('type', 'following')->id));
                });
                break;
            case 'blocked':
            case 'all':
                $blockedUsers = ListsHelperServiceProvider::getListMembers(Auth::user()->lists->firstWhere('type', 'blocked')->id);
                $postsQuery->whereNotIn('posts.user_id', $blockedUsers);
                break;
            case 'subs':
            case 'all':
                $userIds = array_merge(self::getUserActiveSubs($userID), self::getFreeFollowingProfiles($userID));
                $postsQuery->whereIn('posts.user_id', $userIds);
                break;
            case 'bookmarks':
                $postsQuery->join('user_bookmarks', function ($join) use ($userID) {
                    $join->on('user_bookmarks.post_id', '=', 'posts.id');
                    $join->on('user_bookmarks.user_id', '=', DB::raw($userID));
                });
                break;
            case 'search':
                $postsQuery->where(function ($query) use ($filters) {
                    $query->where('text', 'like', '%' . $filters['searchTerm'] . '%')
                          ->orWhereHas('user', function ($q) use ($filters) {
                              $q->where('username', 'like', '%' . $filters['searchTerm'] . '%')
                                ->orWhere('name', 'like', '%' . $filters['searchTerm'] . '%');
                          });
                });
                break;
            case 'pinned':
                $postsQuery->orderBy('is_pinned', 'DESC');
                break;
            case 'scheduled':
                $postsQuery->notExpiredAndReleased();
                break;
            case 'approvedPostsOnly':
                if (!(Auth::check() && (Auth::user()->role_id === 1))) {
                    $postsQuery->where('status', Post::APPROVED_STATUS);
                }
                break;
        }
    
        // Sorting and other filters
        if ($userIds) {
            $postsQuery->whereIn('user_id', $userIds);
    
            // If the sort order is set, apply the appropriate sorting
            if ($filters['sortOrder']) {
                if ($filters['sortOrder'] === 'top') {
                    $postsQuery->withCount('reactions','desc');
                } elseif ($filters['sortOrder'] === 'latest') {
                    $postsQuery->orderBy('created_at', 'desc');
                }
            } else {
                $postsQuery->orderBy('created_at', 'desc');
            }
    
            // Paginate the results
            $posts = $postsQuery->paginate($perPage)->withQueryString();
    
            // Populate the response data for 'top', 'latest', 'photos', and 'videos'
            if ($activeFilters['top']) {
                $responseData['top'] = $posts->getCollection()->map(function ($post) {
                    return $this->formatPostData($post);
                });
            }
    
            if ($activeFilters['latest']) {
                $responseData['latest'] = $posts->getCollection()->map(function ($post) {
                    return $this->formatPostData($post);
                });
            }
    
            if ($activeFilters['photos']) {
                $responseData['photos'] = $posts->getCollection()->filter(function ($post) {
                    return $post->attachments->contains(function ($attachment) {
                        return in_array(pathinfo($attachment, PATHINFO_EXTENSION), ['jpg', 'png', 'gif']);
                    });
                })->map(function ($post) {
                    return $this->formatPostData($post);
                });
            }
    
            if ($activeFilters['videos']) {
                $responseData['videos'] = $posts->getCollection()->filter(function ($post) {
                    return $post->attachments->contains(function ($attachment) {
                        return in_array(pathinfo($attachment, PATHINFO_EXTENSION), ['mp4', 'mov', 'avi']);
                    });
                })->map(function ($post) {
                    return $this->formatPostData($post);
                });
            }
        }
    
        return response()->json([
            'status' => 200,
            'data' => $responseData,
            'searchTerm' => $filters['searchTerm'],
            'activeFilter' => $filters['postsFilter'],
        ]);
    }

    protected function formatPostData($post)
    {
        return [
            'name' => $post->user->name,
            'username' => $post->user->username,
            'avatar' => $post->user->avatar,
            'bio' => $post->user->bio,
            'attachments' => $post->attachments->pluck('filename'),
            'likesCount' => $post->reactions()->where('reaction_type', 'like')->count(),
            'commentsCount' => $post->comments()->count(),
            'created_at' => $post->created_at->diffForHumans(),
        ];
    }
}