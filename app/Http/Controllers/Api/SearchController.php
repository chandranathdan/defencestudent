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
        $gender = $request->query('gender', 'all');
        $minAge = $request->query('min_age');
        $maxAge = $request->query('max_age');
        $location = $request->query('location');
        $searchTerm = $request->query('query');
        $filter = $request->query('filter', 'top');
        $userQuery = User::query();
        $postQuery = Post::query();
        $streamQuery = Stream::query();
        if ($gender && $gender != 'all') {
            $userQuery->where('gender', $gender);
        }
        if ($minAge) {
            $userQuery->where('age', '>=', $minAge);
        }
        if ($maxAge) {
            $userQuery->where('age', '<=', $maxAge);
        }
        if ($location) {
            $userQuery->where('location', 'like', "%{$location}%");
        }
        if ($searchTerm) {
            $userQuery->where(function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%")
                  ->orWhere('email', 'like', "%{$searchTerm}%");
            });
        }

        if ($filter == 'top') {
            $postQuery->orderBy('created_at', 'desc');
        }

        $users = $userQuery->get();
        $posts = $postQuery->get(); 
        $streams = $streamQuery->get();
        return response()->json([
            'status' => '200',
            'availableFilters' => ['live', 'top', 'latest', 'people', 'photos', 'videos'] ,
            'results' => $users,
            'posts' => $posts,
            'streams' => $streams,
            'searchFilters' => $request->all(),
            'genders' => UserGender::all(),
            'searchTerm' => $searchTerm,
            'activeFilter' => $filter,
        ]);
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
 
         return response()->json($response);
    }
    
    public function search_top(Request $request)
    {
        $page = $request->query('page', 1);
        $previousPage = $page > 1 ? $page - 1 : null;
        $posts = Post::with('user')
            ->orderBy('created_at', 'desc')
            ->paginate(10, ['*'], 'page', $page);
        $hasPosts = $posts->count() > 0;
        return response()->json([
            'posts' => $posts->items(),
            'pagination' => [
                'current_page' => $posts->currentPage(),
                'last_page' => $posts->lastPage(),
                'has_more' => $posts->hasMorePages(),
                'previous_page' => $previousPage
            ],
            'has_posts' => $hasPosts
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
