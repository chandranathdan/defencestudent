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
use App\Model\Attachment;
use App\Model\Country;
use App\Model\CreatorOffer;
use App\Model\ReferralCodeUsage;
use App\Model\Subscription;
use App\Model\Transaction;
use App\Model\UserDevice;
use App\Model\UserGender;
use App\Model\UserVerify;
use App\Providers\AttachmentServiceProvider;
use App\Providers\AuthServiceProvider;
use App\Providers\EmailsServiceProvider;
use App\Providers\GenericHelperServiceProvider;
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
use App\Model\Wallet;
use App\Model\PaymentRequest;
use App\Providers\SettingsServiceProvider;
use App\Services\PaymentsServiceProvider;
use App\Model\Withdrawal;
use App\Helpers\PaymentHelper;

class WalletController extends Controller
{
    protected $paymentHelper;

    public function __construct(PaymentHelper $paymentHelper)
    {
        $this->paymentHelper = $paymentHelper;
    }

    public function wallet_available_pending_balance()
    {
        $user = Auth::user();

    $totalAmount = number_format($user->wallet->total, 2, '.', '');
    $pendingBalance = number_format($user->wallet->pendingBalance, 2, '.', '');
    $formattedPendingAmount = SettingsServiceProvider::getWebsiteFormattedAmount($pendingBalance);
    $withdrawalAllowFees = getSetting('payments.withdrawal_allow_fees');
    $defaultFeePercentage = floatval(getSetting('payments.withdrawal_default_fee_percentage'));
    $customMessageBox = getSetting('payments.withdrawal_custom_message_box');
    $response = [
        'available_balance' => [
            'amount' => $totalAmount,
            'formatted_amount' => SettingsServiceProvider::getWebsiteFormattedAmount($totalAmount),
        ],
        'pending_balance' => [
            'amount' => $pendingBalance,
            'formatted_amount' => $formattedPendingAmount
        ],
        'status' => 200,
        /*'fee_info' => $withdrawalAllowFees && $defaultFeePercentage > 0
            ? [
                'fee_percentage' => $defaultFeePercentage,
                'message' => __('A :feeAmount% fee will be applied.', ['feeAmount' => $defaultFeePercentage])
            ]
            : null,
        'custom_message' => $customMessageBox,
        'message' => __('Available funds. You can deposit more money or become a creator to earn more.')*/
    ];

    return response()->json($response);
    }
    public function wallet_request_withdraw(Request $request)
    {
        // Validation rules
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:' . \App\Providers\PaymentsServiceProvider::getDepositMinimumAmount() . '|max:' . \App\Providers\PaymentsServiceProvider::getDepositMaximumAmount(),
            'message' => 'nullable|string',
            'payment_identifier' => 'required|string',
            'payment_method' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 600,
                'message' => $validator->errors()
            ]);
        }

        try {
            $amount = $request->input('amount');
            $message = $request->input('message');
            $identifier = $request->input('identifier');
            $method = $request->input('method');

            $user = Auth::user();
            if ($user) {
                if (!$user->wallet) {
                    $user->wallet = GenericHelperServiceProvider::createUserWallet($user);
                }

                if (floatval($amount) < floatval(\App\Providers\PaymentsServiceProvider::getWithdrawalMinimumAmount())) {
                    return response()->json([
                        'success' => false,
                        'message' => __("You don't have enough credit to withdraw. Minimum amount is: :minAmount", ['minAmount' => PaymentsServiceProvider::getWithdrawalMinimumAmount()])
                    ], 400);
                }

                if (floatval($amount) > $user->wallet->total) {
                    return response()->json(['status' => 400, 'message' => __('You cannot withdraw this amount, try with a lower Available funds')], 400);
                }

                $fee = 0;
                if (getSetting('payments.withdrawal_allow_fees') && floatval(getSetting('payments.withdrawal_default_fee_percentage')) > 0) {
                    $fee = (floatval(getSetting('payments.withdrawal_default_fee_percentage')) / 100) * floatval($amount);
                }

                Withdrawal::create([
                    'user_id' => $user->id,
                    'amount' => floatval($amount),
                    'status' => Withdrawal::REQUESTED_STATUS,
                    'message' => $message,
                    'payment_method' => $method,
                    'payment_identifier' => $identifier,
                    'fee' => $fee
                ]);

                $user->wallet->update([
                    'total' => $user->wallet->total - floatval($amount),
                ]);

                $totalAmount = number_format($user->wallet->total, 2, '.', '');
                $pendingBalance = number_format($user->wallet->pendingBalance, 2, '.', '');
                $adminEmails = User::where('role_id', 1)->select(['email', 'name'])->get();
                foreach ($adminEmails as $admin) {
                    EmailsServiceProvider::sendGenericEmail([
                        'email' => $admin->email,
                        'subject' => __('Action required | New withdrawal request'),
                        'title' => __('Hello, :name,', ['name' => $admin->name]),
                        'content' => __('There is a new withdrawal request on :siteName that requires your attention.', ['siteName' => getSetting('site.name')]),
                        'button' => [
                            'text' => __('Go to admin'),
                            'url' => route('voyager.dashboard').'/withdrawals',
                        ],
                    ]);
                }

                return response()->json([
                    'status' => 200,
                    'message' => __('Successfully requested withdrawal'),
                    'totalAmount' => SettingsServiceProvider::getWebsiteFormattedAmount($totalAmount),
                    'pendingBalance' => SettingsServiceProvider::getWebsiteFormattedAmount($pendingBalance),
                ]);
            }
        } catch (\Exception $exception) {
            return response()->json(['success' => false, 'message' => $exception->getMessage()], 500);
        }

        return response()->json(['success' => false, 'message' => __('Something went wrong, please try again')], 500);
    }
    public function wallet_deposit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:' . \App\Providers\PaymentsServiceProvider::getDepositMinimumAmount() . '|max:' . \App\Providers\PaymentsServiceProvider::getDepositMaximumAmount(),
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => '600',
            ], 400);
        }
            $deposit = new PaymentRequest();
            $deposit->amount = $request->input('amount');
            $deposit->user_id = auth()->id();
            $deposit->save();
            return response()->json([
                'message' => 'Deposit successfully processed',
                'status' => '200',
                'deposit' => $deposit,
            ], 201);
    }
    public function notifications(Request $request)
    { 
         $user = Auth::user();
         $settingsKeys = [
             'notification_email_new_post_created',
             'notification_email_new_sub',
             'notification_email_new_tip',
             'notification_email_new_ppv_unlock',
             'notification_email_new_message',
             'notification_email_new_comment',
             'notification_email_expiring_subs',
             'notification_email_renewals',
             'notification_email_creator_went_live',
         ];

         $settings = [];
         foreach ($settingsKeys as $key) {
             $settings[$key] = isset($user->settings[$key]) ? $user->settings[$key] === 'true' : false;
         }
 
         return response()->json($settings);
    }
    public function payments_fetch()
    {
        $payments = Transaction::all();
         $formattedPayments = $payments->map(function ($payment) {
            $user = Auth::user();
            $formattedAmount = \App\Providers\SettingsServiceProvider::getWebsiteFormattedAmount($payment->amount);

            if ($payment->decodedTaxes && $user->id == $payment->recipient_user_id) {
                $formattedAmount = \App\Providers\SettingsServiceProvider::getWebsiteFormattedAmount($payment->amount - $payment->decodedTaxes->taxesTotalAmount);
            }

            return [
                'id' => $payment->id,
                'formatted_amount' => $formattedAmount,
                'sender' => [
                    'name' => $payment->sender->name,
                    'profile_url' => route('profile', ['username' => $payment->sender->username])
                ],
                'receiver' => [
                    'name' => $payment->receiver->name,
                    'profile_url' => route('profile', ['username' => $payment->receiver->username])
                ],
                'decoded_taxes' => $payment->decodedTaxes,
            ];
        });
        
        return response()->json([
            'message' => 'Paymante fetch successfully',
            'status' => '200',
            'payments' => $payments,
        ]);
    }

    public function subscriptions_fetch(Request $request)
    {
        $user = Auth::user();
        $activeSubsTab = $request->query('active', 'subscriptions');
        $subscriptionsQuery = Subscription::query();
        if ($activeSubsTab == 'subscriptions') {
            $subscriptionsQuery->where('sender_user_id', $user->id);
        } elseif ($activeSubsTab == 'subscribers') {
            $subscriptionsQuery->where('subscriber_id', $user->id);
        }
        $subscriptions = $subscriptionsQuery->paginate(10);

        return response()->json([
            'subscriptions' => $subscriptions->map(function ($subscription) {
                return [
                    'id' => $subscription->id,
                    'creator' => $subscription->creator ? [
                        'name' => $subscription->creator->name,
                        'username' => $subscription->creator->username,
                        'avatar' => $subscription->creator->avatar
                    ] : null,
                    'subscriber' => $subscription->subscriber ? [
                        'name' => $subscription->subscriber->name,
                        'username' => $subscription->subscriber->username,
                        'avatar' => $subscription->subscriber->avatar
                    ] : null,
                    'status' => $subscription->status,
                    'provider' => $subscription->provider,
                    'expires_at' => $subscription->expires_at ? $subscription->expires_at->format('M d Y') : null,
                ];
            }),
        ]);
    }
    public function subscriptions_canceled(Request $request)
   {
        $validatedData = $request->validate([
            'id' => 'required|integer|exists:subscriptions,id',
        ]);

        $subscriptionId = $validatedData['id'];

        try {
            $subscription = Subscription::where('id', $subscriptionId)
                ->where(function ($query) {
                    $query->where('sender_user_id', Auth::id())
                          ->orWhere('recipient_user_id', Auth::id());
                })
                ->first();

            if (!$subscription) {
                return response()->json([
                    'status' => '404',
                    'message' => 'Subscription not found',
                ]);
            }

            if ($subscription->status === Subscription::CANCELED_STATUS) {
                return response()->json([
                    'status' => '400',
                    'message' => 'This subscription is already canceled.',
                ]);
            }
            $cancelSubscription = $this->paymentHelper->cancelSubscription($subscription);
            if (!$cancelSubscription) {
                return response()->json([
                    'status' => '500',
                    'message' => 'Something went wrong when cancelling this subscription.',
                ]);
            }
            return response()->json([
                'status' => '200',
                'message' => 'Successfully canceled subscription.',
            ]);
            
        } catch (\Exception $exception) {
            return response()->json(['error' => $exception->getMessage()], 500);
            
        }
    }
    public function subscribers_fetch(Request $request)
    {
        $user = Auth::user();
        $subscriptionsQuery = Subscription::where('recipient_user_id', $user->id)
            ->with(['subscriber'])
            ->paginate(10);

        $subscriptions = $subscriptionsQuery->map(function ($subscription) {
            return [
                'id' => $subscription->id,
                'subscriber' => $subscription->subscriber ? [
                    'name' => $subscription->subscriber->name,
                    'username' => $subscription->subscriber->username,
                    'avatar' => $subscription->subscriber->avatar,
                ] : null,
                'status' => $subscription->status,
                'provider' => $subscription->provider,
                'expires_at' => $subscription->expires_at ? $subscription->expires_at->format('M d Y') : null,
            ];
        });

        return response()->json([
            'subscriptions' => $subscriptions,
            'pagination' => [
                'total' => $subscriptionsQuery->total(),
                'per_page' => $subscriptionsQuery->perPage(),
                'current_page' => $subscriptionsQuery->currentPage(),
                'last_page' => $subscriptionsQuery->lastPage(),
            ],
        ]);
    }
}
