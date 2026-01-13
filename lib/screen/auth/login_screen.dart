import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/auth/auth_controller.dart';
import 'package:maneger/routes.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to your account',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please fill in all fields',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          authController.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA6338),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Get.toNamed(AppRoutes.home);
                            return;
                          }
                          authController.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA6338),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'ضيف',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => authController.errorMessage.isNotEmpty
                    ? Text(
                        authController.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : SizedBox.shrink(),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Get.toNamed('/signup'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFFA6338),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
