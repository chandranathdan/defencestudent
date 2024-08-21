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
            return response()->json(['status' => '400', 'message' => 'User not found']);
        }
        return response()->json([
            'status' => '200',
            'user' => $user,
        ]);
    }
    public function profile_another_user_subscriptions_fetcher(Request $request)
    {
        // Fetch the authenticated user
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'status' => '400',
                'message' => __('User not found.'),
            ], 404);
        }

        // Define subscription durations and prices
        $pricingData = [
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

        // Return the data as a JSON response
        return response()->json([
            'status' => '200',
            'data' => $pricingData,
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
                'status' => '600',
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
            'status' => '200',
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
            'status' => '200',
            'data' => $profileData,
            'Payment method' => $settings,
        ]);
    }
    public function profile_another_user_subscriptions_alldata()
    {
        
    }
}
