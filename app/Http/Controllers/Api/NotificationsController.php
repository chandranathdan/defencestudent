<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\Notification;
use App\Providers\NotificationServiceProvider;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class NotificationsController extends Controller
{
    protected $notificationTypes = [
        Notification::MESSAGES_FILTER,
        Notification::LIKES_FILTER,
        Notification::SUBSCRIPTIONS_FILTER,
        Notification::TIPS_FILTER,
        Notification::PROMOS_FILTER,
    ];
    public function notifications(Request $request)
    {
        $tab = [
            'total' => (int) $request->post('total'),
            'messages' => (int) $request->post('messages'),
            'likes' => (int) $request->post('likes'),
            'subscriptions' => (int) $request->post('subscriptions'),
            'tips' => (int) $request->post('tips'),
            'promos' => (int) $request->post('promos'),
        ];
        $activeType = array_keys($tab, 1, true);
        $allNotifications = [];
        foreach ($activeType as $type) {
            $notifications = $this->getUserNotifications($type);
            $unreadNotificationIds = $notifications->filter(function ($notification) {
                return !$notification->read;
            })->pluck('id');
    
            if ($unreadNotificationIds->isNotEmpty()) {
                Notification::whereIn('id', $unreadNotificationIds)->update(['read' => true]);
            }
            $formattedNotifications = $notifications->map(function ($notification) {
                $user = $notification->fromUser;
                $postMessage = $notification->postComment
                    ? $user->name . ' added a new comment on your post.'
                    : ($notification->post_id
                        ? $user->name . ' liked your post.'
                        : '');
                return [
                    'userId' => $user->id,
                    'name' => $user->name,
                    'username' => $user->username,
                    'avatar' => $user->avatar,
                    'message' => $postMessage,
                    'created_at' => Carbon::parse($notification->created_at)->diffForHumans(),
                ];
            });
            $allNotifications[$type] = $formattedNotifications->toArray();
        }
        return response()->json([
            'status' => 200,
            'activeType' => $activeType,
            'data' => $allNotifications,
        ]);
    }
    private function getUserNotifications($filter)
    {
        $notificationTypes = $this->getNotificationTypesByActiveFilter($filter);

        $query = Notification::query()
            ->where('to_user_id', Auth::id())
            ->orderBy('read', 'ASC')
            ->orderBy('created_at', 'DESC')
            ->with(['fromUser', 'post', 'postComment', 'userMessage', 'transaction', 'withdrawal']);
        if (!empty($notificationTypes)) {
            $query->whereIn('type', $notificationTypes);
        }

        return $query->paginate(8);
    }
    private function getNotificationTypesByActiveFilter($filter)
    {
        $types = [];

        switch ($filter) {
            case Notification::MESSAGES_FILTER:
                $types = [Notification::NEW_COMMENT, Notification::NEW_MESSAGE];
                break;
            case Notification::LIKES_FILTER:
                $types = [Notification::NEW_REACTION];
                break;
            case Notification::SUBSCRIPTIONS_FILTER:
                $types = [Notification::NEW_SUBSCRIPTION];
                break;
            case Notification::TIPS_FILTER:
                $types = [Notification::NEW_TIP, Notification::PPV_UNLOCK];
                break;
            case Notification::PROMOS_FILTER:
                $types = [Notification::PROMOS_FILTER];
                break;
        }

        return $types;
    }
            
}

