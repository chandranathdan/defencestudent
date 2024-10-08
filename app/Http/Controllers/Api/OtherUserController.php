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
use App\Model\UserVerify;
use App\Model\UserListMember;
use App\Model\Reaction;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\ListsHelperServiceProvider; 
use App\Providers\SettingsServiceProvider;
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
        $user = User::findOrFail($id);
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
        $user_data = [
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
    
        $social_user_data = [];
            $authUserId = Auth::id();
            $followers = ListsHelperServiceProvider::getUserFollowers($authUserId);
            $followerIds = collect($followers)->pluck('user_id');
            $followersCount = $followerIds->count();

            $followingCount = UserListMember::where('user_id', $id)->count();
            $postsCount = Post::where('user_id', $id)->count();
            function formatNumber($number)
            {
                if ($number >= 1000000) {
                    return number_format($number / 1000000, 1) . 'm';
                } elseif ($number >= 1000) {
                    return number_format($number / 1000, 1) . 'k';
                } else {
                    return $number;
                }
            }
            $social_user_data = [
                'total_followers' => $followersCount,
                'total_following' => $followingCount,
                'total_post' => $postsCount,
            ];
        $subscriptions = [
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
        $posts = Post::select('id', 'user_id', 'text', 'release_date', 'expire_date')
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
            ->where('user_id', $id)
            ->get();
        return response()->json([
            'status' => 200,
            'user_data' => $user_data,
            'social_user'=> $social_user_data,
            'feed' => $posts,
            'subscriptions' => $subscriptions,
        ]);
    }
    public function profile_another_user_subscriptions_fetcher(Request $request)
    {
        // Fetch the authenticated user
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'status' => 400,
                'message' => __('User not found.'),
            ]);
        }

        // Define subscription durations and prices
        $Subscriptions = [
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

        return response()->json([
            'status' => 200,
            'data' => $Subscriptions,
        ]);
    }
    public function profile_another_user_subscriptions_submit(Request $request)
    {
        $user = Auth::user();
        $rules = [
            'first_name' => 'required|string|max:191',
            'last_name' => 'required|string|max:191',
            'location' => 'nullable|string|max:500',
        ];
        $rules = array_merge($rules, [
            'city' => 'nullable|string|max:191',
            'state' => 'nullable|string|max:191',
            'country' => 'nullable|string|max:191',
            'postcode' => 'nullable|string|max:20',
            'billing_address' => 'nullable|string|max:500',
        ]);
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
        $user->update($request->only([
            'first_name',
            'last_name',
            'city',
            'state',
            'postcode',
            'country',
            'billing_address',
        ]));
    
        return response()->json([
            'status' => 200,
            'message' => __('profile_another_user_subscriptions_submit.'),
        ]);
    }
    public function profile_another_user_subscriptions_fetch()
    {
        $user = Auth::user();
        $profileData = [
            'first_name' => $user->first_name,
            'last_name' => $user->last_name,
            'location' => $user->location,
            'city' => $user->city,
            'state' => $user->state,
            'country' => $user->country,
            'postcode' => $user->postcode,
            'billing_address' => $user->billing_address,
        ];
        $settings = [
            'min_tip_value' => getSetting('payments.min_tip_value'),
            'max_tip_value' => getSetting('payments.max_tip_value'),
            'currency_symbol' => config('app.site.currency_symbol'),
            'stripe_enabled' => getSetting('payments.stripe_secret_key') && !getSetting('payments.stripe_checkout_disabled'),
            'paypal_enabled' => config('paypal.client_id') && !getSetting('payments.paypal_checkout_disabled'),
            'coinbase_enabled' => getSetting('payments.coinbase_api_key') && !getSetting('payments.coinbase_checkout_disabled'),
            'nowpayments_enabled' => getSetting('payments.nowpayments_api_key') && !getSetting('payments.nowpayments_checkout_disabled'),
            'ccbill_enabled' => \App\Providers\PaymentsServiceProvider::ccbillCredentialsProvided(),
            'paystack_enabled' => getSetting('payments.paystack_secret_key') && !getSetting('payments.paystack_checkout_disabled'),
            'oxxo_enabled' => getSetting('payments.stripe_secret_key') && getSetting('payments.stripe_oxxo_provider_enabled'),
            'mercado_enabled' => getSetting('payments.mercado_access_token') && !getSetting('payments.mercado_checkout_disabled'),
            'user_wallet_balance' => $user ? $user->wallet->total : 0,
        ];
        return response()->json([
            'status' => 200,
            'data' => $profileData,
            'Payment method' => $settings,
        ]);
    }
}
