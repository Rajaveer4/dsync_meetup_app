import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/data/services/event_service.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventService eventService;
  final String clubId;

  EventCubit({
    required this.eventService,
    required this.clubId,
  }) : super(EventInitial());

  Future<void> createEvent(Event event) async {
    emit(EventLoading());
    try {
      await eventService.createEvent(clubId, event);
      emit(EventCreatedSuccessfully(event));
      await loadEvents();
    } catch (e) {
      emit(EventError('Failed to create event: $e'));
    }
  }

  Future<void> loadEvents() async {
    emit(EventLoading());
    try {
      final events = await eventService.getEvents(clubId);
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventError('Failed to load events: $e'));
    }
  }

  Future<void> loadEvent(String eventId) async {
    emit(EventLoading());
    try {
      final event = await eventService.getEventById(clubId, eventId);
      emit(EventLoaded(event));
    } catch (e) {
      emit(EventError('Failed to load event: $e'));
    }
  }

  Future<void> updateEvent(Event event) async {
    emit(EventLoading());
    try {
      await eventService.updateEvent(clubId, event);
      emit(EventUpdatedSuccessfully(event));
      await loadEvents();
    } catch (e) {
      emit(EventError('Failed to update event: $e'));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    emit(EventLoading());
    try {
      await eventService.deleteEvent(clubId, eventId);
      emit(EventDeletedSuccessfully());
      await loadEvents();
    } catch (e) {
      emit(EventError('Failed to delete event: $e'));
    }
  }

  Future<void> updateEventStartTime(String eventId, DateTime newTime) async {
    try {
      final event = (state as EventLoaded).event;
      final updatedEvent = Event(
        id: event.id,
        clubId: event.clubId,
        title: event.title,
        description: event.description,
        startTime: newTime,
        endTime: event.endTime,
        location: event.location,
        category: event.category,
        capacity: event.capacity,
        participantIds: event.participantIds,
        imageUrl: event.imageUrl,
      );
      await updateEvent(updatedEvent);
    } catch (e) {
      emit(EventError('Failed to update start time: $e'));
    }
  }
}