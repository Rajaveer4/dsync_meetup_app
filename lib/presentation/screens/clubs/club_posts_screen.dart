import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class ClubPostsScreen extends StatelessWidget {
  final String clubId;

  const ClubPostsScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.pushNamed(
                RouteNames.clubPostSearch,
                pathParameters: {'clubId': clubId},
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(
            RouteNames.createPost,
            pathParameters: {'clubId': clubId},
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add refresh functionality here
          // Example: await context.read<PostCubit>().fetchPosts(clubId);
        },
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('Post ${index + 1}'),
                subtitle: const Text('Posted by Member • 3 days ago'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  context.pushNamed(
                    RouteNames.postDetails,
                    pathParameters: {
                      'clubId': clubId,
                      'postId': 'post$index',
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}