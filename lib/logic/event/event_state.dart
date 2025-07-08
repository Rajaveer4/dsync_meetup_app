part of 'event_cubit.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  const EventsLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventLoaded extends EventState {
  final Event event;
  const EventLoaded(this.event);

  @override
  List<Object> get props => [event];
}

class EventCreatedSuccessfully extends EventState {
  final Event event;
  const EventCreatedSuccessfully(this.event);

  @override
  List<Object> get props => [event];
}

class EventUpdatedSuccessfully extends EventState {
  final Event event;
  const EventUpdatedSuccessfully(this.event);

  @override
  List<Object> get props => [event];
}

class EventDeletedSuccessfully extends EventState {}

class EventError extends EventState {
  final String message;
  const EventError(this.message);

  @override
  List<Object> get props => [message];
}