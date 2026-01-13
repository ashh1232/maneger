import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TestMapControllerX extends GetxController
    with GetTickerProviderStateMixin {
  // final MapController mapController = MapController();
  // final MapController mapController = MapController();

  var currentLatLng = const LatLng(31.417272, 34.970499).obs; // مثال: الرياض
  var destinationLatLng = const LatLng(31.410972, 34.970001).obs;
  var routePoints = <LatLng>[].obs;
  var distanceRemaining = 0.0.obs;
  var transportProfile = 'driving'.obs;

  late final AnimatedMapController mapController;

  ///qweqwe
  LatLng? lastFetchedLatLng;

  bool isMapReady = false;

  void setProfile(String newProfile) {
    print(currentLatLng);
    transportProfile.value = newProfile;
    fetchRoute(); // إعادة حساب المسار فوراً عند تغيير الوسيلة
  }

  @override
  void onInit() {
    super.onInit();
    _startTracking();
    fetchRoute();
    mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // هنا يتم تحديد الوقت
      curve: Curves.easeInOut,
    );
  }

  void onMapReady() {
    isMapReady = true;
  }

  // الرابط الافتراضي للخريطة (OSM)
  // الرابط الافتراضي مع البروتوكول الكامل والفواصل الصحيحة
  var currentTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'.obs;

  void changeMapStyle(String style) {
    switch (style) {
      case 'dark':
        // إضافة https:// وإضافة / قبل {z}
        currentTileUrl.value =
            'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
        break;
      case 'light':
        currentTileUrl.value =
            'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
        break;
      case 'satellite':
        // رابط القمر الصناعي مع المسار الكامل
        currentTileUrl.value =
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
        break;
      case 'traffic':
        // رابط الزحام مع إضافة المعاملات بشكل صحيح
        currentTileUrl.value = 'https://mt1.google.com/vt/&x={x}&y={y}&z={z}';
        break;
      default:
        currentTileUrl.value = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  Future<void> _startTracking() async {
    // ... (كود التحقق من الصلاحيات السابق) ...
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2, // تحديث كل مترين لزيادة السلاسة
      ),
    ).listen((Position position) {
      LatLng newPos = LatLng(position.latitude, position.longitude);
      currentLatLng.value = newPos;

      // تحديث المسار

      if (isMapReady) {
        //   // التدوير التلقائي:
        //   // position.heading هو اتجاه حركة المستخدم (البوصلة)
        //   mapController.moveAndRotate(
        //     newPos,
        //     17.0, // زووم قريب للملاحة
        //     position.heading, // تدوير الخريطة مع اتجاه الحركة
        //   );
        // }
        mapController.animateTo(
          dest: newPos,
          rotation: position.heading, // التدوير مع اتجاه الهاتف
          zoom: 17.0,
          // curve: Curves.easeInOut, // نوع الحركة
          // duration: const Duration(milliseconds: 500), // مدة الانميشن
        );
      }
      // fetchRoute();
      if (lastFetchedLatLng == null ||
          Geolocator.distanceBetween(
                lastFetchedLatLng!.latitude,
                lastFetchedLatLng!.longitude,
                newPos.latitude,
                newPos.longitude,
              ) >
              15) {
        lastFetchedLatLng = newPos;
        fetchRoute();
      }
    });
  }

  Future<void> fetchRoute() async {
    try {
      // 1. تحديد المعايير
      final String profile = transportProfile.value;
      final double startLng = currentLatLng.value.longitude;
      final double startLat = currentLatLng.value.latitude;
      final double endLng = destinationLatLng.value.longitude;
      final double endLat = destinationLatLng.value.latitude;

      // 2. بناء الرابط باستخدام Uri لضمان عدم وجود أخطاء في الـ Host
      final Uri url = Uri.https(
        'router.project-osrm.org',
        '/route/v1/$profile/$startLng,$startLat;$endLng,$endLat',
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

        List<LatLng> points =
            geometry.map<LatLng>((c) {
              // تحويل من [Longitude, Latitude] إلى LatLng(Latitude, Longitude)
              return LatLng(c[1].toDouble(), c[0].toDouble());
            }).toList();

        routePoints.assignAll(points);
        distanceRemaining.value = (routeData['distance'] as num).toDouble();

        print("✅ تم رسم المسار بنجاح: ${routePoints.length} نقطة");
      } else {
        print("❌ فشل السيرفر: ${response.body}");
      }
    } catch (e) {
      print("⚠️ خطأ تقني: $e");
    }
  }

  // دالة للبحث عن مكان وتحويله لإحداثيات
  Future<void> searchPlace(String query) async {
    try {
      if (query.isEmpty) return;

      // بناء الرابط بشكل آمن باستخدام Uri.https
      final Uri url = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'limit': '1',
      });

      print("🔍 جاري البحث في: $url");

      // إضافة User-Agent ضروري جداً لـ Nominatim لتجنب الحظر
      final response = await GetConnect().get(
        url.toString(),
        headers: {'User-Agent': 'com.newmanager.app'},
      );

      if (response.isOk && response.body != null && response.body.isNotEmpty) {
        // Nominatim يعيد قائمة، نأخذ العنصر الأول
        final data = response.body[0];
        final double lat = double.parse(data['lat']);
        final double lon = double.parse(data['lon']);

        // تحديث الوجهة والتحرك إليها بسلاسة
        destinationLatLng.value = LatLng(lat, lon);
        mapController.animateTo(dest: destinationLatLng.value, zoom: 15.0);

        // جلب المسار الجديد فوراً
        fetchRoute();

        Get.snackbar(
          "تم العثور على الوجهة",
          data['display_name'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white.withOpacity(0.9),
        );
      } else {
        Get.snackbar("تنبيه", "لم يتم العثور على نتائج للبحث");
      }
    } catch (e) {
      print("❌ خطأ في البحث: $e");
    }
  }

  // دالة لتحديث الوجهة عند الضغط المطول
  void setDestination(LatLng point) {
    destinationLatLng.value = point;

    // إعادة جلب المسار للوجهة الجديدة
    fetchRoute();

    // اختيارياً: إظهار رسالة تأكيد للمستخدم
    Get.snackbar(
      "تحديث الوجهة",
      "تم تحديد وجهة جديدة على الخريطة",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white70,
      duration: const Duration(seconds: 2),
    );
  }

  Future<List<dynamic>> getSuggestions(String query) async {
    if (query.length < 3)
      return []; // ابدأ البحث بعد كتابة 3 أحرف لتوفير البيانات
    try {
      final Uri url = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'limit': '5', // جلب أفضل 5 نتائج
      });

      final response = await GetConnect().get(
        url.toString(),
        headers: {'User-Agent': 'com.newmanager.app'},
      );

      if (response.isOk && response.body != null) {
        return response.body as List<dynamic>;
      }
    } catch (e) {
      print("خطأ في جلب الاقتراحات: $e");
    }
    return [];
  }
}
