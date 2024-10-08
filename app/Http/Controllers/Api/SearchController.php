<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\ProfileUploadRequest;
use App\Http\Requests\UpdateUserFlagSettingsRequest;
use App\Http\Requests\UpdateUserProfileSettingsRequest;
use App\Http\Requests\UpdateUserRatesSettingsRequest;
use App\Http\Requests\UpdateUserSettingsRequest;
use App\Http\Requests\VerifyProfileAssetsRequest;
use App\Http\Requests\VerifyTwoFactorCodeRequest;
use App\Model\Attachment;
use App\Model\UserList;
use App\Model\UserListMember;
use App\Model\Country;
use App\Model\CreatorOffer;
use App\Model\ReferralCodeUsage;
use App\Model\Subscription;
use App\Model\Transaction;
use App\Model\UserDevice;
use App\Model\UserVerify;
use App\Providers\AttachmentServiceProvider;
use App\Providers\AuthServiceProvider;
use App\Providers\EmailsServiceProvider;
use App\Providers\GenericHelperServiceProvider;
use App\Providers\SettingsServiceProvider; 
use App\Providers\StreamsServiceProvider;
use App\Providers\PostsHelperServiceProvider;
use App\Providers\MembersHelperServiceProvider;
use App\Providers\IconsServiceProvider;
use App\Model\UserCode;
use App\Model\Post;
use App\Model\UserGender;
use App\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Illuminate\Support\Facades\Validator; 
use App\Model\Stream;
use App\Rules\MatchOldPassword;
use JavaScript;
use Jenssegers\Agent\Agent;
use Ramsey\Uuid\Uuid;

class SearchController extends Controller
{
    public $filters = [
        'live',
        'top',
        'latest',
        'photos',
        'videos',
        'people',
    ];

    protected function processFilterParams($request)
    {
        $searchTerm = $request->input('query');
        $postsFilter = $request->get('filter', 'people');

        $mediaType = 'image';
        $sortOrder = '';

        switch ($postsFilter) {
            case 'videos':
                $mediaType = 'video';
                break;
            case 'photos':
                $mediaType = 'image';
                break;
            case 'top':
            case 'latest':
            case 'live':
                $sortOrder = $postsFilter;
                $mediaType = false;
                break;
        }

        return [
            'searchTerm' => $searchTerm,
            'postsFilter' => $postsFilter,
            'mediaType' => $mediaType,
            'sortOrder' => $sortOrder
        ];
    }

    public function search(Request $request)
    {
        if (!Auth::check()) {
            return response()->json(['status' => 401, 'message' => 'Unauthorized'], 401);
        }
    
        $activeFilters = [
            'people' => (int) $request->post('people'),
            'latest' => (int) $request->post('latest'),
            'top' => (int) $request->post('top'),
            'photos' => (int) $request->post('photos'),
            'videos' => (int) $request->post('videos'),
        ];
    
        $filters = $this->processFilterParams($request);
    
        // Prepare the response data
        $responseData = [
            'people' => [],
            'top' => [],
            'latest' => [],
            'photos' => [],
            'videos' => [],
        ];
    
        // Fetch users if the people filter is active
        $userIds = [];
        if ($activeFilters['people']) {
            $users = MembersHelperServiceProvider::getSearchUsers(['searchTerm' => $filters['searchTerm']]);
            $userIds = $users->pluck('id')->toArray();
            $responseData['people'] = $users->map(function ($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'username' => $user->username,
                    'bio' => $user->bio ? $user->bio : __('No description available.'),
                    'avatar' => $user->avatar,
                    'post_text' => '',
                    'attachments' => [],
                    'likesCount' => 0,
                    'commentsCount' =>0,
                    'tips' => 0,
                    'created_at' =>'',
                ];
            });
        }
    
