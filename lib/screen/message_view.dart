import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/message_controller.dart';

class MessageView extends StatelessWidget {
  final MessageController controller = Get.put(MessageController());

  MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message View')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.smList.length,
            itemBuilder: (context, index) {
              var crt = controller.smList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  child: ListTile(
                    leading: Image.network(crt['logoSrc']!),
                    title: Text('التواصل من خلال ${crt['name']}'),
                    onTap: () async {
                      // 1. Get the string URL
                      var urlString = crt['link']!;

                      // 2. Convert the string URL into a Uri object
                      final Uri url = Uri.parse(urlString); //

                      // 3. Use the Uri object in canLaunchUrl and launchUrl
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        // It's better to print an error message or show a snackbar instead of throwing
                        // a general exception here, which might crash your UI.
                        // You could also show a Get.snackbar() here if you are using GetX
                      }
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
