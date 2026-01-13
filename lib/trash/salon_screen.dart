import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'salon_controller.dart';

class SalonView extends StatelessWidget {
  final SalonController salonController = Get.put(SalonController());

  SalonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salon View')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  const Text(
                    'الدور',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Obx(
                    () => Text(
                      '${salonController.msg.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                if (salonController.msg.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: salonController.msg.length,
                    itemBuilder: (context, index) {
                      final ms = salonController.msg[index];
                      return Card(
                        child: ListTile(
                          leading: Text(
                            index == 0 ? 'الدور' : '${index + 1}:',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            ms.salonUsername,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(ms.barbarName), Text(ms.orderTime)],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Handle delete action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('حذف'),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle edit action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: const Text('تعديل'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
