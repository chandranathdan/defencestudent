<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\Notification;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;

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
        ];

        $perPage = 6;
        $offset = ($request->post('page', 1) - 1) * $perPage; 

        $activeType = array_keys($tab, 1, true);
        $allNotifications = [];
        $totalNotificationsCount = 0;

        foreach ($activeType as $type) {
            $notifications = $this->getUserNotifications($type, $offset, $perPage);
            $totalNotificationsCount += $this->countUserNotifications($type);

            $unreadNotificationIds = $notifications->filter(fn($notification) => !$notification->read)->pluck('id');

            if ($unreadNotificationIds->isNotEmpty()) {
                Notification::whereIn('id', $unreadNotificationIds)->update(['read' => true]);
            }

            $formattedNotifications = $notifications->map(fn($notification) => [
                'name' => optional($notification->fromUser)->name,
                'username' => optional($notification->fromUser)->username,
                'avatar' => optional($notification->fromUser)->avatar,
                'message' => $this->formatNotificationMessage($notification),
                'created_at' => Carbon::parse($notification->created_at)->diffForHumans(),
                'read' => $notification->read,
            ]);

            $allNotifications[$type] = $formattedNotifications->toArray();
        }

        return response()->json([
            'status' => 200,
            'activeType' => $activeType,
            'data' => array_diff_key($allNotifications, ['page' => []]),
        ]);
    }

    private function countUserNotifications($filter)
    {
        $notificationTypes = $this->getNotificationTypesByActiveFilter($filter);
    
        $query = Notification::query()
            ->where('to_user_id', Auth::id());
    
        if (!empty($notificationTypes)) {
            $query->whereIn('type', $notificationTypes);
        }
    
        return $query->count();
    }

    private function getUserNotifications($filter, $offset, $perPage)
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
        return $query->skip($offset)->take($perPage)->get();
    }

    private function getNotificationTypesByActiveFilter($filter)
    {
        switch ($filter) {
            case Notification::MESSAGES_FILTER:
                return [Notification::NEW_COMMENT, Notification::NEW_MESSAGE];
            case Notification::LIKES_FILTER:
                return [Notification::NEW_REACTION];
            case Notification::SUBSCRIPTIONS_FILTER:
                return [Notification::NEW_SUBSCRIPTION];
            case Notification::TIPS_FILTER:
                return [Notification::NEW_TIP, Notification::PPV_UNLOCK];
            case Notification::PROMOS_FILTER:
                return [Notification::PROMOS_FILTER];
            default:
                return [];
        }
    }

    private function formatNotificationMessage($notification)
    {
        switch ($notification->type) {
            case Notification::NEW_TIP:
                return isset($notification->transaction)
                    ? "{$notification->transaction->sender->name} sent you a tip of " . \App\Providers\SettingsServiceProvider::getWebsiteFormattedAmount(\App\Providers\PaymentsServiceProvider::getTransactionAmountWithTaxesDeducted($notification->transaction)) . "."
                    : 'No transaction data';
            case Notification::NEW_REACTION:
                return $notification->post_id
                    ? __(":name liked your post.", ['name' => $notification->fromUser->name])
                    : ($notification->post_comment_id
                        ? __(":name liked your comment.", ['name' => $notification->postComment->author->name])
                        : '');
            case Notification::NEW_COMMENT:
                return __(":name added a new comment on your post.", ['name' => $notification->fromUser->name]);
            case Notification::NEW_SUBSCRIPTION:
                return "A new user subscribed to your profile.";
            case Notification::WITHDRAWAL_ACTION:
                return 'Withdrawal processed: ' . $notification->withdrawal->amount . ' ' . \App\Providers\SettingsServiceProvider::getWebsiteCurrencySymbol();
            case Notification::NEW_MESSAGE:
                return "Sent you a message: `{$notification->userMessage->message}`";
            case Notification::EXPIRING_STREAM:
                return "Your live streaming is about to end in 30 minutes. You can start another one afterwards.";
            case Notification::PPV_UNLOCK:
                return "Someone unlocked your {$notification->PPVUnlockType}.";
            default:
                return '';
        }
    }
}
