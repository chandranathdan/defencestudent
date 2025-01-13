<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use App\User;
use App\Model\Post;
use App\Model\PostComment;
use App\Model\Country;
use App\Model\UserList;
use App\Model\UserListMember;
use App\Model\Reaction;
use App\Model\Transaction;
use App\Model\Subscription;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
// use function App\Helpers\getSetting;
use App\Helpers\PostsHelper;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\MembersHelperServiceProvider;
use Illuminate\Support\Facades\Storage;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\ListsHelperServiceProvider;
use App\Providers\SettingsServiceProvider;
use App\Providers\PaymentsServiceProvider;
use App\Providers\InvoiceServiceProvider;
use Carbon\Carbon;

class FeedsController extends Controller
{
     //feeds-indivisual
    public function feeds_individual($id,$page = 1)
    {
        // Check if the user is authenticated
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ]);
        }
    
        if (!is_numeric($id)) {
            return response()->json([
                'status' => 400,
                'message' => 'Invalid user ID'
            ]);
        }
    
        $user = User::select('id', 'name', 'username', 'avatar', 'cover', 'bio', 'created_at', 'location', 'website')
            ->find($id);
    
        if (!$user) {
            return response()->json([
                'status' => 404,
                'message' => 'User not found'
            ]);
        }
        $userData = [
            'id' => $user->id,
            'name' => $user->name,
            'username' => $user->username,
            'avatar' => $user->avatar,
            'bio' => $user->bio ?? __('No description available.'),
            'created_at' => $user->created_at->format('F j'),
            'location' => $user->location ?? '',
            'website' => $user->website ?? '',
        ];
        $authUser = Auth::user();
	
        // Use pagination
        $posts = $user->posts()
            ->withCount(['comments', 'reactions'])
            ->paginate(6, ['*'], 'page', $page);
    
        $formattedPosts = $posts->getCollection()->map(function ($post) use ($authUser) {
            $transactions = $post->transactions()->where('status', Transaction::APPROVED_STATUS)->get();
            $isPaid = $transactions->isNotEmpty();
    
            if (!$isPaid) {
                // Logic for locked posts
                if ((Auth::check() && Auth::user()->id !== $post->user_id && $post->price > 0 && !\PostsHelper::hasUserUnlockedPost($post->postPurchases)) || 
                    (!Auth::check() && $post->price > 0)) {
                    $attachments = [
                        [
                            'content_type' => 'locked',
                            'file' => asset('/img/post-locked.svg'),
                            'price' => $post->price,
                        ]
                    ];
                } else {
                    // User can view attachments
                    $attachments = $post->attachments->map(function ($attachment) {
                        $extension = pathinfo($attachment->filename, PATHINFO_EXTENSION);
                        $type = null;
    
                        if (in_array($extension, ['jpg', 'png', 'gif'])) {
                            $type = 'image';
                        } elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
                            $type = 'video';
                        }
    
                        return [
                            'content_type' => $type,
                            'file' => Storage::url($attachment->filename),
                            'price' => 0,
                        ];
                    })->toArray();
                }
            } else {
                // Post is locked but paid
                $attachments = [
                    [
                        'content_type' => 'locked',
                        'file' => asset('/img/post-locked.svg'),
                        'price' => $post->price,
                    ]
                ];
            }
    
            $tipsCount = $post->transactions()->where('type', Transaction::TIP_TYPE)
                ->where('status', Transaction::APPROVED_STATUS)->count();
    
            $own_like = Auth::check() ? $post->reactions()->where('user_id', Auth::user()->id)
                ->where('reaction_type', 'like')->exists() : false;
    
            return [
                'post_id' => $post->id,
                'name' => $post->user->name,
                'username' => $post->user->username,
                'avatar' => $post->user->avatar,
                'bio' => $post->user->bio ?? '',
                'post_text' => $post->text,
                'attachments' => $attachments,
                'commentsCount' => $post->comments_count,
                'tipsCount' => $tipsCount,
                'likesCount' => $post->reactions_count,
                'own_like' => $own_like,
                'created_at' => $post->created_at->diffForHumans(),
            ];
        });
    
        return response()->json([
            'status' => 200,
            'data' => [
                'user' => $userData,
                'posts' => $formattedPosts,
            ],
        ]);
    }
    //post feeds-indivisual
    public function feeds_individuals(Request $request)
    {
        $userId = $request->input('id');
        $page = $request->input('page', 1);
        $perPage = config('custom.api.INDIVIDUAL_USERS_POSTS_PERPAGE_DATA');
    
        // Fetch user by ID
        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                'status' => 404,
                'message' => 'User not found'
            ]);
        }
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
		$is_following = ListsHelperServiceProvider::isUserFollowing(Auth::user()->id, $userId);
		$has_active_sub = PostsHelperServiceProvider::hasActiveSub(Auth::user()->id, $userId);
		if($user->paid_profile){
			$monthly_subscription_text = SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price).' for '.trans_choice('days', 30, ['number' => 30]);
			$monthly_subscription_price = $user->profile_access_price;
			$monthly_subscription_duration = trans_choice('days', 30, ['number' => 30]);
			$monthly_subscription_type = 'one-month-subscription';
		}else{
			$monthly_subscription_text = '';
			$monthly_subscription_price = 0;
			$monthly_subscription_duration = '';
			$monthly_subscription_type = '';
		}
        $userData = [
            'id' => $user->id,
            'name' => $user->name,
            'username' => $user->username,
            'avatar' => $user->avatar,
            'cover' => $user->cover,
			'default_avatar' => $default_avatar,
            'default_cover' => $default_cover,
            'bio' => $user->bio ?? __('No description available.'),
			'birthdate' => $user->birthdate,
			'gender_pronoun' => $user->gender_pronoun,
            'location' => $user->location ?? '',
            'website' => $user->website ?? '',
			'country_id' => $user->country_id,
			'gender_id' => $user->gender_id,
            'created_at' => Carbon::parse($user->created_at)->format('F j'),
            'user_verify' =>$status,
            'is_follow' =>$is_following ? 1 : 0,
            'is_paid_profile' =>$user->paid_profile,
            'has_active_sub' =>$has_active_sub ? 1 : 0,
            'monthly_subscription_text' =>$monthly_subscription_text,
            'monthly_subscription_price' =>$monthly_subscription_price,
            'monthly_subscription_duration' =>$monthly_subscription_duration,
            'monthly_subscription_type' =>$monthly_subscription_type,
        ];
		//Social user start
		$fetcfollowinglist = 1;
		if ($fetcfollowinglist == 1) {
            $authUserId = $userId;
            $followers = ListsHelperServiceProvider::getUserFollowers($authUserId);
            $followerIds = collect($followers)->pluck('user_id');
            $followersCount = formatNumber($followerIds->count());
        
            $following = ListsHelperServiceProvider::getUserFollowing($authUserId);
            $followingIds = collect($following)->pluck('user_id');
            $followingCount = formatNumber($followingIds->count());
			
            $post=post::where('user_id', $authUserId)->where('status', 1)->get();
            $posts = formatNumber($post->count());
			
            $socialUserData = [
				'total_followers' => $followersCount,
				'total_following' => $followingCount,
				'total_post' => $posts,
			];
        }
		//Social user end
		
		// user rate subscriptions start
		if($user->paid_profile){
			$three_months = [];
			$six_months = [];
			$twelve_months = [];
			if($user->profile_access_price_3_months > 0){
				$three_months = array(
					'3_months' => [
						'subscription_text' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price_3_months * 3).' for '.trans_choice('months', 3,['number' => 3]),
						'subscription_price' => $user->profile_access_price_3_months * 3,
						'subscription_duration' => trim(trans_choice('months', 3,['number' => 3]), ' '),
						'subscription_type' => 'three-months-subscription',
					]
				);
			}
			if($user->profile_access_price_6_months > 0){
				$six_months = array(
					'6_months' => [
						'subscription_text' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price_6_months * 6).' for '.trans_choice('months', 6, ['number' => 6]),
						'subscription_price' => $user->profile_access_price_6_months * 6,
						'subscription_duration' => trim(trans_choice('months', 6, ['number' => 6]), ' '),
						'subscription_type' => 'six-months-subscription',
					],
				);
			}
			if($user->profile_access_price_12_months > 0){
				$twelve_months = array(
					'12_months' => [
						'subscription_text' => SettingsServiceProvider::getWebsiteFormattedAmount($user->profile_access_price_12_months * 12).' for '.trans_choice('months', 12, ['number' => 12]),
						'subscription_price' => $user->profile_access_price_12_months * 12,
						'subscription_duration' => trim(trans_choice('months', 12, ['number' => 12]), ' '),
						'subscription_type' => 'yearly-subscription',
					],
				);
			}
			$subscriptions = array_merge($three_months, $six_months, $twelve_months);
		}else{
			$subscriptions = [];
		}
		// user rate subscriptions end
		
        // Format user data
        $user->created_at = $user->created_at->format('F j');
        $user->bio = $user->bio ?? __('No description available.');
    
        $posts = $user->posts()
                      ->withCount(['comments', 'reactions'])
                      ->orderBy('created_at', 'desc')
                      ->paginate($perPage, ['*'], 'page', $page);
    
        $authUser = Auth::user();
        // Format posts
        $formattedPosts = $posts->getCollection()->map(function ($post) use ($authUser) {
            $transactions = $post->transactions()->where('status', Transaction::APPROVED_STATUS)->get();
            $isPaid = $transactions->isNotEmpty();
    
            //if (!$isPaid) {
                // Logic for locked posts
                if ((Auth::check() && Auth::user()->id !== $post->user_id && $post->price > 0 && !\PostsHelper::hasUserUnlockedPost($post->postPurchases)) || 
                    (!Auth::check() && $post->price > 0)) {
                    $attachments = [
                        [
                            'content_type' => 'locked',
                            'file' => asset('/img/post-locked.svg'),
                            'price' => $post->price,
                        ]
                    ];
                } else {
                    // User can view attachments
                    $attachments = $post->attachments->map(function ($attachment) {
                        $extension = pathinfo($attachment->filename, PATHINFO_EXTENSION);
                        $type = null;
    
                        if (in_array($extension, ['jpg', 'png', 'gif'])) {
                            $type = 'image';
                        } elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
                            $type = 'video';
                        }
    
                        return [
                            'content_type' => $type,
                            'file' => Storage::url($attachment->filename),
                            'price' => 0,
                        ];
                    })->toArray();
                }
           /* } else {
                // Post is locked but paid
                $attachments = [
                    [
                        'content_type' => 'locked',
                        'file' => asset('/img/post-locked.svg'),
                        'price' => $post->price,
                    ]
                ];
            }*/
    
            $tipsCount = $post->transactions()->where('type', Transaction::TIP_TYPE)
                              ->where('status', Transaction::APPROVED_STATUS)
                              ->count();
    
            $own_like = Auth::check() && $post->reactions()->where('user_id', $authUser->id)
                                                          ->where('reaction_type', 'like')->exists();
    
            return [
                'post_id' => $post->id,
                'name' => $post->user->name,
                'username' => $post->user->username,
                'avatar' => $post->user->avatar,
                'bio' => $post->user->bio ?? '',
                'post_text' => $post->text,
                'attachments' => $attachments,
                'commentsCount' => $post->comments_count,
                'tipsCount' => $tipsCount,
                'likesCount' => $post->reactions_count,
                'own_like' => $own_like,
                'created_at' => $post->created_at->diffForHumans(),
            ];
        });
    
        return response()->json([
            'status' => 200,
            'data' => [
                'user' => $userData,
                'social_user' => $socialUserData,
                'subscription_bundle' => $subscriptions,
                'posts' => $formattedPosts,
            ],
        ]);
    }
	//add_product_price
	public function add_product_price(Request $request)
    {
		\Stripe\Stripe::setApiKey(getSetting('payments.stripe_secret_key'));
		
		// generate stripe product
		$recipientUser = User::query()->where(['username' => $request->input('user_name')])->first();
		$description = $recipientUser->name.' for '.SettingsServiceProvider::getWebsiteFormattedAmount($request->input('amount'));
		$product = \Stripe\Product::create([
			'name' => $description,
		]);

		// generate stripe price
		$price = \Stripe\Price::create([
			'product' => $product->id,
			'unit_amount' => $request->input('amount') * 100,
			'currency' => config('app.site.currency_code'),
			'recurring' => [
				'interval' => 'month',
				'interval_count' => PaymentsServiceProvider::getSubscriptionMonthlyIntervalByTransactionType($request->input('transaction_type')),
			],
		]);
		return response()->json([
            'status' => 200,
            'email' => $recipientUser->email,
            'price' => $price->id,
        ]);
	}
	public function createCustomer(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'payment_method' => 'required|string',
        ]);

        try {
			\Stripe\Stripe::setApiKey(getSetting('payments.stripe_secret_key'));
			$recipientUser = User::query()->where(['email' => $request->email])->first();
            $customer = \Stripe\Customer::create([
                'name' => $recipientUser->name,
                'email' => $request->email,
                'payment_method' => $request->payment_method,
                'invoice_settings' => [
                    'default_payment_method' => $request->payment_method,
                ],
            ]);
            return response()->json([
                'status' => 'success',
                'customer_id' => $customer->id,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create a subscription for the customer.
     */
    public function createSubscription(Request $request)
    {
        $request->validate([
            'customer_id' => 'required|string',
            'price_id' => 'required|string',
        ]);

        try {
			\Stripe\Stripe::setApiKey(getSetting('payments.stripe_secret_key'));
            $subscription = \Stripe\Subscription::create([
                'customer' => $request->customer_id,
                'items' => [
                    ['price' => $request->price_id],
                ],
                'expand' => ['latest_invoice.payment_intent'],
            ]);
			
			$recipientUser = User::query()->where(['email' => $request->email])->first();
			$sub_amount = $subscription->latest_invoice->subtotal/100;
			$new_subscription = new Subscription();
			$new_subscription->sender_user_id = Auth::user()->id;
            $new_subscription->recipient_user_id = $recipientUser->id;
            $new_subscription->stripe_subscription_id = $subscription->id;
            $new_subscription->paypal_agreement_id = null;
            $new_subscription->paypal_plan_id = null;
            $new_subscription->amount = null;
            $new_subscription->expires_at = null;
            $new_subscription->canceled_at = null;
            $new_subscription->ccbill_subscription_id = null;
            $new_subscription->type = '';
            $new_subscription->provider = Transaction::STRIPE_PROVIDER;
            $new_subscription->status = Transaction::PENDING_STATUS;
			$new_subscription->save();
			// dd($new_subscription);
			
			/*$dataArray = [
				"data" => [],
				"taxesTotalAmount" => 0.00,
				"subtotal" => $sub_amount
			];*/
			$transaction = new Transaction();
			$transaction->sender_user_id = Auth::user()->id;
            $transaction->recipient_user_id = $recipientUser->id;
            $transaction->subscription_id = $new_subscription->id;
			$transaction->stripe_transaction_id = $subscription->latest_invoice->payment_intent->id;
            $transaction->status = Transaction::PENDING_STATUS;
            $transaction->payment_provider = Transaction::STRIPE_PROVIDER;
			$transaction->amount = $sub_amount;
			// $transaction->taxes = json_encode($dataArray); 
            $transaction->currency = config('app.site.currency_code');
            $transaction->type = '';
            $transaction->payment_provider = Transaction::STRIPE_PROVIDER;
			$transaction->save();
			
			$invoice = InvoiceServiceProvider::createInvoiceByTransaction($transaction);
			if ($invoice != null) {
				$transaction->invoice_id = $invoice->id;
				$transaction->save();
			}
			
            return response()->json([
                'status' => 'success',
                'subscription_id' => $subscription->id,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
    public function subscription_submit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:1|max:500',
            'billing_address' => 'nullable|string',
            'first_name' => 'nullable|string',
            'last_name' => 'nullable|string',
            'city' => 'nullable|string',
            'country' => 'nullable|exists:countries,id',
            'state' => 'nullable|string',
            'postcode' => 'nullable|string',
            'sub_id' => 'required',
        ], 
        [
            'amount.required' => 'Please enter a valid amount.',
            'amount.numeric' => 'Please enter a valid amount.',
            'amount.min' => 'Please enter a valid amount.',
            'amount.max' => 'Please enter a valid amount.',
            'sub_id.required' => 'Subscription Id is required.',
        ]);
				
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
		
		$subscription = Subscription::where('stripe_subscription_id', $request->sub_id)->first();
		$subscription->type = $request->feedData['subscription_type'];
        $subscription->status = Subscription::ACTIVE_STATUS;
		$subscription->expires_at = new \DateTime('+'.PaymentsServiceProvider::getSubscriptionMonthlyIntervalByTransactionType($request->feedData['subscription_type']).' month', new \DateTimeZone('UTC'));
        $subscription->amount = $request->amount;		
		$subscription->save();
		
		$dataArray = [
			"data" => [],
			"taxesTotalAmount" => 0.00,
			"subtotal" => $request->amount,
		];
		$transaction = Transaction::where('subscription_id', $subscription->id)->first();
		$transaction->status = Transaction::APPROVED_STATUS;
		$transaction->type = $request->feedData['subscription_type'];
		$transaction->amount = $request->amount;
		$transaction->taxes = json_encode($dataArray); 
		$transaction->save();
		
        return response()->json([
        'status' => 200, 
        'message' => 'You successfully subscribe',    
        ]);
    }
    //feeds_indivisual_filter_image
    public function feeds_individual_filter_image($id)
    {
        $post = Post::select('id', 'user_id','text', 'release_date', 'expire_date')->with([
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
        ])->where('user_id', $id)->whereHas('attachments')->get();
        if (!$post) {
            return response()->json(['status' => '400', 'message' => 'Post not found']);
        }
        return response()->json([
            'status' => 200,
            'user' => $post,
        ]);
    }
    public function feeds_post_like(Request $request)
    {
        $user = Auth::user();
        $validator = Validator::make($request->all(),[
            'post_id' => 'required|exists:posts,id',
		]);
        if($validator->fails()){
			return response()->json([
				'errors'=>$validator->errors(),
				'status'=>'600',
			]);
		}
        $postId = $request->input('post_id');
        $post = Post::find($postId);
        if (!$post) {
            return response()->json([
                'status' => 404,
                'message' => 'Post not found'
            ]);
        }
    
        $existingLike = Reaction::where('user_id', $user->id)
            ->where('post_id', $postId)
            ->first();
    
        if ($existingLike) {
            $existingLike->delete();
            $message = 'Like removed';
        } else {
            Reaction::create([
                'user_id' => $user->id,
                'post_id' => $postId,
                'reaction_type' => 'like',
            ]);
            $message = 'Post liked';
        }
        $newLikeCount = $post->reactions()->where('reaction_type', 'like')->count();
    
        return response()->json([
            'status' => 200,
            'message' => $message,
            'likesCount' => $newLikeCount,
        ]);
    }
    public function feeds_post_comments(Request $request)
    {
        $user = Auth::user();
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'message' => 'nullable|string|max:1000',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
        $postId = $request->input('post_id');
        $comment = $request->input('message');
        $post = Post::find($postId);
        if (!$post) {
            return response()->json([
                'status' => 400,
                'message' => 'Post not found',
            ]);
        }
        if ($comment) {
            $newComment = PostComment::create([
                'user_id' => $user->id,
                'post_id' => $postId,
                'message' => $comment,
            ]);
            $newComment->load('author');
    
            return response()->json([
                'status' => 200,
                'message' => 'Comment added',
                'data' => $this->formatComment($newComment),
                'new_comments_count' => $post->comments()->count(),
            ]);
        }
        $comments = $post->comments()->with('author')->latest()->get();
        $formattedComments = $comments->map(fn($comment) => $this->formatComment($comment));
    
        return response()->json([
            'status' => 200,
            'message' =>'Comment added.',
            'data' => $formattedComments,
            'new_comments_count' => $comments->count(),
        ]);
    }
    private function formatComment(PostComment $comment)
    {
        $likesCount = $comment->reactions()->count(); 
        $user = Auth::user();
        $hasLiked = $comment->reactions()->where('user_id', $user->id)->exists();
    
        return [
            'id' => $comment->id,
            'user_id' => $comment->user_id,
            'post_id' => $comment->post_id,
            'message' => $comment->message,
            'created_at' => $comment->created_at->diffForHumans(), 
            'username' => $comment->author->username,
            'avatar' => $comment->author->avatar,
            'name' => $comment->author->name,
            'post_comment_likes_count' => $likesCount,
            'own_comment' => $comment->user_id === $user->id,
            'own_like' => $hasLiked,
        ];
    }
    public function feeds_fetch_comments(Request $request)
    {
        $user = Auth::user();
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'comment' => 'nullable|string',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
    
        $postId = $request->input('post_id');
        $post = Post::find($postId);
        
        if (!$post) {
            return response()->json([
                'status' => 400,
                'message' => 'Post not found',
            ]);
        }
    
        // Check if a new comment is being added
        $comment = $request->input('comment');
    
        if ($comment) {
            $newComment = PostComment::create([
                'user_id' => $user->id,
                'post_id' => $postId,
                'message' => $comment,
            ]);
            $newComment->load('author');
    
            return response()->json([
                'status' => 200,
                'message' => 'Comment added',
                'comment' => $this->formatComment($newComment),
                'new_comments_count' => $post->comments()->count(),
            ]);
        }
    
        // Fetch existing comments if no new comment is added
        $comments = $post->comments()->with('author')->latest()->get();
        $formattedComments = $comments->map(fn($comment) => $this->formatComment($comment));
        return response()->json([
            'status' => 200,
            'data' => $formattedComments,
            'new_comments_count' => $comments->count(),
        ]);
    }
    public function feeds_like_comments(Request $request)
    {
        $user = Auth::user();
        $validator = Validator::make($request->all(), [
            'post_comment_id' => 'required|exists:post_comments,id',
        ]);
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
        $postCommentId = $request->input('post_comment_id');
        $postComment = PostComment::find($postCommentId);
        if (!$postComment) {
            return response()->json([
                'status' => 404,
                'message' => 'Comment not found'
            ]);
        }
        $existingLike = Reaction::where('user_id', $user->id)
            ->where('post_comment_id', $postCommentId)
            ->first();
    
        if ($existingLike) {
            $existingLike->delete();
            $message = 'Like removed';
        } else {
            Reaction::create([
                'user_id' => $user->id,
                'post_comment_id' => $postCommentId,
                'reaction_type' => 'like',
            ]);
            $message = 'Comment liked';
        } 
        // Get the new like count
        $newLikeCount = Reaction::where('post_comment_id', $postCommentId)
            ->where('reaction_type', 'like')
            ->count();
    
        return response()->json([
            'status' => 200,
            'message' => $message,
            'post_comment_likes_count' => $newLikeCount,
        ]);
    }
    public function feeds_delete_comments(Request $request)
    {
        $user = Auth::user();
        // Validate the request
        $validator = Validator::make($request->all(), [
            'id' => 'required|exists:post_comments,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
    
        $postCommentId = $request->input('id');
        $comment = PostComment::where('id', $postCommentId)
            ->where('user_id', $user->id)
            ->first();
    
        if (!$comment) {
            return response()->json([
                'status' => 400,
                'message' => 'Comment not found or you do not have permission to delete this comment',
            ]);
        }
    
        $comment->delete();
        return response()->json([
            'status' => 200,
            'message' => 'Comment deleted successfully.',
            'new_comments_count' => PostComment::where('post_id', $comment->post_id)->count(), 
        ]);
    }
    public function feed_all_user(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ]);
        }
    
        $users = User::all();
        $responseData = [];
        $page = $request->input('page', 1);
        $coursesUserPage = $request->input('courses_user_page', 1);
        $suggestedMembers = MembersHelperServiceProvider::getSuggestedMembersForApi();
    
        // Pass suggested members to getUserPosts and getUserCourses if needed
        $responseData['posts'] = $this->getUserPosts($users, $page);
        $responseData['courses_user_page'] = $this->getUserCourses($suggestedMembers, $coursesUserPage);
    
        return response()->json([
            'status' => 200,
            'data' => $responseData
        ]);
    }
    
    private function getUserPosts($users, $page)
    {
        $loggedUserId = Auth::id();
        $userFollowersListId = UserList::where(['user_id' => $loggedUserId, 'type' => 'following'])
            ->value('id');
    
        if ($userFollowersListId === null) {
            return collect([]);
        }
    
        $followingUserIdss = UserListMember::where('list_id', $userFollowersListId)
            // ->pluck('user_id');
            ->get();
		$followingUserIds = [];
        foreach($followingUserIdss as $member){
            if(!$member->user->paid_profile || (getSetting('profiles.allow_users_enabling_open_profiles') && $member->user->open_profile)){
                $followingUserIds[] =  $member->user->id;
            }
        }
		$active_sub = PostsHelperServiceProvider::getUserActiveSubs(Auth::user()->id);
		
		$followingUserIds = collect(array_merge($active_sub, $followingUserIds));
        $posts = $users->filter(function ($user) use ($followingUserIds) {
            return $followingUserIds->contains($user->id);
        })->flatMap(function ($user) {
            return $user->posts()->withCount(['comments', 'reactions'])->orderBy('created_at','DESC')->get();
        });
 
        // $perPage = 6; 
        $perPage = config('custom.api.FEED_PAGE_PERPAGE_DATA'); 
        $totalPosts = $posts->count();
        $posts = $posts->slice(($page - 1) * $perPage, $perPage)->values();
    
        // Prepare the posts for response
        return $posts->map(function ($post) {
            $tipsCount = $post->transactions()
                ->where('type', Transaction::TIP_TYPE)
                ->where('status', Transaction::APPROVED_STATUS)
                ->count();
            $attachments = $this->getPostAttachments($post);
    
            $own_like = Auth::check() ? $post->reactions()
                ->where('user_id', Auth::user()->id)
                ->where('reaction_type', 'like')
                ->exists() : false;
    
            return [
                'post_id' => $post->id,
                'name' => $post->user->name,
                'username' => $post->user->username,
                'avatar' => $post->user->avatar,
                'bio' => '',
                'post_text' => $post->text,
                'attachments' => $attachments,
                'likesCount' => $post->reactions()->where('reaction_type', 'like')->count(),
                'commentsCount' => $post->comments()->count(),
                'tipsCount' => $tipsCount,
                'own_like' => $own_like,
                'created_at' => $post->created_at->diffForHumans(),
            ];
        })->toArray();
    }
    
    private function getPostAttachments($post)
    {
        $transactions = $post->transactions()->where('status', Transaction::APPROVED_STATUS)->get();
        $isPaid = $transactions->isNotEmpty();
        $attachments = [];
    
        foreach ($post->attachments as $attachment) {
			if((Auth::check() && Auth::user()->id !== $post->user_id && $post->price > 0 && !\PostsHelper::hasUserUnlockedPost($post->postPurchases)) || (!Auth::check() && $post->price > 0 )){
				// Locked content
				$attachments[] = [
					'content_type' => 'locked',
					'file' => asset('/img/post-locked.svg'),
					'price' => $post->price,
				];
			}else{
				$extension = pathinfo($attachment->filename, PATHINFO_EXTENSION);
				// $type = $this->determineAttachmentType($extension);
				$type = null;
				if (in_array($extension, ['jpg', 'png', 'gif'])) {
					$type = 'image';
				} elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
					$type = 'video';
				}
				// Accessible content
				$attachments[] = [
					'content_type' => $type,
					'file' => Storage::url($attachment->filename),
					'price' => 0,
				];
			}
            /*if ($post->price == 0 ||
                $isPaid || 
                (Auth::check() && Auth::user()->id !== $post->user_id && $post->price > 0 && !\PostsHelper::hasUserUnlockedPost($post->postPurchases)) ||
                (Auth::check() && \PostsHelper::hasUserUnlockedPost($post->postPurchases))) {
                // Accessible content
                $attachments[] = [
                    'content_type' => $type,
                    'file' => Storage::url('attachments/' . $attachment->filename),
                    'price' => 0,
                ];
            } else {
                // Locked content
                $attachments[] = [
                    'content_type' => 'locked',
                    'file' => asset('/img/post-locked.svg'),
                    'price' => $post->price,
                ];
            }*/
        }
        return $attachments;
    }
    
    private function determineAttachmentType($extension)
    {
        if (in_array($extension, ['jpg', 'png', 'gif'])) {
            return 'image';
        } elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
            return 'video';
        }
        return null;
    }
    private function getUserCourses($suggestedMembers, $coursesUserPage)
    {
		$perPage = config('custom.api.FEED_PAGE_PERPAGE_USER_DATA'); 
        $suggestedMembers = collect($suggestedMembers);
        $courses = $suggestedMembers->map(function ($user) {
            if (is_string($user)) {
                $user = User::find($user);
            }
            if ($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'username' => $user->username,
                    'avatar' => $user->avatar,
                    'cover' => $user->cover,
                ];
            }
    
            return null;
        })->filter()->slice(($coursesUserPage - 1) * $perPage, $perPage)->values(); 
    
        return $courses;
    }
    public function feed_user(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ]);
        }
        $user = Auth::user()->only(['id', 'name', 'username', 'avatar', 'cover', 'bio', 'created_at', 'location', 'website']);
        if (!$user) {
            return response()->json([
                'status' => 404,
                'message' => 'User not found'
            ]);
        }
        $userData = [
            'id' => $user['id'],
            'name' => $user['name'],
            'username' => $user['username'],
            'avatar' => $user['avatar'],
            'bio' =>($user['bio']) ?: __('No description available.'),
            'created_at' =>($user['created_at'])->format('F j'),
            'location' =>($user['location']) ?: '',
            'website' =>($user['website']) ?: '',
        ];
        // Format user data
        $page = $request->input('page', 1);
        $perPage = config('custom.api.PROFILE_PAGE_OWN_USER_POSTS_PERPAGE_DATA');
    
        // Get posts and count
        $postsQuery = Auth::user()->posts()->withCount(['comments', 'reactions']);
        $totalPosts = $postsQuery->count();
        $posts = $postsQuery->skip(($page - 1) * $perPage)->take($perPage)->orderBy('created_at','DESC')->get();
    
        // Format the posts
        $formattedPosts = $posts->map(function ($post) {
            $tipsCount = $post->transactions()
                ->where('type', Transaction::TIP_TYPE)
                ->where('status', Transaction::APPROVED_STATUS)
                ->count();
    
            $transactions = $post->transactions()->where('status', Transaction::APPROVED_STATUS)->get();
            $isPaid = $transactions->isNotEmpty();
            $isAccessible = false;
        
            $attachments = $post->attachments->map(function ($attachment) use ($post, $isPaid) {
				$extension = pathinfo($attachment->filename, PATHINFO_EXTENSION);
				// $type = $this->determineAttachmentType($extension);
				$type = null;
				if (in_array($extension, ['jpg', 'png', 'gif'])) {
					$type = 'image';
				} elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
					$type = 'video';
				}
				
                $isAccessible = $post->price == 0 || $isPaid || 
                    (Auth::check() && Auth::user()->id !== $post->user_id && $post->price > 0 && !\PostsHelper::hasUserUnlockedPost($post->postPurchases)) ||
                    (Auth::check() && \PostsHelper::hasUserUnlockedPost($post->postPurchases));
    
                return [
                    'content_type' =>$type,
                    'file' =>Storage::url($attachment->filename),
                ];
            });
    
            $own_like = Auth::check() ? $post->reactions()->where('user_id', Auth::user()->id)
                ->where('reaction_type', 'like')->exists() : false;
    
            return [
                'post_id' => $post->id,
                'name' => $post->user->name,
                'username' => $post->user->username,
                'avatar' => $post->user->avatar,
                'bio' => '',
                'post_text' => $post->text,
                'price' => $isAccessible ? 0 : $post->price,
                'content_type' => $isAccessible ? 'locked' : 'locked',
                'attachments' => $attachments,
                'commentsCount' => $post->comments_count,
                'tipsCount' => $tipsCount,
                'likesCount' => $post->reactions_count,
                'own_like' => $own_like,
                'created_at' => $post->created_at->diffForHumans(),
            ];
        });
    
        return response()->json([
            'status' => 200,
            'data' => [
                'user' => $userData,
                'posts' => $formattedPosts,
            ]
        ]);
    }
    public function billing_address(Request $request)
    {
        /*$validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        } 
    
        $post = Post::with('user', 'transactions')->find($request->post_id);
    
        if (!$post) {
            return response()->json(['message' => 'Post not found'], 404);
        }
        $walletTotal = auth()->user()->wallet->total;
        if (!is_numeric($walletTotal)) {
            return response()->json(['message' => 'Invalid wallet amount'], 400);
        }
        $formattedAmount = $walletTotal == floor($walletTotal) 
            ? number_format($walletTotal) 
            : number_format($walletTotal, 2); 
    
        // $currencySymbol = config('app.site.currency_symbol', '$');
        // $availableCredit = "($currencySymbol" . $formattedAmount . ")";
        $transactionsData = $post->transactions->map(function ($transaction) {
            return [
                'Payment_summary' => $transaction->taxes,
                'Payment_method' => $transaction->payment_provider,
                'currency' => $transaction->currency,
            ];
        });*/
		if($request->user_id){
			$user = User::find($request->user_id);
			if (!$user) {
				return response()->json(['message' => 'User not found'], 404);
			}
		}else{
			$user = auth()->user();
		}
        $userCountryName = $user->country;
        $country = Country::where('name', $userCountryName)->first();
        $data = [
            'available_credit' =>$user->wallet->total,
            'avatar' => $user->avatar,
            'name' => $user->name,
            'username' => $user->username,
            'address' => $user->billing_address,
            'first_name' => $user->first_name,
            'last_name' => $user->last_name,
            'city' => $user->city,
            'country_id' => $country ? $country->id : null, 
            'state' => $user->state,
            'postcode' => $user->postcode,
            //'transactions' => $transactionsData,
        ];
        $countries = Country::select('id', 'name')->get();
        return response()->json([
            'status' => 200,
            'data' => [
                'user' => $data ,
                'countries' => $countries,
            ],
        ]);
    }
    public function tips_submit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'amount' => 'required|numeric|min:1|max:500',
            'billing_address' => 'nullable|string',
            'first_name' => 'nullable|string',
            'last_name' => 'nullable|string',
            'city' => 'nullable|string',
            'country' => 'nullable|exists:countries,id',
            'state' => 'nullable|string',
            'postcode' => 'nullable|string',
        ], 
        [
            'amount.required' => 'Please enter a valid amount.',
            'amount.numeric' => 'Please enter a valid amount.',
            'amount.min' => 'Please enter a valid amount.',
            'amount.max' => 'Please enter a valid amount.',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        } 
        
        $user = Auth::user();
        $post = Post::find($request->post_id);
        if (!$post) {
            return response()->json(['status' => 400, 'message' => 'Post not found']);
        }
        
        if ($post->user_id === $user->id) {
            return response()->json(['status' => 400, 'message' => 'You cannot tip yourself']);
        }
        
        if (!GenericHelperServiceProvider::creatorCanEarnMoney($post->user)) {
            return response()->json(['status' => 400, 'message' => 'This creator cannot earn money yet']);
        }
        
		if($request->payment_type == 'credit'){
			if ($user->wallet->total < $request->amount) {
				return response()->json(['status' => 400, 'message' => 'Not enough credit. You can deposit using the wallet page or use a different payment method.']);
			}
        }
        
        // Create the tip transaction
        $amt = $request->amount;
        $dataArray = [
            "data" => [],
            "taxesTotalAmount" => $amt,
            "subtotal" => $amt
        ];
        $tip = new Transaction();
        $tip->post_id = $request->post_id;
        $tip->sender_user_id = $user->id;
        $tip->recipient_user_id = $post->user_id;
        $tip->status = Transaction::APPROVED_STATUS;
        $tip->type = Transaction::TIP_TYPE; 
        $tip->currency = config('app.site.currency_code'); 
        $tip->amount = $amt;
        $tip->taxes = json_encode($dataArray); 
		if($request->payment_type == 'stripe'){
			$tip->stripe_transaction_id =  $request->client_secret;
			$tip->payment_provider = Transaction::STRIPE_PROVIDER;
		}
		if($request->payment_type == 'credit'){
			$tip->payment_provider = Transaction::CREDIT_PROVIDER;
		}
        $tip->save();

        if($request->payment_type == 'credit'){
        $user->wallet->total -= $amt;
		}
        $user->wallet->save();
        $tipsCount = $post->transactions()->where('type', Transaction::TIP_TYPE)
            ->where('status', Transaction::APPROVED_STATUS)->count();
        $formattedAmount = number_format($amt, 2);
        $currencySymbol = config('app.site.currency_symbol', '$');
        $country = Country::find($request->country);
        $countryName = $country ? $country->name : null;
    
        User::where('id', $post->user->id)->update([
            'billing_address' => $request->billing_address,
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'city' => $request->city,
            'country' =>$countryName,
            'state' => $request->state,
            'postcode' => $request->postcode,
        ]);
            
        return response()->json([
        'status' => 200, 
        'tipsCount' => $tipsCount,
        'message' => 'You successfully sent a tip of ' . $currencySymbol . $formattedAmount . '.',    
        ]);
    }
    public function post_unlock_submit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'amount' => 'required|numeric|min:1|max:500',
            'billing_address' => 'nullable|string',
            'first_name' => 'nullable|string',
            'last_name' => 'nullable|string',
            'city' => 'nullable|string',
            'country' => 'nullable|exists:countries,id',
            'state' => 'nullable|string',
            'postcode' => 'nullable|string',
        ], 
        [
            'amount.required' => 'Please enter a valid amount.',
            'amount.numeric' => 'Please enter a valid amount.',
            'amount.min' => 'Please enter a valid amount.',
            'amount.max' => 'Please enter a valid amount.',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        } 
        
        $user = Auth::user();
        $post = Post::find($request->post_id);
        if (!$post) {
            return response()->json(['status' => 400, 'message' => 'Post not found']);
        }
        
        if ($post->user_id === $user->id) {
            return response()->json(['status' => 400, 'message' => 'You don`t need to pay to see your post']);
        }
        
        if (!GenericHelperServiceProvider::creatorCanEarnMoney($post->user)) {
            return response()->json(['status' => 400, 'message' => 'This creator cannot earn money yet']);
        }
        
		if($request->payment_type == 'credit'){
			if ($user->wallet->total < $request->amount) {
				return response()->json(['status' => 400, 'message' => 'Not enough credit. You can deposit using the wallet page or use a different payment method.']);
			}
        }
        
        // Create the tip transaction
        $amt = $request->amount;
        $dataArray = [
            "data" => [],
            "taxesTotalAmount" => $amt,
            "subtotal" => $amt
        ];
        $tip = new Transaction();
        $tip->post_id = $request->post_id;
        $tip->sender_user_id = $user->id;
        $tip->recipient_user_id = $post->user_id;
        $tip->status = Transaction::APPROVED_STATUS;
        $tip->type = Transaction::POST_UNLOCK; 
        $tip->currency = config('app.site.currency_code'); 
        $tip->amount = $amt;
        $tip->taxes = json_encode($dataArray); 
		if($request->payment_type == 'stripe'){
			$tip->stripe_transaction_id =  $request->client_secret;
			$tip->payment_provider = Transaction::STRIPE_PROVIDER;
		}
		if($request->payment_type == 'credit'){
			$tip->payment_provider = Transaction::CREDIT_PROVIDER;
		}
        $tip->save();

        if($request->payment_type == 'credit'){
			$user->wallet->total -= $amt;
			$user->wallet->save();
		}
		
		$invoice = InvoiceServiceProvider::createInvoiceByTransaction($tip);
		if ($invoice != null) {
			$tip->invoice_id = $invoice->id;
			$tip->save();
		}
		
        $tipsCount = $post->transactions()->where('type', Transaction::TIP_TYPE)
            ->where('status', Transaction::APPROVED_STATUS)->count();
        $formattedAmount = number_format($amt, 2);
        $currencySymbol = config('app.site.currency_symbol', '$');
        $country = Country::find($request->country);
        $countryName = $country ? $country->name : null;
    
        User::where('id', $post->user->id)->update([
            'billing_address' => $request->billing_address,
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'city' => $request->city,
            'country' =>$countryName,
            'state' => $request->state,
            'postcode' => $request->postcode,
        ]);
            
        return response()->json([
        'status' => 200, 
        'tipsCount' => $tipsCount,
        'message' => 'You successfully sent a tip of ' . $currencySymbol . $formattedAmount . '.',    
        ]);
    }
    public function country()
    {
        $countries = Country::select('id', 'name')->get();
        return response()->json([
            'status' => 200,
            'data' => $countries,
        ]);
    }
    public function social_lists(Request $request)
    {
        $socialUserParams = $request->post();
        $userId = Auth::user()->id;
    
        $followersCount = 0;
        $followersPosts = 0;
        $followingCount = 0;
        $followingPosts = 0;
        $blockedCount = 0; 
        $blockedPosts = 0;
    
        $followingUsers = [];
        $followerUsers = [];
        $blockedUsers = [];
    
        // Following count and posts
        if (!empty($socialUserParams['following'])) {
            $followingLists = ListsHelperServiceProvider::getUserLists();
            foreach ($followingLists as $list) {
                foreach ($list->members as $member) {
                    $followingUsers[] = [
                        'id' => $member->id,
                        'username' => $member->username,
                        'name' => $member->name,
                        'cover' => $member->cover,
                        'avatar' => $member->avatar,
                    ];
                }
                $followingCount += $list->members->count();
                $followingPosts += $list->posts_count;
            }
        }
    
        // Followers count and posts
        if (!empty($socialUserParams['followers'])) {
            $followers = ListsHelperServiceProvider::getUserFollowers($userId);
            $followerIds = collect($followers)->pluck('user_id');
            $followersData = User::whereIn('id', $followerIds)->withCount('posts')->get();
            
            $followersCount = $followersData->count();
            $followersPosts = $followersData->sum('posts_count');
    
            foreach ($followersData as $follower) {
                $followerUsers[] = [
                    'id' => $follower->id,
                    'username' => $follower->username,
                    'name' => $member->name,
                    'cover' => $member->cover,
                    'avatar' => $member->avatar,
                ];
            }
        }
    
        // Blocked count and posts
        if (!empty($socialUserParams['blocked'])) {
            $blockedLists = ListsHelperServiceProvider::getUserLists();
            foreach ($blockedLists as $list) {
                if ($list->type == UserList::BLOCKED_TYPE) {
                    foreach ($list->members as $member) {
                        $blockedUsers[] = [
                            'id' => $member->id,
                            'username' => $member->username,
                            'name' => $member->name,
                            'cover' => $member->cover,
                            'avatar' => $member->avatar,
                        ];
                    }
                    $blockedCount += $list->members->count();
                    $blockedPosts += $list->posts_count;
                }
            }
        }
    
        // Return the response with the collected data
        return response()->json([
            'status' => 200,
            'data' => [
                'following_count' => $followingCount,
                'following_posts' => $followingPosts,
                'followers_count' => $followersCount,
                'followers_posts' => $followersPosts,
                'blocked_count' => $blockedCount,
                'blocked_posts' => $blockedPosts,
                'following' => $followingUsers,
                'followers' => $followerUsers,
                'blocked' => $blockedUsers,
            ],
        ]);
    }
    public function social_lists_following_delete(Request $request)
    {
        $memberID = $request->input('id');
        $member = UserListMember::find($memberID);
    
        if ($member) {
            $member->delete();
            $returnData = $request->input('return_data', false);
            
            if ($returnData) {
                return response()->json([
                    'status' => 200,
                    'message' => __('Member removed from list.'),
                    'data' => $this->getListDetails($member->list_id, $member->user_id),
                ]);
            } else {
                return response()->json([
                    'status' => 200,
                    'message' => __('Member removed from list.'),
                ]);
            }
        } else {
            return response()->json([
                'status' => 400,
                'message' => __('Member not found.'),
            ]);
        }
    }
    public function follow_creator(Request $request)
    {
        $user = Auth::user();
        if (!$user) {
            return response()->json(['status' => 401, 'message' => 'Unauthorized.']);
        }
        $followUserId = $request->input('user_id');
        $follow = $request->input('follow');
        if ($follow == 1) {
            $this->followUser($user->id, $followUserId); 
            return response()->json(['status' => 200, 'message' => 'Member added to list.']);
        } else if ($follow == 0) {
            $this->unfollowUser($user->id, $followUserId);
            return response()->json(['status' => 200, 'message' => 'Member removed from the list.']);
        } else {
            return response()->json(['status' => 400, 'message' => 'Invalid input. Use 1 to follow or 0 to unfollow.']);
        }
    }  
    private function followUser($authUserId, $followUserId)
    {
        $followingListId = $this->getFollowingListId($authUserId);
        if ($followingListId) {
            UserListMember::updateOrCreate(
                [
                    'user_id' => $followUserId,
                    'list_id' => $followingListId,
                ]
            );
        }
    }
    
    private function unfollowUser($authUserId, $followUserId)
    {
        $followingListId = $this->getFollowingListId($authUserId);
        if ($followingListId) {
            UserListMember::where([
                'user_id' => $followUserId,
                'list_id' => $followingListId,
            ])->delete();
        }
    }
    
    private function getFollowingListId($userId)
    {
        $userFollowersList = UserList::where(['user_id' => $userId, 'type' => 'following'])->first();
        return $userFollowersList ? $userFollowersList->id : null;
    }
}
