import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/notification/notification_cubit.dart';
import 'package:dsync_meetup_app/logic/notification/notification_state.dart';
import 'package:dsync_meetup_app/data/services/notification_service.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(NotificationService())..fetchNotifications(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<NotificationCubit>().fetchNotifications();
              },
            ),
          ],
        ),
        body: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            if (state is NotificationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Text('No notifications yet', style: TextStyle(fontSize: 18)),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => context.read<NotificationCubit>().fetchNotifications(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];

                    return ListTile(
                      leading: notification.imageUrl != null
                          ? CircleAvatar(backgroundImage: NetworkImage(notification.imageUrl!))
                          : CircleAvatar(
                              child: Text(notification.title.isNotEmpty
                                  ? notification.title[0].toUpperCase()
                                  : '?'),
                            ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.body),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(notification.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: notification.isRead
                          ? null
                          : const Icon(Icons.circle, color: Colors.blue, size: 12),
                      onTap: () {
                        context.read<NotificationCubit>().markAsRead(notification.id);

                        if (notification.actionRoute != null &&
                            notification.actionRoute!.isNotEmpty) {
                          context.push(notification.actionRoute!);
                        }
                      },
                    );
                  },
                ),
              );
            }

            return const Center(
              child: Text('Pull down to refresh', style: TextStyle(fontSize: 18)),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
