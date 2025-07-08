import 'package:bloc/bloc.dart';
import 'package:dsync_meetup_app/data/models/club_model.dart';
import 'package:dsync_meetup_app/data/services/club_service.dart';
import 'package:dsync_meetup_app/core/utils/error_handler.dart';

abstract class ClubDetailsState {}

class ClubDetailsInitial extends ClubDetailsState {}

class ClubDetailsLoading extends ClubDetailsState {}

class ClubDetailsLoaded extends ClubDetailsState {
  final ClubModel club;

  ClubDetailsLoaded(this.club);
}

class ClubDetailsError extends ClubDetailsState {
  final String message;

  ClubDetailsError(this.message);
}

class ClubDetailsCubit extends Cubit<ClubDetailsState> {
  final String clubId;
  final ClubService clubService;

  ClubDetailsCubit(this.clubId, {ClubService? service})
      : clubService = service ?? ClubService(),
        super(ClubDetailsInitial());

  Future<void> loadClubDetails() async {
    emit(ClubDetailsLoading());
    try {
      final club = await clubService.getClubDetails(clubId);
      emit(ClubDetailsLoaded(club));
    } catch (e) {
      emit(ClubDetailsError(ErrorHandler.handleError(e)));
    }
  }

  Future<void> updateClubDetails(ClubModel updatedClub) async {
    try {
      emit(ClubDetailsLoading());
      await clubService.updateClubDetails(clubId, updatedClub);
      await loadClubDetails();
    } catch (e) {
      emit(ClubDetailsError(ErrorHandler.handleError(e)));
    }
  }
}