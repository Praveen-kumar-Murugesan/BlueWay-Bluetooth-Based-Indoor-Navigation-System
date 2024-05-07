import 'package:bluecart1/features/authentication/screens/onboarding/onboarding.dart';
import 'package:bluecart1/providers/ble_provider.dart';
import 'package:bluecart1/providers/cart.dart';
import 'package:bluecart1/providers/cart_id.dart';
import 'package:bluecart1/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartIDProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BLEProvider(),
        ),
      ],
      child: GetMaterialApp(
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        home: const OnBoardingScreen(),
      ),
    );
  }
}
