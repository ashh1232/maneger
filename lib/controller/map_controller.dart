import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapControllerX extends GetxController {
  final MapController mapController = MapController();

  var currentLatLng = const LatLng(31.417271, 34.970505).obs;
  var destinationLatLng =
      const LatLng(31.405271, 34.970505).obs; // النقطة الهدف
  var routePoints = <LatLng>[].obs; // نقاط رسم المسار
  var distanceRemaining = 0.0.obs; // المسافة المتبقية بالامتار

  // علم للتأكد من أن الخريطة جاهزة لاستقبال الأوامر
  bool isMapReady = false;

  @override
  void onInit() {
    super.onInit();
    _startTracking();
  }

  void onMapReady() {
    isMapReady = true;
    // عند جاهزية الخريطة، تحرك للموقع الحالي فوراً
    mapController.move(currentLatLng.value, 15.0);
  }

  Future<void> _startTracking() async {
    // التأكد من الصلاحيات
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // تحديث كل 5 أمتار
      ),
    ).listen((Position position) {
      LatLng newPos = LatLng(position.latitude, position.longitude);
      currentLatLng.value = newPos;

      // 1. حساب المسافة المتبقية للوجهة
      distanceRemaining.value = Geolocator.distanceBetween(
        newPos.latitude,
        newPos.longitude,
        destinationLatLng.value.latitude,
        destinationLatLng.value.longitude,
      );

      // 2. تحديث المسار (الخط الأزرق)
      fetchRoute();

      // 3. تحريك الكاميرا وتدويرها حسب اتجاه الحركة (Bearing)
      if (isMapReady) {
        mapController.moveAndRotate(newPos, 16.0, position.heading);
      }
    });
  }

  Future<void> fetchRoute() async {
    try {
      final url =
          'router.project-osrm.org'
          '${currentLatLng.value.longitude},${currentLatLng.value.latitude};'
          '${destinationLatLng.value.longitude},${destinationLatLng.value.latitude}'
          '?overview=full&geometries=geojson';

      final response = await GetConnect().get(url);
      if (response.isOk) {
        var coords = response.body['routes'][0]['geometry']['coordinates'];
        routePoints.value =
            coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  void updateLocation(LatLng newLatLng) {
    currentLatLng.value = newLatLng;
    // تحريك الكاميرا للموقع الجديد بسلاسة
    mapController.move(newLatLng, 15.0);
  }

  void myLocation() {}
  Future<void> getRoute() async {
    final url =
        'router.project-osrm.org'
        '${currentLatLng.value.longitude},${currentLatLng.value.latitude};'
        '${destinationLatLng.value.longitude},${destinationLatLng.value.latitude}'
        '?overview=full&geometries=geojson';

    final response = await GetConnect().get(url);
    if (response.status.isOk) {
      final List coords = response.body['routes'][0]['geometry']['coordinates'];
      routePoints.value = coords.map((e) => LatLng(e[1], e[0])).toList();
    }
  }
}
