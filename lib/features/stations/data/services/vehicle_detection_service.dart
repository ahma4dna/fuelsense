// import 'dart:io';

// import 'package:fpdart/fpdart.dart';
// import 'package:fuelsense/core/domain/models/failure.dart';
// import 'package:ultralytics_yolo/ultralytics_yolo.dart';

// /// ═══════════════════════════════════════════
// /// نتيجة اكتشاف المركبات من صورة واحدة
// /// ═══════════════════════════════════════════

// class VehicleDetectionResult {
//   /// العدد الإجمالي للمركبات المكتشفة (بدون الأشخاص)
//   final int totalVehicles;

//   /// تفاصيل كل مركبة مكتشفة
//   final List<DetectedVehicle> vehicles;

//   /// المسار الأصلي للصورة
//   final String imagePath;

//   const VehicleDetectionResult({
//     required this.totalVehicles,
//     required this.vehicles,
//     required this.imagePath,
//   });

//   /// عدد المركبات حسب الفئة
//   Map<String, int> get countByClass {
//     final map = <String, int>{};
//     for (final v in vehicles) {
//       map[v.className] = (map[v.className] ?? 0) + 1;
//     }
//     return map;
//   }

//   /// ملخص نصي للاكتشافات
//   String get summary {
//     if (totalVehicles == 0) return 'لم يتم اكتشاف مركبات';
//     final parts = countByClass.entries.map((e) => '${e.value} ${e.key}').join('، ');
//     return 'تم اكتشاف $totalVehicles مركبة: $parts';
//   }
// }

// class DetectedVehicle {
//   final String className; // Car, Bus, Truck, small bus, taxi
//   final double confidence; // 0.0 - 1.0
//   final double x; // إحداثيات المربع
//   final double y;
//   final double width;
//   final double height;

//   const DetectedVehicle({
//     required this.className,
//     required this.confidence,
//     required this.x,
//     required this.y,
//     required this.width,
//     required this.height,
//   });

//   String get confidencePercent => '${(confidence * 100).toInt()}%';
// }

// /// ═══════════════════════════════════════════
// /// خدمة اكتشاف المركبات (Vehicle Detection Service)
// /// ═══════════════════════════════════════════

// class VehicleDetectionService {
//   /// عتبة الثقة - فقط النتائج فوق 85% تُحتسب
//   static const double confidenceThreshold = 0.85;

//   /// عتبة تداخل المربعات
//   static const double iouThreshold = 0.4;

//   /// الفئات المطلوبة (بدون person)
//   static const List<String> vehicleClasses = [
//     'Bus',
//     'Car',
//     'Truck',
//     'small bus',
//     'taxi',
//   ];

//   /// مسار النموذج
//   static const String modelPath = 'assets/best_float32.tflite';

//   ObjectDetector? _detector;
//   bool _isModelLoaded = false;

//   bool get isModelLoaded => _isModelLoaded;

//   /// ═══════════════════════════════════════════
//   /// تحميل النموذج (يُستدعى مرة واحدة عند بدء التطبيق)
//   /// ═══════════════════════════════════════════
//   Future<Either<Failure, void>> loadModel() async {
//     try {
//       final model = LocalYoloModel(
//         id: 'fuelsense-yolo',
//         task: Task.detect,
//         format: Format.tflite,
//         modelPath: modelPath,
//       );

//       _detector = ObjectDetector(model: model);
//       await _detector!.loadModel();
//       _isModelLoaded = true;

//       return const Right(null);
//     } catch (e) {
//       return Left(
//         Failure(
//           code: 500,
//           message: 'فشل تحميل نموذج الذكاء الاصطناعي: $e',
//         ),
//       );
//     }
//   }

//   /// ═══════════════════════════════════════════
//   /// تحليل صورة واحدة واكتشاف المركبات
//   /// ═══════════════════════════════════════════
//   Future<Either<Failure, VehicleDetectionResult>> detectFromImage(
//     File imageFile,
//   ) async {
//     if (!_isModelLoaded || _detector == null) {
//       final loadResult = await loadModel();
//       if (loadResult.isLeft()) {
//         return Left(
//           loadResult.getLeft().getOrElse(
//             () => const Failure(code: 500, message: 'فشل تحميل النموذج'),
//           ),
//         );
//       }
//     }

//     try {
//       // تشغيل النموذج على الصورة
//       final detections = await _detector!.detect(imagePath: imageFile.path);

//       // فلترة: فقط المركبات فوق عتبة الثقة
//       final vehicles = <DetectedVehicle>[];

//       if (detections != null) {
//         for (final detection in detections) {
//           final className = detection.className ?? '';
//           final confidence = detection.confidence ?? 0.0;

//           // تجاهل person + النتائج تحت العتبة
//           if (className == 'person') continue;
//           if (confidence < confidenceThreshold) continue;
//           if (!vehicleClasses.contains(className)) continue;

//           vehicles.add(
//             DetectedVehicle(
//               className: className,
//               confidence: confidence,
//               x: detection.boundingBox?.left ?? 0,
//               y: detection.boundingBox?.top ?? 0,
//               width: detection.boundingBox?.width ?? 0,
//               height: detection.boundingBox?.height ?? 0,
//             ),
//           );
//         }
//       }

//       return Right(
//         VehicleDetectionResult(
//           totalVehicles: vehicles.length,
//           vehicles: vehicles,
//           imagePath: imageFile.path,
//         ),
//       );
//     } catch (e) {
//       return Left(
//         Failure(
//           code: 500,
//           message: 'فشل تحليل الصورة: $e',
//         ),
//       );
//     }
//   }

//   /// ═══════════════════════════════════════════
//   /// استخراج عدد المركبات من نتائج YOLOView الحية
//   /// (يُستخدم مع onResult في الكاميرا الحية)
//   /// ═══════════════════════════════════════════
//   static VehicleDetectionResult parseYOLOViewResults(
//     List<dynamic>? results,
//     String imagePath,
//   ) {
//     final vehicles = <DetectedVehicle>[];

//     if (results != null) {
//       for (final r in results) {
//         final className = r.className ?? '';
//         final confidence = r.confidence ?? 0.0;

//         if (className == 'person') continue;
//         if (confidence < confidenceThreshold) continue;
//         if (!vehicleClasses.contains(className)) continue;

//         vehicles.add(
//           DetectedVehicle(
//             className: className,
//             confidence: confidence,
//             x: r.boundingBox?.left ?? 0,
//             y: r.boundingBox?.top ?? 0,
//             width: r.boundingBox?.width ?? 0,
//             height: r.boundingBox?.height ?? 0,
//           ),
//         );
//       }
//     }

//     return VehicleDetectionResult(
//       totalVehicles: vehicles.length,
//       vehicles: vehicles,
//       imagePath: imagePath,
//     );
//   }

//   /// تنظيف الموارد
//   void dispose() {
//     _detector?.dispose();
//     _detector = null;
//     _isModelLoaded = false;
//   }
// }
