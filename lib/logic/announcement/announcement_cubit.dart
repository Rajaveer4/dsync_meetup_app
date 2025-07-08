// lib/logic/announcement/announcement_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dsync_meetup_app/data/models/announcement_model.dart';
import 'package:dsync_meetup_app/data/services/announcement_service.dart';
import 'package:equatable/equatable.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementService _service;

  AnnouncementCubit({required AnnouncementService service})
      : _service = service,
        super(AnnouncementInitial());

  Future<void> loadAnnouncements(String clubId) async {
    emit(AnnouncementLoading());
    try {
      final announcements = await _service.getAnnouncements(clubId);
      emit(AnnouncementLoaded(announcements));
    } catch (e) {
      emit(AnnouncementError(e.toString()));
    }
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      emit(AnnouncementLoading());
      await _service.createAnnouncement(announcement);
      await loadAnnouncements(announcement.clubId);
    } catch (e) {
      emit(AnnouncementError(e.toString()));
    }
  }
}