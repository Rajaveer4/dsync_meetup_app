import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';
import 'package:dsync_meetup_app/data/services/auth_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthService authService;

  UserCubit(this.authService) : super(UserInitial());

  Future<void> loadUserProfile(String userId) async {
    emit(UserLoading());
    try {
      final user = await authService.getUserProfile(userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUserProfile(User user) async {
    emit(UserLoading());
    try {
      await authService.updateUserProfile(user);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}