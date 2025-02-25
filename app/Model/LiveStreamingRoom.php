<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class LiveStreamingRoom extends Model
{	
	protected $table = 'live_streaming_room';
	
	protected $fillable = [
        'stream_id', 'user_id', 'status'
    ];
}
