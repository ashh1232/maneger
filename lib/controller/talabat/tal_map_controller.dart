import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maneger/routes.dart';

class TalMapController extends GetxController {
  final MapController mapController = MapController();

  var currentLatLng = const LatLng(31.417272, 34.970499).obs; // مثال: الرياض
  // var destinationLatLng = const LatLng(31.410972, 34.970001).obs;
  var destinationLatLng = const LatLng(31.410972, 34.970001).obs;
  var routePoints = <LatLng>[].obs;
  var currentHeading = 0.0.obs; // إضافة متغير الاتجاه
  bool isMapReady = false;
  bool s = false;

  ///
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
    _startTracking();
  }

  @override
  void onReady() {
    super.onReady();
    fetchRoute();
  }

  void onLongPress(LatLng point) {
    destinationLatLng.value = point;
    fetchRoute();
  }

  void onMapReady() {
    isMapReady = true;
  }

  ///////////
  void newDestinations() {
    Get.toNamed(AppRoutes.checkout);
  }

  ///
  // داخل الكلاس
  var mapStyle = 'streets'.obs; // streets, satellite, dark
  var showTraffic = false.obs;

  Future<void> _startTracking() async {
    // ... (كود التحقق من الصلاحيات السابق) ...
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // تحديث كل مترين لزيادة السلاسة
          ),
        ).listen((Position position) {
          LatLng newPos = LatLng(position.latitude, position.longitude);
          currentLatLng.value = newPos;
          currentHeading.value = position.heading; // تحديث زاوية الدوران
          if (!s) {
            s = true;
            destinationLatLng.value = currentLatLng.value;
          }
          // تحديث المسار
          fetchRoute();
          if (isMapReady) {
            try {
              mapController.moveAndRotate(
                newPos,
                17.0, // أو mapController.camera.zoom
                position.heading,
              );
            } catch (e) {
              // إذا فشل التحريك لأن الخريطة أغلقت، نقوم بإلغاء الاشتراك فوراً
              positionStream?.cancel();
            }
          }
        });
  }

  Future<void> fetchRoute() async {
    try {
      // 1. تحديد المعايير
      // final String profile = transportProfile.value;
      final double startLng = currentLatLng.value.longitude;
      final double startLat = currentLatLng.value.latitude;
      // final double endLng = destinationLatLng.value.longitude;
      // final double endLat = destinationLatLng.value.latitude;

      // 2. بناء الرابط باستخدام Uri لضمان عدم وجود أخطاء في الـ Host
      final Uri url = Uri.https(
        'router.project-osrm.org',
        '/route/v1/driving/$startLng,$startLat',
        {'overview': 'full', 'geometries': 'geojson'},
      );

      print("🔗 جاري الاتصال بالرابط: $url");

      final response = await GetConnect().get(url.toString());

      if (response.isOk &&
          response.body['routes'] != null &&
          response.body['routes'].isNotEmpty) {
        // الوصول للمسار الأول (تأكد من وجود [0])
        var routeData = response.body['routes'][0];
        var geometry = routeData['geometry']['coordinates'];

        List<LatLng> points = geometry.map<LatLng>((c) {
          // تحويل من [Longitude, Latitude] إلى LatLng(Latitude, Longitude)
          return LatLng(c[1].toDouble(), c[0].toDouble());
        }).toList();

        routePoints.assignAll(points);
        // distanceRemaining.value = (routeData['distance'] as num).toDouble();
      }
    } catch (e) {
      print("⚠️ خطأ تقني: $e");
    }
  }

  @override
  void onClose() {
    // 1. إلغاء الاشتراك يمنع Geolocator من إرسال بيانات جديدة للمحرك
    positionStream?.cancel();
    positionStream = null;

    // 2. التخلص من متحكم الخريطة
    mapController.dispose();

    super.onClose();
  }
}
