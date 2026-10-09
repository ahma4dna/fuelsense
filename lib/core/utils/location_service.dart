import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  static Future<void> openMap({
    required double latitude,
    required double longitude,
  }) async {
    String url = '';

    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else if (Platform.isIOS) {
      url = 'https://maps.apple.com/?q=$latitude,$longitude';
    } else {
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }

    final Uri mapUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(mapUri)) {
        await launchUrl(
          mapUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('لا يمكن فتح الخريطة.');
      }
    } catch (e) {
      debugPrint('حدث خطأ أثناء محاولة فتح الخريطة: $e');
    }
  }

  Future<Either<String, bool>> isLocationEnabled() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (isEnabled) {
        return right(true);
      } else {
        return left('خدمات الموقع (GPS) معطلة. يرجى تفعيلها.');
      }
    } catch (e) {
      return left('حدث خطأ غير متوقع أثناء التحقق من الـ GPS: $e');
    }
  }

  static Future<Either<String, bool>> verifyLocationAccess() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return left('خدمات الموقع معطلة في الجهاز.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return left(('تم رفض إذن الوصول إلى الموقع.'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return left(('تم رفض أذونات الموقع بشكل دائم. يرجى تفعيلها من إعدادات التطبيق.'));
      }

      return right(true);
    } catch (e) {
      return left(('فشل في التحقق من صلاحيات الموقع: $e'));
    }
  }

  static Future<Either<String, Position>> getCurrentLocation() async {
    final accessResult = await verifyLocationAccess();

    return accessResult.fold(
      (failure) async => left(failure),

      (isGranted) async {
        try {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
          );

          return right(position);
        } catch (e) {
          return left(('حدث خطأ أثناء جلب الإحداثيات: $e'));
        }
      },
    );
  }
}
