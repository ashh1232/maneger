import 'dart:async'; // Required for StreamSubscription
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:maneger/model/product_model.dart';

class MapDownloadController extends GetxController {
  late final FMTCStore _store;
  final String apiKey = '7b362c35admshd7a14aad884a37fp14d67djsn33367535f0be';
  var isLoading = false.obs;

  final url = Uri.parse(
    "https://shein-scraper-api.p.rapidapi.com/shein/product/details?goods_id=16477544&currency=usd&country=us&language=en",
  );
  final RxList<Product> productList = <Product>[].obs;

  Future<void> getData() async {
    if (isLoading.value) return;
    try {
      isLoading(true);
      var response = await http
          .get(
            url,
            headers: {
              'x-rapidapi-host': 'shein-scraper-api.p.rapidapi.com',
              'x-rapidapi-key': apiKey,
            },
          )
          .timeout(const Duration(seconds: 10));
      print(response.body);
      if (response.statusCode == 200) {
        print('aaaaaaaaaaaaaaaaaaaa');
        var jsonResponse = json.decode(response.body);
        List newDataList =
            jsonResponse['data']; // Matches the "metadata" PHP structure
        print('bbbbbbbbbbbbbbbbbbbb');
        print(newDataList);
        if (newDataList.isEmpty) {
        } else {
          List<Product> newProducts = newDataList
              .map((json) => Product.fromJson(json))
              .toList();
          productList.addAll(newProducts);
          if (jsonResponse['metadata'] != null) {
            int currentPage = jsonResponse['metadata']['current_page'];
            int totalPages = jsonResponse['metadata']['total_pages'];
            if (currentPage >= totalPages) {
              print(newDataList);
            }
          }
        }
      }
    } catch (e) {
      var page;
      if (page == 1) _showErrorSnackbar("تحقق من الاتصال بالإنترنت");
    } finally {
      isLoading(false);
    }
  }

  // Track the subscription to be able to cancel it later
  StreamSubscription<DownloadProgress>? _downloadSubscription;

  var downloadedTiles = 0.obs;
  var totalTiles = 0.obs;
  var isDownloading = false.obs;
  var remainingTime = "00:00".obs;

  double get progress =>
      totalTiles.value == 0 ? 0 : downloadedTiles.value / totalTiles.value;

  @override
  void onInit() {
    print('productList');

    getData();
    print('productList');
    super.onInit();
    _store = FMTCStore('mapStore');
  }

  void startDahriyaDownload() async {
    // Prevent multiple simultaneous downloads
    if (isDownloading.value) return;
    isDownloading.value = true;
    downloadedTiles.value = 0;

    final region = LatLngBounds(LatLng(31.420, 34.950), LatLng(31.455, 34.990));
    final downloadableRegion = RectangleRegion(region).toDownloadable(
      minZoom: 12,
      maxZoom: 18,
      options: TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.newmanager.app',
      ),
    );

    // 2. تحديث العدد الإجمالي فوراً قبل بدء التحميل (حل المشكلة)
    // هذا السطر يحسب عدد البلاطات المتوقع بدقة
    totalTiles.value = await _store.download.check(downloadableRegion);

    // final downloadableRegion = RectangleRegion(
    //   LatLngBounds(LatLng(31.420, 34.950), LatLng(31.455, 34.990)),
    // ).toDownloadable(
    //   minZoom: 12,
    //   maxZoom: 18,
    //   options: TileLayer(
    //     urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //     userAgentPackageName: 'com.newmanager.app',
    //   ),
    // );

    final downloadStream = _store.download.startForeground(
      region: downloadableRegion,
    );

    // Save the subscription
    _downloadSubscription = downloadStream.listen(
      (DownloadProgress progress) {
        totalTiles.value = progress.maxTiles;
        downloadedTiles.value = progress.attemptedTiles;

        final minutes = progress.estRemainingDuration.inMinutes;
        final seconds = progress.estRemainingDuration.inSeconds % 60;
        remainingTime.value =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      },
      onDone: () {
        isDownloading.value = false;
        Get.snackbar('Success', 'Download complete!');
      },
    );
  }

  // Method to stop the download
  void cancelDownload() {
    if (_downloadSubscription != null) {
      _downloadSubscription!.cancel();
      _downloadSubscription = null;
      isDownloading.value = false;
      remainingTime.value = "00:00";
      Get.snackbar('Cancelled', 'Map download has been stopped.');
    }
  }

  @override
  void onClose() {
    // Always cancel subscriptions when the controller is destroyed
    _downloadSubscription?.cancel();
    super.onClose();
  }

  void _showErrorSnackbar(String s) {}
}
