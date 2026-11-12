import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuelsense/features/account/presentation/pages/account_page.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_bloc.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_event.dart';
import 'package:fuelsense/features/main/presentaion/state_manege/bloc/main_state.dart';
import 'package:fuelsense/features/main/presentaion/widgets/custom_bottom_nav_bar.dart';
import 'package:fuelsense/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:fuelsense/features/stations/presentation/pages/stations_page.dart';
import 'package:fuelsense/features/stations_directory/presentation/pages/stations_directory_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<Widget Function()> _pageBuilders;

  final Set<int> _visited = {0};
  final Map<int, Widget> _builtPages = {};

  @override
  void initState() {
    super.initState();
    _pageBuilders = [
      () => const StationsPage(),
      () => const StationsDirectoryScreen(),
      () => const NotificationsScreen(),
      () => const AccountPage(),
    ];
  }

  Widget _pageAt(int index) {
    return _builtPages.putIfAbsent(index, () => _pageBuilders[index]());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          final bloc = context.read<MainBloc>();
          final current = state.currntIndex;
          _visited.add(current);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                IndexedStack(
                  index: current,
                  children: [
                    for (int i = 0; i < _pageBuilders.length; i++)
                      if (_visited.contains(i))
                        i == 0 ? _pageAt(i) : _TabFadeIn(active: i == current, child: _pageAt(i))
                      else
                        const SizedBox.shrink(),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.paddingOf(context).bottom,
                  child: _NavBarEntrance(
                    child: CustomBottomNavBar(
                      currentIndex: current,
                      onItemSelected: (selctedIndex) {
                        bloc.add(ChangeTabEvent(selctIndex: selctedIndex));
                      },
                      onAddPressed: () async {},
                    ),
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

class _TabFadeIn extends StatefulWidget {
  const _TabFadeIn({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_TabFadeIn> createState() => _TabFadeInState();
}

class _TabFadeInState extends State<_TabFadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curved;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.active) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _TabFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      child: widget.child,
      builder: (context, child) {
        final t = _curved.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}

class _NavBarEntrance extends StatelessWidget {
  const _NavBarEntrance({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 80 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}
