// lib/view/widgets/custom_google_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomCurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomCurvedNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    // The CurvedNavigationBar always positions itself at the bottom.
    // It doesn't use SafeArea inside, so you may need extra padding if your app has edge constraints.
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: Colors.transparent, // matches crypto dark theme
        color: Colors.cyanAccent.withOpacity(0.15),
        buttonBackgroundColor: Colors.cyanAccent,
        height: 60,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        items: const [
          Icon(Icons.candlestick_chart_outlined, size: 28, color: Colors.white),
          Icon(Icons.account_balance_wallet_outlined,
              size: 28, color: Colors.white),
          Icon(Icons.swap_horiz_rounded, size: 28, color: Colors.white),
          Icon(Icons.person_outline, size: 28, color: Colors.white),
        ],
        onTap: onTabChange,
      ),
    );
  }
}
