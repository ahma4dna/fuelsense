import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/home/data/models/station_model.dart';
import 'package:fuelsense/features/home/presentation/bloc/station/station_bloc.dart';
import 'package:fuelsense/features/home/presentation/bloc/station/station_event.dart';
import 'package:fuelsense/features/home/presentation/bloc/station/station_state.dart';
import 'package:fuelsense/features/home/presentation/function/function_home_page.dart';
import 'package:fuelsense/features/home/presentation/widgets/home_screen_widget/my_location_and_togle_style_map.dart';
import 'package:fuelsense/features/home/presentation/widgets/home_screen_widget/search_staion_widget.dart';
import 'package:fuelsense/features/home/presentation/widgets/home_screen_widget/station_widget.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _googleMapController;
  LatLng? myLocation;
  //
  List<StationModel> _currentStations = [];
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _markerIcons = {};
  StationModel? _selectedStation;
  String? mapStyle;
  bool _isGettingLocation = false;
  double _currentZoom = 15.0;
  final GlobalKey _stationWidgetKey = GlobalKey();
  double _stationWidgetHeight = 0;
  MapType _mapType = MapType.normal;
  bool _isSatellite = false;
  late TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    _initialCameraPosition = CameraPosition(
      target: LatLng(32.79130167286812, 12.486110373636903),
      zoom: 15,
    );
    getIt<StationBloc>().add(WatchStationsEvent());
    loadMarkerIcons(_currentZoom, _markerIcons);
    _updateStationWidgetSize();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateStationWidgetSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _stationWidgetKey.currentContext;
      if (context == null) return;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final height = renderBox.size.height;

      if (height != _stationWidgetHeight && mounted) {
        setState(() {
          _stationWidgetHeight = height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);
    return BlocProvider.value(
      value: getIt<StationBloc>(),
      child: BlocConsumer<StationBloc, StationState>(
        listener: (context, state) async {
          if (state.stationStatus == StationStatus.success) {
            _currentStations = state.stations;
            if (_markerIcons.isEmpty) {
              await loadMarkerIcons(_currentZoom, _markerIcons);
            }
            await _buildMarkers(state.stations);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  style: _isSatellite ? null : mapStyle,
                  markers: _markers,
                  mapType: _mapType,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: _initialCameraPosition,
                  onCameraMove: (CameraPosition position) {
                    if ((_currentZoom - position.zoom).abs() > 0.8) {
                      setState(() {
                        _currentZoom = position.zoom;
                      });

                      if (state.stationStatus == StationStatus.success) {
                        _updateMarkersSize();
                      }
                    }
                  },
                  onMapCreated: (controller) async {
                    _googleMapController = controller;
                    await initMapStyle();
                    await initUserLocation();
                    await updateCameraPoition(
                      myLocation ?? LatLng(0, 0),
                      _googleMapController,
                      _initialCameraPosition,
                    );
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16,
                left: AppSize.s16,
                right: AppSize.s16,
                bottom: AppSize.s5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: AppSize.s52,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x3F0F172A),
                                    blurRadius: 24,
                                    offset: Offset(0, 8),
                                    spreadRadius: -10,
                                  ),
                                  BoxShadow(
                                    color: Color(0xB2E1E8F0),
                                    blurRadius: 0,
                                    offset: Offset(0, 0),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                keyboardType: TextInputType.webSearch,
                                decoration: InputDecoration(
                                  hint: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.search,
                                        height: AppSize.s22,
                                        width: AppSize.s22,
                                      ),
                                      const Gap(AppSize.s5),
                                      Text(
                                        appContext.localText.search_lable,
                                        style: AppStyles.getRgular(
                                          context: context,
                                          color: const Color(0xFF90A1B8),
                                          fontSize: AppSize.s16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  getIt<StationBloc>().add(SearchStationsEvent(value));
                                },
                              ),
                            ),
                          ),
                        ),
                        const Gap(AppSize.s5),
                        Container(
                          height: AppSize.s52,
                          width: AppSize.s52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSize.s18),
                            color: AppColors.white,
                            border: Border.all(
                              width: AppSize.s1,
                              color: AppColors.border,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F0F172A),
                                blurRadius: 24,
                                offset: Offset(0, 8),
                                spreadRadius: -10,
                              ),
                              BoxShadow(
                                color: Color(0xB2E1E8F0),
                                blurRadius: 0,
                                offset: Offset(0, 0),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.notification,
                              width: AppSize.s22,
                              height: AppSize.s22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_searchController.text.isNotEmpty && state.stations.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.allStations.length,
                          itemBuilder: (context, index) => SearchStaionWidget(
                            stationModel: state.allStations[index],
                            onTap: () async {
                              final selectedStation = state.allStations[index];
                              FocusScope.of(context).unfocus();
                              _searchController.clear();
                              getIt<StationBloc>().add(SearchStationsEvent(""));
                              await updateCameraPoition(
                                LatLng(
                                  selectedStation.latitude,
                                  selectedStation.longitude,
                                ),
                                _googleMapController,
                                _initialCameraPosition,
                              );
                              _onStationMarkerTap(selectedStation);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              MyLocationAndTogleStyleMap(
                toggleMapType: toggleMapType,
                stationWidgetHeight: _stationWidgetHeight,
                selectMyLoction: selectMyLoction,
                isGettingLocation: _isGettingLocation,
                selectedStation: _selectedStation,
              ),

              StationWidget(
                key: _stationWidgetKey,
                appContext: appContext,
                closeStaion: () {
                  setState(() {
                    _selectedStation = null;
                  });
                },
                selectedStation: _selectedStation,
              ),
            ],
          );
        },
      ),
    );
  }

  void toggleMapType() {
    setState(() {
      _isSatellite = !_isSatellite;
      _mapType = _isSatellite ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> selectMyLoction() async {
    setState(() {
      _isGettingLocation = true;
    });
    log(_isGettingLocation.toString());
    try {
      await getLocation(
        _googleMapController,
        _initialCameraPosition,
      );
      log(_isGettingLocation.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
      log(_isGettingLocation.toString());
    }
  }

  Future<void> initMapStyle() async {
    await rootBundle.loadString(AppAssets.mapStyle).then(
      (style) {
        mapStyle = style;
        setState(() {});
      },
    );
  }

  Future<void> _updateMarkersSize() async {
    await loadMarkerIcons(_currentZoom, _markerIcons);
    if (_currentStations.isNotEmpty) {
      await _buildMarkers(_currentStations);
    }
  }

  void _onStationMarkerTap(StationModel station) {
    setState(() {
      _selectedStation = station;
    });
  }

  Future<void> initUserLocation() async {
    final res = await LocationService.getCurrentLocation();
    res.fold(
      (left) {
        Flushbar(
          message: left,
          backgroundColor: AppColors.lightError,
          messageColor: AppColors.white,
          messageSize: getResponsiveSize(
            context: context,
            fontSize: AppSize.s20,
          ),
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(seconds: 5),
        ).show(context);
      },
      (right) {
        myLocation = LatLng(
          right.latitude,
          right.longitude,
        );
      },
    );
  }

  Future<void> _buildMarkers(List<StationModel> stations) async {
    final markers = <Marker>{};
    for (final station in stations) {
      final icon = _markerIcons[station.status] ?? _markerIcons['unknown']!;
      final marker = Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(station.latitude, station.longitude),
        icon: icon,
        anchor: const Offset(0.5, 1.0),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: station.statusLabel,
        ),
        onTap: () {
          _onStationMarkerTap(station);
        },
      );
      markers.add(marker);
    }

    if (!mounted) return;
    setState(() {
      _markers = markers;
    });
  }
}
