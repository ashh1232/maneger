import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat/tal_map_controller.dart';

class MapTal extends StatelessWidget {
  const MapTal({super.key});

  @override
  Widget build(BuildContext context) {
    final TalMapController mapController = Get.find<TalMapController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "map_fab_unique_tagasdasd", // أي نص فريد
        onPressed: () {},
      ),
      // appBar: AppBar(title: const Text('الخريطة')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController.mapController,
            options: MapOptions(
              initialCenter: mapController.currentLatLng.value,
              initialZoom: 17.0,
              onMapReady: mapController.onMapReady,
              onLongPress: (s, point) => mapController.onLongPress(point),
            ),
            children: [
              Obx(
                () => TileLayer(
                  // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  urlTemplate: mapController.currentTileUrl.value,
                  userAgentPackageName: 'com.maneger.app',
                ),
              ),

              // طبقة العلامات (Markers)
              Obx(
                () => MarkerLayer(
                  markers: [
                    Marker(
                      point: mapController.currentLatLng.value,
                      child: Obx(
                        () => Transform.rotate(
                          angle:
                              (mapController.currentHeading.value *
                              (3.141592653589793 / 180)),
                          child: const Icon(
                            Icons.navigation,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Marker(
                      point: mapController.destinationLatLng.value,
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
              heroTag: "map_edit_map", // أي نص فريد

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
                            mapController.changeMapStyle('default');
                            Get.back();
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.satellite_alt),
                          title: const Text("قمر صناعي"),
                          onTap: () {
                            mapController.changeMapStyle('satellite');
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.layers, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),

              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                height: 50,
                // width: double.infinity,
                child: InkWell(
                  onTap: () {
                    mapController.newDestinations();
                  },
                  child: Center(
                    child: Text(
                      "تحديث الموقع",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
              heroTag: "map_fab_unique_tag", // اسم فريد
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => mapController.mapController.move(
                mapController.currentLatLng.value,
                17.0,
              ),
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
          Positioned(
            right: 20,
            top: 100,
            child: FloatingActionButton(
              heroTag: "map_back_btn", // اسم فريد
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => Get.back(),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
