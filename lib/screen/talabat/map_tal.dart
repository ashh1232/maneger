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
      appBar: AppBar(title: const Text('الخريطة')),
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
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.maneger.app',
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
                            size: 45,
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

              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
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
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => mapController.mapController.move(
                mapController.currentLatLng.value,
                15.0,
              ),
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
