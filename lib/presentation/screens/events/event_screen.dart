import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/event/event_cubit.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/widgets/events/date_picker.dart';
import 'package:dsync_meetup_app/data/services/event_service.dart';

class EventScreen extends StatelessWidget {
  final String eventId;
  final String clubId;
  final EventService eventService;

  const EventScreen({
    super.key,
    required this.eventId,
    required this.clubId,
    required this.eventService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(eventService: eventService, clubId: clubId)..loadEvent(eventId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Event Details')),
        body: BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventLoaded) {
              return _buildEventDetails(context, state.event);
            } else if (state is EventError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Event not found'));
          },
        ),
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context, Event event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Location: ${event.location}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          DatePicker(
            initialDate: event.startTime,
            onDateSelected: (newDate) {
              context.read<EventCubit>().updateEventStartTime(event.id, newDate);
            },
          ),
          const SizedBox(height: 16),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _joinEvent(context, event.id),
            child: const Text('Join Event'),
          ),
        ],
      ),
    );
  }

  void _joinEvent(BuildContext context, String eventId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have joined the event!')),
    );
  }
}
