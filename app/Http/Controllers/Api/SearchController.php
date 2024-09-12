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
        $searchTerm = $request->input('query', '');
        $postsFilter = $request->get('filter', 'people');
       
        $mediaType = 'image';
        if($postsFilter == 'videos'){
            $mediaType = 'video';
        }
        if($postsFilter == 'photos'){
            $mediaType = 'image';
        }
        $sortOrder = '';
        if($postsFilter == 'top'){
            $mediaType = false;
            $sortOrder = 'top';
        }
        if($postsFilter == 'latest'){
            $mediaType = false;
            $sortOrder = 'latest';
        }
        if($postsFilter == 'live') {
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
        $filters = $this->processFilterParams($request);
        $viewData = [];
        $topData = [];
        $latestData = [];
        $photosData = [];
        $videoData = [];
        if ($filters['postsFilter'] == 'people') {
            $users = MembersHelperServiceProvider::getSearchUsers([
                'searchTerm' => $filters['searchTerm'],
            ]);
            $viewData = $users->map(function ($user) {
                return [
                    'name' => $user->name,
                    'username' => $user->username,
                    'bio' => $user->bio,
                    'avatar' => $user->avatar,
                ];
            });
        }
        $posts = Post::all();
        $formatPostData = function ($post) {
            return [
                'name' => $post->user->name,
                'username' => $post->user->username,
                'avatar' =>$post->user->avatar,
                'bio' => $post->user->bio,
                'likesCount' => $post->likes_count,
                'createdAt' => $post->created_at->diffForHumans(),
            ];
        };
        $topData = $posts->map($formatPostData);
        $latestData = $posts->map($formatPostData);
        $photosData = $posts->filter(function ($post) {
            return $post->media_type === 'photo';
        })->map($formatPostData);
        $videoData = $posts->filter(function ($post) {
            return $post->media_type === 'video';
        })->map($formatPostData);
   
        return response()->json([
            'status' => 200,
            'data' => [
                'people' => $viewData,
                'top' => $topData,
                'lateast' => $latestData, 
                'phots' => $photosData,
                'vedio' => $videoData,
            ],
            'searchTerm' => $filters['searchTerm'],
            'activeFilter' => $filters['postsFilter'],
        ]);
    }
}