import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var productList = [].obs;
  var isLoading = false.obs;
  var hasMore = true.obs; // Tracks if there is more data to fetch
  int page = 1;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Initial load

    // Add scroll listener to detect when reaching bottom
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoading.value && hasMore.value) {
          fetchProducts();
        }
      }
    });
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(
          'http://192.168.8.106/doc/docana-back/product2.php?page=$page',
        ),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List newData =
            jsonResponse['data']; // Matches the "metadata" PHP structure

        if (newData.isEmpty) {
          // print('empty');
          hasMore(false); // No more records to fetch
        } else {
          productList.addAll(newData);
          page++;
          // Check metadata if your PHP script provides total_pages
          if (jsonResponse['metadata']['current_page'] >=
              jsonResponse['metadata']['total_pages']) {
            hasMore(false);
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Check your connection");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    scrollController.dispose(); // Always dispose controllers in 2025
    super.onClose();
  }
}
