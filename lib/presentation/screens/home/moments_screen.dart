import 'package:flutter/material.dart';

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => _MomentsScreenState();
}

class _MomentsScreenState extends State<MomentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Moments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Memories'),
            Tab(text: 'My Memories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllMemoriesTab(),
          MyMemoriesTab(),
        ],
      ),
    );
  }
}

class AllMemoriesTab extends StatelessWidget {
  const AllMemoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate data refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return MemoryCard(
            username: 'User $index',
            eventName: 'Event #$index',
            description: 'Shared a great moment!',
            imageUrl: null, // Replace with Firebase URL if needed
          );
        },
      ),
    );
  }
}

class MyMemoriesTab extends StatelessWidget {
  const MyMemoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, eventIndex) {
        return ExpansionTile(
          title: Text('My Event #$eventIndex'),
          leading: const Icon(Icons.event_note),
          children: List.generate(2, (memIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MemoryCard(
                username: 'Me',
                eventName: 'Event #$eventIndex',
                description: 'My memory $memIndex description...',
                imageUrl: null,
              ),
            );
          }),
        );
      },
    );
  }
}

class MemoryCard extends StatelessWidget {
  final String username;
  final String eventName;
  final String description;
  final String? imageUrl;

  const MemoryCard({
    super.key,
    required this.username,
    required this.eventName,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Text(username[0]),
        ),
        title: Text('$eventName by $username'),
        subtitle: Text(description),
        trailing: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.photo),
      ),
    );
  }
}
