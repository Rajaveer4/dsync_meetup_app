import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/settings/change_password_state.dart';
import 'package:dsync_meetup_app/data/services/auth_service.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthService authService;

  ChangePasswordCubit(this.authService) : super(ChangePasswordInitial());

  Future<void> changePassword(String oldPwd, String newPwd, String confirmPwd) async {
    emit(ChangePasswordLoading());

    if (newPwd != confirmPwd) {
      emit(ChangePasswordError('Passwords do not match.'));
      return;
    }

    try {
      await authService.changePassword(oldPwd, newPwd);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordError(e.toString()));
    }
  }
}