        //if ($userIds) {
            $sortOrder = $filters['sortOrder'];
            /*$postsQuery = Post::with('user', 'attachments')
                ->whereIn('user_id', $userIds);
    
            if ($sortOrder === 'top') {
                $postsQuery->orderBy('likes_count', 'desc');
            }
            if ($activeFilters['latest']) {
                $responseData['latest'] = $postsQuery->orderBy('created_at', 'desc')->get()->map(function ($post) {
                    return $this->formatPostData($post);
                });
            }
    
            $posts = $postsQuery->get();*/
			$startPage = $request->post('page');
			$posts = PostsHelperServiceProvider::getFeedPosts(Auth::user()->id, false, $startPage, false, $filters['sortOrder'], $filters['searchTerm']);
			//dd($filters['mediaType']);
            if ($activeFilters['top'] || $activeFilters['latest']) {
                if ($activeFilters['top']) {
                    $responseData['top'] = $posts->map(function ($post) {
                        return $this->formatPostData($post);
                    });
                }
    
                if ($activeFilters['latest']) {
                    $responseData['latest'] = $posts->map(function ($post) {
                        return $this->formatPostData($post);
                    });
                }
            }
    
            if ($activeFilters['photos'] || $activeFilters['videos']) {
                if ($activeFilters['photos']) {
                    $responseData['photos'] = $posts->filter(function ($post) {
                        return $post->attachments->contains(function ($attachment) {
                            return in_array(pathinfo($attachment->filename, PATHINFO_EXTENSION), ['jpg', 'png', 'gif']);
                        });
                    })->map(function ($post) {
                        return $this->formatPostData($post);
                    });
                }
    
                if ($activeFilters['videos']) {
                    $responseData['videos'] = $posts->filter(function ($post) {
                        return $post->attachments->contains(function ($attachment) {
                            return in_array(pathinfo($attachment->filename, PATHINFO_EXTENSION), ['mp4', 'mov', 'avi']);
                        });
                    })->map(function ($post) {
                        return $this->formatPostData($post);
                    });
                }
            }
        //}
    
        return response()->json([
            'status' => 200,
            'data' => $responseData,
            'searchTerm' => $filters['searchTerm'],
            'activeFilter' => $filters['postsFilter'],
        ]);
    }
    protected function formatPostData($post)
    {
		//dd($post->id);
        $transactions = $post->transactions()->where('status', Transaction::APPROVED_STATUS)->get();
        $isPaid = $transactions->isNotEmpty();
        /*$attachments = !$isPaid ? $post->attachments->map(function ($attachment) {
            $extension = pathinfo($attachment->filename, PATHINFO_EXTENSION);
            $type = null;
            if (in_array($extension, ['jpg', 'png', 'gif'])) {
                $type = 'image';
            } elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
                $type = 'video';
            }
    
            return [
                'content_type' => $type,
                'file' => Storage::url('attachments/' . $attachment->filename),
            ];
        })->toArray() : [
            [
                'content_type' => 'locked',
                'file' => asset('/img/post-locked.svg'),
                'price' => 1,
            ]
        ];*/
		if(!$isPaid){
			if((Auth::check() && Auth::user()->id !== $post->user_id && $post->price > 0 && !\PostsHelper::hasUserUnlockedPost($post->postPurchases)) || (!Auth::check() && $post->price > 0 )){
				$attachments = [
					[
						'content_type' => 'locked',
						'file' => asset('/img/post-locked.svg'),
						'price' => $post->price,
					]
				];
			}else{
				$attachments = $post->attachments->map(function ($attachment) {
					$extension = pathinfo($attachment->filename, PATHINFO_EXTENSION);
					$type = null;
					if (in_array($extension, ['jpg', 'png', 'gif'])) {
						$type = 'image';
					} elseif (in_array($extension, ['mp4', 'mov', 'avi'])) {
						$type = 'video';
					}
			
					return [
						'content_type' => $type,
						'file' => Storage::url($attachment->filename),
						'price' => 0,
					];
				})->toArray();
			}
		}else{
			$attachments = [
				[
					'content_type' => 'locked',
					'file' => asset('/img/post-locked.svg'),
					'price' => $post->price,
				]
			];
		}
        $tipsCount = $post->transactions()->where('type', Transaction::TIP_TYPE)
        ->where('status', Transaction::APPROVED_STATUS)->count();
        return [
            'post_id' => $post->id,
            'name' => $post->user->name,
            'username' => $post->user->username,
            'avatar' => $post->user->avatar,
            'bio' => '',
            'post_text' => $post->text,
            'attachments' => $attachments,
            'likesCount' => $post->reactions()->where('reaction_type', 'like')->count(),
            'commentsCount' => $post->comments()->count(),
            'tipsCount' => $tipsCount, 
            'created_at' => $post->created_at->diffForHumans(),
        ];
    }
}