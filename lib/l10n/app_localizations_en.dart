// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get english => 'English';

  @override
  String get bengali => 'বাংলা';

  @override
  String get appTitle => 'Pocketa';

  @override
  String get tagline => 'Own your money. Own your future.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get finish => 'Finish';

  @override
  String get continuee => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get confirm => 'Confirm';

  @override
  String get search => 'Search';

  @override
  String get apply => 'Apply';

  @override
  String get clear => 'Clear';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get welcomeTitle => 'Welcome to Pocketa';

  @override
  String get welcomeSubtitle => 'Clarity with every taka you spend.';

  @override
  String get getStarted => 'Let’s begin';

  @override
  String get introTrackTitle => 'Track expenses';

  @override
  String get introTrackSubtitle => 'See where your money goes, instantly.';

  @override
  String get introBudgetTitle => 'Stay on budget';

  @override
  String get introBudgetSubtitle => 'Set a limit, stay in control.';

  @override
  String get introControlTitle => 'Be in control';

  @override
  String get introControlSubtitle => 'Your money. Your rules.';

  @override
  String get login => 'Log in';

  @override
  String get signup => 'Create account';

  @override
  String get logout => 'Log out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get name => 'Name';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String homeGreeting(Object name) {
    return 'Hi, $name!';
  }

  @override
  String get dashboard => 'Dashboard';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expenses';

  @override
  String get net => 'Net';

  @override
  String get monthlySummary => 'This month';

  @override
  String get recentTransactions => 'Recent activity';

  @override
  String get viewAll => 'View all';

  @override
  String get newLabel => 'New';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get addCategory => 'Add category';

  @override
  String get makeDefault => 'Make default';

  @override
  String get menu => 'Menu';

  @override
  String get more => 'More';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get optional => 'Optional';

  @override
  String get notesAndTags => 'Notes & Tags';

  @override
  String get reset => 'Reset';

  @override
  String get setNow => 'Set now';

  @override
  String get anotherWallet => 'Another wallet';

  @override
  String get accessibility_welcome_illustration => 'Welcome illustration';

  @override
  String get someoneAccount => 'Someone / Account';

  @override
  String get recipientLabel => 'Recipient (name / phone / account)';

  @override
  String get recipientHint => 'e.g. Mehedi, 01XXXXXXXXX, A/C 12345';

  @override
  String get targetWallet => 'Target wallet';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get details => 'Details';

  @override
  String get detailsSubtitle => 'Date, wallet, etc.';

  @override
  String get dateTime => 'Date & Time';

  @override
  String get wallet => 'Wallet';

  @override
  String get transferTo => 'Transfer To';

  @override
  String get transferChoiceHelp =>
      'Choose one: another wallet (internal) or a recipient (external).';

  @override
  String get clearAllTags => 'Clear all tags';

  @override
  String get addTag => 'Add tag';

  @override
  String get walletNameHint => 'e.g. Cash, bKash, Nagad';

  @override
  String get amountHint => '0.00';

  @override
  String get netBalance => 'Net balance';

  @override
  String get surplus => 'Surplus';

  @override
  String get deficit => 'Deficit';

  @override
  String get transactions => 'Transactions';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get deleteTransaction => 'Delete transaction';

  @override
  String get transactionAdded => 'Transaction added ✔';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get transactionDeleted => 'Transaction removed';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get note => 'Note';

  @override
  String get date => 'Date';

  @override
  String get type => 'Type';

  @override
  String get incomeType => 'Income';

  @override
  String get expenseType => 'Expense';

  @override
  String get transfer => 'Transfer';

  @override
  String get noTransactions => 'No records yet. Start now!';

  @override
  String get budgets => 'Budgets';

  @override
  String get setBudget => 'Set a budget';

  @override
  String get budgetLimit => 'Budget limit';

  @override
  String get remaining => 'Remaining';

  @override
  String get spent => 'Spent';

  @override
  String get budgetExceeded => 'Limit crossed 🚨';

  @override
  String budgetLeft(Object amount) {
    return '$amount left';
  }

  @override
  String get noBudgets => 'No budgets yet';

  @override
  String get createFirstBudget => 'Create your first budget';

  @override
  String get wallets => 'Wallets';

  @override
  String get addWallet => 'Add wallet';

  @override
  String get editWallet => 'Edit wallet';

  @override
  String get deleteWallet => 'Delete wallet';

  @override
  String get walletName => 'Wallet name';

  @override
  String get walletType => 'Wallet type';

  @override
  String get initialBalance => 'Starting balance';

  @override
  String get cash => 'Cash';

  @override
  String get bank => 'Bank';

  @override
  String get mobileMoney => 'Mobile money';

  @override
  String get wallet_bkash => 'bKash';

  @override
  String get wallet_nagad => 'Nagad';

  @override
  String get wallet_upay => 'Upay';

  @override
  String get wallet_rocket => 'Rocket';

  @override
  String get wallet_preset_bank_ac => 'Bank A/C';

  @override
  String get chooseWallet => 'Choose wallet';

  @override
  String get noWallets => 'No wallets yet';

  @override
  String get food => 'Food';

  @override
  String get transport => 'Transport';

  @override
  String get shopping => 'Shopping';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get utilities => 'Utilities';

  @override
  String get bills => 'Bills';

  @override
  String get health => 'Health';

  @override
  String get education => 'Education';

  @override
  String get rent => 'Rent';

  @override
  String get salary => 'Salary';

  @override
  String get investment => 'Investment';

  @override
  String get gift => 'Gift';

  @override
  String get others => 'Others';

  @override
  String get insights => 'Insights';

  @override
  String get weeklySpending => 'This week';

  @override
  String get monthlyReport => 'Monthly report';

  @override
  String get topCategories => 'Top categories';

  @override
  String get spendingTrend => 'Spending trend';

  @override
  String get exportReport => 'Export report';

  @override
  String get filters => 'Filters';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get lastMonth => 'Last month';

  @override
  String get customRange => 'Custom range';

  @override
  String get fromDate => 'From';

  @override
  String get toDate => 'To';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get systemDefault => 'System default';

  @override
  String get darkMode => 'Dark';

  @override
  String get lightMode => 'Light';

  @override
  String get language => 'Language';

  @override
  String get language_en => 'English';

  @override
  String get language_bn => 'Bangla';

  @override
  String get switchLanguage => 'Switch language';

  @override
  String get currency => 'Currency';

  @override
  String get security => 'Security';

  @override
  String get biometrics => 'Biometrics';

  @override
  String get pinCode => 'PIN code';

  @override
  String get autoBackup => 'Auto backup';

  @override
  String get sync => 'Sync';

  @override
  String get about => 'About';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get export => 'Export';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get exportPDF => 'Export PDF';

  @override
  String get exportSuccess => 'Export ready ✅';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get share => 'Share';

  @override
  String get download => 'Download';

  @override
  String get notifications => 'Notifications';

  @override
  String notifBudgetExceeded(Object category) {
    return 'Overspent on $category';
  }

  @override
  String notifBudgetRemaining(Object category, Object amount) {
    return '$amount left for $category';
  }

  @override
  String notifLowBalance(Object wallet) {
    return 'Low balance in $wallet';
  }

  @override
  String get notifBackupSuccess => 'Backup saved';

  @override
  String get notifBackupFailed => 'Backup failed';

  @override
  String get notifDailySummaryReady => 'Your daily summary is here';

  @override
  String get notifWeeklySummaryReady => 'Weekly summary is ready';

  @override
  String get errorsTitle => 'Something went wrong';

  @override
  String get errorGeneric => 'An unexpected error occurred';

  @override
  String get errorNetwork => 'Network error occurred';

  @override
  String get errorTimeout => 'Request timed out.';

  @override
  String get errorUnauthorized => 'Please log in.';

  @override
  String get errorForbidden => 'Not allowed.';

  @override
  String get errorNotFound => 'Not found.';

  @override
  String get errorValidation => 'Validation error';

  @override
  String errorRequired(Object field) {
    return '$field is required';
  }

  @override
  String errorMinLength(Object field, Object min) {
    return '$field must be at least $min characters';
  }

  @override
  String errorMaxLength(Object field, Object max) {
    return '$field must be at most $max characters';
  }

  @override
  String errorMinValue(Object field, Object min) {
    return '$field must be at least $min';
  }

  @override
  String errorMaxValue(Object field, Object max) {
    return '$field must be at most $max';
  }

  @override
  String get errorAmountPositive => 'Amount must be positive';

  @override
  String get errorSelectWallet => 'Pick a wallet';

  @override
  String get errorSelectCategory => 'Pick a category';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyTransactions => 'Add your first transaction.';

  @override
  String get emptyBudgets => 'Create a budget to get started.';

  @override
  String get emptyWallets => 'Add a wallet to begin.';

  @override
  String get emptySearch => 'No results found';

  @override
  String get accessibilityLanguageSwitch => 'Switch app language';

  @override
  String get accessibilityAddTransaction => 'Add a new transaction';

  @override
  String get accessibilityBack => 'Go back';

  @override
  String get permissionStorageTitle => 'Storage permission';

  @override
  String get permissionStorageDesc =>
      'Allow access to save exports and backups.';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get permissionOpenSettings => 'Open settings';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateNow => 'Update now';

  @override
  String get later => 'Later';

  @override
  String get recurringTransactions => 'Recurring transactions';

  @override
  String get addRecurring => 'Add recurring';

  @override
  String get editRecurring => 'Edit recurring';

  @override
  String get deleteRecurring => 'Delete recurring';

  @override
  String nextOccurrence(Object date) {
    return 'Next on $date';
  }

  @override
  String get goals => 'Goals';

  @override
  String get createGoal => 'New goal';

  @override
  String get editGoal => 'Edit goal';

  @override
  String get deleteGoal => 'Delete goal';

  @override
  String get goalName => 'Goal name';

  @override
  String get goalTargetAmount => 'Target amount';

  @override
  String get goalSavedAmount => 'Saved amount';

  @override
  String get goalDeadline => 'Deadline';

  @override
  String get goalProgress => 'Progress';

  @override
  String get goalCompleted => 'Goal done 🎉';

  @override
  String get noGoals => 'No goals yet';

  @override
  String countTransactions(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String countBudgets(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count budgets',
      one: '1 budget',
      zero: 'No budgets',
    );
    return '$_temp0';
  }

  @override
  String countWallets(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wallets',
      one: '1 wallet',
      zero: 'No wallets',
    );
    return '$_temp0';
  }

  @override
  String daysStreak(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# days',
      one: '# day',
    );
    return 'On budget for $_temp0 🎉';
  }

  @override
  String nudgeReviewSpend(Object category) {
    return 'Check your $category spending';
  }

  @override
  String get nudgeLowerLimitNextMonth => 'Set a lower limit next month?';

  @override
  String get nudgeTrySavingsPlan => 'Try a savings plan today';

  @override
  String get onb_cta_continue => 'Continue →';

  @override
  String get onb_cta_email => 'Use email instead';

  @override
  String get onb_cta_finish => 'Finish';

  @override
  String get onb_cta_google => 'Continue with Google';

  @override
  String get onb_cta_go_premium => 'Go Premium';

  @override
  String get onb_cta_later => 'Maybe later';

  @override
  String get onb_cta_start => 'Start →';

  @override
  String get onb_cta_try_free => 'Try free';

  @override
  String onb_progress(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get onb_opening_headline =>
      'Let’s set up a money plan that matches your life';

  @override
  String get onb_opening_subtext =>
      '8 quick steps. A clearer month. Takes under 2 minutes.';

  @override
  String get onb_monthly_title => 'Choose your monthly needs';

  @override
  String get onb_monthly_options_bills => '💡 Bills';

  @override
  String get onb_monthly_options_groceries => '🛒 Groceries';

  @override
  String get onb_monthly_options_rent => '🏠 Rent';

  @override
  String get onb_monthly_options_transport => '🚍 Transport';

  @override
  String get onb_monthly_options_tuition => '🎓 Tuition';

  @override
  String get onb_irregular_title => 'Irregular but important expenses?';

  @override
  String get onb_irregular_options_eid => '🌙 Eid & festivals';

  @override
  String get onb_irregular_options_gifts => '🎁 Gifts';

  @override
  String get onb_irregular_options_medical => '🏥 Medical';

  @override
  String get onb_irregular_options_school_fees => '📚 School fees';

  @override
  String get onb_irregular_options_wedding => '💍 Wedding events';

  @override
  String get onb_goals_title => 'What are your life goals?';

  @override
  String get onb_goals_options_home => '🏡 Own home';

  @override
  String get onb_goals_options_land => '🌱 Land';

  @override
  String get onb_goals_options_marriage => '💍 Marriage';

  @override
  String get onb_goals_options_study => '🌏 Study abroad';

  @override
  String get onb_goals_options_vehicle => '🚗 Vehicle';

  @override
  String get onb_lifestyle_title => 'Your lifestyle priorities?';

  @override
  String get onb_lifestyle_options_charity => '🤲 Charity';

  @override
  String get onb_lifestyle_options_family => '👨‍👩‍👧‍👦 Family';

  @override
  String get onb_lifestyle_options_fashion => '👗 Fashion';

  @override
  String get onb_lifestyle_options_food => '🍔 Food';

  @override
  String get onb_lifestyle_options_fun => '🎬 Fun';

  @override
  String get onb_plan_title => 'Your personalized starting plan';

  @override
  String get onb_plan_subtext =>
      'Based on your choices, we’ll suggest a basic budget structure you can edit anytime.';

  @override
  String get onb_plan_cta => 'Create my simple plan';

  @override
  String onb_plan_summary(Object needs, Object wants, Object goals) {
    return 'Starter split: $needs% Needs · $wants% Wants · $goals% Goals';
  }

  @override
  String get onb_save_title => 'Create an account to save progress';

  @override
  String get onb_save_subtext =>
      'Save your progress, sync across devices, and keep your plan backed up.';

  @override
  String get onb_save_privacy => 'Your data stays yours.';

  @override
  String get onb_premium_title => 'Free vs Premium—grow your money skills';

  @override
  String get onb_premium_subtext =>
      'Get advanced insights, unlimited categories, and exports. Build habits with streaks & badges.';

  @override
  String get onb_premium_benefits_export => 'CSV/PDF exports';

  @override
  String get onb_premium_benefits_insights => 'Deeper insights & alerts';

  @override
  String get onb_premium_benefits_streaks => 'Streaks & badges';

  @override
  String get onb_premium_benefits_unlimited_categories =>
      'Unlimited categories';

  @override
  String onb_premium_metric_users(Object count) {
    return '$count+ people building money habits';
  }

  @override
  String onb_premium_testimonial1(Object amount) {
    return '\"Saved $amount in 3 months.\"';
  }

  @override
  String get onb_welcome_title => 'Starting today, money is in your control.';

  @override
  String get onb_welcome_subtitle =>
      'Small expenses create big gaps—now they\'ll be easy to track.';

  @override
  String get onb_persona_title => 'Tell us about you.';

  @override
  String get onb_persona_helper =>
      'Language, income type, currency—make it yours.';

  @override
  String get onb_language_label => 'Language';

  @override
  String get onb_income_type_label => 'Income type';

  @override
  String get onb_currency_label => 'Currency';

  @override
  String get onb_income_student => 'Student';

  @override
  String get onb_income_freelancer => 'Freelancer';

  @override
  String get onb_income_family => 'Family';

  @override
  String get onb_save_continue => 'Save & continue';

  @override
  String get onb_demo_title => 'Add an expense in 5 seconds.';

  @override
  String get onb_demo_helper => 'One tap to add the demo—edit if you want.';

  @override
  String get onb_demo_amount => '৳50';

  @override
  String get onb_demo_category => 'Tea/Snacks';

  @override
  String get onb_demo_note => 'With friends';

  @override
  String get onb_demo_cta => 'Add now';

  @override
  String get onb_demo_success_toast => 'Added! You\'ve got this.';

  @override
  String get onb_trust_title => 'Your data stays on your device.';

  @override
  String get onb_trust_bullet_offline =>
      'Offline-first—works without internet.';

  @override
  String get onb_trust_bullet_privacy =>
      'We can\'t see your data unless you choose cloud backup.';

  @override
  String get onb_trust_bullet_lock => 'Lock PIN and biometric support.';

  @override
  String get onb_trust_primary => 'I understand';

  @override
  String get onb_trust_learn_more => 'Learn more';

  @override
  String get onb_continue => 'Continue';

  @override
  String get onb_features_secure => 'Secure';

  @override
  String get onb_features_simple => 'Simple';

  @override
  String get onb_features_smart => 'Smart';

  @override
  String get onb_feature_secure_desc => 'Your data is encrypted and secure';

  @override
  String get onb_feature_simple_desc => 'Easy to use interface';

  @override
  String get onb_feature_smart_desc => 'AI-powered insights';

  @override
  String get language_bengali => 'বাংলা';

  @override
  String get language_english => 'English';

  @override
  String get currency_bdt => '৳ BDT';

  @override
  String get currency_usd => '\$ USD';

  @override
  String get onb_habit_title => 'Today is Day 1—see you tomorrow?';

  @override
  String get onb_habit_helper =>
      '10 seconds a day—keep your streak, invest in your dreams.';

  @override
  String get onb_habit_cta => 'Start now';

  @override
  String get onb_habit_toggle_reminder => 'Daily reminder';

  @override
  String get onb_habit_day_label => 'DAY';

  @override
  String get onb_welcome_chip_offline => 'Offline';

  @override
  String get onb_welcome_chip_fast => '5-second add';

  @override
  String get onb_welcome_chip_secure => 'Secure';

  @override
  String get onb_welcome_chip_offline_info =>
      'Works without internet connection';

  @override
  String get onb_welcome_chip_fast_info => 'Add expenses in just 5 seconds';

  @override
  String get onb_welcome_chip_secure_info =>
      'Your data stays private and secure';

  @override
  String get errorCache => 'Cache error occurred';

  @override
  String get errorDatabase => 'Database error occurred';

  @override
  String get onb_welcome_chip_secure_desc =>
      'Your data is encrypted and stored locally. No cloud sync, maximum privacy.';

  @override
  String get onb_welcome_chip_simple_desc =>
      'Clean, intuitive interface designed for easy expense tracking.';

  @override
  String get onb_welcome_chip_smart_desc =>
      'AI-powered insights and smart categorization for better financial management.';

  @override
  String onb_demo_error_failed(Object error) {
    return 'Failed to add demo transaction: $error';
  }

  @override
  String get onb_demo_adding => 'Adding...';

  @override
  String get empty_transactions_title => 'No Transactions';

  @override
  String get empty_transactions_subtitle =>
      'Start by adding your first transaction';

  @override
  String get empty_categories_title => 'No Categories';

  @override
  String get empty_categories_subtitle =>
      'Create categories to organize your transactions';

  @override
  String get empty_wallets_title => 'No Wallets';

  @override
  String get empty_wallets_subtitle =>
      'Add a wallet to start tracking your finances';

  @override
  String get btn_confirm => 'Confirm';

  @override
  String get btn_cancel => 'Cancel';

  @override
  String onb_habit_error_failed(Object error) {
    return 'Failed to complete onboarding: $error';
  }

  @override
  String get onb_trust_icon_label => 'Security and privacy icon';

  @override
  String get currency_usd_code => 'USD';

  @override
  String get currency_usd_name => 'US Dollar';

  @override
  String get currency_eur_code => 'EUR';

  @override
  String get currency_eur_name => 'Euro';

  @override
  String get currency_bdt_code => 'BDT';

  @override
  String get currency_bdt_name => 'Bangladeshi Taka';

  @override
  String get language_english_name => 'English';

  @override
  String get language_bengali_name => 'বাংলা';

  @override
  String get language_bengali_english_name => 'Bengali';

  @override
  String get settings_theme_title => 'Theme';

  @override
  String get theme_light_name => 'Light';

  @override
  String get theme_light_desc => 'Light Theme';

  @override
  String get theme_dark_name => 'Dark';

  @override
  String get theme_dark_desc => 'Dark Theme';

  @override
  String get theme_system_name => 'System';

  @override
  String get theme_system_desc => 'System Default';

  @override
  String get cat_salary_name => 'Salary';

  @override
  String get cat_business_name => 'Business';

  @override
  String get cat_investment_name => 'Investment';

  @override
  String get cat_food_dining_name => 'Food & Dining';

  @override
  String get cat_transport_name => 'Transport';

  @override
  String get cat_rent_name => 'Rent';

  @override
  String get cat_shopping_name => 'Shopping';

  @override
  String get cat_bank_transfer_name => 'Bank Transfer';

  @override
  String get cat_mobile_wallet_name => 'Mobile Wallet';
}
