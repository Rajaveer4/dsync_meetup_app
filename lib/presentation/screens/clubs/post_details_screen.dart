import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final String postId;
  final String clubId;

  const PostDetailsScreen({
    super.key,
    required this.postId,
    required this.clubId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Member Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Posted 3 days ago'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'This is an example post content that would be displayed here. '
              'Members can discuss various topics and share ideas in the club posts section.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://via.placeholder.com/400x200',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.favorite_border),
                SizedBox(width: 8),
                Text('12 likes'),
                SizedBox(width: 16),
                Icon(Icons.comment),
                SizedBox(width: 8),
                Text('5 comments'),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Member ${index + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Comment ${index + 1} on this post'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Post comment
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}