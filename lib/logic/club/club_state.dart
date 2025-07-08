import 'package:collection/collection.dart';
import 'package:dsync_meetup_app/data/models/club_model.dart';

abstract class ClubState {
  const ClubState();
}

class ClubInitial extends ClubState {
  const ClubInitial();
}

class ClubLoading extends ClubState {
  const ClubLoading();
}

class ClubLoaded extends ClubState {
  final List<ClubModel> clubs;

  const ClubLoaded(this.clubs);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClubLoaded &&
        const ListEquality().equals(other.clubs, clubs);
  }

  @override
  int get hashCode => const ListEquality().hash(clubs);
}

class ClubError extends ClubState {
  final String message;

  const ClubError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClubError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
