import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BLEProvider extends ChangeNotifier {
  // Use an RxList to make the list observable
  RxList<Map<String, dynamic>> bleItems = <Map<String, dynamic>>[].obs;

//   CartProvider({
//     this.cartItems = [];
// });

  // Method to add an item to the cart
  void addItemToList({required String id, required double rssi}) async {
    final existingItem = bleItems.firstWhere(
      (item) => item['id'] == id,
      orElse: () => {'id': '', 'rssi': 0},
    );

    if (existingItem['id'] == '') {
      // If the item doesn't exist, add it to the cart
      bleItems.add({'id': id, 'rssi': rssi});
    } else {
      // If the item exists, update its RSSI value
      existingItem['rssi'] = rssi;
    }

    notifyListeners(); // Notify listeners of the change
  }

  // Method to remove an item from the cart
  void removeItemFromList({required String id}) async {
    bleItems.removeWhere((item) => item['id'] == id);
    notifyListeners(); // Notify listeners of the change
  }

  // Method to update an item in the cart
  // void updateItemInCart(int index, String newItem) {
  //   if (index >= 0 && index < cartItems.length) {
  //     cartItems[index] = newItem;
  //     notifyListeners(); // Notify listeners of the change
  //   }
  // }

  // Method to clear all items from the cart
  void clearCart() {
    bleItems.clear();
    notifyListeners(); // Notify listeners of the change
  }
}
