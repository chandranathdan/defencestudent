@extends('layouts.generic')

@section('page_title', __($page->title))
@section('share_url', route('home'))
@section('share_title', getSetting('site.name') . ' - ' . getSetting('site.slogan'))
@section('share_description', getSetting('site.description'))
@section('share_type', 'article')
@section('share_img', GenericHelper::getOGMetaImage())

@section('styles')
{!!
	Minify::stylesheet(
		[
			'/css/faq.css',
		 ]
		 )->withFullUrl()
!!}
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
@stop
@section('content')
<div class="page-content-wrapper pb-5" style="position: relative; text-align: center;">
    <img class="d-block w-100" src="{{ asset('/img/static/about_image.jpg') }}" style="width: 100%; height: 400px; object-fit: cover;">
    <div class="carousel-caption d-none d-md-block" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: white;">
        <h3>We'd Love To Work with You</h3>
        <h1>Become a Content Creator</h1>
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
            <img src="{{ asset('/img/defence-3.jpg') }}" class="home-mid-img home-achieve-img" alt="{{ __('Make more money') }}" style="width: 400px; height: 300px;">
        </div>
    </div>
</div>
<div class="py-5 home-bg-section">
<div class="container">
	<div class="text-center pb-5">
		<h4 class="font-weight-normal font-italic m-0">All You Need To Know</h4>
		<h1 class="font-weight-bold">Frequently asked questions</h1>
	</div>
	<div class="faq-wrapper">
        <!-- Left Side -->
        <div class="faq-column">
            <div class="faq-item">
                <button class="faq-question">
					Is This Good Value For Money?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Absolutely! Our highly trained and qualified instructors will give you all the skills to protect yourself and your loved ones.</p>
					
					<p class="mb-3">Also, we will provide you with details on how to be aware of your surroundings which will help you detect future danger so you can prevent life threatening situations.</p>

					<p class="mb-3">You will also be given the opportunity to achieve your Black Belt in whichever Martial Art of your choosing.</p> 

					<p>Please contact us via email for more information.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
					Do I Need Any Experience Before Signing Up?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>No experience is necessary! Our instructors are highly trained in teaching you all the techniques and providing you with the required information.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
					How Do I Purchase A Course?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>You can purchase a course by visiting our online platform and selecting your preferred course.</p>
                </div>
            </div>

            <!-- Add more items as needed -->
        </div>

        <!-- Right Side -->
        <div class="faq-column">
            <div class="faq-item">
                <button class="faq-question">
					How Long Will It Take Me To Become A Black Belt?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>This requires a lot of hard work and dedication. However, we hold no grading dates or time restrictions that would hold a student back from achieving their goals.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
					Will This Improve My Health And Fitness?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Yes, martial arts training improves overall health, physical fitness, and mental well-being. Yes, martial arts training improves overall health, physical fitness, and mental well-being. Yes, martial arts training improves overall health, physical fitness, and mental well-being. Yes, martial arts training improves overall health, physical fitness, and mental well-being. </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
					Will This Help Against Bullies?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Martial arts teaches self-defense and boosts confidence, which can be helpful in dealing with bullying.</p>
                </div>
            </div>

            <!-- Add more items as needed -->
        </div>
    </div>
</div>
</div>
@stop
@section('scripts')
<script>
	document.addEventListener("DOMContentLoaded", function () {
		const faqItems = document.querySelectorAll('.faq-question');

		faqItems.forEach(item => {
			item.addEventListener('click', function () {
				const answer = this.nextElementSibling; // Corresponding answer div

				// Close all other open answers
				document.querySelectorAll('.faq-answer').forEach(openItem => {
					if (openItem !== answer) {
						openItem.style.maxHeight = null;
						openItem.classList.remove('open');
						
						const arrow = openItem.previousElementSibling.querySelector('.arrow');
						
						// Ensure the arrow exists before attempting to manipulate it
						if (arrow) {
							arrow.style.transform = 'rotate(0)';
						}
					}
				});

				// Toggle current answer
				const arrow = this.querySelector('.arrow');
				if (answer.classList.contains('open')) {
					answer.style.maxHeight = null; // Close
					answer.classList.remove('open');
					if (arrow) {
						arrow.style.transform = 'rotate(0)';
					}
				} else {
					answer.style.maxHeight = (answer.scrollHeight + 25) + 'px'; // Open
					answer.classList.add('open');
					if (arrow) {
						arrow.style.transform = 'rotate(90deg)';
					}
				}
			});
		});
	});
</script>
@stop