<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use App\Model\LiveStreamingRoom;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class LivestreamingController extends Controller
{
    public function add_live_stream_room(Request $request)
    {
		// Check if the user is authenticated
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ]);
        }
        $validator = Validator::make($request->all(), [
            'stream_id' => 'required',
            'user_id' => 'required',
        ], 
        [
            'stream_id.required' => 'Stream id is required.',
            'user_id.numeric' => 'User id is required.',
        ]);
				
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
		
		$room = new LiveStreamingRoom();
        $room->stream_id = $request->stream_id;
        $room->user_id = $request->user_id;
        $room->status = 0;
        if($room->save()){
			return response()->json([
				'status' => 200, 
				'message' => 'Room created successfully.',    
			]);
		}else{
			return response()->json([
				'status' => 400, 
				'message' => 'Room not created.',    
			]);
		}
	}
	public function close_live_stream_room(Request $request)
    {
		// Check if the user is authenticated
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ]);
        }
		
        $validator = Validator::make($request->all(), [
            'stream_id' => 'required',
        ], 
        [
            'stream_id.required' => 'Stream id is required.',
        ]);
				
        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors(),
                'status' => 600,
            ]);
        }
		
		$room = LiveStreamingRoom::find($request->stream_id);
        $room->status = 1;
        if($room->save()){
			return response()->json([
				'status' => 200, 
				'message' => 'Room closed successfully.',    
			]);
		}else{
			return response()->json([
				'status' => 400, 
				'message' => 'Room not closed.',    
			]);
		}
	}
	public function get_live_stream()
    {
		// Check if the user is authenticated
        if (!Auth::check()) {
            return response()->json([
                'status' => 401,
                'message' => 'Unauthorized'
            ]);
        }
		
		$rooms = LiveStreamingRoom::where('status', 0)->orderBy('id', 'DESC')->get();
		
        return response()->json([
            'status' => 200,
            'data' => $rooms,
        ]);
	}
}
