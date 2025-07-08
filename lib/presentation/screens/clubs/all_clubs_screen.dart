import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/logic/club/club_cubit.dart';
import 'package:dsync_meetup_app/logic/club/club_state.dart';
import 'package:dsync_meetup_app/data/models/club_model.dart';
import 'package:intl/intl.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class AllClubsScreen extends StatelessWidget {
  const AllClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Clubs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateClubDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ClubCubit>().fetchClubs(),
          ),
        ],
      ),
      body: BlocConsumer<ClubCubit, ClubState>(
        listener: (context, state) {
          if (state is ClubError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ClubLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ClubLoaded) {
            if (state.clubs.isEmpty) {
              return const Center(
                child: Text('No clubs found. Create one!'),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async => context.read<ClubCubit>().fetchClubs(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.clubs.length,
                itemBuilder: (context, index) {
                  final club = state.clubs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(club.imageUrl),
                        radius: 30,
                      ),
                      title: Text(
                        club.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(club.description),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 16),
                              const SizedBox(width: 4),
                              Text('${club.members.length} members'),
                              const Spacer(),
                              Text(
                                DateFormat('MMM d, y').format(club.createdAt),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to club details using GoRouter
                        context.goNamed(
                          RouteNames.clubDetails,
                          pathParameters: {'clubId': club.id},
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
          
          return const Center(child: Text('Pull to refresh'));
        },
      ),
    );
  }

  void _showCreateClubDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController(text: 'https://example.com/club.jpg');
    final categoryController = TextEditingController(text: 'General');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Club'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Club Name'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newClub = ClubModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descController.text,
                  imageUrl: imageController.text,
                  members: [],
                  admins: [],
                  createdAt: DateTime.now(),
                  category: categoryController.text,
                );
                context.read<ClubCubit>().createClub(newClub);
                context.pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}