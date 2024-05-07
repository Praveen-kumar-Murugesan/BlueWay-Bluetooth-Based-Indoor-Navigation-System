import 'package:bluecart1/common/widgets/layouts/grid_layout.dart';
import 'package:bluecart1/common/widgets/products/product_cards/products_card_vertical.dart';
import 'package:bluecart1/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../utils/constants/sizes.dart';

class CartController extends GetxController {
  RxList<String> cartItems = <String>[].obs;

  void addToCart(String item) {
    if (!cartItems.contains(item)) {
      cartItems.add(item);
    } else if (cartItems.contains(item)) {
      cartItems.remove(item);
    }

    print(cartItems);
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    List<String> cartItems = [];
    final List<String> productTitles = [
      'A102',
      'A103',
      'A104',
      'C102',
      'C103',
      'C104',
      'Front Office',
      'Back Office',
    ];
    print("HomeScreen - Cart Items: ${cartController.cartItems.toList()}");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  HomeAppBar(
                    cartItems: cartController.cartItems.toList(),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  const SearchContainer(
                    text: 'Where to Next?',
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  GridLayout(
                      itemCount: 8,
                      itemBuilder: (_, index) => ProductCardVertical(
                            title: productTitles[index],
                            onAddToCart: (title) {
                              cartController.addToCart(title);
                            },
                          ))
                ],
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
          ],
        ),
      ),
    );
  }
}
