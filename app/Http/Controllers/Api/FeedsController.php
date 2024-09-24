<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use App\User;
use App\Model\Post;
use App\Model\PostComment;
use App\Model\UserList;
use App\Model\Reaction;
use App\Model\Transaction;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use function App\Helpers\getSetting;
use App\Helpers\PostsHelper;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\PostsHelperServiceProvider;
use Carbon\Carbon;

class FeedsController extends Controller
{
     //feeds-indivisual
    public function feeds_indivisual($id)
    {
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ], 401);
        }
        if (!is_numeric($id)) {
            return response()->json([
                'status' => 400,
                'message' => 'Invalid user ID'
            ]);
        }
        $user = User::select('id', 'name', 'username', 'avatar', 'cover', 'bio', 'created_at', 'location', 'website')
            ->with([
                'posts' => function ($query) {
                    $query->select('id', 'user_id', 'text', 'created_at')
                          ->with([
                              'comments:id,post_id,message,user_id',
                              'user:id,name,username,avatar',
                              'reactions:post_id,reaction_type'
                          ]);
                }
            ])
            ->find($id);
        if (!$user) {
            return response()->json([
                'status' => 400,
                'message' => 'User not found'
            ]);
        }
        $user->created_at_formatted = $user->created_at->format('F Y');
        $user->posts->transform(function ($post) {
            $post->created_at_formatted = $post->created_at->diffForHumans(); // e.g., "1 day ago"
            return $post;
        });
    
        return response()->json([
            'status' => 200,
            'data' => $user
        ]);
    }
    /*{
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
        ])->where('user_id', $id)->get();
        if (!$post) {
            return response()->json(['status' => '400', 'message' => 'Post not found']);
        }

        return response()->json([
            'status' => '200',
            'user' => $post,
        ]);
    } */
    //feeds_indivisual_filter_image
    public function feeds_indivisual_filter_image($id)
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
            'new_like_count' => $newLikeCount,
        ]);
    }
    public function feeds_post_comments(Request $request)
    {
        $user = Auth::user();
        
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'message' => 'sometimes|required|string|max:1000',
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
                'message' => 'Post not found'
            ]);
        }
    
        if ($comment) {
            $newComment = PostComment::create([
                'user_id' => $user->id,
                'post_id' => $postId,
                'message' => $comment,
            ]);
            $newComment->load('author');
            $newCommentsCount = $post->comments()->count();
            return response()->json([
                'status' => 200,
                'message' => 'Comment added',
                'comment' => [
                    'id' => $newComment->id,
                    'message' => $newComment->message,
                    'created_at' => $newComment->created_at,
                    'user' => [
                        'username' => $newComment->author->username,
                        'avatar' => $newComment->author->avatar,
                        'name' => $newComment->author->name,
                    ],
                ],
            ]);
        }
    
        $comments = $post->comments()->with('author')->latest()->get();
        $newCommentsCount = $comments->count();
    
        $formattedComments = $comments->map(function ($comment) {
            return [
                'id' => $comment->id,
                'message' => $comment->message,
                'created_at' => $comment->created_at,
                'user' => [
                    'username' => $comment->author->username,
                    'avatar' => $comment->author->avatar,
                    'name' => $comment->author->name,
                ],
            ];
        });
    
        return response()->json([
            'status' => 200,
            'comments' => $formattedComments,
            'new_comments_count' => $newCommentsCount,
        ]);
    }
    public function feed_all_user()
    {
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ], 401);
        }
        $users = User::select('id', 'name', 'username', 'avatar', 'cover', 'bio', 'created_at', 'location', 'website')
            ->with([
                'posts' => function ($query) {
                    $query->select('id', 'user_id', 'text', 'created_at')
                          ->with([
                              'comments:id,post_id,message,user_id',
                              'user:id,name,username,avatar',
                              'reactions:post_id,reaction_type'
                          ]);
                }
            ])
            ->get()
            ->map(function ($user) {
                $user->created_at_formatted = $user->created_at->format('F Y');
                   $user->posts->map(function ($post) {
                $post->created_at_formatted = $post->created_at->diffForHumans(); // e.g., "1 day ago"
                return $post;
            });
                return $user;
            });
        if ($users->isEmpty()) {
            return response()->json([
                'status' => 400,
                'message' => 'No users found'
            ], 404);
        }
        return response()->json([
            'status' => 200,
            'data' => $users
        ]);
    }
    public function feed()
    {
        if (!Auth::check()) {
            return response()->json(['status' => '600', 'message' => 'Unauthorized'], 401);
        }
    
        $user = Auth::user();
        $followingUserIds = $user->UserList()->pluck()->toArray();
        $posts = Post::with(['user', 'attachments', 'reactions', 'comments'])
            ->whereIn('user_id', $followingUserIds)
            ->get();
        $data = [
            'status' => '200',
            'data' => [
                'posts' => $posts->map(function ($post) use ($user) {
                    return [
                        'id' => $post->id,
                        'user' => [
                            'username' => $post->user->username,
                            'name' => $post->user->name,
                            'avatar' => $post->user->avatar,
                        ],
                        'text' => $post->text,
                        'created_at' => $post->created_at->toDateTimeString(),
                        'is_pinned' => $post->is_pinned,
                        'expire_date' => $post->expire_date ? $post->expire_date->toDateTimeString() : null,
                        'release_date' => $post->release_date ? $post->release_date->toDateTimeString() : null,
                        'price' => $post->price,
                        'attachments' => $post->attachments->map(function ($attachment) {
                            return [
                                'url' => $attachment->url,
                                'type' => $attachment->type,
                            ];
                        }),
                        'reactions_count' => $post->reactions->count(),
                        'comments_count' => $post->comments->count(),
                        'tips_count' => $post->tips_count,
                        'is_subbed' => $post->is_subbed,
                        'is_expired' => $post->is_expired,
                        'is_scheduled' => $post->is_scheduled,
                        'is_own_post' => $user->id === $post->user_id,
                    ];
                }),
            ],
        ];
    
        return response()->json($data);
    }
    public function feed_user()
    {
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ], 401);
        }
        $user = User::select('id', 'name', 'username', 'avatar', 'cover', 'bio', 'created_at', 'location', 'website')
            ->with([
                'posts' => function ($query) {
                    $query->select('id', 'user_id', 'text', 'created_at')
                          ->with([
                              'comments:id,post_id,message,user_id',
                              'user:id,name,username,avatar',
                              'reactions:post_id,reaction_type'
                          ]);
                }
            ])
            ->find($id);
        if (!$user) {
            return response()->json([
                'status' => 400,
                'message' => 'User not found'
            ]);
        }
        $user->created_at_formatted = $user->created_at->format('F Y');
        $user->posts->transform(function ($post) {
            $post->created_at_formatted = $post->created_at->diffForHumans(); // e.g., "1 day ago"
            return $post;
        });
    
        return response()->json([
            'status' => 200,
            'data' => $user
        ]);
    }
    public function tips_fetch(Request $request)
    {
        $validator = Validator::make($request->all(), [
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
        $transactionsData = $post->transactions->map(function ($transaction) {
            return [
                'Payment_summary' => $transaction->taxes,
                'Payment_method'=> $transaction->payment_provider,
            ];
        });
        $data = [
            'user' => [
                'avatar' => $post->user->avatar,
                'name' => $post->user->name,
                'billing_address ' => $post->user->billing_address ,
                'first_name ' => $post->user->first_name ,
                'last_name' => $post->user->last_name ,
                'city' => $post->user->city,
                'country' => $post->user->country,
                'state' => $post->user->state,
                'postcode' => $post->user->postcode, 	 

            ],
            'transactions' => $transactionsData,
        ];
    
        return response()->json([
            'status' => 200,
            'data' => $data,
        ]);
    }
    public function tips_submit(Request $request)
    {
        // Validate the incoming request
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'amount' => 'required|numeric|min:1',
            'payment_provider' => 'required|string',
        ]);
        
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        
        $user = Auth::user();
        $post = Post::find($request->post_id);
        
        if (!$post) {
            return response()->json([
                'status' => 400,
                'message' => 'Post not found'
            ]);
        }
        
        if ($post->user_id == $user->id) {
            return response()->json([
                'status' => 400,
                'message' => 'You cannot tip yourself'
            ]);
        }
        
        if (!GenericHelperServiceProvider::creatorCanEarnMoney($post->user)) {
            return response()->json([
                'status' => 400,
                'message' => 'This creator cannot earn money yet'
            ]);
        }
        
        if ($user->wallet->total < $request->amount) {
            return response()->json([
                'status' => 400,
                'message' => 'Insufficient funds'
            ]);
        }
        
        // Create the tip transaction
        $tip = new Transaction();
        $tip->post_id = $request->post_id;
        $tip->sender_user_id = $user->id;
        $tip->status = 'approved';
        $tip->type = 'tip';
        $tip->currency = 'USD';
        $tip->amount = $request->amount;
        $tip->payment_provider = $request->payment_provider;
        $tip->save();
        
        // Deduct the amount from the user's wallet
        $user->wallet->total -= $request->amount;
        $user->wallet->save();
        
        $creator = $post->user;
        if ($creator) {
            $creator->update([
                'billing_address' => $user->billing_address,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'city' => $user->city,
                'country' => $user->country,
                'state' => $user->state,
                'postcode' => $user->postcode,
            ]);
        }
        
        return response()->json([
            'status' => 200,
            'message' => 'Tip sent successfully'
        ]);
    }
}
  
