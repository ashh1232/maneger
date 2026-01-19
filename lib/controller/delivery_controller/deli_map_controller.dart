import 'dart:async';
import 'dart:convert';

// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/model/order_model.dart' as legacy;

class DeliMapController extends GetxController {
  final MapController mapController = MapController();

  var currentLatLng = const LatLng(31.417272, 34.970499).obs; // مثال: الرياض
  var destinationLatLng = const LatLng(31.410972, 34.970001).obs;
  var routePoints = <LatLng>[].obs;
  var distanceRemaining = 0.0.obs;
  var transportProfile = 'driving'.obs;
  var currentHeading = 0.0.obs; // إضافة متغير الاتجاه
  bool isMapReady = false;
  ////
  final Rx<Order?> order = Rx<Order?>(null);

  ////
  StreamSubscription<Position>? positionStream;
  DateTime? _lastFetchTime; // متغير لتخزين وقت آخر طلب
  ///
  // داخل الكلاس
  var mapStyle = 'streets'.obs; // streets, satellite, dark
  var showTraffic = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startTracking();
    _checkAndSetNightMode(); // فحص تلقائي للوضع الليلي عند التشغيل
  }

  @override
  void onReady() {
    super.onReady();
    fetchRoute();
  }

  void changeMapStyle(String style) {
    mapStyle.value = style;
  }

  void toggleTraffic() {
    showTraffic.value = !showTraffic.value;
  }

  void setProfile(String newProfile) {
    transportProfile.value = newProfile;
    fetchRoute(); // إعادة حساب المسار فوراً عند تغيير الوسيلة
  }

  void onLongPress(LatLng point) {
    destinationLatLng.value = point;
    fetchRoute();
  }

  void onMapReady() {
    isMapReady = true;
  }

  // دالة معالجة البيانات في خيط منفصل (Isolate)
  // داخل الكلاس DeliMapController
  static List<LatLng> parseRoutePoints(String responseBody) {
    final data = jsonDecode(responseBody);
    if (data['routes'] != null && data['routes'].isNotEmpty) {
      var geometry = data['routes'][0]['geometry']['coordinates'];
      return geometry
          .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
          .toList();
    }
    return [];
  }

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
          // تحديث المسار

          // الحل هنا: اطلب المسار فقط إذا مر أكثر من 5 ثوانٍ على آخر طلب
          if (_lastFetchTime == null ||
              DateTime.now().difference(_lastFetchTime!).inSeconds > 5) {
            _lastFetchTime = DateTime.now();
            fetchRoute();
          }

          if (isMapReady) {
            try {
              mapController.moveAndRotate(newPos, 17.5, position.heading);
            } catch (e) {}
          }
        });
  }

  Future<void> fetchRoute() async {
    try {
      final String profile = transportProfile.value;
      final Uri url = Uri.https(
        'router.project-osrm.org',
        '/route/v1/$profile/${currentLatLng.value.longitude},${currentLatLng.value.latitude};${destinationLatLng.value.longitude},${destinationLatLng.value.latitude}',
        {'overview': 'full', 'geometries': 'geojson'},
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // السحر هنا: معالجة الـ JSON في Isolate منفصل لعدم تجميد الخريطة
        final List<LatLng> points = await compute(
          parseRoutePoints,
          response.body,
        );

        // التحديث في الخيط الرئيسي
        routePoints.assignAll(points);

        // تحديث المسافة
        final data = jsonDecode(response.body);
        distanceRemaining.value = (data['routes'][0]['distance'] as num)
            .toDouble();
      }
    } catch (e) {}
  }

  // ميزة إضافية: التحويل التلقائي للوضع الليلي بناءً على وقت الجهاز (2026)
  void _checkAndSetNightMode() {
    final hour = DateTime.now().hour;
    if (hour >= 18 || hour <= 6) {
      mapStyle.value = 'dark';
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
