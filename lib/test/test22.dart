import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:maneger/controller/map_controller.dart';

// class FlutMap2 extends StatelessWidget {
//   const FlutMap2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final MapControllerX controller = Get.put(MapControllerX());

//     return Scaffold(
//       body: FlutterMap(
//         mapController: controller.mapController,
//         options: MapOptions(
//           initialCenter: controller.currentLatLng.value,
//           initialZoom: 15.0,
//           onMapReady: () => controller.onMapReady(),
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.newmanager.app',
//           ),
//           // تحديث الماركر فقط عند تغير الإحداثيات دون إعادة بناء الخريطة بالكامل
//           Obx(
//             () => MarkerLayer(
//               markers: [
//                 Marker(
//                   point: controller.currentLatLng.value,
//                   width: 60,
//                   height: 60,
//                   child: const Icon(
//                     Icons.my_location,
//                     color: Colors.blue,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ), // داخل FlutterMap children:
//           Obx(
//             () => PolylineLayer(
//               polylines: [
//                 Polyline(
//                   points: controller.routePoints.value,
//                   color: Colors.blue,
//                   strokeWidth: 5.0,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       // زر تجريبي لتغيير الموقع واختبار الحركة
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           controller.updateLocation(controller.currentLatLng.value);
//         },
//         child: const Icon(Icons.location_searching),
//       ),
//     );
//   }
// }
class FlutMap2 extends StatelessWidget {
  const FlutMap2({super.key});

  @override
  Widget build(BuildContext context) {
    final MapControllerX controller = Get.find();

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.currentLatLng.value,
                initialZoom: 15.0,
                onMapReady: controller.onMapReady,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.newmanager.app',
                ),

                // رسم خط المسار
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints.value,
                      color: Colors.blueAccent,
                      strokeWidth: 6,
                    ),
                  ],
                ),

                // ماركر الموقع الحالي والوجهة
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.currentLatLng.value,
                      child: Icon(
                        Icons.navigation,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: controller.destinationLatLng.value,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // لوحة معلومات المسافة (تظهر في الأعلى)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Obx(
              () => Card(
                // استخدام Card يعطي ظلاً وتصميماً أفضل
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.directions_car, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        "المسافة المتبقية: ${(controller.distanceRemaining.value / 1000).toStringAsFixed(2)} كم",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
