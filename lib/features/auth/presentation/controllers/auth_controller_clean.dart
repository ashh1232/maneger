import 'package:get/get.dart';
import 'package:maneger/features/auth/domain/usecases/login_usecase.dart';
import 'package:maneger/features/auth/domain/usecases/signup_usecase.dart';
import 'package:maneger/features/auth/domain/usecases/logout_usecase.dart';
import 'package:maneger/features/auth/domain/entities/user.dart';
import 'package:maneger/routes.dart';

/// Auth Controller using Clean Architecture
///
/// This controller is now thin - it only handles UI state and delegates
/// business logic to use cases.
class AuthControllerClean extends GetxController {
  // Dependencies (injected via constructor)
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;

  AuthControllerClean({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
  });

  // Reactive state
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  /// Check if user is logged in
  Future<void> checkLoginStatus() async {
    // This would be implemented via a GetCurrentUserUseCase
    // For now, we'll check in the next iteration
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    try {
      // Clear previous errors
      errorMessage.value = '';
      isLoading.value = true;

      // Call use case
      final result = await loginUseCase(
        LoginParams(email: email, password: password),
      );

      // Handle result
      result.fold(
        // Failure case
        (failure) {
          errorMessage.value = failure.message;
          Get.rawSnackbar(
            title: 'Login Failed',
            message: failure.message,
            duration: const Duration(seconds: 3),
          );
        },
        // Success case
        (user) {
          currentUser.value = user;
          isLoggedIn.value = true;
          errorMessage.value = '';

          // Navigate to home
          Get.offAllNamed(AppRoutes.home);

          Get.rawSnackbar(
            title: 'Welcome',
            message: 'Login successful!',
            duration: const Duration(seconds: 2),
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Signup new user
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) async {
    try {
      errorMessage.value = '';
      isLoading.value = true;

      // Call use case
      final result = await signupUseCase(
        SignupParams(
          username: username,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          phone: phone,
        ),
      );

      // Handle result
      result.fold(
        // Failure case
        (failure) {
          errorMessage.value = failure.message;
          Get.rawSnackbar(
            title: 'Signup Failed',
            message: failure.message,
            duration: const Duration(seconds: 3),
          );
        },
        // Success case
        (user) {
          currentUser.value = user;
          isLoggedIn.value = true;
          errorMessage.value = '';

          // Navigate to home
          Get.offAllNamed(AppRoutes.home);

          Get.rawSnackbar(
            title: 'Welcome',
            message: 'Account created successfully!',
            duration: const Duration(seconds: 2),
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Call use case
      final result = await logoutUseCase();

      // Handle result
      result.fold(
        (failure) {
          Get.rawSnackbar(
            title: 'Logout Failed',
            message: failure.message,
            duration: const Duration(seconds: 2),
          );
        },
        (_) {
          currentUser.value = null;
          isLoggedIn.value = false;

          // Navigate to login
          Get.offAllNamed(AppRoutes.login);

          Get.rawSnackbar(
            title: 'Logged Out',
            message: 'Successfully logged out',
            duration: const Duration(seconds: 2),
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user ID
  String? get userId => currentUser.value?.id;

  /// Get username
  String? get username => currentUser.value?.name;

  /// Update user data
  void updateUser(User user) {
    currentUser.value = user;
  }
}
