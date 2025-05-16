class OnboardingData {
  final String title;
  final String description;

  OnboardingData({required this.title, required this.description});
}

final onboardingContent = <OnboardingData>[
  OnboardingData(title: "Track", description: "Track your daily expenses."),
  OnboardingData(title: "Budget", description: "Plan your spending."),
  OnboardingData(title: "Analyze", description: "Visualize your usage."),
];
