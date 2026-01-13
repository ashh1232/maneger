import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/talabat/profile_controller.dart';

import '../../model/order_model.dart';
// import 'package:talabat/class/statusrequest.dart';
// import 'package:talabat/controller/profile_controller.dart';
// import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(controller.isEditing.value ? Icons.close : Icons.edit),
              onPressed: () => controller.toggleEditMode(),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.statusRequest.value == StatusRequest.loading &&
            controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileHeader(controller),
              const SizedBox(height: 20),
              _buildProfileInfo(controller),
              const SizedBox(height: 16),
              _buildOrderHistory(controller),
              const SizedBox(height: 16),
              _buildSettings(controller),
              const SizedBox(height: 16),
              _buildLogoutButton(controller),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          // Profile Image
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                backgroundImage: controller.user.value?.fullImageUrl != null
                    ? NetworkImage(controller.user.value!.fullImageUrl!)
                    : null,
                child: controller.user.value?.fullImageUrl == null
                    ? Icon(Icons.person, size: 50, color: Colors.blue[700])
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              controller.user.value?.displayName ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              controller.user.value?.userEmail ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        if (controller.isEditing.value) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildEditField(
                controller: controller.nameController,
                label: 'Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildEditField(
                controller: controller.phoneController,
                label: 'Phone',
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
              _buildEditField(
                controller: controller.addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildEditField(
                controller: controller.cityController,
                label: 'City',
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 12),
              _buildEditField(
                controller: controller.countryController,
                label: 'Country',
                icon: Icons.flag_outlined,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => controller.updateProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.person_outline,
                'Name',
                controller.user.value?.userName ?? 'N/A',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.phone_outlined,
                'Phone',
                controller.user.value?.userPhone ?? 'N/A',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Address',
                controller.user.value?.userAddress ?? 'N/A',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.location_city_outlined,
                'City',
                controller.user.value?.userCity ?? 'N/A',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.flag_outlined,
                'Country',
                controller.user.value?.userCountry ?? 'N/A',
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700], size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderHistory(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full order history
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.orders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No orders yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: controller.orders.take(3).map((order) {
                return _buildOrderCard(order);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final date = DateTime.tryParse(order.createdAt);
    final formattedDate = date != null
        ? DateFormat('MMM dd, yyyy').format(date)
        : order.createdAt;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shopping_bag_outlined, color: Colors.blue[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.orderId}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSettings(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Arabic',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Enabled',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(ProfileController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () => controller.logout(),
        icon: const Icon(Icons.logout),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
