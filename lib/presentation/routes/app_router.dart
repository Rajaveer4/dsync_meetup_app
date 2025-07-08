import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:dsync_meetup_app/logic/club/club_cubit.dart';
import 'package:dsync_meetup_app/data/services/club_service.dart';

// Splash and Auth screens
import 'package:dsync_meetup_app/presentation/screens/onboarding/splash_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/auth/login_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/auth/register_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/auth/new_password_screen.dart';

// Onboarding screens
import 'package:dsync_meetup_app/presentation/screens/onboarding/welcome_screen.dart' as welcome;
import 'package:dsync_meetup_app/presentation/screens/onboarding/onboarding_screen.dart' as main_onboarding;
import 'package:dsync_meetup_app/presentation/screens/onboarding/preferences_screen.dart' as main_onboarding;
import 'package:dsync_meetup_app/presentation/screens/onboarding/location_selection_screen.dart' as welcome;
import 'package:dsync_meetup_app/presentation/screens/onboarding/user_detail_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/onboarding/club_selection_screen.dart'as club_selection;

// Main app screens
import 'package:dsync_meetup_app/presentation/screens/home/home_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/profile/user_info_page.dart' as profile;
import 'package:dsync_meetup_app/presentation/screens/profile/edit_profile_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/events/user_events_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/profile/achievements_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/events/create_event_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/events/event_details_screen.dart';

// Club screens
import 'package:dsync_meetup_app/presentation/screens/clubs/all_clubs_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/my_clubs_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/club_details_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/club_members_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/club_events_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/club_settings_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/club_posts_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/create_club_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/club_search_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/create_post_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/clubs/post_details_screen.dart';

// Error Screens
import 'package:dsync_meetup_app/presentation/screens/errors/not_found_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/errors/init_error_screen.dart';

class MainAppShell extends StatelessWidget {
  final Widget child;

