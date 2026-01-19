import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:maneger/features/cart/data/models/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> cacheCartItems(List<CartItemModel> items);
}

const String CACHED_CART_ITEMS = 'cart_items';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final jsonString = sharedPreferences.getString(CACHED_CART_ITEMS);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => CartItemModel.fromJson(json)).toList();
      } catch (e) {
        debugPrint('❌ Error parsing cart items: $e');
        // If error, return empty list (or throw exception)
        // Returning empty list is safer for User Experience (reset corrupted cart)
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheCartItems(List<CartItemModel> items) async {
    final List<Map<String, dynamic>> jsonList = items
        .map((item) => item.toJson())
        .toList();
    await sharedPreferences.setString(CACHED_CART_ITEMS, jsonEncode(jsonList));
  }
}
