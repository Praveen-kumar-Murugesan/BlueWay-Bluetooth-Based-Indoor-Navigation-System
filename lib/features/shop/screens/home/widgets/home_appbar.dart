import 'package:flutter/material.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.cartItems,
  });
  final List<String> cartItems;
  @override
  Widget build(BuildContext context) {
    print("HomeAppBar - Cart Items: $cartItems");
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: TSizes.sm,
          ),
          Text(TTexts.homeAppBarTitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.grey)),
          Text(TTexts.homeAppBarSubTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .apply(color: TColors.white)),
        ],
      ),
      actions: [
        CartCounterIcon(
          onPressed: () {},
          iconColor: TColors.white,
          cartItems: cartItems,
        )
      ],
    );
  }
}
