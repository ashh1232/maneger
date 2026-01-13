import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maneger/controller/test_map_controller.dart';

class FlutMap extends StatelessWidget {
  const FlutMap({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final TestMapControllerX controller = Get.find();

    return Scaffold(
      body: Stack(
        children: [
          // الخريطة لا تحتاج Obx هنا لأننا نتحرك عبر mapController
          FlutterMap(
            mapController: controller.mapController.mapController,
            options: MapOptions(
              initialCenter: controller.currentLatLng.value,
              initialZoom: 15.0,
              onMapReady: controller.onMapReady,
              onLongPress: (tapPosition, point) =>
                  controller.setDestination(point),
            ),
            children: [
              Obx(
                () => TileLayer(
                  urlTemplate: controller.currentTileUrl.value,

                  userAgentPackageName: 'com.newmanager.app',
                  // تفعيل وضع الدقة العالية تلقائياً بناءً على كثافة شاشة الهاتف
                  retinaMode: RetinaMode.isHighDensity(context),
                ),
              ),
              // طبقة حركة المرور (Traffic Layer) - تم تصحيح الرابط
              // Obx(
              //   () =>
              //       controller.showTraffic.value
              //           ? TileLayer(
              //             urlTemplate:
              //                 'https://mt1.google.com/vt/lyrs=h&x={x}&y={y}&z={z}',
              //             backgroundColor: Colors.transparent,
              //           )
              //           : const SizedBox.shrink(),
              // ),

              // تحديث المسار فقط
              Obx(
                () => PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints.toList(),
                      color: Colors.blue.withOpacity(0.8),
                      strokeWidth: 6,
                      // isOutlineVisible: true, // متوفر في إصدارات 2025/2026 لتعريف حدود الخط
                      // outlineColor: Colors.blue.shade900,
                      strokeCap:
                          StrokeCap.round, // لجعل زوايا الطريق دائرية وسلسة
                    ),
                  ],
                ),
              ),

              // تحديث الماركرات فقط
              Obx(
                () => AnimatedMarkerLayer(
                  markers: [
                    AnimatedMarker(
                      // ماركر متحرك أيضاً إذا أردت

                      // Marker(
                      point: controller.destinationLatLng.value,
                      width: 50,
                      height: 50,
                      builder: (context, animation) => const Icon(
                        Icons.navigation,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    AnimatedMarker(
                      // ماركر متحرك أيضاً إذا أردت

                      // Marker(
                      point: controller.destinationLatLng.value,

                      builder: (context, animation) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // لوحة معلومات المسافة
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
          Positioned(
            right: 20,
            bottom: 160, // فوق زر الموقع الحالي
            child: FloatingActionButton(
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

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
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
          Positioned(
            right: 20,
            bottom: 100, // فوق أزرار اختيار الوسيلة
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => controller.mapController.animateTo(
                dest: controller.currentLatLng.value,
                zoom: 17.0,
                rotation: 0.0, // تصفير الدوران عند الضغط على الزر (اختياري)
              ),
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
          // Widget مساعد لبناء زر الوسيلة
          RawAutocomplete<Map<String, dynamic>>(
            // تحويل الخيار المختار إلى نص يظهر في الحقل
            displayStringForOption: (option) => option['display_name'] ?? '',

            // بناء الاقتراحات
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text.isEmpty) return const Iterable.empty();

              // جلب القائمة من الـ Controller وتحويلها لـ Iterable من الـ Maps
              final List<dynamic> suggestions = await controller.getSuggestions(
                textEditingValue.text,
              );
              return suggestions.cast<Map<String, dynamic>>();
            },

            // عند اختيار عنوان من القائمة
            onSelected: (Map<String, dynamic> selection) {
              final double lat = double.parse(selection['lat'].toString());
              final double lon = double.parse(selection['lon'].toString());

              controller.destinationLatLng.value = LatLng(lat, lon);
              controller.mapController.animateTo(
                dest: controller.destinationLatLng.value,
                zoom: 15.0,
              );
              controller.fetchRoute();

              FocusManager.instance.primaryFocus?.unfocus();
            },

            // بناء حقل الإدخال
            fieldViewBuilder:
                (context, textController, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: textController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "ابحث عن وجهة...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  );
                },

            // بناء شكل القائمة المنسدلة
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        // تحديد النوع هنا أيضاً لتجنب الخطأ
                        final Map<String, dynamic> option = options.elementAt(
                          index,
                        );
                        return ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          title: Text(
                            option['display_name'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(
    IconData icon,
    String profile,
    TestMapControllerX controller,
  ) {
    bool isSelected = controller.transportProfile.value == profile;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 30),
      onPressed: () => controller.setProfile(profile),
    );
  }
}
