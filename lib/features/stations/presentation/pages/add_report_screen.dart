import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../cubit/add_report_cubit.dart';
import '../cubit/add_report_state.dart';

class AddReportScreen extends StatefulWidget {
  final int stationId;
  final String stationName;
  final double stationLatitude;
  final double stationLongitude;

  const AddReportScreen({
    super.key,
    required this.stationId,
    required this.stationName,
    required this.stationLatitude,
    required this.stationLongitude,
  });

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  late final AddReportCubit _cubit;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AddReportCubit>()
      ..verifyUserLocation(
        stationLatitude: widget.stationLatitude,
        stationLongitude: widget.stationLongitude,
      );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _retryLocationCheck() {
    _cubit.verifyUserLocation(
      stationLatitude: widget.stationLatitude,
      stationLongitude: widget.stationLongitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<AddReportCubit, AddReportState>(
        listener: (context, state) {
          if (state.submitStatus == ReportSubmitStatus.success) {
            context.pop();
          } else if (state.submitStatus == ReportSubmitStatus.error && state.errorMessage != null) {
            Flushbar(
              message: state.errorMessage!,
              backgroundColor: const Color(0xFFD92D20),
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F4EE),
              appBar: AppBar(
                backgroundColor: const Color(0xFFF6F4EE),
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: Color(0xFF11201F),
                  ),
                ),
                title: const Text(
                  'إضافة بلاغ ميداني',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF11201F),
                  ),
                ),
              ),
              body: SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: switch (state.locationStatus) {
                    LocationVerifyStatus.checking => _CheckingLocationView(stationName: widget.stationName),
                    LocationVerifyStatus.serviceDisabled ||
                    LocationVerifyStatus.permissionDenied => _LocationPermissionRequiredView(
                      isServiceDisabled: state.locationStatus == LocationVerifyStatus.serviceDisabled,
                      isPermanentlyDenied: state.isPermanentlyDenied,
                      onRetry: _retryLocationCheck,
                    ),
                    LocationVerifyStatus.outOfRange => _OutOfRangeView(
                      stationName: widget.stationName,
                      distanceInMeters: state.distanceInMeters ?? 0,
                      onRetry: _retryLocationCheck,
                    ),
                    LocationVerifyStatus.inRangeReady => _ReportFormView(
                      stationName: widget.stationName,
                      distanceInMeters: state.distanceInMeters ?? 0,
                      selectedQueueStatus: state.selectedQueueStatus,
                      noteController: _noteController,
                      isSubmitting: state.submitStatus == ReportSubmitStatus.submitting,
                      onQueueSelected: _cubit.selectQueueStatus,
                      onSubmit: () => _cubit.submitReport(
                        stationId: widget.stationId,
                        note: _noteController.text,
                      ),
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 1. واجهة جاري التحقق من الموقع الجغرافي
class _CheckingLocationView extends StatelessWidget {
  final String stationName;

  const _CheckingLocationView({required this.stationName});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('checking_location'),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF9F7),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 38,
                  height: 38,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF0F6E67),
                  ),
                ),
              ),
            ),
            const Gap(24),
            const Text(
              'جاري التحقق من موقعك الجغرافي...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF11201F),
              ),
            ),
            const Gap(10),
            Text(
              'نتأكد من تواجدك بالقرب من "$stationName" للسماح بإضافة البلاغ.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5A6866),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. واجهة مطالبة المستخدم بتفعيل الموقع للتطبيق أولاً للتبليغ
class _LocationPermissionRequiredView extends StatelessWidget {
  final bool isServiceDisabled;
  final bool isPermanentlyDenied;
  final VoidCallback onRetry;

  const _LocationPermissionRequiredView({
    required this.isServiceDisabled,
    required this.isPermanentlyDenied,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('permission_required'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE6E2D9)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_off_rounded,
                  size: 38,
                  color: Color(0xFFD97706),
                ),
              ),
              const Gap(20),
              const Text(
                'يرجى تفعيل الموقع للتطبيق أولاً للتبليغ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF11201F),
                ),
              ),
              const Gap(10),
              Text(
                isServiceDisabled
                    ? 'خدمة تحديد الموقع (GPS) غير مفعلة في هاتفك. يرجى تشغيلها أولاً حتى نتمكن من التحقق من تواجدك عند المحطة.'
                    : 'يتطلب إرسال البلاغ السماح للتطبيق بالوصول إلى موقعك الجغرافي للتأكد من تواجدك الفعلي عند المحطة.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5A6866),
                  height: 1.6,
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (isServiceDisabled) {
                      await Geolocator.openLocationSettings();
                    } else if (isPermanentlyDenied) {
                      await Geolocator.openAppSettings();
                    } else {
                      onRetry();
                      return;
                    }
                    onRetry();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F6E67),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.my_location_rounded, size: 20),
                  label: Text(
                    isServiceDisabled
                        ? 'تفعيل خدمة الموقع (GPS)'
                        : (isPermanentlyDenied ? 'فتح إعدادات التطبيق لتفعيل الموقع' : 'السماح بتحديد الموقع الآن'),
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Gap(12),
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'قمت بتفعيل الموقع، تحقق مجدداً',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F6E67),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3. واجهة خارج نطاق المحطة (توضيح أنه لا يمكنه التبليغ لأنه بعيد عن المحطة)
class _OutOfRangeView extends StatelessWidget {
  final String stationName;
  final double distanceInMeters;
  final VoidCallback onRetry;

