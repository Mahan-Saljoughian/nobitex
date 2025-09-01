import 'package:crypto_app/main_screen.dart';
import 'package:crypto_app/services/auth_cubit.dart';
import 'package:crypto_app/services/nobitex_service.dart';
import 'package:crypto_app/services/profile_service.dart';
import 'package:crypto_app/services/tab_cubit.dart';
import 'package:crypto_app/view/apiKey/api_key_screen.dart';
import 'package:crypto_app/view/apiKey/logic/api_key_cubit.dart';
import 'package:crypto_app/view/market/logic/market_cubit.dart';
import 'package:crypto_app/view/market/logic/market_state.dart';
import 'package:crypto_app/view/onBoarding/logic/onboarding_cubit.dart';
import 'package:crypto_app/view/onBoarding/on_boarding_screen.dart';
import 'package:crypto_app/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:crypto_app/core/animations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthCubit(nobitexService: NobitexService()),
      child: const CryptoApp(),
    ),
  );
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            BlocProvider(create: (_) => TabCubit()),
            Provider<NobitexService>(
              create: (context) {
                final authCubit = context.read<AuthCubit>();
                return NobitexService(
                  onUnauthorized: ({String? error}) =>
                      authCubit.logout(error: error),
                );
              },
            ),
            Provider<ProfileService>(
              create: (context) =>
                  ProfileService(context.read<NobitexService>()),
            ),
            BlocProvider<ApiKeyCubit>(
              create: (context) => ApiKeyCubit(
                context.read<NobitexService>(),
                context.read<AuthCubit>(),
              ),
            ),
            BlocProvider<OnboardingCubit>(
              create: (_) => OnboardingCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Crypto',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFF0F0F1E),
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }),
            ),
            home: BlocConsumer<AuthCubit, AuthState>(
              listenWhen: (prev, current) =>
                  prev.error != current.error && current.error != null,
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.error!),
                        backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return Scaffold(
                    body: Center(
                      child: Lottie.asset(
                        JsonAssets.splashCrypto,
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }

                if (state.isAuthenticated && state.token != null) {
                  return BlocProvider(
                    create: (context) => MarketCubit(
                      service: context.read<NobitexService>(),
                      token: state.token!,
                    )..fetchMarketStats(),
                    child: BlocBuilder<MarketCubit, MarketState>(
                      builder: (context, marketState) {
                        if (marketState.isLoading) {
                          return Scaffold(
                            body: Center(
                              child: Lottie.asset(
                                JsonAssets.splashCrypto,
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }
                        return MainScreen();
                      },
                    ),
                  );
                }
                return const SplashScreen();
              },
            ),
            routes: {
              '/onboarding': (_) => const OnboardingScreen(),
              '/api-key': (_) => const ApiKeyScreen(),
              '/market': (_) => BlocProvider(
                    create: (context) => MarketCubit(
                      service: context.read<NobitexService>(),
                      token: context.read<AuthCubit>().state.token!,
                    )..fetchMarketStats(),
                    child: MainScreen(),
                  ),
            },
          ),
        );
      },
    );
  }
}
