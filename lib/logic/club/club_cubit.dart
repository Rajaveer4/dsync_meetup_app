import 'package:bloc/bloc.dart';
import 'package:dsync_meetup_app/data/models/club_model.dart';
import 'package:dsync_meetup_app/data/services/club_service.dart';
import 'package:dsync_meetup_app/logic/club/club_state.dart';
import 'package:dsync_meetup_app/core/utils/error_handler.dart';

class ClubCubit extends Cubit<ClubState> {
  final ClubService clubService;
  ClubModel? _selectedClub;

  ClubCubit(this.clubService): super(ClubInitial());

  ClubModel? get selectedClub => _selectedClub;

  Future<void> fetchClubs() async {
    emit(const ClubLoading());
    try {
      final clubs = await clubService.getClubs();
      emit(ClubLoaded(clubs));
    } catch (e) {
      emit(ClubError(ErrorHandler.handleError(e)));
    }
  }

  Future<void> fetchMyClubs() async {
    emit(const ClubLoading());
    try {
      final clubs = await clubService.getMyClubs();
      emit(ClubLoaded(clubs));
    } catch (e) {
      emit(ClubError(ErrorHandler.handleError(e)));
    }
  }

  Future<void> createClub(ClubModel club) async {
    emit(const ClubLoading());
    try {
      await clubService.createClub(club);
      await fetchClubs(); // Refresh list after creation
    } catch (e) {
      emit(ClubError(ErrorHandler.handleError(e)));
    }
  }

  Future<void> joinClub(String clubId) async {
    emit(const ClubLoading());
    try {
      await clubService.joinClub(clubId);
      await fetchClubs(); // Refresh list after joining
    } catch (e) {
      emit(ClubError(ErrorHandler.handleError(e)));
    }
  }

  void selectClub(String clubId) {
    if (state is ClubLoaded) {
      final clubs = (state as ClubLoaded).clubs;
      _selectedClub = clubs.firstWhere(
        (club) => club.id == clubId,
        orElse: () => ClubModel.empty(),
      );
    }
  }

  List<ClubModel> filterClubsByCategory(String category) {
    if (state is ClubLoaded) {
      return (state as ClubLoaded)
          .clubs
          .where((club) => club.category == category)
          .toList();
    }
    return [];
  }

  Future<void> fetchClubDetails(String clubId) async {
    try {
      emit(ClubLoading());
      final club = await clubService.getClubDetails(clubId);
      emit(ClubLoaded([club]));
    } catch (e) {
      emit(ClubError(e.toString()));
    }
  }
}
