import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maneger/controller/talabat/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController controller = Get.find<CheckoutController>();

    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('الدفع'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.surface,
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
              _buildOrderSummary(controller, context),

              const SizedBox(height: 16),

              // Delivery Information Form
              _buildDeliveryForm(controller, context),

              const SizedBox(height: 16),
              _buildMap(controller, context),
              const SizedBox(height: 16),

              // Payment Method Selection
              _buildPaymentMethod(controller, context),

              const SizedBox(height: 16),

              // Order Notes
              _buildOrderNotes(controller, context),

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

  Widget _buildMap(CheckoutController controller, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                onPressed: () => controller.openMap(),
                icon: const Icon(Icons.edit_location_alt, size: 20),
                label: const Text('تغيير'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // عرض الخريطة المصغرة
          InkWell(
            onTap: () => controller.openMap(),
            child: Container(
              height: 180, // ارتفاع الخريطة المعروضة
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Obx(() {
                  if (controller.ismap.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.selectedLat.value == 0.0 &&
                      controller.selectedLong.value == 0.0) {
                    return const Center(child: Text('لا يوجد موقع محدد'));
                  }

                  // نفترض وجود lat و lng في الـ controller
                  final lat = controller.selectedLat;
                  final lng = controller.selectedLong;

                  return IgnorePointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          lat.value,
                          lng.value,
                        ), // إحداثيات الموقع المختار
                        initialZoom: 17.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag
                              .none, // جعلها للمعاينة فقط (غير قابلة للتحريك)
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
                          userAgentPackageName: 'com.your.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(lat.value, lng.value),
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
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
    CheckoutController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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

  Widget _buildDeliveryForm(
    CheckoutController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
          const SizedBox(height: 8),
          _buildTextField(
            controller: controller.phoneController,
            label: 'رقم الهاتف',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: controller.addressController,
            label: 'الحاره',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
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

  Widget _buildPaymentMethod(
    CheckoutController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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

  Widget _buildOrderNotes(CheckoutController controller, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.placeOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
