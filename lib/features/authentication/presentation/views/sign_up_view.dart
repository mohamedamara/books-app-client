import 'package:books_app_client/core/extensions/context_extension.dart';
import 'package:books_app_client/core/extensions/string_extension.dart';
import 'package:books_app_client/core/widgets/custom_textfield.dart';
import 'package:books_app_client/core/widgets/primary_button.dart';
import 'package:books_app_client/features/authentication/presentation/controllers/authentication_controller.dart';
import 'package:books_app_client/features/authentication/presentation/views/widgets/checkbox_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/navigation/navigation_paths.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../enums/authentication_status.dart';

class SignUpView extends HookConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameTextEditingController = useTextEditingController();
    final lastNameTextEditingController = useTextEditingController();
    final emailTextEditingController = useTextEditingController();
    final passwordTextEditingController = useTextEditingController();
    final isMonthlyNewsletterChecked = useState(false);
    final areAllTextFieldsValid = useState(false);

    void validateTextFields() {
      bool isFirstNameValid = firstNameTextEditingController.text.isNotEmpty;
      bool isLastNameValid = lastNameTextEditingController.text.isNotEmpty;
      bool isEmailValid = emailTextEditingController.text.isValidEmail;
      bool isPasswordValid = passwordTextEditingController.text.length >= 8;
      areAllTextFieldsValid.value =
          isFirstNameValid && isLastNameValid && isEmailValid && isPasswordValid
              ? true
              : false;
    }

    ref.listen(authenticationControllerProvider, (_, current) {
      if (current is AsyncError && current.error is Failure) {
        showSnackBar(
          context: context,
          message: current.error.toString(),
          messageType: SnackBarMessageType.failure,
        );
      } else if (current is AsyncData &&
          current.value == AuthenticationStatus.authenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          NavigationPaths.topNavigationRoute,
          (Route<dynamic> route) => false,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.setHeight(30)),
              Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: context.setHeight(20)),
              CustomTextField(
                controller: firstNameTextEditingController,
                labelText: "First Name",
                keyboardType: TextInputType.name,
                onChanged: (_) => validateTextFields(),
              ),
              SizedBox(height: context.setHeight(20)),
              CustomTextField(
                controller: lastNameTextEditingController,
                labelText: "Last Name",
                keyboardType: TextInputType.name,
                onChanged: (_) => validateTextFields(),
              ),
              SizedBox(height: context.setHeight(20)),
              CustomTextField(
                controller: emailTextEditingController,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => validateTextFields(),
              ),
              SizedBox(height: context.setHeight(20)),
              CustomTextField(
                controller: passwordTextEditingController,
                labelText: "Password",
                obscureText: true,
                onChanged: (_) => validateTextFields(),
              ),
              SizedBox(height: context.setHeight(21)),
              CheckboxWithLabel(
                text: "Please sign me up for the monthly newsletter.",
                isChecked: isMonthlyNewsletterChecked.value,
                onChanged: (_) {
                  isMonthlyNewsletterChecked.value =
                      !isMonthlyNewsletterChecked.value;
                },
                onTextPressed: () {
                  isMonthlyNewsletterChecked.value =
                      !isMonthlyNewsletterChecked.value;
                },
              ),
              SizedBox(height: context.setHeight(25)),
              PrimaryButtoon(
                buttonText: "Sign Up",
                isEnabled: areAllTextFieldsValid.value,
                isLoading:
                    ref.watch(authenticationControllerProvider) is AsyncLoading,
                onPressed: () {
                  ref.read(authenticationControllerProvider.notifier).signUp(
                        firstName: firstNameTextEditingController.text,
                        lastName: lastNameTextEditingController.text,
                        email: emailTextEditingController.text.toLowerCase(),
                        password: passwordTextEditingController.text,
                      );
                },
              ),
              SizedBox(height: context.setHeight(30)),
            ],
          ),
        ),
      ),
    );
  }
}
