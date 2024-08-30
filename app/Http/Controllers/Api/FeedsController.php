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
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use function App\Helpers\getSetting;
use App\Helpers\PostsHelper;
use App\Providers\GenericHelperServiceProvider;
use Carbon\Carbon;

class FeedsController extends Controller
{
     //feeds-indivisual
    public function feeds_indivisual($id)
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
        ])->where('user_id', $id)->get();
        if (!$post) {
            return response()->json(['status' => '400', 'message' => 'Post not found']);
        }

        return response()->json([
            'status' => '200',
            'user' => $post,
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
    //feed
    public function feed_data(Request $request)
    {
        $userId = $request->input('user_id');
        
        if (!$userId) {
            return response()->json([
                'status' => 400,
                'message' => 'User ID is required'
            ]);
        }
        
        $user = User::select('id', 'name', 'username', 'avatar')
            ->where('id', $userId)
            ->first();
        if (!$user) {
            return response()->json([
                'status' => 404,
                'message' => 'User not found'
            ]);
        } 
        return response()->json([
            'status' => 200,
            'user' => $user,
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
    public function feeds_post_tips(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'post_id' => 'required|exists:posts,id',
            'amount' => 'required|numeric|min:1',
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
                'status' => 404,
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
        $user->$post->tips_count;
        $user->wallet->total -= $request->amount;
        $user->wallet->save();
        $tip = new  transactions();
        $tip->post_id = $request->post_id;
        $tip->user_id = $user->id;
        $tip->amount = $request->amount;
        $tip->save();
        return response()->json([
            'status' => 200,
            'message' => 'Tip sent successfully'
        ]);
    }
}
