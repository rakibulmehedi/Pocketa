// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get english => 'ইংরেজি';

  @override
  String get bengali => 'বাংলা';

  @override
  String get appTitle => 'Pocketa';

  @override
  String get tagline => 'টাকা আপনার নিয়ন্ত্রণে, ভবিষ্যৎ আপনার হাতে।';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get close => 'বন্ধ';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get back => 'পেছনে';

  @override
  String get next => 'পরবর্তী';

  @override
  String get skip => 'স্কিপ';

  @override
  String get finish => 'শেষ';

  @override
  String get continuee => 'চালিয়ে যান';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get search => 'খুঁজুন';

  @override
  String get apply => 'প্রয়োগ করুন';

  @override
  String get clear => 'মুছে ফেলুন';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get welcomeTitle => 'Pocketa-তে স্বাগতম';

  @override
  String get welcomeSubtitle => 'প্রতিটি খরচে থাকুক স্পষ্টতা।';

  @override
  String get getStarted => 'শুরু করি';

  @override
  String get introTrackTitle => 'খরচ ট্র্যাক';

  @override
  String get introTrackSubtitle => 'টাকা কোথায় যাচ্ছে, দেখুন সঙ্গে সঙ্গে।';

  @override
  String get introBudgetTitle => 'বাজেটে থাকুন';

  @override
  String get introBudgetSubtitle => 'লিমিট ঠিক করুন, নিয়ন্ত্রণে থাকুন।';

  @override
  String get introControlTitle => 'আপনার নিয়ন্ত্রণ';

  @override
  String get introControlSubtitle => 'টাকা আপনার নিয়মে চলুক।';

  @override
  String get login => 'লগ ইন';

  @override
  String get signup => 'অ্যাকাউন্ট খুলুন';

  @override
  String get logout => 'লগ আউট';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get name => 'নাম';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get resetPassword => 'পাসওয়ার্ড রিসেট';

  @override
  String get orContinueWith => 'অথবা চালিয়ে যান';

  @override
  String homeGreeting(Object name) {
    return 'হাই, $name!';
  }

  @override
  String get dashboard => 'ড্যাশবোর্ড';

  @override
  String get totalBalance => 'মোট ব্যালেন্স';

  @override
  String get income => 'আয়';

  @override
  String get expense => 'খরচ';

  @override
  String get net => 'নেট';

  @override
  String get monthlySummary => 'এই মাস';

  @override
  String get recentTransactions => 'সাম্প্রতিক লেনদেন';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get transactions => 'লেনদেন';

  @override
  String get addTransaction => 'লেনদেন যোগ করুন';

  @override
  String get editTransaction => 'লেনদেন সম্পাদনা';

  @override
  String get deleteTransaction => 'লেনদেন মুছুন';

  @override
  String get transactionAdded => 'লেনদেন যোগ হয়েছে ✔';

  @override
  String get transactionUpdated => 'লেনদেন আপডেট হয়েছে';

  @override
  String get transactionDeleted => 'লেনদেন মুছে গেছে';

  @override
  String get amount => 'পরিমাণ';

  @override
  String get category => 'ক্যাটাগরি';

  @override
  String get note => 'নোট';

  @override
  String get date => 'তারিখ';

  @override
  String get type => 'ধরন';

  @override
  String get incomeType => 'আয়';

  @override
  String get expenseType => 'খরচ';

  @override
  String get transfer => 'ট্রান্সফার';

  @override
  String get noTransactions => 'কোনো লেনদেন নেই। শুরু করুন এখনই!';

  @override
  String get budgets => 'বাজেট';

  @override
  String get setBudget => 'বাজেট সেট করুন';

  @override
  String get budgetLimit => 'বাজেট সীমা';

  @override
  String get remaining => 'বাকি';

  @override
  String get spent => 'খরচ';

  @override
  String get budgetExceeded => 'বাজেট সীমা পেরিয়েছে 🚨';

  @override
  String budgetLeft(Object amount) {
    return 'বাকি $amount';
  }

  @override
  String get noBudgets => 'এখনও কোনো বাজেট নেই';

  @override
  String get createFirstBudget => 'প্রথম বাজেট তৈরি করুন';

  @override
  String get wallets => 'ওয়ালেট';

  @override
  String get addWallet => 'ওয়ালেট যোগ করুন';

  @override
  String get editWallet => 'ওয়ালেট সম্পাদনা';

  @override
  String get deleteWallet => 'ওয়ালেট মুছুন';

  @override
  String get walletName => 'ওয়ালেটের নাম';

  @override
  String get walletType => 'ওয়ালেটের ধরন';

  @override
  String get initialBalance => 'শুরুর ব্যালেন্স';

  @override
  String get cash => 'ক্যাশ';

  @override
  String get bank => 'ব্যাংক';

  @override
  String get mobileMoney => 'মোবাইল মানি';

  @override
  String get chooseWallet => 'ওয়ালেট বেছে নিন';

  @override
  String get noWallets => 'এখনও কোনো ওয়ালেট নেই';

  @override
  String get food => 'খাবার';

  @override
  String get transport => 'যাতায়াত';

  @override
  String get shopping => 'শপিং';

  @override
  String get entertainment => 'বিনোদন';

  @override
  String get utilities => 'ইউটিলিটি';

  @override
  String get bills => 'বিল';

  @override
  String get health => 'স্বাস্থ্য';

  @override
  String get education => 'শিক্ষা';

  @override
  String get rent => 'ভাড়া';

  @override
  String get salary => 'বেতন';

  @override
  String get investment => 'বিনিয়োগ';

  @override
  String get gift => 'উপহার';

  @override
  String get others => 'অন্যান্য';

  @override
  String get insights => 'বিশ্লেষণ';

  @override
  String get weeklySpending => 'এই সপ্তাহ';

  @override
  String get monthlyReport => 'মাসিক রিপোর্ট';

  @override
  String get topCategories => 'শীর্ষ ক্যাটাগরি';

  @override
  String get spendingTrend => 'খরচের ধারা';

  @override
  String get exportReport => 'রিপোর্ট এক্সপোর্ট';

  @override
  String get filters => 'ফিল্টার';

  @override
  String get all => 'সব';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get thisWeek => 'এই সপ্তাহ';

  @override
  String get thisMonth => 'এই মাস';

  @override
  String get lastMonth => 'গত মাস';

  @override
  String get customRange => 'কাস্টম রেঞ্জ';

  @override
  String get fromDate => 'শুরুর তারিখ';

  @override
  String get toDate => 'শেষ তারিখ';

  @override
  String get settings => 'সেটিংস';

  @override
  String get appearance => 'চেহারা';

  @override
  String get theme => 'থিম';

  @override
  String get systemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get darkMode => 'ডার্ক';

  @override
  String get lightMode => 'লাইট';

  @override
  String get language => 'ভাষা';

  @override
  String get language_en => 'ইংরেজি';

  @override
  String get language_bn => 'বাংলা';

  @override
  String get switchLanguage => 'ভাষা বদলান';

  @override
  String get currency => 'মুদ্রা';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get biometrics => 'বায়োমেট্রিক্স';

  @override
  String get pinCode => 'পিন কোড';

  @override
  String get autoBackup => 'স্বয়ংক্রিয় ব্যাকআপ';

  @override
  String get sync => 'সিঙ্ক';

  @override
  String get about => 'সম্পর্কে';

  @override
  String version(Object version) {
    return 'ভার্সন $version';
  }

  @override
  String get export => 'এক্সপোর্ট';

  @override
  String get exportCSV => 'CSV এক্সপোর্ট';

  @override
  String get exportPDF => 'PDF এক্সপোর্ট';

  @override
  String get exportSuccess => 'এক্সপোর্ট প্রস্তুত ✅';

  @override
  String get exportFailed => 'এক্সপোর্ট ব্যর্থ';

  @override
  String get share => 'শেয়ার';

  @override
  String get download => 'ডাউনলোড';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String notifBudgetExceeded(Object category) {
    return '$category-এ বাজেট অতিক্রম করেছে';
  }

  @override
  String notifBudgetRemaining(Object category, Object amount) {
    return '$category-এ বাকি $amount';
  }

  @override
  String notifLowBalance(Object wallet) {
    return '$wallet-এ ব্যালেন্স কম';
  }

  @override
  String get notifBackupSuccess => 'ব্যাকআপ সংরক্ষিত';

  @override
  String get notifBackupFailed => 'ব্যাকআপ ব্যর্থ';

  @override
  String get notifDailySummaryReady => 'আজকের সারাংশ প্রস্তুত';

  @override
  String get notifWeeklySummaryReady => 'সাপ্তাহিক সারাংশ প্রস্তুত';

  @override
  String get errorsTitle => 'কিছু সমস্যা হয়েছে';

  @override
  String get errorGeneric => 'আবার চেষ্টা করুন।';

  @override
  String get errorNetwork => 'ইন্টারনেট সংযোগ নেই।';

  @override
  String get errorTimeout => 'সময়ের সীমা শেষ।';

  @override
  String get errorUnauthorized => 'দয়া করে লগ ইন করুন।';

  @override
  String get errorForbidden => 'এই কাজটি অনুমোদিত নয়।';

  @override
  String get errorNotFound => 'পাওয়া যায়নি।';

  @override
  String get errorValidation => 'ঘরগুলো যাচাই করুন।';

  @override
  String errorRequired(Object field) {
    return '$field প্রয়োজন';
  }

  @override
  String errorMinLength(Object field, Object min) {
    return '$field অন্তত $min অক্ষর হতে হবে';
  }

  @override
  String errorMaxLength(Object field, Object max) {
    return '$field সর্বোচ্চ $max অক্ষর হতে হবে';
  }

  @override
  String errorMinValue(Object field, Object min) {
    return '$field অন্তত $min হতে হবে';
  }

  @override
  String errorMaxValue(Object field, Object max) {
    return '$field সর্বোচ্চ $max হতে হবে';
  }

  @override
  String get errorAmountPositive => 'পরিমাণ শূন্যের বেশি হতে হবে';

  @override
  String get errorSelectWallet => 'একটি ওয়ালেট বেছে নিন';

  @override
  String get errorSelectCategory => 'একটি ক্যাটাগরি বেছে নিন';

  @override
  String get emptyTitle => 'এখনও কিছু নেই';

  @override
  String get emptyTransactions => 'প্রথম লেনদেন যোগ করুন।';

  @override
  String get emptyBudgets => 'শুরু করতে বাজেট তৈরি করুন।';

  @override
  String get emptyWallets => 'প্রথমে একটি ওয়ালেট যোগ করুন।';

  @override
  String get emptySearch => 'কোনো ফল পাওয়া যায়নি';

  @override
  String get accessibilityLanguageSwitch => 'ভাষা পরিবর্তন বোতাম';

  @override
  String get accessibilityAddTransaction => 'নতুন লেনদেন যোগের বোতাম';

  @override
  String get accessibilityBack => 'পেছনে যাওয়ার বোতাম';

  @override
  String get permissionStorageTitle => 'স্টোরেজ অনুমতি';

  @override
  String get permissionStorageDesc =>
      'এক্সপোর্ট ও ব্যাকআপ সংরক্ষণ করতে অনুমতি দিন।';

  @override
  String get permissionDenied => 'অনুমতি অস্বীকৃত';

  @override
  String get permissionOpenSettings => 'সেটিংস খুলুন';

  @override
  String get updateAvailable => 'আপডেট এসেছে';

  @override
  String get updateNow => 'এখনই আপডেট করুন';

  @override
  String get later => 'পরে';

  @override
  String get recurringTransactions => 'পুনরাবৃত্ত লেনদেন';

  @override
  String get addRecurring => 'পুনরাবৃত্ত যোগ করুন';

  @override
  String get editRecurring => 'পুনরাবৃত্ত সম্পাদনা';

  @override
  String get deleteRecurring => 'পুনরাবৃত্ত মুছুন';

  @override
  String nextOccurrence(Object date) {
    return 'পরবর্তী $date';
  }

  @override
  String get goals => 'লক্ষ্য';

  @override
  String get createGoal => 'নতুন লক্ষ্য';

  @override
  String get editGoal => 'লক্ষ্য সম্পাদনা';

  @override
  String get deleteGoal => 'লক্ষ্য মুছুন';

  @override
  String get goalName => 'লক্ষ্যের নাম';

  @override
  String get goalTargetAmount => 'টার্গেট পরিমাণ';

  @override
  String get goalSavedAmount => 'সংরক্ষিত পরিমাণ';

  @override
  String get goalDeadline => 'সময়সীমা';

  @override
  String get goalProgress => 'অগ্রগতি';

  @override
  String get goalCompleted => 'লক্ষ্য পূর্ণ হয়েছে 🎉';

  @override
  String get noGoals => 'এখনও কোনো লক্ষ্য নেই';

  @override
  String countTransactions(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লেনদেন',
      one: '১টি লেনদেন',
      zero: 'কোনো লেনদেন নেই',
    );
    return '$_temp0';
  }

  @override
  String countBudgets(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বাজেট',
      one: '১টি বাজেট',
      zero: 'কোনো বাজেট নেই',
    );
    return '$_temp0';
  }

  @override
  String countWallets(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ওয়ালেট',
      one: '১টি ওয়ালেট',
      zero: 'কোনো ওয়ালেট নেই',
    );
    return '$_temp0';
  }

  @override
  String daysStreak(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# দিন',
      one: '# দিন',
    );
    return 'বাজেট মেনে চলা $_temp0 🎉';
  }

  @override
  String nudgeReviewSpend(Object category) {
    return '$category খরচ একবার দেখে নিন';
  }

  @override
  String get nudgeLowerLimitNextMonth => 'পরের মাসে লিমিট একটু কমাবেন?';

  @override
  String get nudgeTrySavingsPlan => 'আজই একটি সেভিংস প্ল্যান চেষ্টা করুন';
}
