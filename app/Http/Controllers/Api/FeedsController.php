<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\Post;
use App\Model\PostComment;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use function App\Helpers\getSetting;
use App\Model\UserList;
use App\User;
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
            'status' => '200',
            'user' => $post,
        ]);
    }
    //feed
    public function feed_data(Request $request)
    {
        $user = User::with(['attachments' => function ($query) {
            $query->select('filename', 'post_id', 'driver');
        }])->get();
        if (!$user) {
            return response()->json(['status' => '400', 'message' => 'user not found']);
        }
        return response()->json([
            'status' => '200',
            'user' => $user,
        ]);
    }
    public function feeds_post_like(Request $request)
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
}
