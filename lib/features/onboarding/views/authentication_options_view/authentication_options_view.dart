import 'package:books_app_client/core/extensions/context_extension.dart';
import 'package:books_app_client/features/onboarding/views/authentication_options_view/widgets/bottom_section.dart';
import 'package:books_app_client/features/onboarding/views/authentication_options_view/widgets/top_section.dart';
import 'package:flutter/material.dart';

class AuthenticationOptionsView extends StatelessWidget {
  const AuthenticationOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopSection(),
        SizedBox(height: context.setHeight(20)),
        const BottomSection(),
      ],
    );
  }
}
