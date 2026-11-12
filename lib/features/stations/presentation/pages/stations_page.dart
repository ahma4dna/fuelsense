import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:fuelsense/core/services/app_notification_service.dart';
import 'package:fuelsense/core/utils/location_service.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/notifications/routes/notifications_path.dart';
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

class _StationsPageState extends State<StationsPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late CameraPosition _initialCameraPosition;
  late GoogleMapController _googleMapController;
  LatLng? myLocation;

  List<StationEntity> _currentStations = [];
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _markerIcons = {};
  StationEntity? _selectedStation;

  StationEntity? _lastStation;

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

  bool _mapReady = false;
  Timer? _zoomDebounce;
  late final AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _initialCameraPosition = const CameraPosition(
      target: LatLng(32.79130167286812, 12.486110373636903),
      zoom: 15,
    );
    getIt<StationsBloc>().add(WatchStationsEvent());
    loadMarkerIcons(_currentZoom, _markerIcons);
    _updateStationWidgetSize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _zoomDebounce?.cancel();
    _refreshController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      getIt<StationsBloc>().add(WatchStationsEvent());
    }
  }

  Future<void> _onSearchResultTap(StationEntity station) async {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    getIt<StationsBloc>().add(const SearchStationsEvent(""));
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

  void _onRefreshPressed(BuildContext context) {
    HapticFeedback.lightImpact();
    _refreshController.forward(from: 0);
    getIt<StationsBloc>().add(WatchStationsEvent());
    Flushbar(
      message: "جاري تحديث بيانات المحطات...",
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.primary,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(14),
      animationDuration: const Duration(milliseconds: 450),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    ).show(context);
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
                  _lastStation = st;
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
          final hasSelection = _selectedStation != null;

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
                      _zoomDebounce?.cancel();
                      _zoomDebounce = Timer(const Duration(milliseconds: 180), () {
                        if (mounted && _currentStations.isNotEmpty) {
                          _updateMarkersSize();
                        }
                      });
                    }
                  },
                  onMapCreated: (controller) async {
                    _googleMapController = controller;
                    await initMapStyle();
                    await initUserLocation();
                    await getIt<AppNotificationService>().initialize(
                      onNotificationTapped: (stationId) {
                        if (stationId != null) {
                          context.push(notificationsPath);
                        }
                      },
                    );
                    if (myLocation != null && mounted) {
                      await _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: myLocation!, zoom: _initialCameraPosition.zoom),
                        ),
                      );
                    }
                  },
                ),
              ),

              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _mapReady ? 0 : 1,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    child: const ColoredBox(color: AppColors.white),
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16 + AppSize.s52 + AppSize.s60,
                right: AppSize.s16,
                child: _EntranceAnimation(
                  delay: const Duration(milliseconds: 350),
                  offset: const Offset(24, 0),
                  child: FloatingActionButton.small(
                    heroTag: "refresh_stations_btn",
                    backgroundColor: AppColors.white,
                    onPressed: () => _onRefreshPressed(context),
                    child: RotationTransition(
                      turns: CurvedAnimation(
                        parent: _refreshController,
                        curve: Curves.easeInOutCubic,
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16,
                left: AppSize.s16,
                right: AppSize.s16,
                bottom: AppSize.s5,
                child: _EntranceAnimation(
                  delay: const Duration(milliseconds: 100),
                  offset: const Offset(0, -24),
                  child: SearchAndNotificationHeaderWidget(
                    appContext: appContext,
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    onStationSelected: _onSearchResultTap,
                    state: state,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSize.s16 + AppSize.s52 + AppSize.s8,
                left: AppSize.s16,
                right: AppSize.s16,
                child: _EntranceAnimation(
                  delay: const Duration(milliseconds: 220),
                  offset: const Offset(0, -16),
                  child: FilterList(
                    searchFocusNode: _searchFocusNode,
                    state: state,
                  ),
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
                  ignoring: !hasSelection,
                  child: AnimatedSlide(
                    offset: hasSelection ? Offset.zero : const Offset(0, 1.3),
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: hasSelection ? 1 : 0,
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      child: Dismissible(
                        key: ValueKey(_dismissKeyCounter),
                        direction: hasSelection ? DismissDirection.down : DismissDirection.none,
                        onDismissed: (_) {
                          setState(() {
                            _selectedStation = null;
                            _dismissKeyCounter++;
                          });
                        },
                        child: StationWidget(
                          state: state,
                          key: _stationWidgetKey,
                          selectedStation: _selectedStation ?? _lastStation,
                          userLocation: myLocation,
                          todayReports: state.todayReports,
                          onViewDetailsPressed: () {
                            context.pushNamed(
                              stationHistoryName,
                              extra: _selectedStation ?? _lastStation,
                            );
                          },
                          onOpenRoutePressed: () async {
                            final s = _selectedStation ?? _lastStation;
                            await LocationService.openMap(
                              latitude: s?.latitude ?? 0,
                              longitude: s?.longitude ?? 0,
                            );
                          },
                        ),
                      ),
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
    HapticFeedback.selectionClick();
    setState(() {
      _isSatellite = !_isSatellite;
      _mapType = _isSatellite ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> selectMyLoction() async {
    HapticFeedback.selectionClick();
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
    try {
      final style = await rootBundle.loadString(AppAssets.mapStyle);
      mapStyle = style;
    } finally {
      if (mounted) {
        setState(() {
          _mapReady = true;
        });
      }
    }
  }

  Future<void> _updateMarkersSize() async {
    await loadMarkerIcons(_currentZoom, _markerIcons);
    if (_currentStations.isNotEmpty) {
      await _buildMarkers(_currentStations);
    }
  }

  void _onStationMarkerTap(StationEntity station) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedStation = station;
      _lastStation = station;
    });
    getIt<StationsBloc>().add(
      SelectStationEvent(
        station: station,
        userLatitude: myLocation?.latitude,
        userLongitude: myLocation?.longitude,
      ),
    );

    try {
      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(station.latitude, station.longitude),
          math.max(_currentZoom, 15),
        ),
      );
    } catch (_) {}

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
          margin: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(14),
          animationDuration: const Duration(milliseconds: 450),
          forwardAnimationCurve: Curves.easeOutCubic,
          reverseAnimationCurve: Curves.easeInCubic,
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

class _EntranceAnimation extends StatefulWidget {
  const _EntranceAnimation({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 20),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  State<_EntranceAnimation> createState() => _EntranceAnimationState();
}

class _EntranceAnimationState extends State<_EntranceAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _timer = Timer(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final t = _curve.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(
              widget.offset.dx * (1 - t),
              widget.offset.dy * (1 - t),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
