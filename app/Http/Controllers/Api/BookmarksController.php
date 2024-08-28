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
use Cookie;

class BookmarksController extends Controller
{
    public function bookmarks_all (Request $request)
    {
        $user = Auth::user();
        if (!$user) {
            return response()->json([
                'status' => '401',
                'message' => 'Unauthorized',
            ], 401);
        }
        $startPage = PostsHelperServiceProvider::getFeedStartPage(PostsHelperServiceProvider::getPrevPage($request));
        $type = AttachmentServiceProvider::getActualTypeByBookmarkCategory($request->route('type'));
        $posts = PostsHelperServiceProvider::getUserBookmarks($user->id, false, $startPage, $type);
        $bookmarks = PostsHelperServiceProvider::getUserBookmarks($user->id, true, false, $type);
        PostsHelperServiceProvider::shouldDeletePaginationCookie($request);

        if ($request->method() == 'GET') {
            return view('pages.bookmarks', [
                'posts' => $posts,
                'bookmarkTypes' => $this->bookmarkTypes,
                'activeTab' => $request->route('type'),
            ]);
        } else {
            return response()->json([
                'success'=>true,
                'data'=>PostsHelperServiceProvider::getUserBookmarks(Auth::user()->id, true, false, $type),
            ]);
        }
    }
}
