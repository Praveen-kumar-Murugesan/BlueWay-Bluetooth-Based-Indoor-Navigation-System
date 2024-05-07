import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/texts/product_title_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../home/widgets/rounded_image.dart';

import 'package:flutter/material.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({Key? key, required this.title, required this.onRemove})
      : super(key: key);

  final String title;
  final Function(String) onRemove; // Callback function to remove item

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RoundedImage(
              imageUrl: '', // Assuming image is not required here
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(TSizes.xs),
              backgroundColor: dark ? TColors.darkerGrey : TColors.light,
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductTitleText(
                  title: title,
                  smallSize: false,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: TSizes.xs,
                ),
                const ProductTitleText(
                  title: 'AB3 Ground Floor',
                  smallSize: true,
                  maxLines: 1,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          width: 30,
          height: 35,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(7),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: IconButton(
              icon: Icon(
                Iconsax.trash,
                size: 20,
                color:
                    dark ? TColors.light.withOpacity(0.8) : TColors.darkerGrey,
              ),
              onPressed: () => onRemove(title), // Call onRemove with title
            ),
          ),
        ),
      ],
    );
  }
}
