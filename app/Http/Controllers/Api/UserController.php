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
use App\Mail\GenericEmail;
use Carbon\Carbon;
/////

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
use Cookie;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use JavaScript;
use View;


class UserController extends Controller
{
    function login(Request $request)
    {
		$validator = Validator::make($request->all(),[
			'email'=>'required',
			'password'=>'required',
		]);
		if($validator->fails()){
			return response()->json([
				'errors'=>$validator->errors(),
				'status'=>'600',
			]);
		}
        $email =  $request->input('email');
        $password = $request->input('password');
 
        $user = User::where('email',$email)->first();
        if($user){
			if(!Hash::check($password, $user->password)){
				$response['status']="400";
				$response['message']="Password are not matched";
			}
			else if($user->email_verified_at == null)
			{
				$response['status']="400";
				$response['message']="User is not verified";
			}
			else
			{
				$response['status']="200";
				$response['user']=$user;
				$response['message']="Login success";
			}
        }else{
			$response['status']="400";
			$response['message']="User does not exist";
		}
		return $response;
    }
	function register(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'name' => 'required|string',
			'email' => 'required|email',
			'password' => 'required|min:6',
		]);

		if ($validator->fails()) {
			return response()->json([
				'errors' => $validator->errors(),
				'status' => '600',
			]);
		}

		$name = $request->input('name');
		$email = $request->input('email');
		$password = $request->input('password');
		
		$user = User::where('name', $name)->first();

		$response = [
			'status' => '400',
			'message' => 'User does not exist',
		];

		if ($user) {
			if (!Hash::check($password, $user->password)) {
				$response['message'] = 'Password does not match';
			} elseif ($user->email_verified_at === null) {
				$response['message'] = 'User is not verified';
			} else {
				$response['status'] = '200';
				$response['user'] = $user;
				$response['message'] = 'Login successful';
			}
		}

		return response()->json($response);
	}
	
    public function forgotPassword(Request $request){
    $request->validate([
        'email' => 'required|email|exists:users,email',
    ]);
        $email = $request->input('email');
        $user = User::where('email', $email)->first();

        $otp = mt_rand(100000, 999999); // Generating a 6-digit OTP
            if ($user) {
                $user->otp = $otp;
                $user->save();
                
                // Send email with OTP
                Mail::to($email)->send(new GenericEmail([
                    'mailTitle' => 'OTP',
                    'mailContent' => 'the following OTP to complete the process.',
                    'otp' => $otp, 
                    'button' => [
                        'url' => url('/otp'),
                        'text' => 'Use OTP'
                    ]
                ]));

            return response()->json(['message' => 'Password reset instructions sent to your email.']);
        }
    }

    public function verify(Request $request){
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'otp' => 'required|numeric|digits:6', // Ensure OTP is 6 digits
        ]);
    
        $email = $request->input('email');
        $otp = $request->input('otp');
    
        // Retrieve the user by email
        $user = User::where('email', $email)->first();
    
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }
    
        // Check if the provided OTP matches the user's OTP
        if ($user->otp !== $otp) {
            return response()->json(['message' => 'Invalid OTP'], 400);
        }
        $user->otp = null;
        $user->save();
    
        return response()->json(['message' => 'OTP verified successfully']);
    }

    public function feed(Request $request)
    {
        try {
            // Ensure user is authenticated
            if (!Auth::check()) {
                return response()->json(['success' => false, 'message' => 'Unauthorized'], 401);
            }

            // Log request data
            Log::info('Feed request received with parameters: ', $request->all());

            // Fetch previous page and start page
            $prevPage = PostsHelperServiceProvider::getPrevPage($request);
            $startPage = PostsHelperServiceProvider::getFeedStartPage($prevPage);

            // Fetch posts
            $posts = PostsHelperServiceProvider::getFeedPosts(Auth::user()->id, false, $startPage);

            // Handle pagination cookie
            PostsHelperServiceProvider::shouldDeletePaginationCookie($request);

            // Set up JavaScript variables
            JavaScript::put([
                'paginatorConfig' => [
                    'next_page_url' => str_replace('/feed?page=', '/feed/posts?page=', $posts->nextPageUrl()),
                    'prev_page_url' => str_replace('/feed?page=', '/feed/posts?page=', $posts->previousPageUrl()),
                    'current_page' => $posts->currentPage(),
                    'total' => $posts->total(),
                    'per_page' => $posts->perPage(),
                    'hasMore' => $posts->hasMorePages(), 
                ],
                'initialPostIDs' => $posts->pluck('id')->toArray(),
                'sliderConfig' => [
                    'autoslide' => getSetting('feed.feed_suggestions_autoplay') ? true : false,
                ],
                'user' => [
                    'username' => Auth::user()->username,
                    'user_id' => Auth::user()->id,
                    'lists' => [
                        'blocked' => Auth::user()->lists->firstWhere('type', 'blocked')->id,
                        'following' => Auth::user()->lists->firstWhere('type', 'following')->id,
                    ],
                ],
            ]);

            // Return the view with headers
            return Response::view('pages.feed', [
                'posts' => $posts,
                'suggestions' => MembersHelperServiceProvider::getSuggestedMembers(),
            ])->header('Cache-Control', 'no-cache, no-store, must-revalidate')
              ->header('Pragma', 'no-cache')
              ->header('Expires', '0');
        } catch (\Exception $e) {
            // Log the error message and stack trace
            Log::error('Error in UserController@feed: ' . $e->getMessage(), ['trace' => $e->getTraceAsString()]);

            // Return a user-friendly error response
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while processing your request.'
            ], 500);
        }
    }
    public function create(Request $request){
        // Validate the request
        $validator = Validator::make($request->all(), [
            'text' => 'required|string|min:10',
        ]);

           // Create a new Post instance
        $post = new Post();
        $post->text = $request->input('text');
        $post->user_id = $request->input('user_id');
        $post->price = $request->input('price', 0);
        $post->release_date = $request->input('release_date');
        $post->expire_date = $request->input('expire_date');

        // Handle file upload if present
        if ($request->hasFile('filename')) {
            $file = $request->file('filename');
            $filename = time() . '-' . $file->getClientOriginalName();
            $path = $file->storeAs('uploads', $filename, 'public');
            $post->filename = $filename; 
        } else {
            $post->filename = null; 
        }

        $post->save();

        return response()->json(['success' => true, 'post' => $post]);
    }
}