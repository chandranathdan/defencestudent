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
use App\Providers\AuthServiceProvider;
use Cookie;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use JavaScript;
use View;

//Social login
use Laravel\Socialite\Facades\Socialite;

class UserController extends Controller
{
    public function login(Request $request){
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
				$msg = 'Successfully logged in';
				return $this->authResponse($user, $msg);
			}
        }else{
			$response['status']="400";
			$response['message']="User does not exist";
		}
		return $response;
    }
    public function googleLogin(Request $request){
		//  \Log::info('Socialite user: ' . $request->user['displayName']);
		$email =  $request->user['email'];
		$name = $request->user['displayName'] ?? '';
		$auth_provider_id = $request->user['id'] ?? '';
		$provider = $request->route('provider');
		if($email) {
			$user = User::where('email',$email)->first();
			if($user){
				$user->name = $name;
				$user->save();
				
				$authUser = $user;
			}else{
				try {
					$authUser = AuthServiceProvider::createUser([
						'name' => $name,
						'email' => $email,
						'auth_provider' => $provider,
						'auth_provider_id' => $auth_provider_id,
						'email_verified_at' => date('Y-m-d H:i:s'),
					]);
				} catch (\Exception $exception) {
					// Redirect to homepage with error
					//return redirect(route('home'))->with('error', $exception->getMessage());
					$response['status']="400";
					$response['message']=$e->getMessage();
					return $response;
				}
			}
			$msg = 'Successfully logged in';
			return $this->authResponse($authUser, $msg);
		}else{
			$response['status']="400";
			$response['message']='Email not provided by Google.';
			return $response;
		}
    }
	
	public function register(Request $request){
		$validator = Validator::make($request->all(), [
			'name' => 'required|string',
			'email' => 'required|email|unique:users,email',
			'password' => 'required|confirmed|min:6',
			'password_confirmation' => 'required'
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
		
		$userData = [
            'name' => $name,
            'email' => $email,
            'username' => 'u'.time(),
            'password' => isset($password) ? Hash::make($password) : '',
            'settings' => collect([
                'notification_email_new_sub' => 'true',
                'notification_email_new_message' => env('notification_email_new_message', 'false'),
                'notification_email_expiring_subs' => 'true',
                'notification_email_renewals' => 'false',
                'notification_email_new_tip' => 'true',
                'notification_email_new_comment' => 'false',
                'notification_email_new_post_created' => getSetting('profiles.default_new_post_notification_setting') ? 'true' : 'false',
                'locale' => getSetting('site.default_site_language'),
                'notification_email_new_ppv_unlock' => 'true',
                'notification_email_creator_went_live' => 'false',
            ]),
            'enable_2fa' => false,
        ];
		if(getSetting('security.default_2fa_on_register')){
            $userData['enable_2fa'] = true;
        }
        if(getSetting('profiles.default_profile_type_on_register') == 'free'){
            $userData['paid_profile'] = 0;
        }
        if(getSetting('profiles.default_user_privacy_setting_on_register') && getSetting('profiles.default_user_privacy_setting_on_register')  == 'private'){
            $userData['public_profile'] = false;
        }
        else{
            $userData['public_profile'] = true;
        }

        if(getSetting('profiles.default_profile_type_on_register') === 'open') {
            $userData['open_profile'] = true;
        }

        if(getSetting('payments.default_subscription_price')){
            $price = str_replace(',','.',getSetting('payments.default_subscription_price'));
            $userData['profile_access_price'] = $price;
            $userData['profile_access_price_6_months'] = $price;
            $userData['profile_access_price_12_months'] = $price;
        }

        try {
			$code = AuthServiceProvider::generateReferralCode(8);
            $userData['referral_code'] = $code;
			
			$otp = mt_rand(1000, 9999);
			$userData['otp'] = $otp;
        } catch (\Exception $exception){
        }
		$user = User::create($userData);
		
		// Send email with OTP for verify email
		$get_email = get_email(1);
		$data = [
			'subject' => $get_email->message_subject,
			'body' => str_replace(array("[OTP]"), array($otp), $get_email->message),
			'toEmails' => array($email),
			// 'bccEmails' => array('exaltedsol06@gmail.com','exaltedsol04@gmail.com'),
			// 'ccEmails' => array('exaltedsol04@gmail.com'),
			// 'files' => [public_path('images/logo.jpg'), public_path('css/app.css'),],
		];
		send_email($data);
		unset($user['otp']);
		$msg = 'Successfully registered. We sent a OTP for email verification, Please verify your email with this otp.';
		return $this->authResponse($user, $msg);
	}
	
    public function register_verify_otp(Request $request){
		$validator = Validator::make($request->all(), [
			'email' => 'required|email',
            'otp' => 'required|numeric|digits:4',
		]);

		if ($validator->fails()) {
			return response()->json([
				'errors' => $validator->errors(),
				'status' => '600',
			]);
		}
    
        $email = $request->input('email');
        $otp = $request->input('otp');
    
        // Retrieve the user by email
        $user = User::where('email', $email)->first();
		
        if (!$user) {
            return response()->json(['status' => '400', 'message' => 'User not found']);
        }
    
        // Check if the provided OTP matches the user's OTP
        if ($user->otp != $otp) {
            return response()->json(['status' => '400', 'message' => 'Invalid OTP']);
        }
        $user->otp = null;
        $user->email_verified_at = date('Y-m-d H:i:s');
        $user->save();
    
        return response()->json(['status' => '200', 'message' => 'Email verified successfully']);
    }
	
	protected function authResponse($user, $msg){
        $token = $user->createToken('API Token')->plainTextToken;

        return response()->json([
            'status' => '200',
            'message' => $msg,
            'access_token' => $token,
            'token_type' => 'Bearer',
            'expires_at' => null,
            'user' => $user,
        ]);
    }
	
    public function forgotPassword(Request $request){
		$validator = Validator::make($request->all(), [
			'email' => 'required|email',
		]);

		if ($validator->fails()) {
			return response()->json([
				'errors' => $validator->errors(),
				'status' => '600',
			]);
		}
		
        $email = $request->input('email');
        $user = User::where('email', $email)->first();
		
		if (!$user) {
            return response()->json(['status' => '400', 'message' => 'User not found'], 404);
        }
		
        $otp = mt_rand(1000, 9999); // Generating a 6-digit OTP
        if ($user) {
			$user->otp = $otp;
			$user->save();
			
			// Send email with OTP
			$get_email = get_email(2);
			$data = [
				'subject' => $get_email->message_subject,
				'body' => str_replace(array("[OTP]"), array($otp), $get_email->message),
				'toEmails' => array($email),
				// 'bccEmails' => array('exaltedsol06@gmail.com','exaltedsol04@gmail.com'),
				// 'ccEmails' => array('exaltedsol04@gmail.com'),
				// 'files' => [public_path('images/logo.jpg'), public_path('css/app.css'),],
			];
			send_email($data);
            return response()->json(['status' => '200', 'message' => 'Password reset instructions sent to your email.']);
        }
    }

    public function forget_password_verify_otp(Request $request){
		$validator = Validator::make($request->all(), [
			'email' => 'required|email',
            'otp' => 'required|numeric|digits:4',
		]);

		if ($validator->fails()) {
			return response()->json([
				'errors' => $validator->errors(),
				'status' => '600',
			]);
		}
    
        $email = $request->input('email');
        $otp = $request->input('otp');
    
        // Retrieve the user by email
        $user = User::where('email', $email)->first();
    
        if (!$user) {
            return response()->json(['status' => '400', 'message' => 'User not found']);
        }
    
        // Check if the provided OTP matches the user's OTP
        if ($user->otp != $otp) {
            return response()->json(['status' => '400', 'message' => 'Invalid OTP']);
        }
        $user->otp = null;
        $user->save();
    
        return response()->json(['status' => '200', 'message' => 'OTP verified successfully']);
    }
	
    public function resetpassword(Request $request){
		$validator = Validator::make($request->all(), [
			'email' => 'required|email',
			'password' => 'required|confirmed|min:6',
			'password_confirmation' => 'required'
		]);

		if ($validator->fails()) {
			return response()->json([
				'errors' => $validator->errors(),
				'status' => '600',
			]);
		}
    
        $email = $request->input('email');
    
        // Retrieve the user by email
        $user = User::where('email', $email)->first();
    
        if (!$user) {
            return response()->json(['status' => '400', 'message' => 'User not found']);
        }
        $user->password = Hash::make($request->input('password'));
        $user->save();
		
		$msg = 'Password updated successfully.';
		return $this->authResponse($user, $msg);
    }
	
	public function post_create(Request $request){
        $validator = Validator::make($request->all(), [
            'text' => 'required|string|min:10',
            'price' => 'nullable|numeric',
            'release_date' => 'nullable|date',
            'expire_date' => 'nullable|date',
            'attachments' => 'nullable|array',
        ]);

        if ($validator->fails()) {
            return response()->json([
				'errors' => $validator->errors(),
				'status' => 600,
			]);
        }
        $post = $request->input('post_id') ? Post::find($request->input('post_id')) : new Post();
        if (!$post) {
            return response()->json(['status' => 400, 'message' => 'Post not found']);
        }

        $post->user_id = Auth::id();
        $post->text = $request->input('text');
        $post->price = $request->input('price', 0);
        $post->save();
        if ($request->hasFile('attachments')) {
            $file = $request->file('attachments');
            if ($file->isValid()) {
                $filename = time() . '.' . $file->getClientOriginalExtension();
                $path = $file->storeAs('public/attachments', $filename);
                $attachment = new Attachment();
                $attachment->filename = $filename;
                $attachment->post_id = $post->id;
                $attachment->save();
            } else {
                return response()->json(['status' => 400, 'message' => 'File upload failed.']);
            }
        }
        return response()->json([
            'status' => 200,
            'message' => 'post_create saved successfully'
        ], 200);
    }
   
	/*public function redirectToProvider(Request $request){
        return Socialite::driver($request->route('provider'))->redirect();
    }*/
	
	/*public function handleProviderCallback(Request $request){
        $provider = $request->route('provider');
		\Log::info('Socialite user: ' . json_encode($request->all()));

        try {
            //$user = Socialite::driver($provider)->user();
			$user = Socialite::driver($provider)->stateless()->user();
			\Log::info('Socialite user:', (array) $user);
        } catch (RequestException $e) {
            //throw new \ErrorException($e->getMessage());
			$response['status']="400";
			$response['message']=$e->getMessage();
			return $response;
        }

        // Creating the user & Logging in the user
        $userCheck = User::where('auth_provider_id', $user->id)->first();
        if($userCheck){
            $authUser = $userCheck;
        }
        else{
            try {
				$name = $user->getName() ?? 'No Name'; // Default to 'No Name' if null
				$email = $user->getEmail();
				if (!$email) {
					$response['status']="400";
					$response['message']='Email not provided by Google.';
					return $response;
				}
                $authUser = AuthServiceProvider::createUser([
                    'name' => $name,
                    'email' => $email,
                    'auth_provider' => $provider,
                    'auth_provider_id' => $user->id
                ]);
            }
            catch (\Exception $exception) {
                // Redirect to homepage with error
                //return redirect(route('home'))->with('error', $exception->getMessage());
				$response['status']="400";
				$response['message']=$e->getMessage();
				return $response;
            }

        }

        $msg = 'Successfully logged in';
		return $this->authResponse($authUser, $msg);

    }*/
	
	public function user_data(){
        return auth()->user();
    }

    public function logout(Request $request)
    {
        $user = auth()->user();
        $user
            ->tokens()
            ->where('id', $user->currentAccessToken()->id)
            ->delete();
		return response()->json(['status' => '200.', 'success' => 'Successfully logged out.']);	
    }

}