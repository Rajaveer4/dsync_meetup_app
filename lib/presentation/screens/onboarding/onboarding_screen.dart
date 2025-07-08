import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';
import 'package:dsync_meetup_app/presentation/screens/onboarding/user_detail_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/onboarding/club_selection_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/onboarding/location_selection_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/onboarding/preferences_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'type': 'welcome',
      'title': 'Discover Clubs',
      'description': 'Find and join clubs that match your interests',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'type': 'welcome',
      'title': 'Attend Events',
      'description': 'Never miss out on exciting meetups and activities',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'type': 'welcome',
      'title': 'Connect with People',
      'description': 'Meet like-minded individuals in your community',
      'image': 'assets/images/onboarding3.png',
    },
    {'type': 'profile'},
    {'type': 'location'},
    {'type': 'interests'},
    {'type': 'clubs'},
  ];

  final _nicknameController = TextEditingController();
  final _usernameController = TextEditingController();
  String? _selectedLocation;
  final List<String> _selectedInterests = [];
  final List<String> _selectedClubs = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (!mounted) return;

    if (_nicknameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _selectedLocation == null ||
        _selectedInterests.length < 3 ||
        _selectedClubs.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    await prefs.setString('nickname', _nicknameController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('location', _selectedLocation!);
    await prefs.setStringList('interests', _selectedInterests);
    await prefs.setStringList('clubs', _selectedClubs);

    if (mounted) {
      context.goNamed(RouteNames.home);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${_nicknameController.text}!')),
      );
    }
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else if (_selectedInterests.length < 3) {
        _selectedInterests.add(interest);
      }
    });
  }

  void _toggleClub(String club) {
    setState(() {
      if (_selectedClubs.contains(club)) {
        _selectedClubs.remove(club);
      } else if (_selectedClubs.length < 3) {
        _selectedClubs.add(club);
      }
    });
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildWelcomeSlide({
    required String title,
    required String description,
    required String image,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 32),
          Text(title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage > 0 && _currentPage < 9)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = onboardingData[index];
                  switch (page['type']) {
                    case 'welcome':
                      return _buildWelcomeSlide(
                        title: page['title'],
                        description: page['description'],
                        image: page['image'],
                      );
                    case 'profile':
                      return UserDetailScreen();
                    case 'location':
                      return LocationSelectionScreen(
                        selectedLocation: _selectedLocation,
                        onLocationChanged: (val) => setState(() => _selectedLocation = val),
                      );
                    case 'interests':
                      return PreferencesScreen(
                        selectedInterests: _selectedInterests,
                        onInterestToggled: _toggleInterest,
                      );
                    case 'clubs':
                      return ClubSelectionScreen(
                        selectedClubs: _selectedClubs,
                        onClubToggled: _toggleClub,
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, _buildIndicator),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        ),
                        child: const Text('Back'),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentPage == onboardingData.length - 1) {
                          await _completeOnboarding();
                        } else {
                          bool valid = true;
                          String? error;

                          if (_currentPage == 3 &&
                              (_nicknameController.text.isEmpty || _usernameController.text.isEmpty)) {
                            valid = false;
                            error = 'Please fill all profile details';
                          } else if (_currentPage == 4 && _selectedLocation == null) {
                            valid = false;
                            error = 'Please select your location';
                          } else if (_currentPage == 5 && _selectedInterests.length < 3) {
                            valid = false;
                            error = 'Select at least 3 interests';
                          } else if (_currentPage == 6 && _selectedClubs.length < 3) {
                            valid = false;
                            error = 'Select at least 3 clubs';
                          }

                          if (!valid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error!)),
                            );
                            return;
                          }

                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Text(_currentPage == onboardingData.length - 1 ? 'Finish' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
