import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE25B), Color(0xFFFFA833)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.4),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24),
    );
  }
}
