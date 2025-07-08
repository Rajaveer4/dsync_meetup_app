import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dsync_meetup_app/widgets/events/event_card.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/data/services/firebase_service.dart';
import 'package:dsync_meetup_app/data/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  List<Event> _explorableEvents = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;
  final List<String> _stories = ['My Story', 'Popular', 'New', 'Friends'];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final user = firebaseService.currentUser;
      
      if (user == null) {
        if (!mounted) return;
        context.goNamed(RouteNames.login);
        return;
      }

      final currentUser = await userService.getCurrentUser();
      if (currentUser == null) return;

      List<Event> events;

      if (currentUser.interests?.isNotEmpty ?? false) {
        events = await firebaseService.getRecommendedEvents(
          currentUser.interests is String
              ? [currentUser.interests as String]
              : (currentUser.interests! as List<String>),
        );
      } else {
        events = await firebaseService.getAllEvents();
      }

      if (!mounted) return;
      setState(() {
        _explorableEvents = events;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading events: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  List<Event> get _filteredEvents {
    if (_selectedFilter == 'All') return _explorableEvents;
    return _explorableEvents
        .where((event) => event.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final user = userService.currentFirebaseUser;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(user),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStoriesRow(),
              const SizedBox(height: 20),
              _buildCreatePostSection(user),
              const SizedBox(height: 24),
              _buildEventsHeader(),
              const SizedBox(height: 12),
              _buildEventList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(firebase_auth.User? user) {
    return AppBar(
      title: const Text('Dsync', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Badge(
            child: Icon(Icons.notifications_none),
          ),
          onPressed: () => context.pushNamed(RouteNames.notifications),
        ),
        _buildProfileButton(user),
      ],
    );
  }

  Widget _buildProfileButton(firebase_auth.User? user) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => context.pushNamed(RouteNames.profile),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: user?.imageUrl != null
              ? CachedNetworkImageProvider(user!.imageUrl!)
              : null,
          child: user?.imageUrl == null
              ? const Icon(Icons.person, size: 18, color: Colors.black54)
              : null,
        ),
      ),
    );
  }

  Widget _buildStoriesRow() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12, left: index == 0 ? 4 : 0),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: index == 0
                        ? const LinearGradient(
                            colors: [Colors.orange, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    border: Border.all(
                      color: index == 0 ? Colors.transparent : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          _stories[index][0],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _stories[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreatePostSection(firebase_auth.User? user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: user?.imageUrl != null
                    ? CachedNetworkImageProvider(user!.imageUrl!)
                    : null,
                child: user?.imageUrl == null
                    ? const Icon(Icons.person, size: 20)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  readOnly: true,
                  onTap: () => context.pushNamed(RouteNames.createPost),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.photo_library, color: Colors.green),
                label: Text('Photo', 
                  style: TextStyle(color: Colors.grey.shade800)),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.videocam, color: Colors.red),
                label: Text('Video', 
                  style: TextStyle(color: Colors.grey.shade800)),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.location_on, color: Colors.purple),
                label: Text('Check In', 
                  style: TextStyle(color: Colors.grey.shade800)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Upcoming Events',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        DropdownButton<String>(
          value: _selectedFilter,
          icon: const Icon(Icons.filter_list),
          underline: const SizedBox(),
          items: ['All', 'Sports', 'Food', 'Arts', 'Literature']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedFilter = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    if (_filteredEvents.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredEvents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return EventCard(
          title: event.title,
          subtitle: event.location,
          dateTime: DateFormat('EEE, MMM d • h:mm a').format(event.startTime),
          attendees: event.participantIds.length,
          spotsLeft: event.capacity != null
              ? event.capacity! - event.participantIds.length
              : null,
          clubName: 'Club ${event.clubId}',
          emoji: _getCategoryEmoji(event.category),
          imageUrl: event.imageUrl,
          onTap: () => _navigateToEventDetails(event.id),
        );
      },
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return '🏸';
      case 'literature':
        return '📚';
      case 'food':
        return '🍴';
      case 'arts':
        return '🎨';
      default:
        return '🎉';
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'Check back later for new events'
                : 'No events in this category',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _loadEvents,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: const Color.fromARGB(255, 170, 0, 255),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Clubs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        setState(() => _currentBottomNavIndex = index);
        switch (index) {
          case 1:
            context.goNamed(RouteNames.myClubs);
            break;
          case 2:
            context.goNamed(RouteNames.explore);
            break;
          case 3:
            context.goNamed(RouteNames.profile);
            break;
        }
      },
    );
  }

  void _navigateToEventDetails(String eventId) {
    final event = _explorableEvents.firstWhere((e) => e.id == eventId);
    context.pushNamed(
      RouteNames.eventDetails,
      pathParameters: {'eventId': eventId},
      extra: event,
    );
  }
}