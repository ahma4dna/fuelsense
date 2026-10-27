import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> loadMarkerIcons(
  double zoomLevel,
  Map<String, BitmapDescriptor> markerIcons,
) async {
  final double calculatedLogicalSize = 60 + ((zoomLevel - 10.0) * 2.2);
  final double finalLogicalSize = calculatedLogicalSize.clamp(60, 80.0);

  markerIcons['open'] = await svgToBitmapDescriptor(AppAssets.open, finalLogicalSize);
  markerIcons['on_the_way'] = await svgToBitmapDescriptor(AppAssets.onTheWay, finalLogicalSize);
  markerIcons['refilling'] = await svgToBitmapDescriptor(AppAssets.refilling, finalLogicalSize);
  markerIcons['unknown'] = await svgToBitmapDescriptor(AppAssets.unknown, finalLogicalSize);
}

Future<BitmapDescriptor> svgToBitmapDescriptor(
  String assetPath,
  double targetLogicalWidth,
) async {
  final double devicePixelRatio = ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

  final PictureInfo pictureInfo = await vg.loadPicture(
    SvgAssetLoader(assetPath),
    null,
  );

  final double svgWidth = pictureInfo.size.width > 0 ? pictureInfo.size.width : 100.0;
  final double svgHeight = pictureInfo.size.height > 0 ? pictureInfo.size.height : 100.0;

  final double aspectRatio = svgHeight / svgWidth;
  final double targetLogicalHeight = targetLogicalWidth * aspectRatio;

  final int physicalWidth = (targetLogicalWidth * devicePixelRatio).round();
  final int physicalHeight = (targetLogicalHeight * devicePixelRatio).round();

  final double scaleX = physicalWidth / svgWidth;
  final double scaleY = physicalHeight / svgHeight;

  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);

  canvas.scale(scaleX, scaleY);
  canvas.drawPicture(pictureInfo.picture);

  final ui.Picture scaledPicture = recorder.endRecording();

  final ui.Image image = await scaledPicture.toImage(
    physicalWidth,
    physicalHeight,
  );

  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  pictureInfo.picture.dispose();
  scaledPicture.dispose();
  image.dispose();

  return BitmapDescriptor.bytes(
    byteData!.buffer.asUint8List(),
    imagePixelRatio: devicePixelRatio,
    width: targetLogicalWidth,
    height: targetLogicalHeight,
  );
}

Future<void> getLocation(
  GoogleMapController googleMapController,
  CameraPosition initialCameraPosition,
) async {
  final res = await LocationService.getCurrentLocation();
  res.fold(
    (left) {
      log(left);
    },
    (right) async {
      log(right.latitude.toString());
      await updateCameraPoition(
        LatLng(right.latitude, right.longitude),
        googleMapController,
        initialCameraPosition,
      );
    },
  );
}

Future<void> updateCameraPoition(
  LatLng myLocation,
  GoogleMapController googleMapController,
  CameraPosition initialCameraPosition,
) async {
  initialCameraPosition = CameraPosition(
    target: myLocation,
    zoom: 15,
  );
  googleMapController.animateCamera(
    CameraUpdate.newCameraPosition(initialCameraPosition),
  );
}
