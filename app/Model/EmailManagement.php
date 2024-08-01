<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EmailManagement extends Model
{
    use HasFactory;
	protected $fillable = [
        'message_subject',
        'message_subject_de',
        'message_subject_fr',
        'message_subject_it',
        'message',
        'message_de',
        'message_fr',
        'message_it',
        'status',
    ];
}
