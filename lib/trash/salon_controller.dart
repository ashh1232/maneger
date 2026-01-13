import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalonController extends GetxController {
  var msg = <Salon>[].obs;

  @override
  void onInit() {
    fetchSalonData();
    super.onInit();
  }

  void fetchSalonData() async {
    final response = await http.get(
      Uri.parse(
        'https://lobulate-rhythm.000webhostapp.com/salon/salon_read.php',
      ),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      for (var m in data) {
        for (int o = 0; o < int.parse(m['salon_reservation']); o++) {
          msg.add(Salon.fromJson(m));
        }
      }
    } else {
      // Handle error
    }
  }
}

class Salon {
  final String salonId;
  final String salonUsername;
  final String barbarName;
  final String orderTime;

  Salon({
    required this.salonId,
    required this.salonUsername,
    required this.barbarName,
    required this.orderTime,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      salonId: json['salon_id'],
      salonUsername: json['salon_username'],
      barbarName: json['barbar_name'],
      orderTime: json['order_time'],
    );
  }
}
