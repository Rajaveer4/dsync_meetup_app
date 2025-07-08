import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/logic/club/club_details_cubit.dart';
import 'package:dsync_meetup_app/data/models/club_model.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';
import 'package:intl/intl.dart';

class ClubDetailsScreen extends StatelessWidget {
  final String clubId;

  const ClubDetailsScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClubDetailsCubit(clubId)..loadClubDetails(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Club Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.pushNamed(
                RouteNames.clubSettings,
                pathParameters: {'clubId': clubId},
              ),
            ),
          ],
        ),
        body: BlocBuilder<ClubDetailsCubit, ClubDetailsState>(
          builder: (context, state) {
            if (state is ClubDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ClubDetailsLoaded) {
              final ClubModel club = state.club;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(club.imageUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                club.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${club.members.length} members',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Category: ${club.category}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Created on: ${DateFormat('MMM d, y').format(club.createdAt)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      club.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 32),

                    // Navigation Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.group),
                          onPressed: () => context.pushNamed(
                            RouteNames.clubMembers,
                            pathParameters: {'clubId': clubId},
                          ),
                          label: const Text('View Members'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.event),
                          onPressed: () => context.pushNamed(
                            RouteNames.clubEvents,
                            pathParameters: {'clubId': clubId},
                          ),
                          label: const Text('View Events'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.post_add),
                          onPressed: () => context.pushNamed(
                            RouteNames.clubPosts,
                            pathParameters: {'clubId': clubId},
                          ),
                          label: const Text('View Posts'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (state is ClubDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ClubDetailsCubit>().loadClubDetails(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Loading club details...'));
          },
        ),
      ),
    );
  }
}
