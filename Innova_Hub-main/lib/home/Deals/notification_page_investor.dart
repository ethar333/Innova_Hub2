
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Cubit_notification.dart';
import 'package:innovahub_app/Models/Notifications/notification_response.dart';
import 'package:innovahub_app/home/Deals/accept_page_investor.dart';
import 'package:innovahub_app/home/Deals/admin_page.dart';

// ignore: camel_case_types
class notificationpageforinvestor extends StatefulWidget {
  static const String routname = "notificationpageforinvestor";

  const notificationpageforinvestor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<notificationpageforinvestor> {
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = NotificationCubit();
    _notificationCubit.getUnreadNotifications();
  }

  @override
  void dispose() {
    _notificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _notificationCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color(0xFF1976D2),
          elevation: 0,
          leading: const Icon(Icons.notifications, color: Colors.white),
          title: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              int unreadCount = 0;
              if (state is NotificationSuccessState) {
                final notifications = state.notificationResponse.data;
                unreadCount = notifications.where((n) => !n.isRead).length;
              }
              return Row(
                children: [
                  const Text(
                    'Deals Notification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                _notificationCubit.refreshNotifications();
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1976D2),
                ),
              );
            } else if (state is NotificationErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading notifications',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _notificationCubit.refreshNotifications();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is NotificationSuccessState) {
              final notifications = state.notificationResponse.data;

              return _buildNotificationList(notifications);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationData> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No new notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _notificationCubit.refreshNotifications();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildNotificationItem(
              context: context,
              notification: notification,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required NotificationData notification,
  }) {
    String formattedTime = _formatTime(notification.createdAt);

    Map<String, dynamic> tagInfo = _getTagInfo(notification.messageType);

    return GestureDetector(
      onTap: () => _handleNotificationTap(context, notification),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: notification.isRead ? Colors.grey[200]! : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Profile Circle with Initial
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tagInfo['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notification.senderName.isNotEmpty
                          ? notification.senderName[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        color: tagInfo['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name and verification badge
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        notification.senderName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: notification.isRead
                              ? Colors.grey[600]
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.blue[400],
                      ),
                    ],
                  ),
                ),

                // Time and dismiss button
                Row(
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _dismissNotification(context, notification),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Message Text
            Text(
              notification.messageText,
              style: TextStyle(
                fontSize: 14,
                color:
                    notification.isRead ? Colors.grey[600] : Colors.grey[800],
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Row with Tag and Arrow
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tagInfo['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: tagInfo['color'].withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tagInfo['label'],
                    style: TextStyle(
                      fontSize: 12,
                      color: tagInfo['color'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),

            // Unread indicator
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getTagInfo(String messageType) {
    switch (messageType.toLowerCase()) {
      case 'offeraccepted':
        return {
          'label': 'Deals Acceptance',
          'color': const Color(0xFF1976D2),
        };
      case 'discussoffer':
      case 'offerdiscussion':
        return {
          'label': 'Discussion Request',
          'color': Colors.green,
        };
      case 'admin':
      case 'general':
        return {
          'label': 'Admin Approval',
          'color': Colors.orange,
        };
      default:
        return {
          'label': 'Notification',
          'color': Colors.grey,
        };
    }
  }

  String _formatTime(String createdAt) {
    try {
      DateTime dateTime = DateTime.parse(createdAt.replaceAll(' ', 'T'));
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return createdAt;
    }
  }

  void _handleNotificationTap(
      BuildContext context, NotificationData notification) {
    // Mark as read if not already read
    if (!notification.isRead) {
      _notificationCubit.markNotificationAsRead(notification.id);
    }

    // Navigate based on message type and pass notification data
    switch (notification.messageType.trim().toLowerCase()) {
      case 'offeraccepted':
        Navigator.pushNamed(
          context,
          AcceptPageforinvestor.routeName,
          arguments: notification,
        );
        break;
      /* case 'offerdiscussion':
        Navigator.pushNamed(
          context,
          DiscussPage.routeName,
          arguments: notification,
        );
        break;*/
      case 'general':
        Navigator.pushNamed(
          context,
          adminprocess.routname,
          arguments: notification,
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No action defined for: ${notification.messageType}'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  void _dismissNotification(
      BuildContext context, NotificationData notification) {
    // Mark notification as read when dismissed
    _notificationCubit.markNotificationAsRead(notification.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification dismissed'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF1976D2),
      ),
    );
  }
}