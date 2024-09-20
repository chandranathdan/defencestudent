@extends('layouts.generic')

@section('page_title', __($page->title))
@section('share_url', route('home'))
@section('share_title', getSetting('site.name') . ' - ' . getSetting('site.slogan'))
@section('share_description', getSetting('site.description'))
@section('share_type', 'article')
@section('share_img', GenericHelper::getOGMetaImage())

@section('content')
<div class="page-content-wrapper pb-5">
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img class="d-block w-100" src="{{ asset('/img/static/slider4.png') }}" alt="First slide">
                <div class="carousel-caption d-none d-md-block">
                    <h3>We'd Love To Work with You</h3>
                    <h1 class="elementor-heading-title">become a content creator</h1>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <div class="col-12 col-md-8">
        <div class="col-12 text-center">
            <h1 class="text-bold">{{ $page->title }}</h1>
            @if(in_array($page->slug, ['help', 'privacy', 'terms-and-conditions']))
                <p class="text-muted mt-2">{{ __("Last updated") }}: {{ $page->updated_at->format('Y-m-d') }}</p>
            @endif
        </div>
            <div class="d-flex justify-content">
                {!! $page->content !!}
            </div>
        </div>
        
        <div class="col-12 col-md-4 d-none d-md-flex justify-content-center mt-4">
            <img src="{{ asset('/img/defence-2.jpg') }}" class="home-mid-img home-achieve-img" alt="{{ __('Make more money') }}" style="width: 400px; height: 300px;">
        </div>
    </div>
</div>

@stop
