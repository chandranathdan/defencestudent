<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;

use Illuminate\Validation\Rule;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

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
}