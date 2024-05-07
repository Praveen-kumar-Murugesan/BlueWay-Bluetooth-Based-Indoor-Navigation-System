import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartIDProvider extends ChangeNotifier {
  // Use an RxList to make the list observable
  RxList<int> cartIDItems = <int>[].obs;

//   CartProvider({
//     this.cartItems = [];
// });

  // Method to add an item to the cart
  void addItemToCart({required int item}) async {
    if (!cartIDItems.contains(item)) {
      cartIDItems.add(item);
    }
    notifyListeners(); // Notify listeners of the change
  }

  // Method to remove an item from the cart
  void removeItemFromCart({required int item}) async {
    cartIDItems.remove(item);
    notifyListeners(); // Notify listeners of the change
  }

  // Method to update an item in the cart
  void updateItemInCart(int index, int newItem) {
    if (index >= 0 && index < cartIDItems.length) {
      cartIDItems[index] = newItem;
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Method to clear all items from the cart
  void clearCart() {
    cartIDItems.clear();
    notifyListeners(); // Notify listeners of the change
  }
}
