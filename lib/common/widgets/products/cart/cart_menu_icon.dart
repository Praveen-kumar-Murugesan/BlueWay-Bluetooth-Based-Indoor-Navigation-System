import 'package:bluecart1/features/shop/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({
    super.key,
    required this.onPressed,
    required this.iconColor,
    required this.cartItems,
  });

  final VoidCallback onPressed;
  final Color iconColor;
  final List<String> cartItems;

  @override
  Widget build(BuildContext context) {
    print("CartCounterIcon - Cart Items: $cartItems");
    return Stack(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Iconsax.notification,
                  color: iconColor,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Iconsax.user,
                  color: iconColor,
                )),
          ],
        ),
        // Positioned(
        //   right: 0,
        //   child: Container(
        //     width: 18,
        //     height: 18,
        //     decoration: BoxDecoration(
        //       color: TColors.black.withOpacity(0.5),
        //       borderRadius: BorderRadius.circular(100),
        //     ),
        //     child: Center(
        //       child: Text(
        //         '2',
        //         style: Theme.of(context)
        //             .textTheme
        //             .labelLarge!
        //             .apply(color: TColors.white, fontSizeFactor: 0.85),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
