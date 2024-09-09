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
    public function search(Request $request)
    {
        $tab = [
            'top' => (int) $request->post('top'),
            'latest' => (int) $request->post('latest'),
            'people' => (int) $request->post('people'),
            'photos' => (int) $request->post('photos'),
            'videos' => (int) $request->post('videos'),
        ];
        $filterParams = $this->processFilterParams($request);
        $searchTerm = $filterParams['searchTerm'];
        $postsFilter = $filterParams['postsFilter'];
        $mediaType = $filterParams['mediaType'];
        $sortOrder = $filterParams['sortOrder'];
        $userQuery = User::query();
        $postQuery = Post::query();
        $streamQuery = Stream::query();
        $this->applyUserFilters($userQuery, $request);
        if ($searchTerm) {
            $userQuery->where(function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%")
                  ->orWhere('email', 'like', "%{$searchTerm}%");
            });
        }
        if ($postsFilter === 'top' || $postsFilter === 'latest') {
            $postQuery->orderBy('created_at', 'desc');
        }
        if ($mediaType) {
            $postQuery->where('media_type', $mediaType);
        }
        $users = $userQuery->get();
        $streams = $streamQuery->get();
        $startPage = PostsHelperServiceProvider::getFeedStartPage(PostsHelperServiceProvider::getPrevPage($request));
        $posts = PostsHelperServiceProvider::getFeedPosts(
            Auth::user()->id,
            false,
            $startPage,
            $mediaType,
            $sortOrder,
            $searchTerm
        );
        PostsHelperServiceProvider::shouldDeletePaginationCookie($request);
        $formattedPosts = $posts->map(function ($post) {
            return [
                'username' => $post->user->name,
                'postContent' => $post->content,
                'timestamp' => $post->created_at->diffForHumans(),
                'likes' => $post->likes_count,
                'comments' => $post->comments_count,
                'tips' => $post->tips_count,
            ];
        });
        return response()->json([
            'status' => '200',
            'availableFilters' => ['top', 'latest', 'people', 'photos', 'videos'],
            'data' => $formattedPosts,
            'streams' => $streams,
            'activeFilter' => $postsFilter,
        ]);
    }   
    protected function processFilterParams(Request $request)
    {
        $searchTerm = $request->get('query') ?: false;
        $postsFilter = $request->get('filter') ?: false;
    
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
                $mediaType = false;
                $sortOrder = 'top';
                break;
            case 'latest':
            case 'live':
                $mediaType = false;
                $sortOrder = 'latest';
                break;
        }
    
        return [
            'searchTerm' => $searchTerm,
            'postsFilter' => $postsFilter,
            'mediaType' => $mediaType,
            'sortOrder' => $sortOrder,
        ];
    }
    
    protected function applyUserFilters($query, Request $request)
    {
        if ($gender = $request->query('gender')) {
            if ($gender != 'all') {
                $query->where('gender', $gender);
            }
        }
        if ($minAge = $request->query('minAge')) {
            $query->where('age', '>=', $minAge);
        }
        if ($maxAge = $request->query('maxAge')) {
            $query->where('age', '<=', $maxAge);
        }
        if ($location = $request->query('location')) {
            $query->where('location', 'like', "%{$location}%");
        }
    }
    public function search_people($id)
    {
         $user = User::find($id);

         if (!$user) {
             return response()->json(['error' => 'User not found'], 404);
         }
         $response = [
             'name' => $user->name,
             'username' => $user->username,
             'avatar' => $user->avatar,
             'bio' => $user->bio ?: 'No description available.',
             'email_verified' => (bool)$user->email_verified_at,
             'verified' => $user->verification && $user->verification->status == 'verified'
         ];
 
         return response()->json([
            'status' => 200,
            'data' => $response,
        ]);
    } 
   

    public function search_top(Request $request)
    {
        $postsFilter = $request->input('postsFilter', 'top');
        $searchTerm = $request->input('searchTerm', '');
        $filters = $this->processFilterParams($request);
        $filters['postsFilter'] = $postsFilter;
    
        // Validate filter
        if ($filters['postsFilter'] !== 'top') {
            return response()->json([
                'status' => 400,
                'message' => 'Invalid filter. Only "top" filter is supported.',
            ]);
        }
    
        // Proceed with the valid filter
        $startPage = PostsHelperServiceProvider::getFeedStartPage(
            PostsHelperServiceProvider::getPrevPage($request)
        );
        $userId = $request->user()->id;
        return $userId;
        $posts = PostsHelperServiceProvider::getFeedPosts(
            $userId, 
            false, 
            $startPage, 
            $filters['mediaType'] ?? null,
            $filters['sortOrder'] ?? null,
            $searchTerm
        );
    
        $topData = $this->fetchTopData($filters);
    
        return response()->json([
            'status' => 200,
            'data' => $topData,
            'filters' => $filters,
        ]);
    }
    public function search_latest(Request $request)
    {
        $sortOrder = $request->query('sortOrder', 'desc');
        $searchTerm = $request->query('searchTerm', ''); 

        $startPage = PostsHelperServiceProvider::getFeedStartPage(PostsHelperServiceProvider::getPrevPage($request));
        $posts = PostsHelperServiceProvider::getFeedPosts(Auth::user()->id, false, $startPage, false, $sortOrder, $searchTerm);
        PostsHelperServiceProvider::shouldDeletePaginationCookie($request);

        $jsData = [
            'paginatorConfig' => [
                'next_page_url' => str_replace('/search', '/search/posts', $posts->nextPageUrl()),
                'prev_page_url' => str_replace('/search', '/search/posts', $posts->previousPageUrl()),
                'current_page' => $posts->currentPage(),
                'total' => $posts->total(),
                'per_page' => $posts->perPage(),
                'hasMore' => $posts->hasMorePages(),
            ],
            'initialPostIDs' => $posts->pluck('id')->toArray(),
            'searchType' => 'feed'
        ];

        return response()->json([
            'posts' => $posts,
            'jsData' => $jsData
        ]);
    }
}
