import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/delivery_controller/deli_map_controller.dart';

class DeliMap extends StatelessWidget {
  const DeliMap({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliMapController controller = Get.find();

    return Scaffold(
      // appBar: AppBar(title: const Text('Flutter Map')),
      body: Stack(
        children: [
          // 1. الخريطة الأساسية
          FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: controller.currentLatLng.value,
              initialZoom: 15.0,
              onMapReady: controller.onMapReady,
              onLongPress: (tapPosition, point) =>
                  controller.onLongPress(point),
              // داخل FlutterMap -> options: MapOptions
              initialCameraFit: null, // تأكد من أنها فارغة
              initialRotation: controller.currentHeading.value,
              // الإمالة بزاوية 45-60 درجة تعطي شعوراً بالقيادة الحقيقية
            ),
            children: [
              // طبقة الصور (Base Tiles) - تم تصحيح الروابط هنا
              Obx(() {
                String url;
                switch (controller.mapStyle.value) {
                  case 'satellite':
                    // lyrs=s تعني Satellite
                    url = 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';
                    break;
                  case 'dark':
                    // رابط مستقر جداً للوضع الليلي
                    url =
                        'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
                    break;
                  case 'google':
                    // رابط مستقر جداً للوضع الليلي
                    url = 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
                    break;
                  default:
                    url = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
                }
                return TileLayer(
                  urlTemplate: url,
                  userAgentPackageName: 'com.newmanager.app',
                );
              }),

              // طبقة حركة المرور (Traffic Layer) - تم تصحيح الرابط
              Obx(
                () => controller.showTraffic.value
                    ? TileLayer(
                        urlTemplate:
                            'https://mt1.google.com/vt/lyrs=h&x={x}&y={y}&z={z}',
                        backgroundColor: Colors.transparent,
                      )
                    : const SizedBox.shrink(),
              ),

              // طبقة رسم المسار (Polyline)
              Obx(
                () => PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints.toList(),
                      color: Colors.blue.withOpacity(0.8),
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                    ),
                  ],
                ),
              ),

              // طبقة العلامات (Markers)
              Obx(
                () => MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.currentLatLng.value,
                      child: Obx(
                        () => Transform.rotate(
                          angle:
                              (controller.currentHeading.value *
                              (3.141592653589793 / 180)),
                          child: const Icon(
                            Icons.navigation,
                            color: Colors.blue,
                            size: 45,
                          ),
                        ),
                      ),
                    ),
                    Marker(
                      point: controller.destinationLatLng.value,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 160, // فوق زر الموقع الحالي
            child: FloatingActionButton(
              heroTag: 'map_style',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "اختر شكل الخريطة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: const Icon(Icons.map),
                          title: const Text("الوضع العادي"),
                          onTap: () {
                            controller.changeMapStyle('default');
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.nightlight_round),
                          title: const Text("الوضع الليلي"),
                          onTap: () {
                            controller.changeMapStyle('dark');
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.satellite_alt),
                          title: const Text("قمر صناعي"),
                          onTap: () {
                            controller.changeMapStyle('satellite');
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.traffic),
                          title: const Text("traffic"),
                          onTap: () {
                            controller.changeMapStyle('traffic');
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.layers, color: Colors.blue),
            ),
          ),
          // 2. لوحة معلومات المسافة

          // 3. أزرار التحكم الجانبية (يمين)
          Positioned(
            right: 20,
            top: 150,
            child: Column(
              children: [
                _buildSideButton(
                  tag: 'asdasd',
                  icon: Icons.satellite_alt,
                  onTap: () => controller.changeMapStyle(
                    controller.mapStyle.value == 'satellite'
                        ? 'streets'
                        : 'satellite',
                  ),
                  isActive: controller.mapStyle.value == 'satellite',
                ),
                const SizedBox(height: 10),
                _buildSideButton(
                  tag: 'dasss',
                  icon: Icons.dark_mode,
                  onTap: () => controller.changeMapStyle(
                    controller.mapStyle.value == 'dark' ? 'streets' : 'dark',
                  ),
                  isActive: controller.mapStyle.value == 'dark',
                ),
                const SizedBox(height: 10),
                _buildSideButton(
                  tag: 'google',
                  icon: Icons.gps_fixed,
                  onTap: () => controller.changeMapStyle('google'),
                  isActive: controller.mapStyle.value == 'google',
                  activeColor: Colors.green,
                ),
                const SizedBox(height: 10),

                _buildSideButton(
                  tag: 'traffic',
                  icon: Icons.traffic,
                  onTap: () => controller.toggleTraffic(),
                  isActive: controller.showTraffic.value,
                  activeColor: Colors.green,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // 4. أزرار وسيلة النقل (سفلية)

          // 5. زر الموقع
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
              heroTag: 'my_loc',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => controller.mapController.move(
                controller.currentLatLng.value,
                15.0,
              ),
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    Color activeColor = Colors.blue,
    required String tag,
  }) {
    return FloatingActionButton(
      mini: true,
      heroTag: tag,
      backgroundColor: isActive ? activeColor : Colors.white,
      onPressed: onTap,
      child: Icon(icon, color: isActive ? Colors.white : Colors.grey),
    );
  }

  Widget _buildProfileButton(
    IconData icon,
    String profile,
    DeliMapController controller,
  ) {
    bool isSelected = controller.transportProfile.value == profile;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 30),
      onPressed: () => controller.setProfile(profile),
    );
  }
}
