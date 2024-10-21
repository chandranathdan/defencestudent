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
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
// use function App\Helpers\getSetting;
use App\Helpers\PostsHelper;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\MembersHelperServiceProvider;
use Illuminate\Support\Facades\Storage;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\ListsHelperServiceProvider;
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
        $user = User::select('id', 'name', 'username', 'avatar', 'cover', 'bio', 'created_at', 'location', 'website')
                    ->find($userId);
    
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
                            'file' => Storage::url('attachments/' . $attachment->filename),
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
                'posts' => $formattedPosts,
            ],
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
        $suggestedMembers = MembersHelperServiceProvider::getSuggestedMembers();
    
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
		$followingUserIds = collect($followingUserIds);
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
					'file' => Storage::url('attachments/' . $attachment->filename),
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
                    'file' =>Storage::url('attachments/' . $attachment->filename),
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
        });
        $userCountryName = $post->user->country;
        $country = Country::where('name', $userCountryName)->first();
        $data = [
            'available_credit' =>auth()->user()->wallet->total,
            'avatar' => $post->user->avatar,
            'name' => $post->user->name,
            'username' => $post->user->username,
            'address' => $post->user->billing_address,
            'first_name' => $post->user->first_name,
            'last_name' => $post->user->last_name,
            'city' => $post->user->city,
            'country_id' => $country ? $country->id : null, 
            'state' => $post->user->state,
            'postcode' => $post->user->postcode,
            'transactions' => $transactionsData,
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
        
        if ($user->wallet->total < $request->amount) {
            return response()->json(['status' => 400, 'message' => 'Not enough credit. You can deposit using the wallet page or use a different payment method.']);
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
        $tip->payment_provider = Transaction::CREDIT_PROVIDER;
        $tip->save();

        
        $user->wallet->total -= $amt;
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
        if ($follow === '1') {
            $this->followUser($user->id, $followUserId); 
            return response()->json(['status' => 200, 'message' => ' Member added to list.']);
        } elseif ($follow === '0') {
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