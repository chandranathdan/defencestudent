<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use App\User;
use App\Model\Post;
use App\Model\PostComment;
use App\Model\UserList;
use App\Model\UserListMember;
use App\Model\Reaction;
use App\Model\Transaction;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use function App\Helpers\getSetting;
use App\Helpers\PostsHelper;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\ListsHelperServiceProvider;
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
            ]);
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
            $post->created_at_formatted = $post->created_at->diffForHumans();
            return $post;
        });
    
        return response()->json([
            'status' => 200,
            'data' => $user
        ]);
    }
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
        return [
            'id' => $comment->id,
            'user_id' => $comment->user_id,
           // 'post_id' => $comment->post_id,
            'message' => $comment->message,
            'created_at' => $comment->created_at->diffForHumans(), 
                'username' => $comment->author->username,
                'avatar' => $comment->author->avatar,
                'name' => $comment->author->name,
                'post_comment_likes_ount' =>$likesCount,
                'worn_user' => $comment->user_id === Auth::id(),
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
    
        // Validate the incoming request
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
    
        // Check for an existing like
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
            'new_like_count' => $newLikeCount,
        ]);
    }
    public function feeds_delete_comments(Request $request)
    {
        $user = Auth::user();
        // Validate the request
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
            'new_comments_count' => PostComment::where('post_id', $comment->post_id)->count(), // Reference the post_id
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
                'currency'=> $transaction->currency,
                'available_credit' => auth()->user()->wallet->total, 
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
            'billing_address' => 'nullable|string',
            'first_name' => 'nullable|string',
            'last_name' => 'nullable|string',
            'city' => 'nullable|string',
            'country' => 'nullable|string',
            'state' => 'nullable|string',
            'postcode' => 'nullable|string',
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
        
        if ($user->wallet->total < $request->amount) {
            return response()->json(['status' => 400, 'message' => 'Insufficient funds']);
        }
        
        // Create the tip transaction
        $amt= $request->amount;
        $dataArray = [
            "data" => [],
            "taxesTotalAmount" => $amt,
            "subtotal" => $amt
        ];
        $tip = new Transaction();
        $tip->post_id = $request->post_id;
        $tip->sender_user_id = $user->id;
        $tip->recipient_user_id = $post->user_id;
        $tip->status = 'approved';
        $tip->type = Transaction::TIP_TYPE; 
        $tip->currency = config('app.site.currency_code'); 
        $tip->amount = $request->amount;
        $tip->taxes = json_encode($dataArray); 
        $tip->payment_provider = $request->payment_provider; 
        $tip->save();
        
        $user->wallet->total -= $request->amount;
        $user->wallet->save();
    
        $creator = $post->user;
        $updated = User::where('id', $post->user->id)->update([
            'billing_address' => $request->billing_address,
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'city' => $request->city,
            'country' => $request->country,
            'state' => $request->state,
            'postcode' => $request->postcode,
        ]);
            
        return response()->json(['status' => 200, 'message' => 'Tip sent successfully']);
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
    
        if ($follow === '1') {
            // Ensure the authenticated user is following the specified user
            $this->followUser($user->id, $followUserId);
            return response()->json(['status' => 200, 'message' => 'You are now following the user.']);
        } elseif ($follow === '0') {
            // Ensure the authenticated user unfollows the specified user
            $this->unfollowUser($user->id, $followUserId);
            return response()->json(['status' => 200, 'message' => 'You have unfollowed the user.']);
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