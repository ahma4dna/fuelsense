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
  double calculatedSize = 60.0 + ((zoomLevel - 10.0) * 6.0);

  double finalSize = calculatedSize.clamp(80.0, 180.0);

  markerIcons['open'] = await svgToBitmapDescriptor(AppAssets.openSt, finalSize);
  markerIcons['closed'] = await svgToBitmapDescriptor(AppAssets.closedSt, finalSize);
  markerIcons['probably_active'] = await svgToBitmapDescriptor(AppAssets.probablyActiveSt, finalSize);
  markerIcons['probably_closed'] = await svgToBitmapDescriptor(AppAssets.probablyClosedSt, finalSize);
  markerIcons['uncertain'] = await svgToBitmapDescriptor(AppAssets.uncertainSt, finalSize);
  markerIcons['unknown'] = await svgToBitmapDescriptor(AppAssets.unknownSt, finalSize);
}

Future<BitmapDescriptor> svgToBitmapDescriptor(String assetPath, double targetSize) async {
  final int sizeAsInt = targetSize.toInt();

  final pictureInfo = await vg.loadPicture(
    SvgAssetLoader(assetPath),
    null,
  );

  final double originalSvgSize = pictureInfo.size.width;

  final double scale = targetSize / originalSvgSize;

  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);

  canvas.scale(scale, scale);
  canvas.drawPicture(pictureInfo.picture);

  final ui.Picture scaledPicture = recorder.endRecording();

  final image = await scaledPicture.toImage(
    sizeAsInt,
    sizeAsInt,
  );

  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  pictureInfo.picture.dispose();
  scaledPicture.dispose();

  return BitmapDescriptor.bytes(
    byteData!.buffer.asUint8List(),
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
  googleMapController.animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
}
