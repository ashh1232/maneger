import 'package:get/get.dart';
import 'package:maneger/core/network/api_client.dart';
import 'package:maneger/core/security/encryption_service.dart';
import 'package:maneger/core/security/secure_storage.dart';
import 'package:maneger/features/products/domain/usecases/get_images_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Features: Auth
import 'package:maneger/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:maneger/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maneger/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:maneger/features/auth/domain/repositories/auth_repository.dart';
import 'package:maneger/features/auth/domain/usecases/login_usecase.dart';
import 'package:maneger/features/auth/domain/usecases/signup_usecase.dart';
import 'package:maneger/features/auth/domain/usecases/logout_usecase.dart';
import 'package:maneger/features/auth/presentation/controllers/auth_controller_clean.dart';

// Features: Products
import 'package:maneger/features/products/data/datasources/product_remote_datasource.dart';
import 'package:maneger/features/products/data/repositories/product_repository_impl.dart';
import 'package:maneger/features/products/domain/repositories/product_repository.dart';
import 'package:maneger/features/products/domain/usecases/get_products_usecase.dart';
import 'package:maneger/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:maneger/features/products/domain/usecases/get_banners_usecase.dart';
import 'package:maneger/features/products/presentation/controllers/product_controller_clean.dart';

// Features: Cart (NEW)
import 'package:maneger/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:maneger/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';
import 'package:maneger/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/toggle_select_all_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/toggle_selection_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:maneger/features/cart/presentation/controllers/cart_controller_clean.dart';

/// Dependency Injection Container
///
/// This class initializes and provides all dependencies for the app.
/// Uses GetX dependency injection.
class DependencyInjection {
  DependencyInjection._(); // Private constructor

  /// Initialize all dependencies
  static Future<void> init() async {
    // ==================== Core ====================

    // Encryption Service (Singleton)
    final encryptionService = EncryptionService();
    await encryptionService.initialize();
    Get.put<EncryptionService>(encryptionService, permanent: true);

    // Secure Storage (Singleton)
    final secureStorage = SecureStorage();
    await secureStorage.initialize();
    Get.put<SecureStorage>(secureStorage, permanent: true);

    // SharedPreferences (Singleton)
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);

    // API Client (Singleton)
    Get.put<ApiClient>(
      ApiClient(
        secureStorage: secureStorage,
        encryptionService: encryptionService,
      ),
      permanent: true,
    );

    // ==================== Features: Auth ====================

    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
        encryptionService: Get.find<EncryptionService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(secureStorage: Get.find<SecureStorage>()),
      fenix: true,
    );

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => SignupUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()), fenix: true);

    // Controllers
    Get.lazyPut(
      () => AuthControllerClean(
        loginUseCase: Get.find<LoginUseCase>(),
        signupUseCase: Get.find<SignupUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
      fenix: true,
    );

    // ==================== Features: Products ====================

    // Data Sources
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: Get.find<ProductRemoteDataSource>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
      () => GetProductsUseCase(Get.find<ProductRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCategoriesUseCase(Get.find<ProductRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetBannersUseCase(Get.find<ProductRepository>()),
      fenix: true,
    );
    // Use Cases
    Get.lazyPut(
      () => GetImagesUseCase(Get.find<ProductRepository>()),
      fenix: true,
    );
    // Controllers
    Get.lazyPut(
      () => ProductControllerClean(
        getProductsUseCase: Get.find<GetProductsUseCase>(),
        getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
        getBannersUseCase: Get.find<GetBannersUseCase>(),
      ),
      fenix: true,
    );

    // ==================== Features: Cart (NEW) ====================

    // Data Sources
    Get.lazyPut<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
      ),
      fenix: true, // Re-create if disposed
    );

    // Repository
    Get.lazyPut<CartRepository>(
      () =>
          CartRepositoryImpl(localDataSource: Get.find<CartLocalDataSource>()),
      fenix: true,
    );

    // Use Cases (Set fenix: true to allow recreation)
    Get.lazyPut(() => GetCartUseCase(Get.find<CartRepository>()), fenix: true);
    Get.lazyPut(
      () => AddToCartUseCase(Get.find<CartRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => RemoveFromCartUseCase(Get.find<CartRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UpdateCartQuantityUseCase(Get.find<CartRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ToggleSelectionUseCase(Get.find<CartRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ToggleSelectAllUseCase(Get.find<CartRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ClearCartUseCase(Get.find<CartRepository>()),
      fenix: true,
    );

    // Controller
    Get.put<CartControllerClean>(
      CartControllerClean(
        getCartUseCase: Get.find<GetCartUseCase>(),
        addToCartUseCase: Get.find<AddToCartUseCase>(),
        removeFromCartUseCase: Get.find<RemoveFromCartUseCase>(),
        updateCartQuantityUseCase: Get.find<UpdateCartQuantityUseCase>(),
        toggleSelectionUseCase: Get.find<ToggleSelectionUseCase>(),
        toggleSelectAllUseCase: Get.find<ToggleSelectAllUseCase>(),
        clearCartUseCase: Get.find<ClearCartUseCase>(),
      ),
      permanent: true, // Keep CartController alive throughout the session
    );

    print('✅ Dependency Injection initialized successfully');
  }

  /// Clean up all dependencies (call on app shutdown)
  static void dispose() {
    Get.delete<ApiClient>();
    Get.delete<EncryptionService>();
    Get.delete<SecureStorage>();
    print('🗑️ Dependencies disposed');
  }
}
