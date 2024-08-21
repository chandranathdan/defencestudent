<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class Homecontroller extends Controller
{
    public function home_slider()
    {
        $carouselItems = [
            [
                'image' =>"{{asset('/img/static/slider2.png')}}",
                'alt' => 'First slide',
                'title' => 'Learn Self Defence Online',
             
            ],
            [
                'image' =>"{{asset('/img/static/slider3.png')}}",
                'alt' => 'Second slide',
                'title' => 'Teach Self Defence Online',
            ],
            [
                'image' =>"{{asset('/img/static/slider4.png')}}",
                'alt' => 'Third slide',
                'title' => 'Onlyfans for Self Defence',
            ]
        ];

        return response()->json([
            'status' => '200',
            'user' => $carouselItems,
        ]);
    }
}

