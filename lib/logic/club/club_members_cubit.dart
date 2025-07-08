import 'package:bloc/bloc.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';
import 'package:dsync_meetup_app/data/services/club_service.dart';
import 'package:dsync_meetup_app/core/utils/error_handler.dart';

abstract class ClubMembersState {}

class ClubMembersInitial extends ClubMembersState {}

class ClubMembersLoading extends ClubMembersState {}

class ClubMembersLoaded extends ClubMembersState {
  final List<User> members;

  ClubMembersLoaded(this.members);
}

class ClubMembersError extends ClubMembersState {
  final String message;

  ClubMembersError(this.message);
}

class ClubMembersCubit extends Cubit<ClubMembersState> {
  final String clubId;
  final ClubService clubService;

  ClubMembersCubit(this.clubId, {required this.clubService})
      : super(ClubMembersInitial());

  Future<void> loadMembers() async {
    emit(ClubMembersLoading());
    try {
      final members = await clubService.getClubMembers(clubId);
      emit(ClubMembersLoaded(members));
    } catch (e) {
      emit(ClubMembersError(ErrorHandler.handleError(e)));
    }
  }

  Future<void> removeMember(String userId) async {
    try {
      emit(ClubMembersLoading());
      await clubService.removeMember(clubId, userId);
      await loadMembers();
    } catch (e) {
      emit(ClubMembersError(ErrorHandler.handleError(e)));
    }
  }
}