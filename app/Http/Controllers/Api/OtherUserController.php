<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;

use Illuminate\Validation\Rule;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\password;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use App\Models\Otp;
use Carbon\Carbon;

use App\Providers\AttachmentServiceProvider; 
use App\Http\Requests\SavePostCommentRequest;
use App\Http\Requests\SavePostRequest;
use App\Http\Requests\UpdatePostBookmarkRequest;
use App\Http\Requests\UpdateReactionRequest;
use App\Model\Attachment;
use App\Model\Post;
use App\Model\PostComment;
use App\Model\Reaction;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\AuthServiceProvider;
use Cookie;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use JavaScript;
use View;
class OtherUserController extends Controller
{
    public function profile_another_user(Request $request)
    {
        $request->validate([
            'id' => 'required|integer|exists:users,id',
        ]);
        $id = $request->input('id');
        $user = User::find($id);
        $user = [
            'id' => $user->id,
            'name' => $user->name,
            'username' => $user->username,
            'avatar' => $user->avatar,
            'cover' => $user->cover,
            'bio' => $user->bio,
            'birthdate' => $user->birthdate,
            'gender_pronoun' => $user->gender_pronoun,
            'location' => $user->location,
            'website' => $user->website,
            'country_id' => $user->country_id,
            'gender_id' => $user->gender_id,
        ];

        if (!$user) {
            return response()->json(['status' => '400', 'error' => 'User not found'], 400);
        }
        return response()->json([
            'status' => '200',
            'user' => $user,
        ]);
    }
    
}
