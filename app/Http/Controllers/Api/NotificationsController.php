<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\Notification;
use App\Providers\NotificationServiceProvider;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class NotificationsController extends Controller
{
    protected $notificationTypes = [
        Notification::MESSAGES_FILTER,
        Notification::LIKES_FILTER,
        Notification::SUBSCRIPTIONS_FILTER,
        Notification::TIPS_FILTER,
    ];

    public function notifications(Request $request, $type = null)
    {
        $activeType = $request->route('type');
        $listOnly = $request->get('list');

        $notifications = $this->getUserNotifications($activeType);
        $unreadNotificationIds = [];
        foreach ($notifications as $notification) {
            if (!$notification->read) {
                $unreadNotificationIds[] = $notification->id;
            }
        }
        $notificationsCountOverride = NotificationServiceProvider::getUnreadNotifications();
        if (count($unreadNotificationIds)) {
            Notification::whereIn('id', $unreadNotificationIds)->update(['read' => true]);
        }
        if ($listOnly) {
            return response()->json([
                'notifications' => $notifications,
            ]);
        } else {
            return response()->json([
                'notificationTypes' => $this->notificationTypes,
                'activeType' => $activeType,
                'notifications' => $notifications,
                'notificationsCountOverride' => $notificationsCountOverride
            ]);
        }
    }

    protected function getUserNotifications($type = null)
    {
        $userId = Auth::id();

        $query = Notification::where('to_user_id', $userId);

        if ($type) {
            $query->where('type', $type);
        }

        return $query->get();
    }
    
}
