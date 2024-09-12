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
        $searchTerm = $request->post('query');
        $postsFilter = $request->post('filter');
        $mediaType = 'image';
        if ($postsFilter == 'videos') {
            $mediaType = 'video';
        }
        if ($postsFilter == 'photos') {
            $mediaType = 'image';
        }

        $sortOrder = '';
        if ($postsFilter == 'top') {
            $mediaType = false;
            $sortOrder = 'top';
        }
        if ($postsFilter == 'latest' || $postsFilter === 'live') {
            $mediaType = false;
            $sortOrder = 'latest';
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
        $jsData = $viewData = [];
        $filters = $this->processFilterParams($request);
        $users = user::all();
        $posts = post::all();
        $viewData = $users->map(function ($user) {
            return [
                'name' => $user->name,
                'username' => $user->username,
                'bio' => $user->bio,
                'avatar' => $user->avatar,
                'description' => $user->description ?? 'No description available.'
            ];
        });
    
        return response()->json([
            'status' => 200,
            'users' => $viewData,
            'posts' => $posts,
            'searchTerm' => $filters['searchTerm'],
            'availableFilters' => $this->filters,
            'activeFilter' => $filters['postsFilter'],
        ]);
    }
    /*{
        $jsData = $viewData = [];
        $filters = $this->processFilterParams($request);

        if (!Auth::check() && $filters['postsFilter'] && $filters['postsFilter'] !== 'people') {
            return response()->json([
                'status' => 400,
                'message' => 'Authentication required for this filter.'
            ]);
        }
        if (!$filters['postsFilter'] && !Auth::check()) {
            $filters['postsFilter'] = 'people';
        }
        if (!Auth::check()) {
            $this->filters = ['people'];
        }
        if($filters['postsFilter'] == 'people'){

            $users = MembersHelperServiceProvider::getSearchUsers(array_merge(['searchTerm' => $filters['searchTerm']]));
            $jsData = [
                'paginatorConfig' => [
                    'next_page_url' => str_replace('/search', '/search/users', $users->nextPageUrl()),
                    'prev_page_url' => str_replace('/search', '/search/users', $users->previousPageUrl()),
                    'current_page' => $users->currentPage(),
                    'total' => $users->total(),
                    'per_page' => $users->perPage(),
                    'hasMore' => $users->hasMorePages(),
                ],
                'searchType' => 'people'
            ];
         
            $viewData = $users->map(function ($user) {
                return [
                    'name' => $user->name,
                    'username' => $user->username,
                    'bio' => $user->bio,
                    'avatar' => $user->avatar,
                    'description' => $user->description ?? 'No description available.'
                ];
            });
        } elseif ($filters['postsFilter'] === 'live') {
            $streams = StreamsServiceProvider::getPublicStreams([
                'searchTerm' => $filters['searchTerm'],
                'status' => 'live'
            ]);
            $viewData = [
                'streams' => $streams,
                'searchFilterExpanded' => false
            ];
        } else {
            $startPage = PostsHelperServiceProvider::getFeedStartPage(PostsHelperServiceProvider::getPrevPage($request));
            $posts = PostsHelperServiceProvider::getFeedPosts(
                Auth::user()->id,
                false,
                $startPage,
                $filters['mediaType'],
                $filters['sortOrder'],
                $filters['searchTerm']
            );
            PostsHelperServiceProvider::shouldDeletePaginationCookie($request);
            $viewData = ['posts' => $posts];
        }
        return response()->json([
            'status' => 200,
            'data' => $viewData,
            'searchTerm' => $filters['searchTerm'],
            'availableFilters' => $this->filters,
            'activeFilter' => $filters['postsFilter'],
        ]);
    }*/
}