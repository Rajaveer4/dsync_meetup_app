class RouteNames {
  RouteNames._(); // Private constructor to prevent instantiation

  // ==================== AUTHENTICATION ====================
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String changePasswordScreen = '/change-password';
  static const String newPassword = '/new-password';

  // ==================== ONBOARDING ====================
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String selectInterests = '/select-interests';
  static const String locationSelection = '/location-selection';
  static const String notificationPreferences = '/notification-preferences';
  static const String profileSetup = '/profile-setup';
  static const String preferences = '/preferences';
  static const String location = '/location';
  static const String splash = '/splash';
  

  // ==================== MAIN APP ====================
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String explore = '/explore';
  static const String notifications = '/notifications';
  static const String moments = '/moments';
  static const String achievements = '/achievements';
  static const String activityFeed = '/activity-feed';

  // ==================== USER PROFILE ====================
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String deleteAccount = '/profile/delete';
  static const String followers = '/profile/followers';
  static const String following = '/profile/following';
  static const String userProfile = '/users/:userId';
  static const String userPosts = '/users/:userId/posts';
  static const String userEvents = '/users/:userId/events';
  static const String userClubs = '/users/:userId/clubs';
  static const String userDetail = '/users/:userId/detail';

  // ==================== SETTINGS ====================
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String notificationSettings = '/settings/notifications';
  static const String privacySettings = '/settings/privacy';
  static const String appSettings = '/settings/app';
  static const String helpCenter = '/settings/help';
  static const String aboutApp = '/settings/about';
  static const String changePassword = '/settings/change-password';
  static const String help = '/settings/help';
  static const String about = '/settings/about';

  // ==================== CLUBS ====================
  static const String clubs = '/clubs';
  static const String allClubs = '/clubs/all';
  static const String myClubs = '/clubs/my';
  static const String recommendedClubs = '/clubs/recommended';
  static const String clubSearch = '/clubs/search';
  static const String createClub = '/clubs/create';
  static const String joinClub = '/clubs/join';
  static const String clubRequests = '/clubs/requests';
  static const String clubInvites = '/clubs/invites';
  static const String clubMemberSearch = '/clubs/member-search';
  static const String memberDetails = '/clubs/:clubId/members/:memberId';
  static const String clubSelection = '/clubs/selection';

  // Club-specific routes
  static const String clubDetails = '/clubs/:clubId';
  static const String clubSettings = '/clubs/:clubId/settings';
  static const String editClub = '/clubs/:clubId/edit';
  static const String clubMembers = '/clubs/:clubId/members';
  static const String clubAdmins = '/clubs/:clubId/admins';
  static const String clubJoinRequests = '/clubs/:clubId/join-requests';
  static const String clubRules = '/clubs/:clubId/rules';
  static const String clubAbout = '/clubs/:clubId/about';
  static const String clubMedia = '/clubs/:clubId/media';
  static const String clubPostSearch = '/clubs/:clubId/posts/search';

  // Club content
  static const String clubPosts = '/clubs/:clubId/posts';
  static const String clubEvents = '/clubs/:clubId/events';
  static const String clubAnnouncements = '/clubs/:clubId/announcements';
  static const String clubPolls = '/clubs/:clubId/polls';
  static const String clubDiscussions = '/clubs/:clubId/discussions';

  // Club content creation
  static const String createPost = '/clubs/:clubId/posts/create';
  static const String createEvent = '/clubs/:clubId/events/create';
  static const String createAnnouncement = '/clubs/:clubId/announcements/create';
  static const String createPoll = '/clubs/:clubId/polls/create';
  static const String startDiscussion = '/clubs/:clubId/discussions/create';

  // Club content details
  static const String postDetails = '/clubs/:clubId/posts/:postId';
  static const String eventDetails = '/clubs/:clubId/events/:eventId';
  static const String announcementDetails = '/clubs/:clubId/announcements/:announcementId';
  static const String pollDetails = '/clubs/:clubId/polls/:pollId';
  static const String discussionDetails = '/clubs/:clubId/discussions/:discussionId';

  // ==================== EVENTS ====================
  static const String events = '/events';
  static const String allEvents = '/events/all';
  static const String upcomingEvents = '/events/upcoming';
  static const String pastEvents = '/events/past';
  static const String recommendedEvents = '/events/recommended';
  static const String eventCategories = '/events/categories';
  static const String eventCategoryDetails = '/events/categories/:categoryId';
  static const String myEvents = '/events/my';
  static const String eventCalendar = '/events/calendar';
  static const String eventCreate = '/events/create';
  static const String eventDetailsStandalone = '/events/:eventId';
  static const String eventEdit = '/events/:eventId/edit';
  static const String eventAttendees = '/events/:eventId/attendees';
  static const String eventSearch = '/events/search';

  // ==================== MESSAGING ====================
  static const String chat = '/chat';
  static const String chatConversation = '/chat/:conversationId';
  static const String chatCreateGroup = '/chat/create-group';
  static const String chatGroupDetails = '/chat/group/:groupId';
  static const String chatSettings = '/chat/:chatId/settings';

  // ==================== ADMIN ====================
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminClubs = '/admin/clubs';
  static const String adminEvents = '/admin/events';
  static const String adminReports = '/admin/reports';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminSettings = '/admin/settings/:userId';

  // ==================== SUPPORT ====================
  static const String support = '/support';
  static const String contactUs = '/support/contact';
  static const String faq = '/support/faq';
  static const String reportIssue = '/support/report';
  static const String feedback = '/support/feedback';

  // ==================== LEGAL ====================
  static const String termsOfService = '/legal/terms';
  static const String privacyPolicy = '/legal/privacy';
  static const String communityGuidelines = '/legal/guidelines';
  static const String cookiePolicy = '/legal/cookies';

  // ==================== ERROR PAGES ====================
  static const String notFound = '/error/404';
  static const String unauthorized = '/error/401';
  static const String serverError = '/error/500';
  static const String maintenance = '/error/maintenance';
  static const String initError = '/error/init-error';

  // ==================== UTILITY ====================
  static const String search = '/search';
  static const String notificationsSettings = '/notifications-settings';
  static const String deepLinkHandler = '/deeplink';

  // ==================== HELPER METHODS ====================
  static String buildClubRoute(String clubId, [String subRoute = '']) {
    final base = clubDetails.replaceFirst(':clubId', clubId);
    return subRoute.isNotEmpty ? '$base/$subRoute' : base;
  }

  static String buildEventRoute(String eventId, [String subRoute = '']) {
    final base = eventDetailsStandalone.replaceFirst(':eventId', eventId);
    return subRoute.isNotEmpty ? '$base/$subRoute' : base;
  }

  static String buildUserRoute(String userId, [String subRoute = '']) {
    final base = userProfile.replaceFirst(':userId', userId);
    return subRoute.isNotEmpty ? '$base/$subRoute' : base;
  }

  static String buildChatRoute(String chatId, [String subRoute = '']) {
    final base = chatConversation.replaceFirst(':conversationId', chatId);
    return subRoute.isNotEmpty ? '$base/$subRoute' : base;
  }

  static String buildAdminRoute(String userId, [String subRoute = '']) {
    final base = adminSettings.replaceFirst(':userId', userId);
    return subRoute.isNotEmpty ? '$base/$subRoute' : base;
  }

  static bool isParameterizedRoute(String route) => route.contains(':');

  static String extractBaseRoute(String route) {
    if (isParameterizedRoute(route)) {
      return route.substring(0, route.indexOf('/:'));
    }
    return route;
  }

  static Map<String, String> extractParameters(String route, String actualPath) {
    final params = <String, String>{};
    final routeParts = route.split('/');
    final pathParts = actualPath.split('/');

    for (var i = 0; i < routeParts.length; i++) {
      if (routeParts[i].startsWith(':') && i < pathParts.length) {
        params[routeParts[i].substring(1)] = pathParts[i];
      }
    }

    return params;
  }

  static bool matchesRoutePattern(String routePattern, String actualPath) {
    final patternParts = routePattern.split('/');
    final pathParts = actualPath.split('/');

    if (patternParts.length != pathParts.length) return false;

    for (var i = 0; i < patternParts.length; i++) {
      if (!patternParts[i].startsWith(':') && 
          patternParts[i] != pathParts[i]) {
        return false;
      }
    }

    return true;
  }

  static String getRouteName(String route) {
    return route.split('/').lastWhere(
      (part) => part.isNotEmpty,
      orElse: () => 'home'
    );
  }
}