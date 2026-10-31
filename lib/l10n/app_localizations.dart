import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @staions.
  ///
  /// In ar, this message translates to:
  /// **'المحطات'**
  String get staions;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get account;

  /// No description provided for @reports.
  ///
  /// In ar, this message translates to:
  /// **'بلاغاتي '**
  String get reports;

  /// No description provided for @view_detail_st.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get view_detail_st;

  /// No description provided for @search_lable.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن اسم المحطة أو المدينة...'**
  String get search_lable;

  /// No description provided for @station_details.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المحطة'**
  String get station_details;

  /// No description provided for @confdance_prob.
  ///
  /// In ar, this message translates to:
  /// **'مؤشر الثقة'**
  String get confdance_prob;

  /// No description provided for @location_trak.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاهات'**
  String get location_trak;

  /// No description provided for @currnt_reports.
  ///
  /// In ar, this message translates to:
  /// **'أخر البلاغات'**
  String get currnt_reports;

  /// No description provided for @good.
  ///
  /// In ar, this message translates to:
  /// **'مفيد'**
  String get good;

  /// No description provided for @bad.
  ///
  /// In ar, this message translates to:
  /// **'غير مفيد'**
  String get bad;

  /// No description provided for @confirm_station_state.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد حالة المحطة '**
  String get confirm_station_state;

  /// No description provided for @check_location.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من الموقع'**
  String get check_location;

  /// No description provided for @camera_shot.
  ///
  /// In ar, this message translates to:
  /// **'إالتقاط صوره'**
  String get camera_shot;

  /// No description provided for @shot_ai.
  ///
  /// In ar, this message translates to:
  /// **'تحليل الصوره'**
  String get shot_ai;

  /// No description provided for @send_report.
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get send_report;

  /// No description provided for @success_send_report.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البلاغ بنجاح'**
  String get success_send_report;

  /// No description provided for @success_send_report_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'شكرآ لمساهمتك!'**
  String get success_send_report_subtitle;

  /// No description provided for @contion_check.
  ///
  /// In ar, this message translates to:
  /// **'متابعة التحقق'**
  String get contion_check;

  /// No description provided for @succecss_checkh_location.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق من الموقع'**
  String get succecss_checkh_location;

  /// No description provided for @error_checkh_location.
  ///
  /// In ar, this message translates to:
  /// **'فشل التحقق من الموقع'**
  String get error_checkh_location;

  /// No description provided for @loading_loction.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحقق من الموقع'**
  String get loading_loction;

  /// No description provided for @success_cheeck_location_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق من وجودك الفعلي عبر GPS. يمكنك الآن متابعةالتقاط الدليل البصري.'**
  String get success_cheeck_location_subtitle;

  /// No description provided for @you_inside_range_station.
  ///
  /// In ar, this message translates to:
  /// **'انت داخل نطاق المحطة'**
  String get you_inside_range_station;

  /// No description provided for @plese_check_enable_location_and_nebrey_station.
  ///
  /// In ar, this message translates to:
  /// **'يرجي التحقق من تفعيل اذونات الموقع وانك قريب من المحطة و إعادة المحاولة مره اخرى '**
  String get plese_check_enable_location_and_nebrey_station;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @contion.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get contion;

  /// No description provided for @note_ai_analayze.
  ///
  /// In ar, this message translates to:
  /// **'نتيجة AI لا تحدد حالة المحطة وحدها، بل تدخل ضمن مؤشرالثقة.'**
  String get note_ai_analayze;

  /// No description provided for @loading_ai.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحليل الصوره'**
  String get loading_ai;

  /// No description provided for @error_chck_ai_image.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحليل الصوره'**
  String get error_chck_ai_image;

  /// No description provided for @retry_chck_ai_image.
  ///
  /// In ar, this message translates to:
  /// **'يرجي إعادة المحاولة مره اخرى'**
  String get retry_chck_ai_image;

  /// No description provided for @detect_car.
  ///
  /// In ar, this message translates to:
  /// **'تم التعرف علي '**
  String get detect_car;

  /// No description provided for @car.
  ///
  /// In ar, this message translates to:
  /// **'مركبات'**
  String get car;

  /// No description provided for @qualtiy_analyze_ai.
  ///
  /// In ar, this message translates to:
  /// **'دقة تحليل البصري'**
  String get qualtiy_analyze_ai;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'مغلقة'**
  String get close;

  /// No description provided for @open.
  ///
  /// In ar, this message translates to:
  /// **'مفتوحة'**
  String get open;

  /// No description provided for @unloading.
  ///
  /// In ar, this message translates to:
  /// **'يتم التفريغ'**
  String get unloading;

  /// No description provided for @please_selcte_state_station.
  ///
  /// In ar, this message translates to:
  /// **'يرجي تحديد حالة المحطة'**
  String get please_selcte_state_station;

  /// No description provided for @send_report_note.
  ///
  /// In ar, this message translates to:
  /// **'بإرسالك البلاغ تؤكد أن المعلومات صحيحة لحظة التقاط الصورة.البلاغات المضللة تخفّض موثوقية حسابك.'**
  String get send_report_note;

  /// No description provided for @done_send_report.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البلاغ بنجاح'**
  String get done_send_report;

  /// No description provided for @retern.
  ///
  /// In ar, this message translates to:
  /// **'العودة'**
  String get retern;

  /// No description provided for @thank_you.
  ///
  /// In ar, this message translates to:
  /// **'شكرآ لمساهمتك'**
  String get thank_you;

  /// No description provided for @map.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get map;

  /// No description provided for @list_station.
  ///
  /// In ar, this message translates to:
  /// **'المحطات'**
  String get list_station;

  /// No description provided for @city_radar.
  ///
  /// In ar, this message translates to:
  /// **'رادار المدن'**
  String get city_radar;

  /// No description provided for @settinges.
  ///
  /// In ar, this message translates to:
  /// **'الاعدادات'**
  String get settinges;

  /// No description provided for @km.
  ///
  /// In ar, this message translates to:
  /// **'كم'**
  String get km;

  /// No description provided for @station_statee.
  ///
  /// In ar, this message translates to:
  /// **'حالة المحطة'**
  String get station_statee;

  /// No description provided for @route_nigber_station.
  ///
  /// In ar, this message translates to:
  /// **'الطريق بجانب المحطة'**
  String get route_nigber_station;

  /// No description provided for @letency.
  ///
  /// In ar, this message translates to:
  /// **'تأخير'**
  String get letency;

  /// No description provided for @user_report_station.
  ///
  /// In ar, this message translates to:
  /// **'آراء موثقة من المتواجدين اليوم'**
  String get user_report_station;

  /// No description provided for @view_details_and_hitory_station.
  ///
  /// In ar, this message translates to:
  /// **'عرض تفاصيل وسجل المحطة'**
  String get view_details_and_hitory_station;

  /// No description provided for @open_route.
  ///
  /// In ar, this message translates to:
  /// **'فتح المسار '**
  String get open_route;

  /// No description provided for @history_and_date_station.
  ///
  /// In ar, this message translates to:
  /// **'سجل وتاريخ المحطة'**
  String get history_and_date_station;

  /// No description provided for @reports_today_uers.
  ///
  /// In ar, this message translates to:
  /// **'آراء المتواجدين اليوم '**
  String get reports_today_uers;

  /// No description provided for @reports_today_uers_hint.
  ///
  /// In ar, this message translates to:
  /// **'آراء المستخدمين تعكس مشاهدات اليوم من موقع المحطة ولا\nتغير الحالة أعلاه.'**
  String get reports_today_uers_hint;

  /// No description provided for @submit_report_user.
  ///
  /// In ar, this message translates to:
  /// **' أؤكد هذا الوضع الآن'**
  String get submit_report_user;

  /// No description provided for @history_this_station_not_avialeble.
  ///
  /// In ar, this message translates to:
  /// **'سجل هذه المحطة غير متوفر'**
  String get history_this_station_not_avialeble;

  /// No description provided for @not_report.
  ///
  /// In ar, this message translates to:
  /// **'لايوجد ارأ بعد'**
  String get not_report;

  /// No description provided for @name_error.
  ///
  /// In ar, this message translates to:
  /// **' يرجى إدخال الاسم الكامل'**
  String get name_error;

  /// No description provided for @email_error.
  ///
  /// In ar, this message translates to:
  /// **' صيغة البريد الإلكتروني غير صحيحة'**
  String get email_error;

  /// No description provided for @password_error.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 8 أحرف على الأقل وتحتوي رقماً'**
  String get password_error;

  /// No description provided for @accepted_terms.
  ///
  /// In ar, this message translates to:
  /// **'يرجى الموافقة على شروط الاستخدام وسياسة الخصوصية للمتابعة'**
  String get accepted_terms;

  /// No description provided for @error_crate_account.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إنشاء الحساب'**
  String get error_crate_account;

  /// No description provided for @create_new_account.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get create_new_account;

  /// No description provided for @create_new_account_title.
  ///
  /// In ar, this message translates to:
  /// **'انضم للمتواجدين وساهم في توثيق حالة المحطات'**
  String get create_new_account_title;

  /// No description provided for @sin_up_google.
  ///
  /// In ar, this message translates to:
  /// **'التسجيل عبر جوجل'**
  String get sin_up_google;

  /// No description provided for @or_sin_up_email.
  ///
  /// In ar, this message translates to:
  /// **'أو أنشئ حساباً بالبريد الإلكتروني'**
  String get or_sin_up_email;

  /// No description provided for @full_name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get full_name;

  /// No description provided for @week.
  ///
  /// In ar, this message translates to:
  /// **'ضعيفة'**
  String get week;

  /// No description provided for @medium.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get medium;

  /// No description provided for @strong.
  ///
  /// In ar, this message translates to:
  /// **'قوية'**
  String get strong;

  /// No description provided for @strong_pasword.
  ///
  /// In ar, this message translates to:
  /// **'قوة كلمة المرور'**
  String get strong_pasword;

  /// No description provided for @warrning_password.
  ///
  /// In ar, this message translates to:
  /// **'ثمانية أحرف على الأقل، وتحتوي رقماً'**
  String get warrning_password;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @accept.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على'**
  String get accept;

  /// No description provided for @and.
  ///
  /// In ar, this message translates to:
  /// **'و'**
  String get and;

  /// No description provided for @privcy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privcy;

  /// No description provided for @terms.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get terms;

  /// No description provided for @create_account.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get create_account;

  /// No description provided for @you_have_account.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟ '**
  String get you_have_account;

  /// No description provided for @sign_in.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول'**
  String get sign_in;

  /// No description provided for @email_hint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب بريدك الإلكتروني'**
  String get email_hint;

  /// No description provided for @forgot_password.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgot_password;

  /// No description provided for @enter_email_for_reset.
  ///
  /// In ar, this message translates to:
  /// **'يرجى كتابة بريدك الإلكتروني أولاً في الحقل المخصص لإرسال رابط الاستعادة'**
  String get enter_email_for_reset;

  /// No description provided for @password_reset_sent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني'**
  String get password_reset_sent;

  /// No description provided for @login_error.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تسجيل الدخول'**
  String get login_error;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @or.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get or;

  /// No description provided for @continue_with_google.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة عبر جوجل'**
  String get continue_with_google;

  /// No description provided for @no_account.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟ '**
  String get no_account;

  /// No description provided for @welcome_back.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get welcome_back;

  /// No description provided for @login_subtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك لمتابعة محطات مدينتك'**
  String get login_subtitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
