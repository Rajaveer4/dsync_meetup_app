import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/logic/club/club_cubit.dart';
import 'package:dsync_meetup_app/logic/club/club_state.dart';
import 'package:dsync_meetup_app/data/services/club_service.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClubCubit(ClubService())..fetchClubs(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Club',
              onPressed: () {
                context.pushNamed(RouteNames.createClub);
              },
            ),
          ],
        ),
        body: BlocBuilder<ClubCubit, ClubState>(
          builder: (context, state) {
            if (state is ClubLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClubError) {
              return Center(child: Text(state.message));
            } else if (state is ClubLoaded) {
              if (state.clubs.isEmpty) {
                return const Center(child: Text('No clubs available.'));
              }
              return ListView.separated(
                itemCount: state.clubs.length,
                padding: const EdgeInsets.all(12),
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final club = state.clubs[index];
                  return ListTile(
                    title: Text(club.name),
                    subtitle: Text(club.description),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.pushNamed(
                        RouteNames.clubDetails,
                        pathParameters: {'clubId': club.id},
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: Text('No clubs found'));
          },
        ),
      ),
    );
  }
}
