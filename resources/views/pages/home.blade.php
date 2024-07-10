@extends('layouts.generic')

@section('page_description', getSetting('site.description'))
@section('share_url', route('home'))
@section('share_title', getSetting('site.name') . ' - ' . getSetting('site.slogan'))
@section('share_description', getSetting('site.description'))
@section('share_type', 'article')
@section('share_img', GenericHelper::getOGMetaImage())

@section('scripts')
    <script type="application/ld+json">
  {
    "@context": "http://schema.org",
    "@type": "Organization",
    "name": "{{getSetting('site.name')}}",
    "url": "{{getSetting('site.app_url')}}",
    "address": ""
  }
</script>
@stop

@section('styles')
    {!!
        Minify::stylesheet([
            '/css/pages/home.css',
            '/css/pages/search.css',
         ])->withFullUrl()
    !!}
@stop

@section('content')
    {{-- <div class="home-header min-vh-75 relative pt-2" >
        <div class="container h-100">
            <div class="row d-flex flex-row align-items-center h-100">
                <div class="col-12 col-md-6 mt-4 mt-md-0">
                    <h1 class="font-weight-bold text-gradient bg-gradient-primary">{{__('Teach Self Defence Online')}},</h1>
                    <h1 class="font-weight-bold text-gradient bg-gradient-primary">{{__('Learn Self Defence Online')}}.</h1>
                    <p class="font-weight-bold mt-3"> {{__("Start your own olnine Self Defence platform with lots of opportunities.")}}</p>
                    <div class="mt-4">
                        <a href="{{route('login')}}" class="btn btn-grow bg-gradient-primary  btn-round mb-0 me-1 mt-2 mt-md-0 ">{{__('Try for free')}}</a>
                        <a href="{{route('search.get')}}" class="btn btn-grow btn-link  btn-round mb-0 me-1 mt-2 mt-md-0 ">
                            @include('elements.icon',['icon'=>'search-outline','centered'=>false])
                            {{__('Explore')}}</a>
                    </div>
                </div>
                <div class="col-12 col-md-6 d-none d-md-block p-5">
                    <img src="{{asset('/img/home-header.svg')}}" alt="{{__('Make more money')}}"/>
                </div>
            </div>
        </div>
    </div> --}}
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
      <ol class="carousel-indicators">
        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img class="d-block w-100" src="{{asset('/img/static/slider4.png')}}" alt="First slide">
          <div class="carousel-caption d-none d-md-block">
            <h1>Learn Self Defence Online</h1>
            <p>...</p>
          </div>
        </div>
        <div class="carousel-item">
          <img class="d-block w-100" src="{{asset('/img/static/slider2.png')}}" alt="Second slide">
          <div class="carousel-caption d-none d-md-block">
            <h1>Teach Self Defence Online</h1>
            <p>...</p>
          </div>
        </div>
        <div class="carousel-item">
          <img class="d-block w-100" src="{{asset('/img/static/slider3.png')}}" alt="Third slide">
          <div class="carousel-caption d-none d-md-block">
            <h1>Onlyfans for Self Defence</h1>
            <p>...</p>
          </div>
        </div>
      </div>
      <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
    </div>
    <div class="my-5 py-5 home-bg-section">
        <div class="container my-5">
            <div class="row">
                <div class="col-12 col-md-4 mb-5 mb-md-0">
                    <div class="d-flex justify-content-center">
					{{--<img src="{{asset('/img/home-scene-1.svg')}}" class="img-fluid home-box-img" alt="{{__('Premium & Private content')}}">--}}
						@include('elements.icon',['icon'=>'home-outline','variant'=>'xlarge','centered'=>false,'classes'=>''])
                    </div>
                    <div class="d-flex justify-content-center mt-4">
                        <div class="col-12 col-md-10 text-center">
                            <h5 class="text-bold">{{__('LEARN ANYWHERE')}}</h5>
                            <span>{{__('You Can Learn Martial Arts From Anywhere In The World With Our Easy 24/7 Online Access..')}} </span>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md-4 mb-5 mb-md-0">
                    <div class="d-flex justify-content-center">
                        {{--<img src="{{asset('/img/home-scene-2.svg')}}" class="img-fluid home-box-img" alt="{{__('Private chat & Tips')}}">--}}
						@include('elements.icon',['icon'=>'star-outline','variant'=>'xlarge','centered'=>false,'classes'=>''])
                    </div>
                    <div class="d-flex justify-content-center mt-4">
                        <div class="col-12 col-md-10 text-center">
                            <h5 class="text-bold">{{__('INSTRUCTORS')}}</h5>
                            <span>{{__('We Provide You With Some Of The Most Highly Trained And Qualified Instructors In The World.')}}</span>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md-4 mb-5 mb-md-0">
                    <div class="d-flex justify-content-center">
                        {{--<img src="{{asset('/img/home-scene-3.svg')}}" class="img-fluid home-box-img" alt="{{__('Secured assets & Privacy focus')}}">--}}
						@include('elements.icon',['icon'=>'medkit-outline','variant'=>'xlarge','centered'=>false,'classes'=>''])
                    </div>
                    <div class="d-flex justify-content-center mt-4">
                        <div class="col-12 col-md-10 text-center">
                            <h5 class="text-bold">{{__('HEALTH AND SAFETY')}}</h5>
                            <span>{{__("We Give You The Skills Required To Protect Yourself And More Importantly, Your Loved Ones.")}}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="mt-5 pb-3 pt-5">
        <div class="container">
            <div class="row">
                <div class="col-12 col-md-5 d-none d-md-flex justify-content-center">
                    {{--<img src="{{asset('/img/home-creators.svg')}}" class="home-mid-img" alt="{{__('Make more money')}}">--}}
					<img src="{{asset('/img/defence-1.jpg')}}" class="home-mid-img home-achieve-img" alt="{{__('Make more money')}}">
                </div>
                <div class="col-12 col-md-7">
                    <div class="w-100 h-100 d-flex justify-content-center align-items-center">
                        <div class="pl-4 pl-md-5">
                            <h4 class="font-weight-normal font-italic m-0">{{__('State Of The Art Online Training')}}.</h4>
                            <h2 class="font-weight-bold m-0">{{__('ACHIEVE MORE THAN YOU EVER THOUGHT POSSIBLE!')}},</h2>
                            <div class="my-4 col-9 px-0">
                                <p>{{__("We focus on giving everyone the opportunity to achieve more than they ever thought possible.")}}</p>
                                <p>{{__("This program gives you the ability to reach your goals in a much quicker period of time, providing you with access to some of the best Martial Arts in the world, by bringing together some of the most highly trained, respected and qualified instructors in the world.")}}</p>
                                <p>{{__("We understand that it can be hard making the time in life to do the things you like and want to do, that is why our online program is designed to make it easier for you!")}}</p>
                                <p>{{__("You can now learn Martial Arts from the comfort of your own home or anywhere in the world with our easy online access that is available 24/7 at a click of a button.")}}</p>
                                <p>{{__("We know that you cannot put a price on your family’s safety. That is why we offer a wide range of courses for you to choose from, that are specifically designed to teach you self defence, also how to be aware of your surroundings and give you the skills required to neutralise any attacker and protect you and your loved ones.")}}</p>
                                <p>{{__("Don’t delay JOIN us today on this journey and become part of something special.")}}</p>
                            </div>
                            <div>
                                <a href="{{route('pages.get',['slug' => 'about'])}}" class="btn btn-grow mb-0 me-1 mt-2 mt-md-0 button-default">{{__('About Us')}}</a>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    {{--<div class="mt-5 pb-3 pt-5 home-bg-section">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="font-weight-bold">{{__('Main features')}}</h2>
                <p>{{__("Here's a glimpse at the main features our script offers")}}</p>
            </div>
            <div class="row">
                <div class="col-12 col-md-4 mb-5 btn-grow px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row-reverse">
                        @include('elements.icon',['icon'=>'phone-portrait-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("Mobile Ready")}}</h5>
                    <p class="mb-0">{{__("Cross compatible & mobile first design.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row-reverse">
                        @include('elements.icon',['icon'=>'cog-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("Advanced Admin panel")}}</h5>
                    <p class="mb-0">{{__("Easy to use, fully featured admin panel.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row-reverse">
                        @include('elements.icon',['icon'=>'people-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("User subscriptions")}}</h5>
                    <p class="mb-0">{{__("Easy to use and reliable subscriptions system.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row-reverse">
                        @include('elements.icon',['icon'=>'list-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("User feed & Locked posts")}}</h5>
                    <p class="mb-0">{{__("Advanced feed system, pay to unlock posts.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow text-left px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row">
                        @include('elements.icon',['icon'=>'moon-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("Light & Dark themes")}}</h5>
                    <p class="mb-0">{{__("Eazy to customize themes, dark & light mode.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow text-left px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row">
                        @include('elements.icon',['icon'=>'language-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("RTL & Locales")}}</h5>
                    <p class="mb-0">{{__("Fully localize your site with languages & RTL.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow text-left px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row">
                        @include('elements.icon',['icon'=>'chatbubbles-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("Live chat & Notifications")}}</h5>
                    <p class="mb-0">{{__("Live user messenger & User notifications.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow text-left px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row">
                        @include('elements.icon',['icon'=>'bookmarks-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("Post Bookmarks & User lists")}}</h5>
                    <p class="mb-0">{{__("Stay updated with list users and bookmarks.")}}</p>
                </div>

                <div class="col-12 col-md-4 mb-5 btn-grow text-left px-4 py-3 rounded my-2 w-100">
                    <div class="flex-row">
                        @include('elements.icon',['icon'=>'flag-outline','variant'=>'large','centered'=>false,'classes'=>''])
                    </div>
                    <h5 class="text-bold">{{__("Content flagging and User reports")}}</h5>
                    <p class="mb-0">{{__("Stay safe with user and content reporting.")}}</p>
                </div>

            </div>
        </div>
    </div>

    <div class="my-5 py-2">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="font-weight-bold">{{__("Technologies used")}}</h2>
                <p>{{__("Built on secure, scalable and reliable techs")}}</p>
            </div>
            <div class="d-flex align-items-center justify-content-center">
                <div class="d-flex justify-content-center align-items-center row col">
                    <img src="{{asset('/img/logos/laravel.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('laravel'))}}" alt="{{__('laravel')}}"/>
                    <img src="{{asset('/img/logos/bootstrap.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('bootstrap'))}}" alt="{{__('bootstrap')}}"/>
                    <img src="{{asset('/img/logos/jquery.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('jquery'))}}" alt="{{__('jquery')}}"/>
                    <img src="{{asset('/img/logos/aws.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('aws'))}}" alt="{{__('aws')}}"/>
                    <img src="{{asset('/img/logos/pusher.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('pusher'))}}" alt="{{__('pusher')}}"/>
                    <img src="{{asset('/img/logos/stripe.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('stripe'))}}" alt="{{__('stripe')}}"/>
                    <img src="{{asset('/img/logos/paypal.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('paypal'))}}" alt="{{__('paypal')}}"/>
                    <img src="{{asset('/img/logos/coinbase.svg')}}" class="mx-3 mb-2 grayscale coinbasae-logo" title="{{ucfirst(__('coinbase'))}}" alt="{{__('coinbase')}}"/>
                    <img src="{{asset('/img/logos/wasabi.svg')}}" class="mx-3 mb-2 grayscale" title="{{ucfirst(__('wasabi'))}}" alt="{{__('wasabi')}}"/>
                </div>
            </div>
        </div>
    </div>--}}

    <div class="my-5 py-5 home-bg-section text-white bgimg-1" style="background-image: url({{asset('/img/static/slider4.png')}});">
        <div class="container">
            <div class="text-center mb-4">
                <h4 class="font-weight-normal font-italic m-0">{{__('Our Students Believe In Us')}}.</h4>
                <h2 class="font-weight-bold">{{__("Here's what they are saying")}}</h2>
				{{--<p>{{__("Here's list of currated content creators to start exploring now!")}}</p>--}}
            </div>

            <div class="creators-wrapper">
            <div class="row">
            <div class="col-md-12">
                <div id="carouselExampleIndicators1" class="carousel slide" data-ride="carousel">
				  <div class="carousel-inner">
					<div class="carousel-item active">
						<div class="carousel-testimonial">
							<p>“Amazing course and great value for money! Looking forward to learning more!"</p>
							<h4 class="font-weight-normal font-italic m-0">{{__('Charlotte Wood')}}.</h4>
						</div>
					</div>
					<div class="carousel-item">
						<div class="carousel-testimonial">
							<p>“Great value for money! My child feels a lot more confident now!"</p>
							<h4 class="font-weight-normal font-italic m-0">{{__('Paul Cooper')}}.</h4>
						</div>
					</div>
					<div class="carousel-item">
						<div class="carousel-testimonial">
							<p>“Great way to spend more time with my son! The techniques are so simple and effective!"</p>
							<h4 class="font-weight-normal font-italic m-0">{{__('David James')}}.</h4>
						</div>
					</div>
				  </div>
				  <ol class="testimonial-carousel-indicators">
					<li data-target="#carouselExampleIndicators1" data-slide-to="0" class="active"></li>
					<li data-target="#carouselExampleIndicators1" data-slide-to="1"></li>
					<li data-target="#carouselExampleIndicators1" data-slide-to="2"></li>
				  </ol>
				  <a class="carousel-control-prev" href="#carouselExampleIndicators1" role="button" data-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="sr-only">Previous</span>
				  </a>
				  <a class="carousel-control-next" href="#carouselExampleIndicators1" role="button" data-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"></span>
					<span class="sr-only">Next</span>
				  </a>
				</div>
            </div>
            </div>
            </div>
        </div>
    </div>
    <div class="my-5 py-5 home-bg-section">
        <div class="container">
            <div class="text-center mb-4">
                <h2 class="font-weight-bold">{{__("Featured Instructors")}}</h2>
                <p>{{__("Meet just some of the instructors")}}</p>
				{{--<p>{{__("Here's list of currated content creators to start exploring now!")}}</p>--}}
            </div>

            <div class="creators-wrapper">
                <div class="row px-3">
                    @if(count($featuredMembers))
                        @foreach($featuredMembers as $member)
                            <div class="col-12 col-md-4 p-1">
                                <div class="p-2">
                                    @include('elements.vertical-member-card',['profile' => $member])
                                </div>
                            </div>
                        @endforeach
                    @endif
                </div>
            </div>
        </div>
    </div>

    {{--<div class="py-4 my-4 white-section ">
        <div class="container">
            <div class="text-center">
                <h3 class="font-weight-bold">{{__("Got questions?")}}</h3>
                <p>{{__("Don't hesitate to send us a message at")}} - <a href="{{route('contact')}}">{{__("Contact")}}</a> </p>
            </div>
        </div>
    </div>--}}
    <div class="py-4 my-4 white-section ">
        <div class="container">
            <div class="text-center">
                <h4 class="font-weight-normal font-italic m-0">State Of The Art Online Training.</h4>
				<h1 class="font-weight-bold">{{__("Challenge yourself. have you got what it takes?")}}</h1>
                <div>
					<a href="#" class="btn btn-grow mb-0 me-1 mt-2 mt-md-0 button-default">{{__('Join Us')}}</a>
				</div>
            </div>
        </div>
    </div>
@stop
