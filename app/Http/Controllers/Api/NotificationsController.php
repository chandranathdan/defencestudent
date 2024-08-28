<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\Notification;
use App\Providers\NotificationServiceProvider;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class NotificationsController extends Controller
{
    protected $notificationTypes = [
        Notification::MESSAGES_FILTER,
        Notification::LIKES_FILTER,
        Notification::SUBSCRIPTIONS_FILTER,
        Notification::TIPS_FILTER,
        Notification::PROMOS_FILTER,
    ];
    public function notifications(Request $request, $type = null)
    {
        $activeType = $request->route('type');
        $listOnly = $request->get('list');
        $notifications = $this->getUserNotifications($activeType);
    
        $unreadNotificationIds = $notifications->filter(function ($notification) {
            return !$notification->read;
        })->pluck('id');
        if ($unreadNotificationIds->isNotEmpty()) {
            Notification::whereIn('id', $unreadNotificationIds)->update(['read' => true]);
        }
        $notificationsCountOverride = NotificationServiceProvider::getUnreadNotifications();
    
        $formattedNotifications = $notifications->map(function ($notification) {
            return [
                'type' => $notification->type,
                'fromUser' => [
                    'username' => $notification->fromUser->username,
                    'name' => $notification->fromUser->name,
                    'avatar' => $notification->fromUser->avatar
                ],
                'transaction' => $notification->transaction ? [
                    'sender' => [
                        'name' => $notification->transaction->sender->name
                    ],
                    'amount' => $notification->transaction->amount
                ] : null,
                'read' => $notification->read,
                'created_at' => Carbon::parse($notification->created_at)->diffForHumans(),
                    
               'postDetails' => $notification->postComment ? 
                [
                    'message' => $notification->fromUser->name . ' added a new comment on your post.',
                ] : ($notification->post_id ? [
                    'message' => $notification->fromUser->name . ' liked your post.',
                ] : null),
            ];
        });
    
        if ($listOnly) {
            return response()->json([
                'notifications' => $formattedNotifications
            ]);
        } else {
            return response()->json([
                'notificationTypes' => $this->notificationTypes,
                'activeType' => $activeType,
                'notifications' => $formattedNotifications,
            ]);
        }
        
    }
    private function getUserNotifications($activeType)
    {
        $notificationTypes = $this->getNotificationTypesByActiveFilter($activeType);
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
        if ($filter) {
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
        }

        return $types;
    }
}

