class EditProfileArguments {
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime joinDate;
  final int eventsAttended;
  final String? profileImageUrl;

  EditProfileArguments({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.joinDate,
    required this.eventsAttended,
    this.profileImageUrl,
  });
}

class UserProfileArguments {
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime joinDate;
  final int eventsAttended;

  UserProfileArguments({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.joinDate,
    required this.eventsAttended,
  });
}

class UserEventsArguments {
  final String userId;

  UserEventsArguments({required this.userId});
}

class ClubDetailsArguments {
  final String clubId;

  ClubDetailsArguments({required this.clubId});
}

class PostDetailsArguments {
  final String postId;
  final String clubId;

  PostDetailsArguments({required this.postId, required this.clubId});
}

class EventDetailsArguments {
  final String eventId;
  final String clubId;

  EventDetailsArguments({required this.eventId, required this.clubId});
}

class AnnouncementDetailsArguments {
  final String announcementId;
  final String clubId;

  AnnouncementDetailsArguments({required this.announcementId, required this.clubId});
}

class PollDetailsArguments {
  final String pollId;
  final String clubId;

  PollDetailsArguments({required this.pollId, required this.clubId});
}

class MemberDetailsArguments {
  final String userId;
  final String clubId;

  MemberDetailsArguments({required this.userId, required this.clubId});
}