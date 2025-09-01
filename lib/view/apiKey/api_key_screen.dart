import 'package:crypto_app/view/apiKey/logic/api_key_cubit.dart';
import 'package:crypto_app/view/apiKey/logic/api_key_state.dart';
import 'package:crypto_app/view/apiKey/widgets/custom_gradient_app_bar.dart';
import 'package:crypto_app/view/apiKey/widgets/gradient_button.dart';
import 'package:crypto_app/view/apiKey/widgets/gradient_icon_container.dart';
import 'package:crypto_app/view/apiKey/widgets/gradient_text_field.dart';
import 'package:crypto_app/view/apiKey/widgets/help_text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApiKeyScreen extends StatelessWidget {
  const ApiKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomGradientAppBar(
                title: 'API Configuration',
                onBack: () => Navigator.pushReplacementNamed(context, '/onboarding'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocListener<ApiKeyCubit, ApiKeyState>(
                    listenWhen: (prev, curr) =>
                        prev.isLoading != curr.isLoading ||
                        prev.error != curr.error ||
                        prev.isSuccess != curr.isSuccess,
                    listener: (context, state) {
                      if (state.isSuccess) {
                        Navigator.pushReplacementNamed(context, '/market');
                      }
                    },
                    child: BlocBuilder<ApiKeyCubit, ApiKeyState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const GradientIconContainer(icon: Icons.account_balance_wallet),
                              SizedBox(height: 32.h),
                              Text(
                                'Connect to Nobitex',
                                style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Enter your API key to access real‑time\ncrypto data and trading features',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16.sp, height: 1.5),
                              ),
                              SizedBox(height: 48.h),
                              GradientTextField(
                                label: 'Nobitex API Key',
                                value: state.apiKey,
                                hint: 'Enter your API key here',
                                errorText: state.error,
                                isObscured: state.isObscured,
                                onChanged: (v) => context.read<ApiKeyCubit>().apiKeyChanged(v),
                                onToggleVisibility: () => context.read<ApiKeyCubit>().toggleObscure(),
                              ),
                              SizedBox(height: 32.h),
                              GradientButton(
                                label: 'Save & Continue',
                                isLoading: state.isLoading,
                                onPressed: () => context.read<ApiKeyCubit>().submit(),
                              ),
                              SizedBox(height: 24.h),
                              HelpTextLink(
                                text: 'Need help getting your API key?',
                                onTap: () => _showHelpDialog(context),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const Text('How to get API Key?', style: TextStyle(color: Colors.white)),
        content: Text(
          '1. Go to Nobitex website\n'
          '2. Login to your account\n'
          '3. Navigate to API settings\n'
          '4. Generate a new API key\n'
          '5. Copy and paste it here',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }
}
