import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MessageController extends GetxController {
  var smList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSmList();
  }

  void loadSmList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the data as a raw String
    String? jsonString = prefs.getString('smList');

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        // Use json.decode() to convert the valid JSON string back to a List<dynamic>
        List<dynamic> decodedData = json.decode(jsonString);

        // Map the dynamic list to your specific List<Map<String, String>> type
        smList.value =
            decodedData.map((e) => Map<String, String>.from(e)).toList();
      } catch (e) {
        // Handle cases where the stored data might be corrupted or in the old, wrong format
        initializeDefaultList(prefs); // Re-initialize with default valid data
      }
    } else {
      // Data does not exist yet, initialize defaults and save correctly
      initializeDefaultList(prefs);
    }
  }

  void initializeDefaultList(SharedPreferences prefs) async {
    final defaultList = [
      {
        'link': 'https://www.facebook.com/profile.php?id=61553765874476',
        'name': 'facebook',
        'logoSrc':
            'https://res.cloudinary.com/dwsuclcox/image/upload/v1701334037/icon/face_wiq2j2.png',
      },
      {
        'link': 'https://www.facebook.com/profile.php?id=61553765874476',
        'name': 'instagram',
        'logoSrc':
            'https://res.cloudinary.com/dwsuclcox/image/upload/v1701334049/icon/inst_oaxabv.png',
      },
      {
        'link': 'https://www.facebook.com/profile.php?id=61553765874476',
        'name': 'whatsapp',
        'logoSrc':
            'https://res.cloudinary.com/dwsuclcox/image/upload/v1701334049/icon/wapp_nu1jjr.png',
      },
      // ... include all your default maps here
    ];

    smList.value = defaultList;

    // CRITICAL: Use json.encode() before saving to SharedPreferences
    await prefs.setString('smList', json.encode(defaultList));
  }

  // void loadSmList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('smList') != null) {
  //     smList.value = List<Map<String, String>>.from(
  //       (prefs.getString('smList') as List).map(
  //         (e) => Map<String, String>.from(e),
  //       ),
  //     );
  //   } else {
  //     smList.value = [
  //       {
  //         'link': 'https://www.facebook.com/profile.php?id=61553765874476',
  //         'name': 'facebook',
  //         'logoSrc':
  //             'https://res.cloudinary.com/dwsuclcox/image/upload/v1701334037/icon/face_wiq2j2.png',
  //       },
  //       {
  //         'link': 'https://www.facebook.com/profile.php?id=61553765874476',
  //         'name': 'instagram',
  //         'logoSrc':
  //             'https://res.cloudinary.com/dwsuclcox/image/upload/v1701334049/icon/inst_oaxabv.png',
  //       },
  //       {
  //         'link': 'https://www.facebook.com/profile.php?id=61553765874476',
  //         'name': 'whatsapp',
  //         'logoSrc':
  //             'https://res.cloudinary.com/dwsuclcox/image/upload/v1701334049/icon/wapp_nu1jjr.png',
  //       },
  //     ];
  //     prefs.setString('smList', smList.toString());
  //   }
  // }
}
