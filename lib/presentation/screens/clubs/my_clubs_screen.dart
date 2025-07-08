import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/logic/club/club_cubit.dart';
import 'package:dsync_meetup_app/logic/club/club_state.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class MyClubsScreen extends StatelessWidget {
  const MyClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Clubs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ClubCubit>().fetchClubs(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(RouteNames.createClub),
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
                child: Text('You haven\'t joined any clubs yet'),
              );
            }
            
            return ListView.builder(
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
                    subtitle: Text(club.description),
                    onTap: () => context.pushNamed(
                      RouteNames.clubDetails,
                      pathParameters: {'clubId': club.id},
                    ),
                  ),
                );
              },
            );
          }
          
          return const Center(child: Text('Pull to refresh clubs'));
        },
      ),
    );
  }
}