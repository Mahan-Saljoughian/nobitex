// lib/view/main/main_screen.dart
import 'package:crypto_app/services/nobitex_service.dart';
import 'package:crypto_app/services/tab_cubit.dart';
import 'package:crypto_app/view/market/market_screen.dart';
import 'package:crypto_app/view/profile/profile_screen.dart';
import 'package:crypto_app/view/wallet/logic/wallet_cubit.dart';
import 'package:crypto_app/view/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_cubit.dart';
import 'widgets/custom_curved_nav_bar.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    profileTabNavKey,
  ];

  Future<bool> _onWillPop(BuildContext context, int selectedIndex) async {
    if (selectedIndex != 0) {
      context.read<TabCubit>().changeTab(0);
      return false;
    }
    return true;
  }

  Widget _buildNavigator(GlobalKey<NavigatorState> key, Widget child) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, int>(
      builder: (context, selectedIndex) {
        return WillPopScope(
          onWillPop: () => _onWillPop(context, selectedIndex),
          child: Scaffold(
            backgroundColor: const Color(0xFF0F0F1E),
            body: IndexedStack(
              index: selectedIndex,
              children: [
                _buildNavigator(_navigatorKeys[0], const MarketScreen()),
                _buildNavigator(
                  _navigatorKeys[1],
                  BlocProvider(
                    create: (context) {
                      final token = context.read<AuthCubit>().state.token!;
                      return WalletCubit(
                        nobitexService: context.read<NobitexService>(),
                        token: token,
                      )..fetchWallets();
                    },
                    child: const WalletScreen(),
                  ),
                ),
                _buildNavigator(
                  _navigatorKeys[2],
                  const PlaceholderScreen(screenName: "Trade"),
                ),
                _buildNavigator(
                  _navigatorKeys[3],
                  const ProfileScreenWrapper(),
                ),
              ],
            ),
            bottomNavigationBar: CustomCurvedNavBar(
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                if (index == selectedIndex) {
                  _navigatorKeys[index]
                      .currentState!
                      .popUntil((route) => route.isFirst);
                } else {
                  context.read<TabCubit>().changeTab(index);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String screenName;
  const PlaceholderScreen({super.key, required this.screenName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Center(
        child: Text(
          screenName,
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}
