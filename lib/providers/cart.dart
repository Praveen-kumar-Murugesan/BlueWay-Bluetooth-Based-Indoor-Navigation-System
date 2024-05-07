import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProvider extends ChangeNotifier {
  // Use an RxList to make the list observable
  RxList<String> cartItems = <String>[].obs;

//   CartProvider({
//     this.cartItems = [];
// });

  // Method to add an item to the cart
  void addItemToCart({required String item}) async {
    if (!cartItems.contains(item)) {
      cartItems.add(item);
    }
    notifyListeners(); // Notify listeners of the change
  }

  // Method to remove an item from the cart
  void removeItemFromCart({required String item}) async {
    cartItems.remove(item);
    notifyListeners(); // Notify listeners of the change
  }

  // Method to update an item in the cart
  void updateItemInCart(int index, String newItem) {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index] = newItem;
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Method to clear all items from the cart
  void clearCart() {
    cartItems.clear();
    notifyListeners(); // Notify listeners of the change
  }
}
