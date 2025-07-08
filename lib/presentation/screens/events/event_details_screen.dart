import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/event/event_cubit.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/presentation/screens/events/edit_event_screen.dart'; // Add this import

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String clubId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.clubId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    context.read<EventCubit>().loadEvent(widget.eventId); // Removed clubId parameter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditScreen(context),
          ),
        ],
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventError) {
            return Center(child: Text(state.message));
          }
          if (state is EventLoaded) {
            return _buildEventDetails(state.event);
          }
          return const Center(child: Text('No event data'));
        },
      ),
    );
  }

  Widget _buildEventDetails(Event event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              // Replace imageUrl with your actual image field or use a placeholder
              'https://via.placeholder.com/400x200', // Removed imageUrl reference
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.event, size: 60),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text(
                event.formattedDate,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 8),
              Text(
                event.location,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.category, size: 16),
              const SizedBox(width: 8),
              Text(
                event.category,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          if (event.capacity != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Capacity: ${event.capacity}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'About this event',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleRsvp(event),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('RSVP'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRsvp(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('RSVP to ${event.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _navigateToEditScreen(BuildContext context) async {
    if (!mounted) return;
    
    final state = context.read<EventCubit>().state;
    if (state is EventLoaded) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<EventCubit>(),
            child: EditEventScreen(event: state.event),
          ),
        ),
      );

      if (!mounted) return;
      context.read<EventCubit>().loadEvent(widget.eventId); // Removed clubId parameter
    }
  }
}