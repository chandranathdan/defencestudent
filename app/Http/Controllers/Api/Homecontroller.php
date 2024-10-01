<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\HomeSlider;
use App\Model\PublicPage;

class Homecontroller extends Controller
{
    public function home_slider()
    {
        $homeslider = HomeSlider::select('image', 'title', 'description')->get();
        $carouselItems = [];
        foreach ($homeslider as $slider) {
            $carouselItems[] = [
                'image' => asset('img/static/' . $slider->image),          
                'title' => $slider->title,
                'description' => $slider->description
            ];
        }
        return response()->json([
            'status' => 200,
            'data' => $carouselItems,
        ]);
    }
    public function cms(Request $request)
    {
    $termsConditions = (int) $request->post('terms_and_conditions');
    $privacyPolicy = (int) $request->post('privacy_policy');
    $helpFaq = (int) $request->post('help_faq');

    $response = [
        'status' => 200,
        'data' => []
    ];

    // Function to format date and content
    $formatDate = function ($page) {
        return [
            'title'=> $page->title,
            'updated_at' => $page->updated_at->format('Y-m-d'),
            'content' => $page->content,
        ];
    };

    // Fetch data based on conditions
    if ($termsConditions === 1) {
        $response['data']['terms_and_conditions'] = PublicPage::where('slug', 'terms-and-conditions')->get()->map($formatDate);
    }
    if ($privacyPolicy === 1) {
        $response['data']['privacy_policy'] = PublicPage::where('slug', 'privacy')->get()->map($formatDate);
    }
    if ($helpFaq === 1) {
        $response['data']['help_faq'] = PublicPage::where('slug', 'help')->get()->map($formatDate);
    }

    // Return JSON response
    return response()->json($response);
}
}
