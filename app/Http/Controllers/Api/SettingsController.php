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
use App\Model\UserGender;
use App\Model\UserVerify;
use App\Providers\AttachmentServiceProvider;
use App\Providers\ListsHelperServiceProvider; 
use App\Providers\AuthServiceProvider;
use App\Providers\EmailsServiceProvider;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\SettingsServiceProvider; 
use App\Model\UserCode;
use App\Model\Post;
use App\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Illuminate\Support\Facades\Validator;
use App\Rules\MatchOldPassword;
use JavaScript;
use Jenssegers\Agent\Agent;
use Ramsey\Uuid\Uuid;

class SettingsController extends Controller
{
    public function privacy()
    {
        $userID = Auth::user()->id;
        $user = Auth::user(); 

        $devices = UserDevice::where('user_id', $userID)
            ->orderBy('created_at', 'DESC')
            ->get()
            ->map(function ($item) {
                $agent = new Agent();
                $agent->setUserAgent($item->agent);
    
                $deviceType = 'Desktop';
                if ($agent->isPhone()) {
                    $deviceType = 'Mobile';
                } elseif ($agent->isTablet()) {
                    $deviceType = 'Tablet';
                }
    
                $item->setAttribute('device_type', $deviceType);
                $item->setAttribute('browser', $agent->browser());
                $item->setAttribute('device', $agent->device());
                $item->setAttribute('platform', $agent->platform());
    
                return $item;
            });
    
        $data = [
            'public_profile' => $user->public_profile,
            'open_profile' => $user->open_profile,
            'devices' => $devices,
            'verifiedDevicesCount' => UserDevice::where('user_id', $userID)->whereNotNull('verified_at')->count(),
            'unverifiedDevicesCount' => UserDevice::where('user_id', $userID)->whereNull('verified_at')->count(),
            'countries' => Country::all(),
            'enabled' => getSetting('security.allow_geo_blocking'),
        ];
    
        return response()->json([
            'status' => '200',
            'settings' => $data,
        ]);
    }
    public function privacy_delete(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|integer|exists:user_devices,id',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'status' => 600,
                'errors' => $validator->errors()
            ]);
        }
        $userID = Auth::id();
        $deviceID = $validatedData['id'];
        $device = UserDevice::where('user_id', $userID)
            ->where('id', $deviceID)
            ->first();
    
        if (!$device) {
            return response()->json([
                'status' => '404',
                'message' => 'Device not found',
            ], 404);
        }
    
        try {
            $device->delete();
            return response()->json([
                'status' => '200',
                'message' => 'Device successfully deleted',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => '400',
                'message' => 'An error occurred while deleting the device',
            ], 500);
        }
    }
    public function rates_update(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'profile_access_offer_date' => 'nullable|date|date_format:Y-m-d',
            'profile_access_price' => 'required|numeric|min:0',
            'profile_access_price_3_months' => 'required|numeric|min:0',
            'profile_access_price_6_months' => 'required|numeric|min:0',
            'profile_access_price_12_months' => 'required|numeric|min:0',
            'is_offer' => 'nullable|boolean',
            'paid_profile' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 422,
                'errors' => $validator->errors()
            ], 422);
        }
        $user = Auth::user();
        $isOffer = $request->input('is_offer', false);

        if ($isOffer) {
            $offerExpireDate = $request->input('profile_access_offer_date');
            $currentOffer = CreatorOffer::where('user_id', $user->id)->first();

            $data = [
                'expires_at' => $offerExpireDate,
                'old_profile_access_price' => $user->profile_access_price,
                'old_profile_access_price_3_months' => $user->profile_access_price_3_months,
                'old_profile_access_price_6_months' => $user->profile_access_price_6_months,
                'old_profile_access_price_12_months' => $user->profile_access_price_12_months,
            ];

            if ($currentOffer) {
                $currentOffer->update($data);
            } else {
                $data['user_id'] = $user->id;
                CreatorOffer::create($data);
            }
        } else {
            $currentOffer = CreatorOffer::where('user_id', $user->id)->first();
            if ($currentOffer) {
                $currentOffer->delete();
            }
        }
        $user->update([
            'profile_access_price' => $request->input('profile_access_price'),
            'profile_access_price_3_months' => $request->input('profile_access_price_3_months'),
            'profile_access_price_6_months' => $request->input('profile_access_price_6_months'),
            'profile_access_price_12_months' => $request->input('profile_access_price_12_months'),
            'paid_profile' => $request->input('paid_profile', false),
        ]);

        return response()->json([
            'status' => 200,
            'message' => 'Rates saved successfully'
        ], 200);
    }
    public function rates_fetch(Request $request)
    {
        $user = Auth::user();
    
        if (!$user) {
            return response()->json([
                'error' => 'User not authenticated'
            ], 401);
        }
    
        $currentOffer = CreatorOffer::where('user_id', $user->id)->first();
    
        if (!$currentOffer) {
            return response()->json([
                'profile_access_price' => $user->profile_access_price,
                'profile_access_price_6_months' => $user->profile_access_price_6_months,
                'profile_access_price_12_months' => $user->profile_access_price_12_months,
                'profile_access_price_3_months' => $user->profile_access_price_3_months,
                'paid_profile' => $user->paid_profile,
                'is_offer' => $user->is_offer,
                'message' => 'No current offer found'
            ], 200);
        }
    
        return response()->json([
            'profile_access_price' => $user->profile_access_price,
            'profile_access_price_6_months' => $user->profile_access_price_6_months,
            'profile_access_price_12_months' => $user->profile_access_price_12_months,
            'profile_access_price_3_months' => $user->profile_access_price_3_months,
            'paid_profile' => $user->paid_profile,
            'is_offer' => $user->is_offer,
            'current_offer' => [
                'expires_at' => $currentOffer->expires_at,
                'old_profile_access_price' => $currentOffer->old_profile_access_price,
                'old_profile_access_price_6_months' => $currentOffer->old_profile_access_price_6_months,
                'old_profile_access_price_12_months' => $currentOffer->old_profile_access_price_12_months,
                'old_profile_access_price_3_months' => $currentOffer->old_profile_access_price_3_months,
            ]
        ], 200);
    }

    public function rates_type(Request $request)
    {
    $validator = Validator::make($request->all(), [
        'paid_profile' => 'nullable|boolean',
        'is_offer' => 'nullable|boolean',
        'profile_access_offer_date' => 'nullable|date'
    ]);
    if ($validator->fails()) {
        return response()->json([
            'status' => 600,
            'errors' => $validator->errors()
        ], 422);
    }

    $user = Auth::user();
    $isOffer = $request->input('is_offer', false);
    $profileAccessOfferDate = $request->input('profile_access_offer_date');
    if ($isOffer) {
        $data = [
            'expires_at' => $profileAccessOfferDate,
            'old_profile_access_price' => $user->profile_access_price,
            'old_profile_access_price_3_months' => $user->profile_access_price_3_months,
            'old_profile_access_price_6_months' => $user->profile_access_price_6_months,
            'old_profile_access_price_12_months' => $user->profile_access_price_12_months,
        ];

        $currentOffer = CreatorOffer::where('user_id', $user->id)->first();

        if ($currentOffer) {
            $currentOffer->update($data);
        } else {
            $data['user_id'] = $user->id;
            CreatorOffer::create($data);
        }
    } else {
        $currentOffer = CreatorOffer::where('user_id', $user->id)->first();
        if ($currentOffer) {
            $currentOffer->delete();
        }
    }
    $user->update([
        'paid_profile' => $request->input('paid_profile', false),
    ]);
    return response()->json([
        'status' => 200,
        'message' => 'Rates type updated successfully'
    ], 200);
    }
    
    public function account_update(Request $request)
    { 
        $validator = Validator::make($request->all(), [
            'password' => ['required', 'current_password'],
            'new_password' => ['required', 'min:8'],
            'confirm_password' => ['required_with:new_password', 'same:new_password','min:8']
        ]);
        if ($validator->fails()) {
            return response()->json([
                'status' => 600,
                'errors' => $validator->errors()
            ],);
        }
    
        $user = Auth::user();
        if (!Hash::check($request->input('password'), $user->password)) {
            return response()->json([
                'status' => 400,
                'message' => 'Current password is incorrect'
            ], 400);
        }

        $user->password = Hash::make($request->input('new_password'));
        $user->save();
        return response()->json([
            'status' => 200,
            'message' => 'Password changed successfully'
        ], 200);
    } 
    public function profile(Request $request)
    {
        $user = Auth::user();
        if (!$user) {
            return response()->json([
                'status' => '400',
                'message' => __('User not found.'),
            ]);
        }
        
        $fetchUser = (int) $request->post('user');
        $fetchverify = (int) $request->post('user_verify');
        $fetcfollowinglist = (int) $request->post('social_user');
        $fetchPosts = (int) $request->post('feeds');
        $fetchPostsWithAttachments = (int) $request->post('posts_with_attachments');
        $fetchGenders = (int) $request->post('genders');
        $fetchPricingData = (int) $request->post('subscriptions');
        $fetchCountries = (int) $request->post('countries');
        
        $response = [
            'status' => '200',
            'data' => []
        ];
        
        if ($fetchUser === 1) {
            $response['data']['user'] = [
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
                'created_at' => $user->created_at,
            ];
        }
        if ($fetchverify === 1) {
            $response['data']['user_verify'] = UserVerify::all(['id','user_id', 'status']);
        }
        if ($fetcfollowinglist === 1) {
            $authUserId = Auth::id();
            $followers = ListsHelperServiceProvider::getUserFollowers($authUserId);
            $followerIds = collect($followers)->pluck('user_id');
            $followersCount = $followerIds->count();
        
            $following = UserListMember::all('id','user_id','list_id');
            $followingCount = $following->count();
            $post=post::all();
            $posts = $post->count();
            function formatNumber($number) {
                if ($number >= 1000000) {
                    return number_format($number / 1000000, 1) . 'm';
                } elseif ($number >= 1000) {
                    return number_format($number / 1000, 1) . 'k';
                } else {
                    return $number;
                }
            }
            $response['data']['social_user'] = [
                        'total_followers' => $followersCount,
                        'total_following' => $followingCount,
                        'total_post' => $posts,
                    ];
        }
        if ($fetchPosts === 1) {
            $response['data']['feeds'] = Post::select('id', 'user_id', 'text', 'release_date', 'expire_date')
                ->with([
                    'attachments' => function ($query) {
                        $query->select('filename', 'post_id', 'driver');
                    },
                    'user' => function ($query) {
                        $query->select('id', 'name', 'username');
                    },
                    'comments' => function ($query) {
                        $query->select('id', 'post_id', 'message', 'user_id');
                    },
                    'reactions' => function ($query) {
                        $query->select('post_id', 'reaction_type');
                    }
                ])
                ->where('user_id', $user->id)
                ->get();
        }
    
        if ($fetchPostsWithAttachments === 1) {
            $response['data']['posts_with_attachments'] = Post::select('id', 'user_id', 'text', 'release_date', 'expire_date')
                ->with([
                    'attachments' => function ($query) {
                        $query->select('filename', 'post_id', 'driver');
                    },
                    'user' => function ($query) {
                        $query->select('id', 'name', 'username');
                    },
                    'comments' => function ($query) {
                        $query->select('id', 'post_id', 'message', 'user_id');
                    },
                    'reactions' => function ($query) {
                        $query->select('post_id', 'reaction_type');
                    }
                ])
                ->where('user_id', $user->id)
                ->whereHas('attachments')
                ->get();
        }
    
        if ($fetchGenders === 1) {
            $response['data']['genders'] = UserGender::all(['id', 'gender_name']);
        }
    
        if ($fetchPricingData === 1) {
            $response['data']['subscriptions'] = [
                '1_month' => [
                    'price' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price),
                    'duration' => trans_choice('days', 30, ['number' => 30]),
                ],
                '3_months' => [
                    'price' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price_3_months * 3),
                    'duration' => trans_choice('months', 3, ['number' => 3]),
                ],
                '6_months' => [
                    'price' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price_6_months * 6),
                    'duration' => trans_choice('months', 6, ['number' => 6]),
                ],
                '12_months' => [
                    'price' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price_12_months * 12),
                    'duration' => trans_choice('months', 12, ['number' => 12]),
                ],
            ];
        }
    
        if ($fetchCountries === 1) {
            $response['data']['countries'] = Country::all(['id', 'name']);
        }
        
        if (empty($response['data'])) {
            $response = [
                'status' => '400',
                'message' => 'No valid parameters provided.',
            ];
        }
        
        return response()->json($response);
    }
   /* public function profile()
    {
        $user_data = [];
        $user = Auth::user();
        $user_data = [
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
            'created_at ' => $user->created_at,
        ];

        if (!$user) {
            return response()->json(['status' => '400', 'message' => 'User not found']);
        }
        return response()->json([
            'status' => '200',
            'user' => $user_data,
            'gender' => UserGender::all(['id', 'gender_name']),
            'country' => Country::all(['id', 'name']),

        ]);
        return response()->json($user);
    } */
    public function profile_submit(Request $request)
    {
        $user = Auth::user();
        $rules = [
            'name' => 'required|max:191',
            'username' => 'required|string|alpha_dash|max:255|unique:users,username,' . $user->id,
            'location' => 'max:500',
        ];
    
        if (getSetting('profiles.max_profile_bio_length') && getSetting('profiles.max_profile_bio_length') !== 0) {
            if (getSetting('profiles.allow_profile_bio_markdown')) {
                $rules['bio'] = [new MaxLengthMarkdown];
            } else {
                $rules['bio'] = 'max:' . getSetting('profiles.max_profile_bio_length');
            }
        }
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json([
				'errors'=>$validator->errors(),
				'status'=>'600',
			]);
        }
        $user->update([
            'name' => $request->input('name'),
            'username' => $request->input('username'),
            'bio' => $request->input('bio'),
            'location' => $request->input('location'),
            'website' => $request->input('website'),
            'birthdate' => $request->input('birthdate'),
            'gender_id' => $request->input('gender_id'),
            'gender_pronoun' => $request->input('gender_pronoun'),
            'country_id' => $request->input('country_id'),
        ]);
        
        return response()->json([
            'status' => '200',
            'message' => __('Profile saved.'),
        ]);
    }
    public function profile_cover_image_upload(Request $request)
    {    
        $file = $request->file('file');
        if ($file == null) {
            return response()->json([
                'status' => '400',
                'message' => 'No file was uploaded.'
            ]);
        }
            $data=[]; 
            $type = 'cover';

            try {
                $directory = 'users/'.$type;
                $s3 = Storage::disk(config('filesystems.defaultFilesystemDriver'));
                $fileId = Uuid::uuid4()->getHex();
                $filePath = $directory.'/'.$fileId.'.'.$file->guessClientExtension();

                $img = Image::make($file);
                if ($type == 'cover') {
                    $coverWidth = 599;
                    $coverHeight = 180;
                    if(getSetting('media.users_covers_size')){
                        $coverSizes = explode('x',getSetting('media.users_covers_size'));
                        if(isset($coverSizes[0])){
                            $coverWidth = (int)$coverSizes[0];
                        }
                        if(isset($coverSizes[1])){
                            $coverHeight = (int)$coverSizes[1];
                        }
                    }
                    $img->fit($coverWidth, $coverHeight)->orientate();
                    $data = ['cover' => $filePath];
                }
                $img->encode('jpg', 100);
                Auth()->user()->update($data);
                $s3->put($filePath, $img, 'public');
            } catch (\Exception $exception) {
                return response()->json(['status' => '400','errors' => ['file'=>$exception->getMessage()]]);
            }

            $assetPath = GenericHelperServiceProvider::getStorageAvatarPath($filePath);
            if($type == 'cover'){
                $assetPath = GenericHelperServiceProvider::getStorageCoverPath($filePath);
            }
            return response()->json(['status' => '200', 'message' => __('Cover image uploaded successfully!'),'assetSrc' => $assetPath]);
            
    }
    public function profile_avatar_image_upload(Request $request)
   {   
    $file = $request->file('file');
        if ($file == null) {
            return response()->json([
                'status' => '400',
                'message' => 'No file was uploaded.'
            ]);
        } 
        $data=[];
        $type = 'avatar';
        try {
            $directory = 'users/'.$type;
            $s3 = Storage::disk(config('filesystems.defaultFilesystemDriver'));
            $fileId = Uuid::uuid4()->getHex();
            $filePath = $directory.'/'.$fileId.'.'.$file->guessClientExtension();

            $img = Image::make($file);
            if ($type == 'avatar') {
                $avatarWidth = 96;
                $avatarHeight = 96;
                if(getSetting('media.users_avatars_size')){
                    $sizes = explode('x',getSetting('media.users_avatars_size'));
                    if(isset($sizes[0])){
                        $avatarWidth = (int)$sizes[0];
                    }
                    if(isset($sizes[1])){
                        $avatarHeight = (int)$sizes[1];
                    }
                }
                $img->fit($avatarWidth, $avatarHeight)->orientate();
                $data = ['avatar' => $filePath];
            }
            $img->encode('jpg', 100);
            Auth()->user()->update($data);
            $s3->put($filePath, $img, 'public');
        } catch (\Exception $exception) {
            return response()->json(['status' => '400','message' => __('Failed to upload avatar image.'), 'errors' => ['file'=>$exception->getMessage()]]);
        }

        $assetPath = GenericHelperServiceProvider::getStorageAvatarPath($filePath);
        if($type == 'avatar'){
            $assetPath = GenericHelperServiceProvider::getStorageCoverPath($filePath);
        }
        return response()->json(['status' => '200','message' => __('avatar image uploaded successfully!'), 'assetSrc' => $assetPath]);
    }
   //delete
    public function profile_cover_image_delete(Request $request)
    {
        $user = Auth()->user();
        $coverPath = $user->cover;
        if (!$coverPath) {
            return response()->json(['status' => 600, 'errors' => ['file' => 'No cover image found to delete.']]);
        }
    
        try {
            $s3 = Storage::disk(config('filesystems.defaultFilesystemDriver'));
            if ($s3->exists($coverPath)) {
                $s3->delete($coverPath);
            }
            $user->update(['cover' => null]);
            
        } catch (\Exception $exception) {
            return response()->json(['status' => '400', 'errors' => ['file' => $exception->getMessage()]]);
        }
    
        return response()->json(['status' => '200', 'message' => 'Cover image deleted successfully.']);
    }

    public function profile_avatar_image_delete(Request $request)
    {
        $user = Auth()->user();
        $avatarPath = $user->avatar;
        if (!$avatarPath) {
            return response()->json(['status' => '600', 'message' => ['file' => 'No avatar found to delete.']]);
        }
    
        try {
            $s3 = Storage::disk(config('filesystems.defaultFilesystemDriver'));
            if ($s3->exists($avatarPath)) {
                $s3->delete($avatarPath);
            }
            $user->update(['avatar' => null]);
            
        } catch (\Exception $exception) {
            return response()->json(['status' => '400', 'errors' => ['file' => $exception->getMessage()]]);
        }
    
        return response()->json(['status' => '200', 'message' => 'Avatar deleted successfully.']);
    }

    public function verify_Identity_check(Request $request)
     {
        $validator = Validator::make($request->all(), [
            'filename' => 'nullable|file|mimes:jpeg,png,pdf,doc,docx|max:4065',
        ]);
    
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);   
        }
    
        $user = auth()->user();
        $verify = UserVerify::where('user_id', $user->id)->first();
        if (!$verify) {
            $verify = new UserVerify();
            $verify->user_id = $user->id;
        }
        if ($request->hasFile('files')) {
            $file = $request->file('files');
            if ($file->isValid()) {
                $uniqueId = uniqid();
                $filename = $uniqueId . '.' . $file->getClientOriginalExtension();
                $path = '["users\/verifications\/' . $filename;
                $file->storeAs('public/users/verifications', $filename);
    
                $verify->files = $path;
            } else {
                return response()->json([
                    'status' => '422',
                    'message' => 'File upload failed.',
                ], 422);
            }
        }
        $verify->save();
        return response()->json([
            'status' => '200',
            'message' => 'Verification successfully updated with file upload.',
        ]);
    }
    public function verify_email_birthdate()
    {
        $user = Auth::user();
        $response = [
            'email_verified' => [
                'status' => $user->email_verified_at ? 'verified' : 'unverified',
                'icon' => $user->email_verified_at ? 'checkmark-circle-outline' : 'close-circle-outline',
                'color' => $user->email_verified_at ? 'success' : 'warning',
                'message' => __('Confirm your email address.')
            ],
            'birthdate_set' => [
                'status' => $user->birthdate ? 'set' : 'not_set',
                'icon' => $user->birthdate ? 'checkmark-circle-outline' : 'close-circle-outline',
                'color' => $user->birthdate ? 'success' : 'warning',
                'message' => __('Set your birthdate.')
            ],
            'identity_verification' => [
                'status' => 'pending',
                'icon' => 'time-outline',
                'color' => 'primary',
                'message' => __('Identity check in progress.')
            ]
        ];

        if ($user->verification) {
            if ($user->verification->status == 'verified') {
                $response['identity_verification'] = [
                    'status' => 'verified',
                    'icon' => 'checkmark-circle-outline',
                    'color' => 'success',
                    'message' => __('Upload a Government issued ID card.')
                ];
            } elseif ($user->verification->status !== 'pending') {
                $response['identity_verification'] = [
                    'status' => 'not_verified',
                    'icon' => 'close-circle-outline',
                    'color' => 'warning',
                    'message' => __('Upload a Government issued ID card.')
                ];
            }
        }

        return response()->json([
            'status' => '200',
            'response' => $response,
        ]);
    }
    
    
}
