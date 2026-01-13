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
      appBar: AppBar(title: const Text('Flutter Map')),
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

          // 2. لوحة معلومات المسافة
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Obx(
              () => Card(
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
                        controller.distanceRemaining.value > 0
                            ? "المسافة: ${(controller.distanceRemaining.value / 1000).toStringAsFixed(2)} كم"
                            : "جاري حساب المسار...",
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

          // 3. أزرار التحكم الجانبية (يمين)
          Positioned(
            right: 20,
            top: 150,
            child: Column(
              children: [
                _buildSideButton(
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
                  icon: Icons.dark_mode,
                  onTap: () => controller.changeMapStyle(
                    controller.mapStyle.value == 'dark' ? 'streets' : 'dark',
                  ),
                  isActive: controller.mapStyle.value == 'dark',
                ),
                const SizedBox(height: 10),
                _buildSideButton(
                  icon: Icons.gps_fixed,
                  onTap: () => controller.changeMapStyle('google'),
                  isActive: controller.mapStyle.value == 'google',
                  activeColor: Colors.green,
                ),
                const SizedBox(height: 10),

                _buildSideButton(
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
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfileButton(
                      Icons.directions_car,
                      'driving',
                      controller,
                    ),
                    _buildProfileButton(
                      Icons.directions_bike,
                      'cycling',
                      controller,
                    ),
                    _buildProfileButton(
                      Icons.directions_walk,
                      'walking',
                      controller,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 5. زر الموقع
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
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
  }) {
    return FloatingActionButton(
      mini: true,
      heroTag: null,
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
