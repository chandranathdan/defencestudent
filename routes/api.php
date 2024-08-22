<?php

use Illuminate\Http\Request;

use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\FeedsController;
use App\Http\Controllers\Api\SettingsController;
use App\Http\Controllers\Api\Homecontroller;
use App\Http\Controllers\Api\WalletController;
use App\Http\Controllers\Api\OtherUserController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/login', [UserController::class, 'login']); // lOGIN url
Route::post('/register', [UserController::class, 'register']); // REGISTER url
Route::post('/forgot-password', [UserController::class, 'forgotpassword']); // FORGOTPASSWORD url
Route::post('/forgot-password/verify-otp', [UserController::class, 'forget_password_verify_otp']); // Verify otp
Route::post('/reset-password', [UserController::class, 'resetpassword']); // RESETPASSWORD url
Route::post('/feed', [UserController::class, 'feed']); // feed url


Route::group(['middleware' => ['auth:sanctum']], function () {
	Route::post('/register/verify-otp', [UserController::class, 'register_verify_otp']);
    Route::post('/logout', [UserController::class, 'logout']);

	Route::group(['middleware' => ['api_email_verified']], function () {
		Route::get('/feeds_indivisual/{id}', [FeedsController::class, 'feeds_indivisual']); // feeds-indivisual URL
		Route::get('/feeds_indivisual_filter_image/{id}', [FeedsController::class, 'feeds_indivisual_filter_image']); // feeds_indivisual_filter_image URL
		Route::get('/feed-alldata', [FeedsController::class, 'feed_data']); // feed URL
		Route::post('/post_create', [UserController::class, 'post_create']); // post_create url
		
		Route::get('/user-data',[UserController::class, 'user_data']); // Get log in user data
		Route::get('/privacy', [SettingsController::class, 'privacy']); // privacy url
		Route::post('/privacy_delete', [SettingsController::class, 'privacy_delete']); // privacy_delete url
		Route::get('/notification', [SettingsController::class, 'notification']); // notifications url
		Route::post('/rates_update', [SettingsController::class, 'rates_update']); // rates_update url
		Route::post('/rates_type', [SettingsController::class, 'rates_type']); // rates_type url
		Route::get('/rates_fetch', [SettingsController::class, 'rates_fetch']); // rates_fetch url
		Route::post('/account_update', [SettingsController::class, 'account_update']); // account_update url
		Route::post('/profile', [SettingsController::class, 'profile']); // profile url
		Route::post('/profile_submit', [SettingsController::class, 'profile_submit']); // profile_submit url
		Route::post('/profile_cover_image_upload', [SettingsController::class, 'profile_cover_image_upload']); // profile_cover_image_upload url
		Route::post('/profile_avatar_image_upload', [SettingsController::class, 'profile_avatar_image_upload']); // profile_avatar_image_upload url
		Route::post('/profile_cover_image_delete', [SettingsController::class, 'profile_cover_image_delete']); // profile_cover_image_delete url
		Route::post('/profile_avatar_image_delete', [SettingsController::class, 'profile_avatar_image_delete']); // profile_avatar_image_delete url
		Route::get('/verify_email_birthdate', [SettingsController::class, 'verify_email_birthdate']); // verify_email_birthdate url
		Route::post('/verify_Identity_check', [SettingsController::class, 'verify_Identity_check']); // verify_Identity_check url
		Route::get('/home_slider', [Homecontroller::class, 'home_slider']); // home_slider url
		Route::get('/wallet_available_pending_balance', [WalletController::class, 'wallet_available_pending_balance']); // wallet_available_pending_balance url
		Route::post('/wallet_request_withdraw', [WalletController::class, 'wallet_request_withdraw']); // wallet_request_withdraw url
		Route::post('/wallet_deposit', [WalletController::class, 'wallet_deposit']); // wallet_deposit url
		Route::get('/notifications', [WalletController::class, 'notifications']); // notifications url
		Route::get('/payments_fetch', [WalletController::class, 'payments_fetch']); // payments_fetch url
		Route::get('/subscriptions_fetch', [WalletController::class, 'subscriptions_fetch']); // subscriptions_fatch url
		Route::post('/subscriptions_canceled', [WalletController::class, 'subscriptions_canceled']); // subscriptions_Canceled url
		Route::get('/subscribers_fetch', [WalletController::class, 'subscribers_fetch']); // subscribers_fetch url
		Route::get('/profile_another_user_subscriptions_fetcher', [OtherUserController::class, 'profile_another_user_subscriptions_fetcher']); // profile_another_user_fetch url
		Route::post('/profile_another_user', [OtherUserController::class, 'profile_another_user']); // profile_another_user url
		Route::post('/profile_another_user_subscriptions_submit', [OtherUserController::class, 'profile_another_user_subscriptions_submit']); // profile_another_user_subscriptions_submit url
		Route::get('/profile_another_user_subscriptions_fetch', [OtherUserController::class, 'profile_another_user_subscriptions_fetch']); // profile_another_user_subscriptions_fetch url
	});
});