  const MainAppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  BottomNavigationBar _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _calculateCurrentIndex(context),
      onTap: (index) => _onItemTapped(index, context),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Clubs'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  int _calculateCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/clubs')) return 1;
    if (location.startsWith('/events')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/settings')) return 4;
    
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
        break;
      case 1:
        context.goNamed(RouteNames.myClubs);
        break;
      case 2:
        context.goNamed(RouteNames.events);
        break;
      case 3:
        context.goNamed(RouteNames.chat);
        break;
      case 4:
        context.goNamed(RouteNames.settings);
        break;
    }
  }
}

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authCubit.state;
      final isInitialized = authState is! AuthInitial;
      final isAuthenticated = authState is Authenticated;
      final hasCompletedOnboarding = isAuthenticated && authState.hasCompletedOnboarding;

      // If we're still initializing, stay on splash screen
      if (!isInitialized) return '/splash';

      // Handle initialization errors
      if (authState is AuthError) return '/init-error';

      // If on splash screen and initialized, redirect appropriately
      if (state.uri.path == '/splash') {
        if (!isAuthenticated) return '/welcome';
        if (!hasCompletedOnboarding) return '/onboarding';
        return '/home';
      }

      // If not authenticated, redirect to welcome screen
      if (!isAuthenticated &&
          !['/welcome', '/login', '/register', '/forgot-password', '/new-password', '/splash'].contains(state.uri.path)) {
        return '/welcome';
      }

      // If authenticated but hasn't completed onboarding
      if (isAuthenticated && !hasCompletedOnboarding &&
          !['/onboarding', '/preferences', '/location', '/user-detail', '/club-selection'].contains(state.uri.path)) {
        return '/onboarding';
      }

      // If onboarding completed but trying to access onboarding screens
      if (hasCompletedOnboarding &&
          ['/onboarding', '/welcome', '/login', '/register', '/forgot-password', '/new-password', '/splash', '/preferences', '/location', '/user-detail', '/club-selection'].contains(state.uri.path)) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),

      // Public Routes
            GoRoute(
              path: '/welcome',
              name: RouteNames.welcome,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const welcome.WelcomeScreen(
                  type: 'welcome',
                  title: 'Connect with People',
                  description: 'Meet like-minded individuals in your community',
                  image: 'assets/images/onboarding3.png',
                ),
              ),
            ),
            GoRoute(
              path: '/login',
              name: RouteNames.login,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const LoginScreen(),
              ),
            ),
            GoRoute(
              path: '/register',
              name: RouteNames.register,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const RegisterScreen(),
              ),
            ),
            GoRoute(
              path: '/forgot-password',
              name: RouteNames.forgotPassword,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const ForgotPasswordScreen(),
              ),
            ),
            GoRoute(
              path: '/new-password',
              name: RouteNames.newPassword,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: NewPasswordScreen(email: state.extra as String),
              ),
            ),
            GoRoute(
              path: '/onboarding',
              name: RouteNames.onboarding,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const main_onboarding.OnboardingScreen(),
              ),
            ),
            GoRoute(
              path: '/preferences',
              name: RouteNames.preferences,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: main_onboarding.PreferencesScreen(
                  selectedInterests: const <String>[], // Provide your default or current interests here
                  onInterestToggled: (String interest) {}, // Provide your callback logic here
                ),
              ),
            ),
            GoRoute(
              path: '/location',
              name: RouteNames.location,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: welcome.LocationSelectionScreen(
                  selectedLocation: null, // Replace null with your default or current location value
                  onLocationChanged: (location) {}, // Replace with your actual callback logic
                ),
              ),
            ),
            GoRoute(
              path: '/user-detail',
              name: RouteNames.userDetail,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const UserDetailScreen(),
              ),
            ),
            GoRoute(
              path: '/club-selection',
              name: RouteNames.clubSelection,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: club_selection.ClubSelectionScreen(
                  selectedClubs: const <String>[], // Provide your default or current selected clubs here
                  onClubToggled: (String clubId) {}, // Provide your callback logic here
                ),
              ),
            ),
            GoRoute(
              path: '/init-error',
              name: RouteNames.initError,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: InitErrorScreen(
                  error: state.extra as String? ?? 'Initialization Error',
                ),
              ),
            ),
            GoRoute(
              path: '/home',
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),

      // Main App Shell
      ShellRoute(
        builder: (context, state, child) => MainAppShell(child: child),
        routes: [
          // Home Section
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
            routes: [
              GoRoute(
                path: 'profile',
                name: RouteNames.profile,
                pageBuilder: (context, state) {
                  final args = state.extra as Map<String, dynamic>;
                  return MaterialPage(
                    key: state.pageKey,
                    child: profile.UserInfoPage(
                      userId: args['userId'] as String,
                      userName: args['userName'] as String,
                      userEmail: args['userEmail'] as String,
                      joinDate: args['joinDate'] is String
                          ? DateTime.parse(args['joinDate'] as String)
                          : args['joinDate'] as DateTime,
                      eventsAttended: args['eventsAttended'] is String
                          ? int.parse(args['eventsAttended'] as String)
                          : args['eventsAttended'] as int,
                      profileImageUrl: args['profileImageUrl'] as String?,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'edit-profile',
                name: RouteNames.editProfile,
                pageBuilder: (context, state) {
                  final args = state.extra as Map<String, dynamic>;
                  return MaterialPage(
                    key: state.pageKey,
                    child: EditProfileScreen(
                      userId: args['userId'] as String,
                      userName: args['userName'] as String,
                      userEmail: args['userEmail'] as String,
                      profileImageUrl: args['profileImageUrl'] as String?,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'achievements',
                name: RouteNames.achievements,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const AchievementsScreen(),
                ),
              ),
            ],
          ),

          // Clubs Section
          GoRoute(
            path: '/clubs',
            name: RouteNames.clubs,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const MyClubsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'all',
                name: RouteNames.allClubs,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => ClubCubit(ClubService())..fetchClubs(),
                    child: const AllClubsScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: 'create',
                name: RouteNames.createClub,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => ClubCubit(ClubService()),
                    child: const CreateClubScreen(),
                  ),
                ),
              ),
              GoRoute(
                path: 'search',
                name: RouteNames.clubSearch,
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const ClubSearchScreen(),
                ),
              ),
              GoRoute(
                path: ':clubId',
                name: RouteNames.clubDetails,
                pageBuilder: (context, state) {
                  final clubId = state.pathParameters['clubId']!;
                  return MaterialPage(
                    key: state.pageKey,
                    child: ClubDetailsScreen(clubId: clubId),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'members',
                    name: RouteNames.clubMembers,
                    pageBuilder: (context, state) {
                      final clubId = state.pathParameters['clubId']!;
                      return MaterialPage(
                        key: state.pageKey,
                        child: ClubMembersScreen(clubId: clubId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'events',
                    name: RouteNames.clubEvents,
                    pageBuilder: (context, state) {
                      final clubId = state.pathParameters['clubId']!;
                      return MaterialPage(
                        key: state.pageKey,
                        child: ClubEventsScreen(clubId: clubId),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'posts',
                    name: RouteNames.clubPosts,
                    pageBuilder: (context, state) {
                      final clubId = state.pathParameters['clubId']!;
                      return MaterialPage(
                        key: state.pageKey,
                        child: ClubPostsScreen(clubId: clubId),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'create',
                        name: RouteNames.createPost,
                        pageBuilder: (context, state) {
                          final clubId = state.pathParameters['clubId']!;
                          return MaterialPage(
                            key: state.pageKey,
                            child: CreatePostScreen(clubId: clubId),
                          );
                        },
                      ),
                      GoRoute(
                        path: ':postId',
                        name: RouteNames.postDetails,
                        pageBuilder: (context, state) {
                          final clubId = state.pathParameters['clubId']!;
                          final postId = state.pathParameters['postId']!;
                          return MaterialPage(
                            key: state.pageKey,
                            child: PostDetailsScreen(
                              clubId: clubId, 
                              postId: postId,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'settings',
                    name: RouteNames.clubSettings,
                    pageBuilder: (context, state) {
                      final clubId = state.pathParameters['clubId']!;
                      return MaterialPage(
                        key: state.pageKey,
                        child: ClubSettingsScreen(clubId: clubId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Events Section
          GoRoute(
            path: '/events',
            name: RouteNames.events,
            pageBuilder: (context, state) {
              final userId = (state.extra as Map<String, dynamic>?)?['userId'] as String? ?? '';
              return MaterialPage(
                key: state.pageKey,
                child: UserEventsScreen(userId: userId),
              );
            },
            routes: [
              GoRoute(
                path: 'create',
                name: RouteNames.createEvent,
                pageBuilder: (context, state) {
                  final clubId = state.extra as String? ?? '';
                  return MaterialPage(
                    key: state.pageKey,
                    child: CreateEventScreen(clubId: clubId),
                  );
                },
              ),
              GoRoute(
                path: ':eventId',
                name: RouteNames.eventDetails,
                pageBuilder: (context, state) {
                  final eventId = state.pathParameters['eventId']!;
                  final clubId = (state.extra as Map<String, dynamic>?)?['clubId'] as String? ?? '';
                  return MaterialPage(
                    key: state.pageKey,
                    child: EventDetailsScreen(
                      eventId: eventId,
                      clubId: clubId,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}