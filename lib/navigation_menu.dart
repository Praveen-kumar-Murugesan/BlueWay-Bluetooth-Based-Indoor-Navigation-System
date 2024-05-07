import 'package:bluecart1/features/shop/screens/bluetooth/bluetooth.dart';
import 'package:bluecart1/features/shop/screens/cart/cart.dart';
import 'package:bluecart1/features/shop/screens/home/home.dart';
import 'package:bluecart1/features/shop/screens/map/map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/shop/screens/Geo/geo.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.route_square), label: 'NavQ'),
            NavigationDestination(icon: Icon(Iconsax.location), label: 'Map'),
            NavigationDestination(icon: Icon(Iconsax.component), label: 'Geo'),
            NavigationDestination(
                icon: Icon(Iconsax.bluetooth), label: 'Buetooth'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    const CartScreen(cartItems: []),
    const MapScreen(),
    const GeoScreen(),
    const BluetoothScreen(),
  ];
}
