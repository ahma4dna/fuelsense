import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/core/services/app_notification_service.dart';
import 'package:fuelsense/di/injection.dart';
import 'package:fuelsense/features/account/presentation/pages/account_page.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_bloc.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_event.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_state.dart';
import 'package:fuelsense/features/main/presentaion/widgets/custom_bottom_nav_bar.dart';
import 'package:fuelsense/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:fuelsense/features/stations/presentation/pages/stations_page.dart';
import 'package:fuelsense/features/stations_directory/presentation/pages/stations_directory_screen.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<Widget> _pages;
  @override
  void initState() {
    _pages = [
      StationsPage(),
      StationsDirectoryScreen(),
      NotificationsScreen(),
      AccountPage(),
    ];
    super.initState();
    getIt<AppNotificationService>().initialize(
      onNotificationTapped: (stationId) {
        if (stationId != null) {
          // context.push(s);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          final bloc = context.read<MainBloc>();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                IndexedStack(
                  index: state.currntIndex,
                  children: _pages,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.paddingOf(context).bottom,
                  child: CustomBottomNavBar(
                    currentIndex: state.currntIndex,
                    onItemSelected: (selctedIndex) {
                      bloc.add(ChangeTabEvent(selctIndex: selctedIndex));
                    },
                    onAddPressed: () async {},
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
