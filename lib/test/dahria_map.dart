import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/map_download_controller.dart';

class DahriaMap extends StatelessWidget {
  DahriaMap({super.key});
  final MapDownloadController controller = Get.put(MapDownloadController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => LinearProgressIndicator(value: controller.progress)),
          const SizedBox(height: 10),
          Obx(
            () => Text(
              "تم تحميل ${controller.downloadedTiles} من اصل ${controller.totalTiles}",
            ),
          ),
          Obx(
            () => Text(
              "الوقت المتبقي التقريبي: ${controller.remainingTime.value}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
