import 'package:bluecart1/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../../../common/widgets/texts/product_title_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../home/home.dart';
import '../home/widgets/rounded_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key, required List<String> cartItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, int> referenceMap = {
      'A102': 0,
      'A103': 3,
      'A104': 6,
      'C102': 2,
      'C103': 5,
      'C104': 8,
      'Front Office': 1,
      'Back Office': 7,
    };
    final List<int> newList = [];
    final List<String> cList = context.watch<CartProvider>().cartItems;
    final CartController controller = Get.find();
    cList.forEach((item) {
      // Check if item is a key in the referenceMap
      if (referenceMap.containsKey(item)) {
        // Add the corresponding value to the newList
        // context.read<CartIDProvider>().addItemToCart(item: item);
        newList.add(referenceMap[item]!);
      }
    });
    print('New List: $newList');
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: false,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: GetX<CartController>(
          builder: (controller) {
            // Use Obx or GetX to listen to changes in cartItems
            print("CartScreen - Cart Items: ${cList.toList()}");
            return ListView.separated(
              shrinkWrap: true,
              itemCount: cList.length,
              separatorBuilder: (_, __) => const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              itemBuilder: (_, index) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RoundedImage(
                            imageUrl: TImages.product,
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(TSizes.xs),
                            backgroundColor:
                                THelperFunctions.isDarkMode(context)
                                    ? TColors.darkerGrey
                                    : TColors.light,
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductTitleText(
                                title: cList[index],
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
                      Center(
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey
                                  .withOpacity(0.3), // Adjust color as needed
                            ),
                            child: IconButton(
                                onPressed: () {
                                  context
                                      .read<CartProvider>()
                                      .removeItemFromCart(item: cList[index]);
                                },
                                icon: Icon(
                                  Iconsax.trash,
                                  size: 20, // Adjust size as needed
                                  color: dark
                                      ? TColors.light.withOpacity(0.8)
                                      : TColors.darkerGrey,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(
      //       left: TSizes.defaultSpace,
      //       right: TSizes.defaultSpace,
      //       bottom: TSizes.defaultSpace),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Get.to(() => MapScreen(newList: newList));
      //       // Navigate to MapScreen and pass newList
      //       // Navigator.push(
      //       //   context,
      //       //   MaterialPageRoute(
      //       //     builder: (context) => MapScreen(newList: newList),
      //       //   ),
      //       // );
      //     },
      //     child: Text(
      //       'Get Direction',
      //       style: Theme.of(context).textTheme.bodyMedium,
      //     ),
      //   ),
      // ),
    );
  }
}
