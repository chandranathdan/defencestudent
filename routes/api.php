<?php

use Illuminate\Http\Request;

use App\Http\Controllers\Api\UserController;

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

Route::post('/login',[UserController::class,'login']); // lOGIN url
Route::post('/register',[UserController::class,'register']); // REGISTER url
Route::post('/forgot-password',[UserController::class,'forgotpassword']); // FORGOTPASSWORD url
Route::post('/verify-otp',[UserController::class,'verify']); // Verify url
Route::post('/reset-password',[UserController::class,'resetpassword']); // RESETPASSWORD url
Route::post('/logout',[UserController::class,'logout']); // RESETPASSWOR url
Route::post('/feed',[UserController::class,'feed']); // feed url
Route::post('/post-create',[UserController::class,'create']); // POSTCREATE url

Route::group(['middleware' => ['auth:sanctum']], function () {
	Route::get('/user-data',[UserController::class, 'user_data']); // Get log in user data
});