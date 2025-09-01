import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _iconController;

  late AnimationController _glowController;

  late Animation<double> _iconScaleAnimation;

  late Animation<double> _iconRotationAnimation;

  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _glowController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.elasticOut));

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.easeInOut));
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _iconController.forward();

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_iconController, _glowController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _iconScaleAnimation.value,
          child: Transform.rotate(
            angle: _iconRotationAnimation.value * 0.1,
            child: Container(
              width: 140.w,
              height: 140.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFE25B),
                    Color(0xFFFFA833),
                    Color(0xFFFFC107)
                  ],
                ),
                borderRadius: BorderRadius.circular(35.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700)
                        .withOpacity(0.4 * _glowAnimation.value),
                    blurRadius: 30 * _glowAnimation.value,
                    spreadRadius: 5 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFFA500)
                        .withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 50 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                ],
              ),
              child: const Icon(Icons.account_balance_wallet,
                  size: 70, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
