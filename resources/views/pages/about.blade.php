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
        <h3 class="default-color-text">We'd Love To Work with You</h3>
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
            <div>
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
		<h4 class="font-weight-normal font-italic m-0 text-css">All You Need To Know</h4>
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
                <p class="mb-3">No experience is necessary! Our instructors are highly trained in teaching you all the techniques and providing you with the required information.</p>
                    <p class="mb-3">Or you can choose a monthly subscription plan if you wish to test out the course to see if you enjoy it first.</p>
                    <p>You will then be given full access to that course once you have chosen the right plan for you.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    How Do I Know Which Course Is Right For Me?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>All our courses provide you with the required information so you can decide which one is best for you.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Can I Have Access To All The Courses?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Yes! We offer a VIP package option so you can get full access to the entire collection that includes: Bully Buster, Street Defence and Women’s Self Defence.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Can I Cancel My Subscription At Anytime?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                <p class="mb-3">Absolutely! You can cancel your monthly subscription plan at anytime, we do not hold you accountable for any long term contracts.</p>
                    <p class="mb-3">We do recommend that you cancel your plan at the end of the month so you can continue to enjoy our video content because your access will be removed as soon as you submit your cancellation.</p>
                    <p>If you press cancel by mistake, do not worry because the option to re-active will come up straight away!</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                        How Do The Promotion Codes Work?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                <p class="mb-3">Promotion codes give you 20% off on your first course purchase when you sign up! Please note, it can only be used once per user.</p>
                    <p class="mb-3">Promotion codes on merchandise from our store will be given through our referral program when people sign up from your doing. This is our way of saying thank you!</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Do I Get Discount For Referral?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Please contact us if any of your friends sign up so we can offer discount on merchandise using our store or commission. </p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    How Fast Can I Take A Grading?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                <p class="mb-3">Defence Student has no set grading dates, or time restrictions that would hold a student back from achieving their goals sooner.</p>
                    <p class="mb-3">Once you have mastered all the required techniques in the syllabus, you will be given the opportunity to record yourself performing those techniques with your training partner. Then send in your videos, they will be assessed by our instructors.</p>
                    <p class="mb-3">They will give feedback on your performance so you know exactly what your strengths and weaknesses are, you can then adjust your training habits. If your techniques meet Defence Student standards, you will have passed the grading.</p>
                    <p>The next syllabus will then become available to you. The instructors may require a live stream on some occasions so they can watch you perform your grading.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    What Happens If I Fail My Grading?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>For whatever reason you failed on your grading, you will be given 1 free attempt to correct your mistakes and perfect your techniques.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    How Will I Receive My Belt And Certificate?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Once you’ve passed your grading, we will send your belt and certificate out in the post.</p>
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
                    <p class="mb-3">This requires a lot of hard work and dedication, however, we hold no grading dates or time restrictions that would hold a student back from achieving their goals soon.</p>
                    <p class="mb-3">The quality of the student needs to meet Defence Student standards. With our instructors and advanced training system, we estimate that it would take our students a quicker process. However, this decision will depend on the chosen art and the instructor teaching the course.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
					Will This Improve My Health And Fitness?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Absolutely! Our training drills are designed to increase your fitness. </p>
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

            <div class="faq-item">
                <button class="faq-question">
                    Will This Help Against Sexual Assault?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Absolutely! Unfortunately rape and sexual abuse can happen to anyone regardless of their age, gender, race, religion, culture or social status.</p>
                    <p>That is why we teach and help women develop confidence and give them the ability how to use leverage, technique and timing over strength so anyone regardless of age or athletic ability are able to defend themselves against larger and stronger attackers.</p>
                </div>
            </div>


            <div class="faq-item">
                <button class="faq-question">
                    Will This Help Against Weapon Violence?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Absolutely! Unfortunately knife crime and gun violence is on the rise.</p>
                    <p class="mb-3">That is why we understand how important it is to make sure you have all the skills required to adapt and overcome various weapons in life threatening situations so you can protect yourself and your loved ones.</p>
                    <p>Please contact us via email for more information.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Can I Book A Private Lesson With The Instructors?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p>Yes! If you’d like private coaching, online or in person with our instructors then please contact us via email with your enquire and we will get back to you soon with all the information.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Do you visit schools and gyms?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Yes! If any school would like to book a free 1 hour seminar, please contact us via email for more information.</p>
                    <p>If you want to know more information about a gym booking, we can also provide you with further information via email.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Do You Hold Seminars So I Can Meet The Instructors?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Yes! We hold charity seminars so we can meet and greet our members. We also allow access to the general public so we can potentially gain new members and share what we teach to you.</p>
                    <p class="mb-3">We will teach self defence techniques and answer questions throughout the day. Please look out for future dates and areas near you</p>
                    <p>Defence Student will provide all the information via email if you need more assistance.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Can I Upload My Own Content?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Absolutely! We encourage instructors, athletes and content creators to film their own content and upload it using our Defence Student platform.</p>
                    <p class="mb-3">You keep 80% of all income generated when customers purchase your content and you can also decide how much you want to sell your content for using a yearly plan, monthly subscription option or a one off payment or special offer.</p>
                    <p class="mb-3">Simple visit the Instructor Sign Up page or contact us via email for more information. If you like what you hear, send your content to us and we will create you a page and upload all your videos.</p>
                    <p >Welcome to the Only Fans for Martial Arts!</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Can I Become An Instructor?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Yes! We will a create a step by step plan for you and then see if your up for the challenge.</p>
                    <p>Please visit the Instructor Sign Up page or contact us via email for more information.</p>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">
                    Can I Get Paid for a Referral?
					<i class="fas fa-chevron-right arrow"></i>
				</button>
                <div class="faq-answer">
                    <p class="mb-3">Yes! Defence Student offers a referral program in which those who refer an instructor or content creator to the platform can earn 5% of the referred creator’s earnings for the first 6 months up to the first £1 million earned by the referred creator.</p>
                    <p class="mb-3">There are no limitations to the number of referred creators or total referral earnings. Referrals are paid out monthly on the last business day of the month or around the beginning of the next month.</p>
                    <p>Please contact us via email for more information.</p>
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