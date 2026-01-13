// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ShadaController extends GetxController {
//   var round = 1.obs;
//   var ne = 0.obs;
//   var newGame = <Map<String, dynamic>>[].obs;
//   var shdaData = <Map<String, dynamic>>[].obs;
//   var newplayer = {}.obs;
//   var mode = 'newgame'.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadShdaData();
//   }
//
//   // void loadShdaData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   if (prefs.getString('shdaData') != null) {
//   //     shdaData.value = List<Map<String, dynamic>>.from(
//   //       (prefs.getString('shdaData') as List).map(
//   //         (e) => Map<String, dynamic>.from(e),
//   //       ),
//   //     );
//   //   } else {
//   //     shdaData.value = [{}];
//   //     prefs.setString('shdaData', shdaData.toString());
//   //   }
//   //
//   //   if (prefs.getString('newGame') != null) {
//   //     newGame.value = List<Map<String, dynamic>>.from(
//   //       (prefs.getString('newGame') as List).map(
//   //         (e) => Map<String, dynamic>.from(e),
//   //       ),
//   //     );
//   //   } else {
//   //     newGame.value = [
//   //       {
//   //         'name': '',
//   //         'total': '',
//   //         'score': '',
//   //         'round': '0',
//   //         'date': DateTime.now().toString(),
//   //       },
//   //     ];
//   //   }
//
//   //   if (prefs.getString('newplayer') != null) {
//   //     newplayer.value = Map<String, dynamic>.from(
//   //       prefs.getString('newplayer') as Map,
//   //     );
//   //   } else {
//   //     newplayer.value = {
//   //       'name': '',
//   //       'total': '',
//   //       'score': '',
//   //       'round': '0',
//   //       'date': DateTime.now().toString(),
//   //     };
//   //   }
//   // }
//
//   void saveShdaData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('shdaData', shdaData.toString());
//     prefs.setString('newGame', newGame.toString());
//     prefs.setString('newplayer', newplayer.toString());
//   }
//
//   void newGameBtn() {
//     if (mode.value == 'start') {
//       mode.value = 'newgame';
//     } else {
//       mode.value = 'start';
//       round.value = 1;
//       ne.value = 0;
//       newGame.value = [
//         {
//           'name': '',
//           'total': '',
//           'score': '',
//           'round': '0',
//           'date': DateTime.now().toString(),
//         },
//       ];
//       shdaData.add(newGame as Map<String, dynamic>);
//       saveShdaData();
//     }
//   }
//
//   void addNewPlayer(String playerName) {
//     if (playerName.isEmpty) {
//       // Handle empty player name
//     } else {
//       newplayer.value = {
//         'name': playerName,
//         'total': '',
//         'round': '',
//         'score': '',
//         'date': DateTime.now().toString(),
//       };
//       newGame.add(newplayer as Map<String, dynamic>);
//       saveShdaData();
//       ne.value++;
//     }
//   }
//
//   void getTotal() {
//     // Implement getTotal logic
//   }
//
//   void addScore() {
//     // Implement addScore logic
//   }
// }
