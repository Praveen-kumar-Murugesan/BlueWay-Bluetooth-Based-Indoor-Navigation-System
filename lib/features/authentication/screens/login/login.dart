import 'package:bluecart1/common/styles/spacing_styles.dart';
import 'package:bluecart1/features/authentication/screens/login/widgets/login_form.dart';
import 'package:bluecart1/features/authentication/screens/login/widgets/login_header.dart';
import 'package:bluecart1/utils/constants/sizes.dart';
import 'package:bluecart1/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              const LoginHeader(),
              const LoginForm(),
              FormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const SocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
