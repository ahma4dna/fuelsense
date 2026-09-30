import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuelsense/core/application/resource/app_assets.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onAddPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final AppContext appContext = AppContext.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SizedBox(
          height: 105,
          child: Container(
            height: 88,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(38),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Home
                Expanded(
                  child: _NavItem(
                    index: 0,
                    label: appContext.localText.home,
                    icon: AppAssets.home,
                    currentIndex: currentIndex,
                    onTap: onItemSelected,
                  ),
                ),
                // Accounts
                Expanded(
                  child: _NavItem(
                    index: 1,
                    label: appContext.localText.staions,
                    icon: AppAssets.staions,
                    currentIndex: currentIndex,
                    onTap: onItemSelected,
                  ),
                ),

                // Budgets
                Expanded(
                  child: _NavItem(
                    index: 2,
                    label: appContext.localText.reports,
                    icon: AppAssets.reports,
                    currentIndex: currentIndex,
                    onTap: onItemSelected,
                  ),
                ),
                // Reports
                Expanded(
                  child: _NavItem(
                    index: 3,
                    label: appContext.localText.account,
                    icon: AppAssets.account,
                    currentIndex: currentIndex,
                    onTap: onItemSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Navigation Item
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.label,

    required this.icon,
    required this.currentIndex,
    required this.onTap,
  });

  final int index;
  final String label;

  final String icon;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF03BFA6).withValues(alpha: 0.08),
                        const Color(0xFF03BFA6).withValues(alpha: 0.04),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF0D5C56).withValues(alpha: 0.12),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D5C56).withValues(alpha: 0.08),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),

                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.7),
                        blurRadius: 8,
                        spreadRadius: -2,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      icon,
                      key: ValueKey(isActive),
                      colorFilter: ColorFilter.mode(isActive ? Color(0XFF0F766E) : Color(0XFF91A0B9), BlendMode.srcIn),
                      width: getResponsiveSize(context: context, fontSize: 30),
                      height: getResponsiveSize(context: context, fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: AppStyles.getBold(
                      context: context,
                      color: isActive ? const Color(0xFF0F172A) : const Color(0xFF90A1B8),
                      fontSize: AppSize.s14,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
