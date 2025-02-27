<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Providers\AuthServiceProvider;
use App\Providers\RouteServiceProvider;
use App\User;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;
use Session;
use Cookie;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = RouteServiceProvider::HOME;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->redirectTo = route('feed');
        $this->middleware('guest')->except('logout');
    }

    protected function authenticated(Request $request)
    {
        // Handling 2FA stuff
        $force2FA = false;
        if(getSetting('security.enable_2fa')){
            if(Auth::user()->enable_2fa && !in_array(AuthServiceProvider::generate2FaDeviceSignature(), AuthServiceProvider::getUserDevices(Auth::user()->id))  ){
                AuthServiceProvider::generate2FACode();
                AuthServiceProvider::addNewUserDevice(Auth::user()->id);
                $force2FA = true;
            }
        }
        Session::put('force2fa', $force2FA);

        if ($request->ajax()) {
            return response()->json(['success' => true, 'message' => 'Logged in successfully.']);
        }
    }


    /**
     * Redirect the user to the Facebook authentication page.
     */
    public function redirectToProvider(Request $request)
    {
        return Socialite::driver($request->route('provider'))->redirect();
    }

    /**
     * Obtain the user information from Facebook.
     */
    public function handleProviderCallback(Request $request)
    {
        $provider = $request->route('provider');

        try {
            $user = Socialite::driver($provider)->user();
        } catch (RequestException $e) {
            throw new \ErrorException($e->getMessage());
        }

        // Creating the user & Logging in the user
        $userCheck = User::where('auth_provider_id', $user->id)->first();
        if($userCheck){
            $authUser = $userCheck;
        }
        else{
            try {
                $authUser = AuthServiceProvider::createUser([
                    'name' => $user->getName(),
                    'email' => $user->getEmail(),
                    'auth_provider' => $provider,
                    'auth_provider_id' => $user->id
                ]);
            }
            catch (\Exception $exception) {
                // Redirect to homepage with error
                return redirect(route('home'))->with('error', $exception->getMessage());
            }

        }

        Auth::login($authUser, true);
        $redirectTo = route('feed');
        if (Session::has('lastProfileUrl')) {
            $redirectTo = Session::get('lastProfileUrl');
        }
        return redirect($redirectTo);

    }
	public function login(Request $request)
    {
        $this->validateLogin($request);

		if($request->has('remember')){
			Cookie::queue('frontuser', $request->email, (24*60*30));
			Cookie::queue('frontpwd', $request->password, (24*60*30));
		}else{
			Cookie::queue('frontuser', $request->email, -(24*60*30));
			Cookie::queue('frontpwd', $request->password, -(24*60*30));
		}
        // If the class is using the ThrottlesLogins trait, we can automatically throttle
        // the login attempts for this application. We'll key this by the username and
        // the IP address of the client making these requests into this application.
        if (method_exists($this, 'hasTooManyLoginAttempts') &&
            $this->hasTooManyLoginAttempts($request)) {
            $this->fireLockoutEvent($request);

            return $this->sendLockoutResponse($request);
        }

        if ($this->attemptLogin($request)) {
            if ($request->hasSession()) {
                $request->session()->put('auth.password_confirmed_at', time());
            }

            return $this->sendLoginResponse($request);
        }

        // If the login attempt was unsuccessful we will increment the number of attempts
        // to login and redirect the user back to the login form. Of course, when this
        // user surpasses their maximum number of attempts they will get locked out.
        $this->incrementLoginAttempts($request);

        return $this->sendFailedLoginResponse($request);
    }

}