  const _OutOfRangeView({
    required this.stationName,
    required this.distanceInMeters,
    required this.onRetry,
  });

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} كم';
    }
    return '${meters.round()} متر';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('out_of_range'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE6E2D9)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wrong_location_outlined,
                  size: 38,
                  color: Color(0xFFD92D20),
                ),
              ),
              const Gap(20),
              const Text(
                'لا يمكنك التبليغ خارج موقع المحطة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF11201F),
                ),
              ),
              const Gap(10),
              Text(
                'لضمان مصداقية البلاغات، يُسمح بالتبليغ فقط للمتواجدين بالقرب من "$stationName" (ضمن نطاق 200 متر).',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5A6866),
                  height: 1.6,
                ),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.straighten_rounded,
                      size: 18,
                      color: Color(0xFFD92D20),
                    ),
                    const Gap(8),
                    Text(
                      'المسافة الحالية عن المحطة: ${_formatDistance(distanceInMeters)}',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F6E67),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'الرجوع لصفحة تفاصيل المحطة',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: Color(0xFF5A6866),
                ),
                label: const Text(
                  'إعادة فحص الموقع الجغرافي',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5A6866),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. واجهة نموذج التبليغ (تظهر عندما يكون المستخدم في موقع المحطة)
class _ReportFormView extends StatelessWidget {
  final String stationName;
  final double distanceInMeters;
  final String selectedQueueStatus;
  final TextEditingController noteController;
  final bool isSubmitting;
  final ValueChanged<String> onQueueSelected;
  final VoidCallback onSubmit;

  const _ReportFormView({
    required this.stationName,
    required this.distanceInMeters,
    required this.selectedQueueStatus,
    required this.noteController,
    required this.isSubmitting,
    required this.onQueueSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final queueOptions = [
      (
        value: 'light',
        title: 'طابور خفيف',
        subtitle: 'حركة سريعة (أقل من 15 دقيقة)',
        icon: Icons.speed_rounded,
        color: const Color(0xFF16A34A),
        bgColor: const Color(0xFFDCFCE7),
      ),
      (
        value: 'medium',
        title: 'ازدحام متوسط',
        subtitle: 'الطابور يتحرك بانتظام (15 - 35 دقيقة)',
        icon: Icons.directions_car_filled_outlined,
        color: const Color(0xFFD97706),
        bgColor: const Color(0xFFFEF3C7),
      ),
      (
        value: 'heavy',
        title: 'ازدحام شديد',
        subtitle: 'طابور طويل وانتظار أكثر من 45 دقيقة',
        icon: Icons.traffic_rounded,
        color: const Color(0xFFDC2626),
        bgColor: const Color(0xFFFEE2E2),
      ),
      (
        value: 'stopped',
        title: 'الطابور متوقف',
        subtitle: 'المضخات متوقفة حالياً أو لا توجد حركة',
        icon: Icons.pan_tool_outlined,
        color: const Color(0xFF475569),
        bgColor: const Color(0xFFF1F5F9),
      ),
    ];

    return SingleChildScrollView(
      key: const ValueKey('report_form'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شارة تأكيد التواجد في موقع المحطة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF9F7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB5E2DC)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F6E67),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تم التحقق من تواجدك في موقع المحطة',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF083A38),
                        ),
                      ),
                      const Gap(2),
                      Text(
                        '$stationName • على بُعد ${distanceInMeters.round()} متر',
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F6E67),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(22),

          // اختيار مدى الازدحام
          const Text(
            'ما هو مدى الازدحام في المحطة الآن؟',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF11201F),
            ),
          ),
          const Gap(12),

          ...queueOptions.map((option) {
            final isSelected = selectedQueueStatus == option.value;
            return GestureDetector(
              onTap: () => onQueueSelected(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0F6E67) : const Color(0xFFE6E2D9),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: option.bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        option.icon,
                        color: option.color,
                        size: 24,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF11201F),
                            ),
                          ),
                          const Gap(2),
                          Text(
                            option.subtitle,
                            style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5A6866),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: isSelected ? const Color(0xFF0F6E67) : const Color(0xFF9CA8A6),
                      size: 24,
                    ),
                  ],
                ),
              ),
            );
          }),
          const Gap(14),

          // حقل كتابة التعليق / الملاحظة
          const Text(
            'أضف تعليقاً أو ملاحظة للمتواجدين (اختياري)',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF11201F),
            ),
          ),
          const Gap(8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6E2D9)),
            ),
            child: TextField(
              controller: noteController,
              maxLength: 120,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF11201F),
              ),
              decoration: const InputDecoration(
                hintText: 'مثال: جميع المضخات تعمل والطابور يتحرك بسلاسة من الجهة الشرقية...',
                hintStyle: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8C9896),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const Gap(24),

          // زر إرسال البلاغ والرجوع لصفحة تفاصيل المحطة
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F6E67),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: isSubmitting ? const SizedBox.shrink() : const Icon(Icons.send_rounded, size: 20),
              label: isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'إرسال البلاغ الآن',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
