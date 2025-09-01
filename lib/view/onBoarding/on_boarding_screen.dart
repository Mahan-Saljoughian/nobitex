import 'package:crypto_app/view/onBoarding/logic/onboarding_cubit.dart';
import 'package:crypto_app/view/onBoarding/widgets/onboarding_done_button.dart';
import 'package:crypto_app/view/onBoarding/widgets/onboarding_next_button.dart';
import 'package:crypto_app/view/onBoarding/widgets/onboarding_page_content.dart';
import 'package:crypto_app/view/onBoarding/widgets/onboarding_skip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D0D2B),
              Color(0xFF1B1B3A),
              Color(0xFF22223B),
            ],
          ),
        ),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "",
              bodyWidget: const OnboardingPageContent(
                title: "Welcome to Nobitex",
                subtitle: "Buy, sell & track coins securely in one place",
                icon: Icons.account_balance_wallet,
                iconColor: Color(0xFFFFD700),
                glowColor: Color(0xFFFFD700),
              ),
            ),
            PageViewModel(
              title: "",
              bodyWidget: const OnboardingPageContent(
                title: "Live Market Data",
                subtitle: "Real-time prices & charts, updated every 1s",
                icon: Icons.show_chart,
                iconColor: Color(0xFF00E676),
                glowColor: Color(0xFF00E676),
              ),
            ),
            PageViewModel(
              title: "",
              bodyWidget: const OnboardingPageContent(
                title: "Bank-Level Security",
                subtitle: "Encrypted transactions & data protection",
                icon: Icons.shield,
                iconColor: Color(0xFFFF6B35),
                glowColor: Color(0xFFFF6B35),
              ),
            ),
          ],
          onDone: () =>
              context.read<OnboardingCubit>().completeOnboarding(context),
          onSkip: () => context.read<OnboardingCubit>().skipOnboarding(context),
          showSkipButton: true,
          skip: OnboardingSkipButton(
              onTap: () =>
                  context.read<OnboardingCubit>().skipOnboarding(context)),
          next: const OnboardingNextButton(),
          done: OnboardingDoneButton(
              onTap: () =>
                  context.read<OnboardingCubit>().completeOnboarding(context)),
          dotsDecorator: DotsDecorator(
            size: Size(12.w, 12.h),
            activeSize: Size(24.w, 12.h),
            activeColor: const Color(0xFFFFD700),
            color: Colors.white.withOpacity(0.3),
            spacing: EdgeInsets.symmetric(horizontal: 4.w),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r)),
          ),
          globalBackgroundColor: Colors.transparent,
          animationDuration: 300,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
