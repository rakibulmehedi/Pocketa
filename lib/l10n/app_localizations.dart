import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bengali;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pocketa'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Own your money. Own your future.'**
  String get tagline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Deprecated; use onb.cta.continue for onboarding flows
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pocketa'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clarity with every taka you spend.'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Let’s begin'**
  String get getStarted;

  /// No description provided for @introTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track expenses'**
  String get introTrackTitle;

  /// No description provided for @introTrackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See where your money goes, instantly.'**
  String get introTrackSubtitle;

  /// No description provided for @introBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on budget'**
  String get introBudgetTitle;

  /// No description provided for @introBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a limit, stay in control.'**
  String get introBudgetSubtitle;

  /// No description provided for @introControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Be in control'**
  String get introControlTitle;

  /// No description provided for @introControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your money. Your rules.'**
  String get introControlSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signup;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// Greets the user by name on the home screen
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String homeGreeting(Object name);

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expense;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get monthlySummary;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentTransactions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @makeDefault.
  ///
  /// In en, this message translates to:
  /// **'Make default'**
  String get makeDefault;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @notesAndTags.
  ///
  /// In en, this message translates to:
  /// **'Notes & Tags'**
  String get notesAndTags;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @setNow.
  ///
  /// In en, this message translates to:
  /// **'Set now'**
  String get setNow;

  /// No description provided for @anotherWallet.
  ///
  /// In en, this message translates to:
  /// **'Another wallet'**
  String get anotherWallet;

  /// Semantic label for the welcome screen illustration used by screen readers.
  ///
  /// In en, this message translates to:
  /// **'Welcome illustration'**
  String get accessibility_welcome_illustration;

  /// No description provided for @someoneAccount.
  ///
  /// In en, this message translates to:
  /// **'Someone / Account'**
  String get someoneAccount;

  /// No description provided for @recipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient (name / phone / account)'**
  String get recipientLabel;

  /// No description provided for @recipientHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mehedi, 01XXXXXXXXX, A/C 12345'**
  String get recipientHint;

  /// No description provided for @targetWallet.
  ///
  /// In en, this message translates to:
  /// **'Target wallet'**
  String get targetWallet;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @detailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Date, wallet, etc.'**
  String get detailsSubtitle;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @transferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer To'**
  String get transferTo;

  /// No description provided for @transferChoiceHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose one: another wallet (internal) or a recipient (external).'**
  String get transferChoiceHelp;

  /// No description provided for @clearAllTags.
  ///
  /// In en, this message translates to:
  /// **'Clear all tags'**
  String get clearAllTags;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// No description provided for @walletNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cash, bKash, Nagad'**
  String get walletNameHint;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get netBalance;

  /// No description provided for @surplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus'**
  String get surplus;

  /// No description provided for @deficit.
  ///
  /// In en, this message translates to:
  /// **'Deficit'**
  String get deficit;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction'**
  String get deleteTransaction;

  /// No description provided for @transactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added ✔'**
  String get transactionAdded;

  /// No description provided for @transactionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated'**
  String get transactionUpdated;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction removed'**
  String get transactionDeleted;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeType;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseType;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No records yet. Start now!'**
  String get noTransactions;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set a budget'**
  String get setBudget;

  /// No description provided for @budgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Budget limit'**
  String get budgetLimit;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @budgetExceeded.
  ///
  /// In en, this message translates to:
  /// **'Limit crossed 🚨'**
  String get budgetExceeded;

  /// Shows remaining budget amount
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetLeft(Object amount);

  /// No description provided for @noBudgets.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get noBudgets;

  /// No description provided for @createFirstBudget.
  ///
  /// In en, this message translates to:
  /// **'Create your first budget'**
  String get createFirstBudget;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add wallet'**
  String get addWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit wallet'**
  String get editWallet;

  /// No description provided for @deleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete wallet'**
  String get deleteWallet;

  /// No description provided for @walletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get walletName;

  /// No description provided for @walletType.
  ///
  /// In en, this message translates to:
  /// **'Wallet type'**
  String get walletType;

  /// No description provided for @initialBalance.
  ///
  /// In en, this message translates to:
  /// **'Starting balance'**
  String get initialBalance;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @mobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile money'**
  String get mobileMoney;

  /// Wallet provider name: bKash
  ///
  /// In en, this message translates to:
  /// **'bKash'**
  String get wallet_bkash;

  /// Wallet provider name: Nagad
  ///
  /// In en, this message translates to:
  /// **'Nagad'**
  String get wallet_nagad;

  /// Wallet provider name: Upay
  ///
  /// In en, this message translates to:
  /// **'Upay'**
  String get wallet_upay;

  /// Wallet provider name: Rocket
  ///
  /// In en, this message translates to:
  /// **'Rocket'**
  String get wallet_rocket;

  /// Preset label for bank account wallet
  ///
  /// In en, this message translates to:
  /// **'Bank A/C'**
  String get wallet_preset_bank_ac;

  /// No description provided for @chooseWallet.
  ///
  /// In en, this message translates to:
  /// **'Choose wallet'**
  String get chooseWallet;

  /// No description provided for @noWallets.
  ///
  /// In en, this message translates to:
  /// **'No wallets yet'**
  String get noWallets;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @gift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get gift;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @weeklySpending.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weeklySpending;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly report'**
  String get monthlyReport;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top categories'**
  String get topCategories;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending trend'**
  String get spendingTrend;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export report'**
  String get exportReport;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get lastMonth;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get customRange;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toDate;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_bn.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get language_bn;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get switchLanguage;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// No description provided for @pinCode.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get pinCode;

  /// No description provided for @autoBackup.
  ///
  /// In en, this message translates to:
  /// **'Auto backup'**
  String get autoBackup;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version label with version value
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(Object version);

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @exportPDF.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPDF;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export ready ✅'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification when a category budget is exceeded
  ///
  /// In en, this message translates to:
  /// **'Overspent on {category}'**
  String notifBudgetExceeded(Object category);

  /// Notification showing remaining budget in a category
  ///
  /// In en, this message translates to:
  /// **'{amount} left for {category}'**
  String notifBudgetRemaining(Object category, Object amount);

  /// Notification when a wallet balance is low
  ///
  /// In en, this message translates to:
  /// **'Low balance in {wallet}'**
  String notifLowBalance(Object wallet);

  /// No description provided for @notifBackupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get notifBackupSuccess;

  /// No description provided for @notifBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get notifBackupFailed;

  /// No description provided for @notifDailySummaryReady.
  ///
  /// In en, this message translates to:
  /// **'Your daily summary is here'**
  String get notifDailySummaryReady;

  /// No description provided for @notifWeeklySummaryReady.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary is ready'**
  String get notifWeeklySummaryReady;

  /// No description provided for @errorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorsTitle;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Please log in.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Not allowed.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get errorNotFound;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get errorValidation;

  /// Shown when a required field is empty
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String errorRequired(Object field);

  /// Minimum length validation error
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {min} characters'**
  String errorMinLength(Object field, Object min);

  /// Maximum length validation error
  ///
  /// In en, this message translates to:
  /// **'{field} must be at most {max} characters'**
  String errorMaxLength(Object field, Object max);

  /// Minimum numeric value validation error
  ///
  /// In en, this message translates to:
  /// **'{field} must be at least {min}'**
  String errorMinValue(Object field, Object min);

  /// Maximum numeric value validation error
  ///
  /// In en, this message translates to:
  /// **'{field} must be at most {max}'**
  String errorMaxValue(Object field, Object max);

  /// No description provided for @errorAmountPositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be positive'**
  String get errorAmountPositive;

  /// No description provided for @errorSelectWallet.
  ///
  /// In en, this message translates to:
  /// **'Pick a wallet'**
  String get errorSelectWallet;

  /// No description provided for @errorSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Pick a category'**
  String get errorSelectCategory;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyTransactions.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction.'**
  String get emptyTransactions;

  /// No description provided for @emptyBudgets.
  ///
  /// In en, this message translates to:
  /// **'Create a budget to get started.'**
  String get emptyBudgets;

  /// No description provided for @emptyWallets.
  ///
  /// In en, this message translates to:
  /// **'Add a wallet to begin.'**
  String get emptyWallets;

  /// No description provided for @emptySearch.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get emptySearch;

  /// No description provided for @accessibilityLanguageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch app language'**
  String get accessibilityLanguageSwitch;

  /// No description provided for @accessibilityAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add a new transaction'**
  String get accessibilityAddTransaction;

  /// No description provided for @accessibilityBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get accessibilityBack;

  /// No description provided for @permissionStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage permission'**
  String get permissionStorageTitle;

  /// No description provided for @permissionStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow access to save exports and backups.'**
  String get permissionStorageDesc;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @permissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permissionOpenSettings;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @recurringTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recurring transactions'**
  String get recurringTransactions;

  /// No description provided for @addRecurring.
  ///
  /// In en, this message translates to:
  /// **'Add recurring'**
  String get addRecurring;

  /// No description provided for @editRecurring.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring'**
  String get editRecurring;

  /// No description provided for @deleteRecurring.
  ///
  /// In en, this message translates to:
  /// **'Delete recurring'**
  String get deleteRecurring;

  /// Shows the next date of a recurring item
  ///
  /// In en, this message translates to:
  /// **'Next on {date}'**
  String nextOccurrence(Object date);

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @createGoal.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get createGoal;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get editGoal;

  /// No description provided for @deleteGoal.
  ///
  /// In en, this message translates to:
  /// **'Delete goal'**
  String get deleteGoal;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalName;

  /// No description provided for @goalTargetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get goalTargetAmount;

  /// No description provided for @goalSavedAmount.
  ///
  /// In en, this message translates to:
  /// **'Saved amount'**
  String get goalSavedAmount;

  /// No description provided for @goalDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get goalDeadline;

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get goalProgress;

  /// No description provided for @goalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Goal done 🎉'**
  String get goalCompleted;

  /// No description provided for @noGoals.
  ///
  /// In en, this message translates to:
  /// **'No goals yet'**
  String get noGoals;

  /// Pluralized count of transactions
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No transactions} one {1 transaction} other {{count} transactions}}'**
  String countTransactions(num count);

  /// Pluralized count of budgets
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No budgets} one {1 budget} other {{count} budgets}}'**
  String countBudgets(num count);

  /// Pluralized count of wallets
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No wallets} one {1 wallet} other {{count} wallets}}'**
  String countWallets(num count);

  /// Shows user's consecutive days staying within budget
  ///
  /// In en, this message translates to:
  /// **'On budget for {days, plural, one {# day} other {# days}} 🎉'**
  String daysStreak(num days);

  /// Nudge to review a category
  ///
  /// In en, this message translates to:
  /// **'Check your {category} spending'**
  String nudgeReviewSpend(Object category);

  /// No description provided for @nudgeLowerLimitNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Set a lower limit next month?'**
  String get nudgeLowerLimitNextMonth;

  /// No description provided for @nudgeTrySavingsPlan.
  ///
  /// In en, this message translates to:
  /// **'Try a savings plan today'**
  String get nudgeTrySavingsPlan;

  /// No description provided for @onb_cta_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get onb_cta_continue;

  /// No description provided for @onb_cta_email.
  ///
  /// In en, this message translates to:
  /// **'Use email instead'**
  String get onb_cta_email;

  /// No description provided for @onb_cta_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onb_cta_finish;

  /// No description provided for @onb_cta_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get onb_cta_google;

  /// No description provided for @onb_cta_go_premium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get onb_cta_go_premium;

  /// No description provided for @onb_cta_later.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get onb_cta_later;

  /// No description provided for @onb_cta_start.
  ///
  /// In en, this message translates to:
  /// **'Start →'**
  String get onb_cta_start;

  /// No description provided for @onb_cta_try_free.
  ///
  /// In en, this message translates to:
  /// **'Try free'**
  String get onb_cta_try_free;

  /// Progress label for onboarding steps
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onb_progress(Object current, Object total);

  /// No description provided for @onb_opening_headline.
  ///
  /// In en, this message translates to:
  /// **'Let’s set up a money plan that matches your life'**
  String get onb_opening_headline;

  /// No description provided for @onb_opening_subtext.
  ///
  /// In en, this message translates to:
  /// **'8 quick steps. A clearer month. Takes under 2 minutes.'**
  String get onb_opening_subtext;

  /// No description provided for @onb_monthly_title.
  ///
  /// In en, this message translates to:
  /// **'Choose your monthly needs'**
  String get onb_monthly_title;

  /// No description provided for @onb_monthly_options_bills.
  ///
  /// In en, this message translates to:
  /// **'💡 Bills'**
  String get onb_monthly_options_bills;

  /// No description provided for @onb_monthly_options_groceries.
  ///
  /// In en, this message translates to:
  /// **'🛒 Groceries'**
  String get onb_monthly_options_groceries;

  /// No description provided for @onb_monthly_options_rent.
  ///
  /// In en, this message translates to:
  /// **'🏠 Rent'**
  String get onb_monthly_options_rent;

  /// No description provided for @onb_monthly_options_transport.
  ///
  /// In en, this message translates to:
  /// **'🚍 Transport'**
  String get onb_monthly_options_transport;

  /// No description provided for @onb_monthly_options_tuition.
  ///
  /// In en, this message translates to:
  /// **'🎓 Tuition'**
  String get onb_monthly_options_tuition;

  /// No description provided for @onb_irregular_title.
  ///
  /// In en, this message translates to:
  /// **'Irregular but important expenses?'**
  String get onb_irregular_title;

  /// No description provided for @onb_irregular_options_eid.
  ///
  /// In en, this message translates to:
  /// **'🌙 Eid & festivals'**
  String get onb_irregular_options_eid;

  /// No description provided for @onb_irregular_options_gifts.
  ///
  /// In en, this message translates to:
  /// **'🎁 Gifts'**
  String get onb_irregular_options_gifts;

  /// No description provided for @onb_irregular_options_medical.
  ///
  /// In en, this message translates to:
  /// **'🏥 Medical'**
  String get onb_irregular_options_medical;

  /// No description provided for @onb_irregular_options_school_fees.
  ///
  /// In en, this message translates to:
  /// **'📚 School fees'**
  String get onb_irregular_options_school_fees;

  /// No description provided for @onb_irregular_options_wedding.
  ///
  /// In en, this message translates to:
  /// **'💍 Wedding events'**
  String get onb_irregular_options_wedding;

  /// No description provided for @onb_goals_title.
  ///
  /// In en, this message translates to:
  /// **'What are your life goals?'**
  String get onb_goals_title;

  /// No description provided for @onb_goals_options_home.
  ///
  /// In en, this message translates to:
  /// **'🏡 Own home'**
  String get onb_goals_options_home;

  /// No description provided for @onb_goals_options_land.
  ///
  /// In en, this message translates to:
  /// **'🌱 Land'**
  String get onb_goals_options_land;

  /// No description provided for @onb_goals_options_marriage.
  ///
  /// In en, this message translates to:
  /// **'💍 Marriage'**
  String get onb_goals_options_marriage;

  /// No description provided for @onb_goals_options_study.
  ///
  /// In en, this message translates to:
  /// **'🌏 Study abroad'**
  String get onb_goals_options_study;

  /// No description provided for @onb_goals_options_vehicle.
  ///
  /// In en, this message translates to:
  /// **'🚗 Vehicle'**
  String get onb_goals_options_vehicle;

  /// No description provided for @onb_lifestyle_title.
  ///
  /// In en, this message translates to:
  /// **'Your lifestyle priorities?'**
  String get onb_lifestyle_title;

  /// No description provided for @onb_lifestyle_options_charity.
  ///
  /// In en, this message translates to:
  /// **'🤲 Charity'**
  String get onb_lifestyle_options_charity;

  /// No description provided for @onb_lifestyle_options_family.
  ///
  /// In en, this message translates to:
  /// **'👨‍👩‍👧‍👦 Family'**
  String get onb_lifestyle_options_family;

  /// No description provided for @onb_lifestyle_options_fashion.
  ///
  /// In en, this message translates to:
  /// **'👗 Fashion'**
  String get onb_lifestyle_options_fashion;

  /// No description provided for @onb_lifestyle_options_food.
  ///
  /// In en, this message translates to:
  /// **'🍔 Food'**
  String get onb_lifestyle_options_food;

  /// No description provided for @onb_lifestyle_options_fun.
  ///
  /// In en, this message translates to:
  /// **'🎬 Fun'**
  String get onb_lifestyle_options_fun;

  /// No description provided for @onb_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Your personalized starting plan'**
  String get onb_plan_title;

  /// No description provided for @onb_plan_subtext.
  ///
  /// In en, this message translates to:
  /// **'Based on your choices, we’ll suggest a basic budget structure you can edit anytime.'**
  String get onb_plan_subtext;

  /// No description provided for @onb_plan_cta.
  ///
  /// In en, this message translates to:
  /// **'Create my simple plan'**
  String get onb_plan_cta;

  /// Summary line showing recommended needs/wants/goals split
  ///
  /// In en, this message translates to:
  /// **'Starter split: {needs}% Needs · {wants}% Wants · {goals}% Goals'**
  String onb_plan_summary(Object needs, Object wants, Object goals);

  /// No description provided for @onb_save_title.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save progress'**
  String get onb_save_title;

  /// No description provided for @onb_save_subtext.
  ///
  /// In en, this message translates to:
  /// **'Save your progress, sync across devices, and keep your plan backed up.'**
  String get onb_save_subtext;

  /// No description provided for @onb_save_privacy.
  ///
  /// In en, this message translates to:
  /// **'Your data stays yours.'**
  String get onb_save_privacy;

  /// No description provided for @onb_premium_title.
  ///
  /// In en, this message translates to:
  /// **'Free vs Premium—grow your money skills'**
  String get onb_premium_title;

  /// No description provided for @onb_premium_subtext.
  ///
  /// In en, this message translates to:
  /// **'Get advanced insights, unlimited categories, and exports. Build habits with streaks & badges.'**
  String get onb_premium_subtext;

  /// No description provided for @onb_premium_benefits_export.
  ///
  /// In en, this message translates to:
  /// **'CSV/PDF exports'**
  String get onb_premium_benefits_export;

  /// No description provided for @onb_premium_benefits_insights.
  ///
  /// In en, this message translates to:
  /// **'Deeper insights & alerts'**
  String get onb_premium_benefits_insights;

  /// No description provided for @onb_premium_benefits_streaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks & badges'**
  String get onb_premium_benefits_streaks;

  /// No description provided for @onb_premium_benefits_unlimited_categories.
  ///
  /// In en, this message translates to:
  /// **'Unlimited categories'**
  String get onb_premium_benefits_unlimited_categories;

  /// Metric showing social proof count
  ///
  /// In en, this message translates to:
  /// **'{count}+ people building money habits'**
  String onb_premium_metric_users(Object count);

  /// Short premium testimonial with saved amount
  ///
  /// In en, this message translates to:
  /// **'\"Saved {amount} in 3 months.\"'**
  String onb_premium_testimonial1(Object amount);

  /// No description provided for @onb_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Starting today, money is in your control.'**
  String get onb_welcome_title;

  /// No description provided for @onb_welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Small expenses create big gaps—now they\'ll be easy to track.'**
  String get onb_welcome_subtitle;

  /// No description provided for @onb_persona_title.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you.'**
  String get onb_persona_title;

  /// No description provided for @onb_persona_helper.
  ///
  /// In en, this message translates to:
  /// **'Language, income type, currency—make it yours.'**
  String get onb_persona_helper;

  /// No description provided for @onb_language_label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get onb_language_label;

  /// No description provided for @onb_income_type_label.
  ///
  /// In en, this message translates to:
  /// **'Income type'**
  String get onb_income_type_label;

  /// No description provided for @onb_currency_label.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get onb_currency_label;

  /// No description provided for @onb_income_student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get onb_income_student;

  /// No description provided for @onb_income_freelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get onb_income_freelancer;

  /// No description provided for @onb_income_family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get onb_income_family;

  /// No description provided for @onb_save_continue.
  ///
  /// In en, this message translates to:
  /// **'Save & continue'**
  String get onb_save_continue;

  /// No description provided for @onb_demo_title.
  ///
  /// In en, this message translates to:
  /// **'Add an expense in 5 seconds.'**
  String get onb_demo_title;

  /// No description provided for @onb_demo_helper.
  ///
  /// In en, this message translates to:
  /// **'One tap to add the demo—edit if you want.'**
  String get onb_demo_helper;

  /// No description provided for @onb_demo_amount.
  ///
  /// In en, this message translates to:
  /// **'৳50'**
  String get onb_demo_amount;

  /// No description provided for @onb_demo_category.
  ///
  /// In en, this message translates to:
  /// **'Tea/Snacks'**
  String get onb_demo_category;

  /// No description provided for @onb_demo_note.
  ///
  /// In en, this message translates to:
  /// **'With friends'**
  String get onb_demo_note;

  /// No description provided for @onb_demo_cta.
  ///
  /// In en, this message translates to:
  /// **'Add now'**
  String get onb_demo_cta;

  /// No description provided for @onb_demo_success_toast.
  ///
  /// In en, this message translates to:
  /// **'Added! You\'ve got this.'**
  String get onb_demo_success_toast;

  /// No description provided for @onb_trust_title.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on your device.'**
  String get onb_trust_title;

  /// No description provided for @onb_trust_bullet_offline.
  ///
  /// In en, this message translates to:
  /// **'Offline-first—works without internet.'**
  String get onb_trust_bullet_offline;

  /// No description provided for @onb_trust_bullet_privacy.
  ///
  /// In en, this message translates to:
  /// **'We can\'t see your data unless you choose cloud backup.'**
  String get onb_trust_bullet_privacy;

  /// No description provided for @onb_trust_bullet_lock.
  ///
  /// In en, this message translates to:
  /// **'Lock PIN and biometric support.'**
  String get onb_trust_bullet_lock;

  /// No description provided for @onb_trust_primary.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get onb_trust_primary;

  /// No description provided for @onb_trust_learn_more.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get onb_trust_learn_more;

  /// No description provided for @onb_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onb_continue;

  /// No description provided for @onb_features_secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get onb_features_secure;

  /// No description provided for @onb_features_simple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get onb_features_simple;

  /// No description provided for @onb_features_smart.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get onb_features_smart;

  /// No description provided for @onb_feature_secure_desc.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted and secure'**
  String get onb_feature_secure_desc;

  /// No description provided for @onb_feature_simple_desc.
  ///
  /// In en, this message translates to:
  /// **'Easy to use interface'**
  String get onb_feature_simple_desc;

  /// No description provided for @onb_feature_smart_desc.
  ///
  /// In en, this message translates to:
  /// **'AI-powered insights'**
  String get onb_feature_smart_desc;

  /// No description provided for @language_bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get language_bengali;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @currency_bdt.
  ///
  /// In en, this message translates to:
  /// **'৳ BDT'**
  String get currency_bdt;

  /// No description provided for @currency_usd.
  ///
  /// In en, this message translates to:
  /// **'\$ USD'**
  String get currency_usd;

  /// No description provided for @onb_habit_title.
  ///
  /// In en, this message translates to:
  /// **'Today is Day 1—see you tomorrow?'**
  String get onb_habit_title;

  /// No description provided for @onb_habit_helper.
  ///
  /// In en, this message translates to:
  /// **'10 seconds a day—keep your streak, invest in your dreams.'**
  String get onb_habit_helper;

  /// No description provided for @onb_habit_cta.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get onb_habit_cta;

  /// No description provided for @onb_habit_toggle_reminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get onb_habit_toggle_reminder;

  /// Day label for habit tracking
  ///
  /// In en, this message translates to:
  /// **'DAY'**
  String get onb_habit_day_label;

  /// No description provided for @onb_welcome_chip_offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get onb_welcome_chip_offline;

  /// No description provided for @onb_welcome_chip_fast.
  ///
  /// In en, this message translates to:
  /// **'5-second add'**
  String get onb_welcome_chip_fast;

  /// No description provided for @onb_welcome_chip_secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get onb_welcome_chip_secure;

  /// No description provided for @onb_welcome_chip_offline_info.
  ///
  /// In en, this message translates to:
  /// **'Works without internet connection'**
  String get onb_welcome_chip_offline_info;

  /// No description provided for @onb_welcome_chip_fast_info.
  ///
  /// In en, this message translates to:
  /// **'Add expenses in just 5 seconds'**
  String get onb_welcome_chip_fast_info;

  /// No description provided for @onb_welcome_chip_secure_info.
  ///
  /// In en, this message translates to:
  /// **'Your data stays private and secure'**
  String get onb_welcome_chip_secure_info;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Cache error occurred'**
  String get errorCache;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database error occurred'**
  String get errorDatabase;

  /// Description for secure feature chip in welcome screen
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted and stored locally. No cloud sync, maximum privacy.'**
  String get onb_welcome_chip_secure_desc;

  /// Description for simple feature chip in welcome screen
  ///
  /// In en, this message translates to:
  /// **'Clean, intuitive interface designed for easy expense tracking.'**
  String get onb_welcome_chip_simple_desc;

  /// Description for smart feature chip in welcome screen
  ///
  /// In en, this message translates to:
  /// **'AI-powered insights and smart categorization for better financial management.'**
  String get onb_welcome_chip_smart_desc;

  /// Error message when demo transaction fails to add
  ///
  /// In en, this message translates to:
  /// **'Failed to add demo transaction: {error}'**
  String onb_demo_error_failed(Object error);

  /// Loading state text when adding demo transaction
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get onb_demo_adding;

  /// Title for empty transactions state
  ///
  /// In en, this message translates to:
  /// **'No Transactions'**
  String get empty_transactions_title;

  /// Subtitle for empty transactions state
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first transaction'**
  String get empty_transactions_subtitle;

  /// Title for empty categories state
  ///
  /// In en, this message translates to:
  /// **'No Categories'**
  String get empty_categories_title;

  /// Subtitle for empty categories state
  ///
  /// In en, this message translates to:
  /// **'Create categories to organize your transactions'**
  String get empty_categories_subtitle;

  /// Title for empty wallets state
  ///
  /// In en, this message translates to:
  /// **'No Wallets'**
  String get empty_wallets_title;

  /// Subtitle for empty wallets state
  ///
  /// In en, this message translates to:
  /// **'Add a wallet to start tracking your finances'**
  String get empty_wallets_subtitle;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get btn_confirm;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btn_cancel;

  /// Error message when habit onboarding fails
  ///
  /// In en, this message translates to:
  /// **'Failed to complete onboarding: {error}'**
  String onb_habit_error_failed(Object error);

  /// Accessibility label for security icon in trust screen
  ///
  /// In en, this message translates to:
  /// **'Security and privacy icon'**
  String get onb_trust_icon_label;

  /// USD currency code
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get currency_usd_code;

  /// USD currency name
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get currency_usd_name;

  /// EUR currency code
  ///
  /// In en, this message translates to:
  /// **'EUR'**
  String get currency_eur_code;

  /// EUR currency name
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get currency_eur_name;

  /// BDT currency code
  ///
  /// In en, this message translates to:
  /// **'BDT'**
  String get currency_bdt_code;

  /// BDT currency name
  ///
  /// In en, this message translates to:
  /// **'Bangladeshi Taka'**
  String get currency_bdt_name;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english_name;

  /// Bengali language name in Bengali script
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get language_bengali_name;

  /// Bengali language name in English
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get language_bengali_english_name;

  /// Theme settings title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme_title;

  /// Light theme name
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light_name;

  /// Light theme description
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get theme_light_desc;

  /// Dark theme name
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark_name;

  /// Dark theme description
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get theme_dark_desc;

  /// System theme name
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system_name;

  /// System theme description
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get theme_system_desc;

  /// Salary category name
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get cat_salary_name;

  /// Business category name
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get cat_business_name;

  /// Investment category name
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get cat_investment_name;

  /// Food & Dining category name
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get cat_food_dining_name;

  /// Transport category name
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get cat_transport_name;

  /// Rent category name
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get cat_rent_name;

  /// Shopping category name
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get cat_shopping_name;

  /// Bank Transfer category name
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get cat_bank_transfer_name;

  /// Mobile Wallet category name
  ///
  /// In en, this message translates to:
  /// **'Mobile Wallet'**
  String get cat_mobile_wallet_name;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
