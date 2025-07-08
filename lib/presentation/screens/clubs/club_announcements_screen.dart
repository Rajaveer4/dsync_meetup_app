import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';
import 'package:dsync_meetup_app/logic/announcement/announcement_cubit.dart';
import 'package:dsync_meetup_app/data/models/announcement_model.dart';
import 'package:dsync_meetup_app/data/services/announcement_service.dart';

class ClubAnnouncementsScreen extends StatelessWidget {
  final String clubId;

  const ClubAnnouncementsScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementCubit(
        service: AnnouncementService(),
      )..loadAnnouncements(clubId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Club Announcements'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<AnnouncementCubit>().loadAnnouncements(clubId),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed(
              RouteNames.createAnnouncement,
              pathParameters: {'clubId': clubId},
            );
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (context, state) {
            if (state is AnnouncementLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AnnouncementLoaded) {
              final announcements = state.announcements;
              if (announcements.isEmpty) {
                return const Center(
                  child: Text('No announcements yet'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return _buildAnnouncementCard(context, announcement);
                },
              );
            }

            if (state is AnnouncementError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AnnouncementCubit>().loadAnnouncements(clubId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Loading announcements...'));
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, AnnouncementModel announcement) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(announcement.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.content),
            const SizedBox(height: 4),
            Text(
              'Posted ${_formatDate(announcement.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                  ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.pushNamed(
            RouteNames.announcementDetails,
            pathParameters: {
              'clubId': clubId,
              'announcementId': announcement.id,
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}