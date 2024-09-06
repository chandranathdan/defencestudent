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
    public function privacy_fetch()
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
            'public_account' => $user->public_profile,
            'open_profile' => $user->enable_2fa,
            'devices' => $devices,
        ];
    
        return response()->json([
            'status' => 200,
            'data' => $data,
        ]);
    } 
    public function privacy_update(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'key' => 'required|string|in:public_profile,paid-profile,enable_2fa,enable_geoblocking,open_profile',
            'value' => 'required|integer|in:0,1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
                'message' => __('Invalid input'),
            ]);
        }
        $user = Auth::user();
        $key = $request->get('key');
        $value = (int)$request->get('value');
        if (! in_array($key, ['public_profile', 'paid-profile','enable_2fa', 'enable_geoblocking', 'open_profile'])) {
            return response()->json(['success' => false, 'message' => __('Settings not saved')]);
        }

        if ($key === 'public_profile') {
            $key = 'public_profile';
        }
        if ($key === 'enable_2fa' && $value === 1) {
            $userDevices = UserDevice::where('user_id', $user->id)->count();
            if ($userDevices === 0) {
                AuthServiceProvider::addNewUserDevice($user->id, true);
            }
        }
        $user->update([
            $key => $value,
        ]);

        return response()->json([
            'status' => 200,
            'message' => __('Settings saved')
        ]);
    }
    public function privacy_delete(Request $request)
    {
        $validatedData = $request->validate([
            'id' => 'required|integer|exists:user_devices,id',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,  
            ]);
        }
        $userID = Auth::id();
        $deviceID = $validatedData['id'];
        $device = UserDevice::where('user_id', $userID)
            ->where('id', $deviceID)
            ->first();
    
        if (!$device) {
            return response()->json([
                'status' => 404,
                'message' => 'Device not found',
            ], 404);
        }
    
        try {
            $device->delete();
            return response()->json([
                'status' => 200,
                'message' => 'Device successfully deleted',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 400,
                'message' => 'An error occurred while deleting the device',
            ]);
        }
    }
    public function rates_update(Request $request)
    {
        $user = Auth::user();
        if ($request->get('is_offer')) {
            $offerExpireDate = $request->get('profile_access_offer_date');
            $currentOffer = CreatorOffer::where('user_id', $user->id)->first();
    
            $data = [
                'expires_at' => $offerExpireDate,
                'old_profile_access_price' => $user->profile_access_price,
                'old_profile_access_price_6_months' => $user->profile_access_price_6_months,
                'old_profile_access_price_12_months' => $user->profile_access_price_12_months,
                'old_profile_access_price_3_months' => $user->profile_access_price_3_months,
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
            return response()->json([
                'status' => 200,
                'message' => 'old_Rates delete successfully',
            ]);
        }
        $rules = UpdateUserRatesSettingsRequest::getRules();
        $trimmedRules = [];
    
        foreach ($rules as $key => $rule) {
            if ($request->has($key) || $key == 'profile_access_price') {
                $trimmedRules[$key] = $rule;
            }
        }
        $request->validate($trimmedRules);
        $user->update([
            'profile_access_price' => $request->get('profile_access_price'),
            'profile_access_price_6_months' => $request->get('profile_access_price_6_months'),
            'profile_access_price_12_months' => $request->get('profile_access_price_12_months'),
            'profile_access_price_3_months' => $request->get('profile_access_price_3_months'),
        ]);
        return response()->json([
            'status' => 200,
            'message' => 'Settings saved.',
        ]);
    }
    public function rates_fetch(Request $request)
    {
        $user = Auth::user();
    
        if (!$user) {
            return response()->json([
                'status' => 400,
                'message' => 'User not authenticated',
            ]);
        }
        $currentOffer = CreatorOffer::where('user_id', $user->id)->first();
    
        $response = [
            'profile_access_price' => $user->profile_access_price,
            'profile_access_price_6_months' => $user->profile_access_price_6_months,
            'profile_access_price_12_months' => $user->profile_access_price_12_months,
            'profile_access_price_3_months' => $user->profile_access_price_3_months,
            'paid_profile' => $user->paid_profile,
        ];
        if ($currentOffer && $currentOffer->expires_at && $currentOffer->expires_at->isFuture()) {
            $response['is_offer'] = true;
            $response['current_offer_expires_at'] = $currentOffer->expires_at->format('d-m-Y');
        } else {
            $response['is_offer'] = false;
            $response['current_offer_expires_at'] = null;
        }
        return response()->json([
            'status' => 200,
            'data' => $response,
        ]);
    }
    public function rates_type(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'paid_profile' => 'nullable|integer|in:0,1',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'status' => 600,
                'errors' => $validator->errors(),
            ]);
        }
        $user = Auth::user();
        $isOffer = $request->input('is_offer', false);
        $profileAccessOfferDate = $request->input('profile_access_offer_date');
        $paidProfile = (bool) $request->input('paid_profile', 0); 
        if ($isOffer) {
            $data = [
                'expires_at' => $profileAccessOfferDate,
                'old_profile_access_price' => $user->profile_access_price,
                'old_profile_access_price_3_months' => $user->profile_access_price_3_months,
                'old_profile_access_price_6_months' => $user->profile_access_price_6_months,
                'old_profile_access_price_12_months' => $user->profile_access_price_12_months,
                'paid_profile' => $user->paid_profile,
            ];
            CreatorOffer::updateOrCreate(
                ['user_id' => $user->id],
                $data
            );
        } else {
            CreatorOffer::where('user_id', $user->id);
        }
        $updateResult = $user->update([
            'paid_profile' => $paidProfile,
        ]);
        if (!$updateResult) {
            return response()->json([
                'status' => 500,
                'message' => 'Failed Settings saved.',
            ]);
        }
        return response()->json([
            'status' => 200,
            'message' => 'Settings saved.',
        ]);
    }
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
            'message' => __('Settings saved.'),
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
            return response()->json([
				'errors' => $validator->errors(),
				'status' => 600,
			]);
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
                    'status' => 400,
                    'message' => 'File upload failed.',
                ]);
            }
        }else {
            return response()->json([
                'status' => 400,
                'message' => 'File upload failed.',
            ]);
        }
        $verify->save();
        return response()->json([
            'status' => 200,
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
            'status' => 200,
            'data' => $response,
        ]);
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
            $parsedAUrl = parse_url($user->avatar);
            $imageAPath = $parsedAUrl['path'];
            $imageAName = basename($imageAPath);
            $default_avatar = 0;
            if($imageAName=='default-avatar.jpg') {
                $default_avatar = 1;
            }
            $parsedCUrl = parse_url($user->cover);
            $imageCPath = $parsedCUrl['path'];
            $imageCName = basename($imageCPath);
            $default_cover = 0;
            if($imageCName=='default-cover.png') {
                $default_cover = 1;
            }
            $userVerify = $user->email_verified_at && $user->birthdate && 
              ($user->verification && $user->verification->status == 'verified');
                $status = 0;
                if ($userVerify) {
                    $status = 1;
                }else{
                    $status = 0;
                }
            $response['data']['user'] = [
                'id' => $user->id,
                'name' => $user->name,
                'username' => $user->username,
                'avatar' => $user->avatar,
                'cover' => $user->cover,
                'default_avatar' => $default_avatar,
                'default_cover' => $default_cover,
                'bio' => $user->bio,
                'birthdate' => $user->birthdate,
                'gender_pronoun' => $user->gender_pronoun,
                'location' => $user->location,
                'website' => $user->website,
                'country_id' => $user->country_id,
                'gender_id' => $user->gender_id,
                'created_at' =>Carbon::parse($user->created_at)->format('F j'),
                'user_verify' =>$status,
            ];
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
}
