import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/stations/domain/entities/station_entity.dart';
import 'package:fuelsense/features/stations/domain/enums/station_enums.dart';
import 'package:fuelsense/features/stations/domain/extensions/station_extensions.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_bloc.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_event.dart';
import 'package:fuelsense/features/stations/presentation/bloc/stations_state.dart';
import 'package:fuelsense/features/stations/presentation/function/function_home_page.dart';
import 'package:fuelsense/features/stations/presentation/routes/stations_path.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/filter_list.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/my_location_and_togle_style_map.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/search_and_notification_header_widget.dart';
import 'package:fuelsense/features/stations/presentation/widgets/home_screen_widget/station_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationsPage extends StatefulWidget {
  const StationsPage({super.key});

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> with WidgetsBindingObserver {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _googleMapController;
  LatLng? myLocation;

  List<StationEntity> _currentStations = [];
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _markerIcons = {};
  StationEntity? _selectedStation;
  int _dismissKeyCounter = 0;
  String? mapStyle;
  bool _isGettingLocation = false;
  double _currentZoom = 15.0;
  final GlobalKey _stationWidgetKey = GlobalKey();
  double _stationWidgetHeight = 0;
  MapType _mapType = MapType.normal;
  bool _isSatellite = false;
  late TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _initialCameraPosition = const CameraPosition(
      target: LatLng(32.79130167286812, 12.486110373636903),
      zoom: 15,
    );
    getIt<StationsBloc>().add(WatchStationsEvent());
    loadMarkerIcons(_currentZoom, _markerIcons);
    _updateStationWidgetSize();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log(state.toString());

    if (state == AppLifecycleState.resumed) {
      getIt<StationsBloc>().add(WatchStationsEvent());
    }
  }

  Future<void> _onSearchResultTap(StationEntity station) async {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    getIt<StationsBloc>().add(const SearchStationsEvent(""));
    await updateCameraPoition(
      LatLng(station.latitude, station.longitude),
      _googleMapController,
      _initialCameraPosition,
    );
    _onStationMarkerTap(station);
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
      value: getIt<StationsBloc>(),
      child: BlocConsumer<StationsBloc, StationsState>(
        listenWhen: (previous, current) =>
            previous.stationsStatus != current.stationsStatus || previous.filteredStations != current.filteredStations,
        listener: (context, state) async {
          if (state.stationsStatus == StationsDataStatus.loaded) {
            _currentStations = state.filteredStations;

            if (_selectedStation != null) {
              for (final st in state.allStations) {
                if (st.id == _selectedStation!.id) {
                  _selectedStation = st;
                  break;
                }
              }
            }

            if (_markerIcons.isEmpty) {
              await loadMarkerIcons(_currentZoom, _markerIcons);
            }

            await _buildMarkers(state.filteredStations);
          }
        },
        buildWhen: (previous, current) =>
            previous.stationsStatus != current.stationsStatus ||
            previous.filteredStations != current.filteredStations ||
            previous.selectedStation != current.selectedStation ||
            previous.activeQuickFilter != current.activeQuickFilter ||
            previous.selectedCityFilter != current.selectedCityFilter ||
            previous.searchQuery != current.searchQuery ||
            previous.todayReportsStatus != current.todayReportsStatus ||
            previous.historyStatus != current.historyStatus ||
            previous.todayReports != current.todayReports,
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  style: _isSatellite ? null : mapStyle,
                  markers: _markers,
                  mapType: _mapType,
                  onTap: (argument) {
                    if (_selectedStation != null) {
                      setState(() {
                        _selectedStation = null;
                      });
                    }
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _initialCameraPosition,
                  onCameraMove: (CameraPosition position) {
                    if ((_currentZoom - position.zoom).abs() > 0.8) {
                      _currentZoom = position.zoom;
                      if (state.stationsStatus == StationsDataStatus.loaded) {
                        _updateMarkersSize();
                      }
                    }
                  },
                  onMapCreated: (controller) async {
                    _googleMapController = controller;
                    await initMapStyle();
                    await initUserLocation();
                    await updateCameraPoition(
                      myLocation ?? const LatLng(0, 0),
                      _googleMapController,
                      _initialCameraPosition,
                    );
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16 + AppSize.s52 + AppSize.s60,
                right: AppSize.s16,
                child: FloatingActionButton.small(
                  heroTag: "refresh_stations_btn",
                  backgroundColor: AppColors.white,
                  onPressed: () {
                    getIt<StationsBloc>().add(WatchStationsEvent());
                    Flushbar(
                      message: "جاري تحديث بيانات المحطات...",
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.primary,
                    ).show(context);
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: AppColors.black,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16,
                left: AppSize.s16,
                right: AppSize.s16,
                bottom: AppSize.s5,
                child: SearchAndNotificationHeaderWidget(
                  appContext: appContext,
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode,
                  onStationSelected: _onSearchResultTap,
                  state: state,
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16 + AppSize.s52 + AppSize.s8,
                left: AppSize.s16,
                right: AppSize.s16,
                child: FilterList(
                  searchFocusNode: _searchFocusNode,
                  state: state,
                ),
              ),
              MyLocationAndTogleStyleMap(
                toggleMapType: toggleMapType,
                stationWidgetHeight: _stationWidgetHeight,
                selectMyLoction: selectMyLoction,
                isGettingLocation: _isGettingLocation,
                selectedStation: _selectedStation,
              ),
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + AppSize.s73,
                left: AppSize.s8,
                right: AppSize.s8,
                child: IgnorePointer(
                  ignoring: _selectedStation == null,
                  child: Dismissible(
                    key: ValueKey(_dismissKeyCounter),
                    direction: _selectedStation != null ? DismissDirection.down : DismissDirection.none,
                    onDismissed: (_) {
                      setState(() {
                        _selectedStation = null;
                        _dismissKeyCounter++;
                      });
                    },
                    child: StationWidget(
                      state: state,
                      key: _stationWidgetKey,
                      selectedStation: _selectedStation,
                      userLocation: myLocation,
                      todayReports: state.todayReports,
                      onViewDetailsPressed: () {
                        context.pushNamed(
                          stationHistoryName,
                          extra: _selectedStation,
                        );
                      },
                      onOpenRoutePressed: () async {
                        await LocationService.openMap(
                          latitude: _selectedStation?.latitude ?? 0,
                          longitude: _selectedStation?.longitude ?? 0,
                        );
                      },
                    ),
                  ),
                ),
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

  void _onStationMarkerTap(StationEntity station) {
    setState(() {
      _selectedStation = station;
    });
    getIt<StationsBloc>().add(
      SelectStationEvent(
        station: station,
        userLatitude: myLocation?.latitude,
        userLongitude: myLocation?.longitude,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateStationWidgetSize();
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
        setState(() {
          myLocation = LatLng(
            right.latitude,
            right.longitude,
          );
        });
      },
    );
  }

  Future<void> _buildMarkers(List<StationEntity> stations) async {
    final markers = <Marker>{};
    for (final station in stations) {
      final icon = _markerIcons[station.status.dbValue] ?? _markerIcons['unknown']!;
      final marker = Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(station.latitude, station.longitude),
        icon: icon,
        anchor: const Offset(0.5, 1.0),
        infoWindow: InfoWindow(
          title: station.name,
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
