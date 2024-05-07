import 'package:bluecart1/common/styles/shadows.dart';
import 'package:bluecart1/common/widgets/texts/product_title_text.dart';
import 'package:bluecart1/features/shop/screens/home/widgets/rounded_container.dart';
import 'package:bluecart1/features/shop/screens/home/widgets/rounded_image.dart';
import 'package:bluecart1/providers/cart.dart';
import 'package:bluecart1/utils/constants/colors.dart';
import 'package:bluecart1/utils/constants/image_strings.dart';
import 'package:bluecart1/utils/constants/sizes.dart';
import 'package:bluecart1/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical(
      {super.key, required this.title, required this.onAddToCart});

  final String title;

  final Function(String) onAddToCart;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: Colors.transparent, // Ensure Material widget is transparent
      child: InkWell(
        onTap: () {
          // onAddToCart(title);
          context.read<CartProvider>().addItemToCart(item: title);
          // FocusManager.instance.primaryFocus?.unfocus();
        },
        borderRadius: BorderRadius.circular(TSizes.productImageRadius),
        splashColor: TColors.primary.withOpacity(0.2), // Custom splash color
        highlightColor:
            TColors.primary.withOpacity(0.1), // Custom highlight color
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            boxShadow: [],
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: THelperFunctions.isDarkMode(context)
                ? TColors.darkerGrey
                : TColors.grey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedContainer(
                height: 165,
                padding: const EdgeInsets.all(TSizes.borderRadiusLg / 2),
                backgroundColor: dark ? TColors.dark : TColors.darkerGrey,
                child: const Stack(
                  children: [
                    RoundedImage(
                      imageUrl: TImages.product,
                      applyImageRadius: true,
                    ),
                    // RoundedContainer(
                    //   radius: TSizes.sm,
                    //   backgroundColor: TColors.secondary.withOpacity(0.8),
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: TSizes.sm, vertical: TSizes.xs),
                    // )
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const ProductTitleText(
                    //   title: 'A102',
                    //   smallSize: false,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductTitleText(
                              title: title,
                              smallSize: false,
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems / 4,
                            ),
                            Text(
                              'AB3 Ground Floor',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems / 2,
                            ),
                          ],
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: TColors.dark,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(TSizes.cardRadiusMd),
                                bottomRight:
                                    Radius.circular(TSizes.productImageRadius),
                              )),
                          child: const SizedBox(
                            width: TSizes.iconLg * 1.2,
                            height: TSizes.iconLg * 1.35,
                            child: Center(
                              child: Icon(
                                Iconsax.add,
                                color: TColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
