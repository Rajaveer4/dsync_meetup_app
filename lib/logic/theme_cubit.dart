import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:dsync_meetup_app/core/theme/app_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  void toggleTheme() {
    emit(state.brightness == Brightness.light ? darkTheme : lightTheme);
  }
}