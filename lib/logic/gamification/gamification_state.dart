abstract class GamificationState {}

class GamificationInitial extends GamificationState {}

class GamificationUpdated extends GamificationState {
  final int points;

  GamificationUpdated(this.points);
}
