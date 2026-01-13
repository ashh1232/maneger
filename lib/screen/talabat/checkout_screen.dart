import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maneger/controller/talabat/checkout_controller.dart';
import 'package:maneger/routes.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController controller = Get.find<CheckoutController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('الدفع'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isProcessing.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Order Summary Card
              _buildOrderSummary(controller),

              const SizedBox(height: 16),

              // Delivery Information Form
              _buildDeliveryForm(controller),

              const SizedBox(height: 16),
              _buildMap(controller),
              const SizedBox(height: 16),

              // Payment Method Selection
              _buildPaymentMethod(controller),

              const SizedBox(height: 16),

              // Order Notes
              _buildOrderNotes(controller),

              const SizedBox(height: 24),

              // Place Order Button
              _buildPlaceOrderButton(controller),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  // Widget _buildMap(CheckoutController controller) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           // ignore: deprecated_member_use
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'العنوان',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           children: [
  //             Container(
  //               margin: const EdgeInsets.symmetric(horizontal: 16),
  //               child: InkWell(
  //                 onTap: () {
  //                   Get.toNamed(AppRoutes.mapScreen);
  //                 },
  //                 child: Row(
  //                   children: [
  //                     Icon(Icons.add_location),

  //                     Text(
  //                       'عنوان جديد',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),

  //             const SizedBox(width: 12),
  //             Container(
  //               width: 100,
  //               height: 100,
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey[300]!, width: 1),
  //               ),
  //               child: CachedNetworkImage(
  //                 imageUrl: 'https://tile.openstreetmap.org/1/1/1.png',
  //                 fit: BoxFit.cover,
  //                 height: 100,
  //                 width: 100,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMap(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'موقع التوصيل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.mapScreen),
                icon: const Icon(Icons.edit_location_alt, size: 20),
                label: const Text('تغيير'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // عرض الخريطة المصغرة
          Container(
            height: 180, // ارتفاع الخريطة المعروضة
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Obx(() {
                // نفترض وجود lat و lng في الـ controller
                final lat = controller.selectedLat;
                final lng = controller.selectedLong;

                return FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lng), // إحداثيات الموقع المختار
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag
                          .none, // جعلها للمعاينة فقط (غير قابلة للتحريك)
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      userAgentPackageName: 'com.your.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(lat, lng),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الطلب',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'المجموع',
            '\$${controller.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          // _buildSummaryRow(
          //   'Tax (8%)',
          //   '\$${controller.tax.toStringAsFixed(2)}',
          // ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'التوصيل',
            '\$${controller.shipping.toStringAsFixed(2)}',
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'المجموع (شامل التوصيل)',
            '\$${controller.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green[700] : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryForm(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات التوصيل',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: controller.nameController,
            label: 'الاسم الكامل',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controller.phoneController,
            label: 'رقم الهاتف',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: controller.addressController,
            label: 'العنوان',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildTextField(
          //         controller: controller.cityController,
          //         label: 'City',
          //         icon: Icons.location_city_outlined,
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: _buildTextField(
          //         controller: controller.countryController,
          //         label: 'Country',
          //         icon: Icons.flag_outlined,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildPaymentMethod(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'التوصيل',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Column(
              children: [
                _buildPaymentOption(controller, 'cash', 'توصيل', Icons.money),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  controller,
                  'card',
                  'المتجر',
                  Icons.credit_card,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    CheckoutController controller,
    String value,
    String label,
    IconData icon,
  ) {
    final isSelected = controller.selectedPaymentMethod.value == value;
    return InkWell(
      onTap: () => controller.selectPaymentMethod(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue[50] : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue[700] : Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.blue[700] : Colors.black,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderNotes(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملاحظات الطلب (اختياري)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'أضف أي تعليمات خاصة لطلبك...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => controller.placeOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'ارسال الطلب',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
