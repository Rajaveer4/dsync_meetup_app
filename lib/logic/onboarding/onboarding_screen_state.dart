part of 'onboarding_screen_cubit.dart';

class OnboardingScreenState extends Equatable {
  final int currentPage;
  final int totalPages;

  const OnboardingScreenState({
    this.currentPage = 0,
    this.totalPages = 4, // Welcome + 3 other pages
  });

  OnboardingScreenState copyWith({
    int? currentPage,
    int? totalPages,
  }) {
    return OnboardingScreenState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages];
}