import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class WelcomeScreen extends StatefulWidget {
  final String type;
  final String title;
  final String description;
  final String image;

  const WelcomeScreen({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> onboardingPages = [
    {
      'title': 'Discover Clubs',
      'description': 'Find and join clubs that match your interests',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Attend Events',
      'description': 'Never miss out on exciting meetups and activities',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'Connect with People',
      'description': 'Meet like-minded individuals in your community',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildPage(String title, String description, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPage == onboardingPages.length - 1) {
      _animationController.forward();
    } else {
      _animationController.reset();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Collage Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/collage_bg.png', // Replace with your collage image
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay for contrast
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Logo or App Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'DSync',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                // Onboarding Screens
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingPages.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(
                        onboardingPages[index]['title']!,
                        onboardingPages[index]['description']!,
                        onboardingPages[index]['image']!,
                      );
                    },
                  ),
                ),

                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: _currentPage == index ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white38,
                      ),
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _currentPage == onboardingPages.length - 1
                            ? FadeTransition(
                                opacity: _fadeAnimation,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.goNamed(RouteNames.register);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Get Started'),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Next'),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
