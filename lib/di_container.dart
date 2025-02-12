import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazzraati_vendor_app/features/auction/controllers/add_auction_controller.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/services/auth_service.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:mazzraati_vendor_app/features/bank_info/domain/repositories/bank_info_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/bank_info/domain/services/bank_info_service.dart';
import 'package:mazzraati_vendor_app/features/bank_info/domain/services/bank_info_service_interface.dart';
import 'package:mazzraati_vendor_app/features/barcode/controllers/barcode_controller.dart';
import 'package:mazzraati_vendor_app/features/barcode/domain/repositories/barcode_repository.dart';
import 'package:mazzraati_vendor_app/features/barcode/domain/repositories/barcode_reposity_interface.dart';
import 'package:mazzraati_vendor_app/features/barcode/domain/services/barcode_service.dart';
import 'package:mazzraati_vendor_app/features/barcode/domain/services/barcode_service_interface.dart';
import 'package:mazzraati_vendor_app/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/chat/domain/services/chat_service.dart';
import 'package:mazzraati_vendor_app/features/chat/domain/services/chat_service_interface.dart';
import 'package:mazzraati_vendor_app/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/coupon/domain/services/coupon_service.dart';
import 'package:mazzraati_vendor_app/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:mazzraati_vendor_app/features/delivery_man/domain/repositories/delivery_man_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/emergency_contract/domain/repositories/emergency_contract_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/delivery_man/domain/services/delivery_service.dart';
import 'package:mazzraati_vendor_app/features/delivery_man/domain/services/delivery_service_interface.dart';
import 'package:mazzraati_vendor_app/features/emergency_contract/domain/services/emergency_contruct_service_interface.dart';
import 'package:mazzraati_vendor_app/features/emergency_contract/domain/services/emergency_service.dart';
import 'package:mazzraati_vendor_app/features/notification/controllers/notification_controller.dart';
import 'package:mazzraati_vendor_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:mazzraati_vendor_app/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/notification/domain/services/notification_service.dart';
import 'package:mazzraati_vendor_app/features/notification/domain/services/notification_service_interface.dart';
import 'package:mazzraati_vendor_app/features/order/domain/repositories/location_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/order/domain/repositories/order_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/order/domain/services/location_service.dart';
import 'package:mazzraati_vendor_app/features/order/domain/services/location_service_interface.dart';
import 'package:mazzraati_vendor_app/features/order/domain/services/order_service.dart';
import 'package:mazzraati_vendor_app/features/order/domain/services/order_service_interface.dart';
import 'package:mazzraati_vendor_app/features/order_details/controllers/order_details_controller.dart';
import 'package:mazzraati_vendor_app/features/order_details/domain/repositories/order_details_repository.dart';
import 'package:mazzraati_vendor_app/features/order_details/domain/repositories/order_details_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/order_details/domain/services/order_details_service.dart';
import 'package:mazzraati_vendor_app/features/order_details/domain/services/order_details_service_interface.dart';
import 'package:mazzraati_vendor_app/features/pos/domain/repository/cart_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/pos/domain/services/cart_service.dart';
import 'package:mazzraati_vendor_app/features/pos/domain/services/cart_service_interface.dart';
import 'package:mazzraati_vendor_app/features/product/domain/repositories/product_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/product/domain/services/product_service.dart';
import 'package:mazzraati_vendor_app/features/product_details/controllers/productDetailsController.dart';
import 'package:mazzraati_vendor_app/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:mazzraati_vendor_app/features/product_details/domain/repositories/product_details_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/product_details/domain/services/product_details_service.dart';
import 'package:mazzraati_vendor_app/features/product_details/domain/services/product_details_service_interface.dart';
import 'package:mazzraati_vendor_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/profile/domain/services/profice_service_interface.dart';
import 'package:mazzraati_vendor_app/features/profile/domain/services/profile_service.dart';
import 'package:mazzraati_vendor_app/features/refund/domain/repositories/refund_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/refund/domain/services/refund_service.dart';
import 'package:mazzraati_vendor_app/features/refund/domain/services/refund_service_interface.dart';
import 'package:mazzraati_vendor_app/features/review/domain/repositories/product_review_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/review/domain/services/review_service.dart';
import 'package:mazzraati_vendor_app/features/review/domain/services/review_service_interface.dart';
import 'package:mazzraati_vendor_app/features/settings/domain/repositories/buisness_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/settings/domain/repositories/business_repository.dart';
import 'package:mazzraati_vendor_app/features/pos/domain/repository/cart_repository.dart';
import 'package:mazzraati_vendor_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:mazzraati_vendor_app/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:mazzraati_vendor_app/features/delivery_man/domain/repositories/delivery_man_repository.dart';
import 'package:mazzraati_vendor_app/features/emergency_contract/domain/repositories/emergency_contact_repository.dart';
import 'package:mazzraati_vendor_app/features/order/domain/repositories/location_repository.dart';
import 'package:mazzraati_vendor_app/features/order/domain/repositories/order_repository.dart';
import 'package:mazzraati_vendor_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:mazzraati_vendor_app/features/refund/domain/repositories/refund_repository.dart';
import 'package:mazzraati_vendor_app/features/settings/domain/services/business_service.dart';
import 'package:mazzraati_vendor_app/features/settings/domain/services/business_service_interface.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/repositories/shipping_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/services/shipping_service.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/services/shipping_service_interface.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/repository/add_product_repository.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/repositories/shipping_repository.dart';
import 'package:mazzraati_vendor_app/features/shop/domain/repositories/shop_repository.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/repository/add_product_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/services/add_product_service.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/services/add_product_service_interface.dart';
import 'package:mazzraati_vendor_app/features/shop/domain/repositories/shop_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/shop/domain/services/shop_service.dart';
import 'package:mazzraati_vendor_app/features/shop/domain/services/shop_service_interface.dart';
import 'package:mazzraati_vendor_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:mazzraati_vendor_app/features/bank_info/domain/repositories/bank_info_repository.dart';
import 'package:mazzraati_vendor_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/splash/domain/services/splash_service.dart';
import 'package:mazzraati_vendor_app/features/splash/domain/services/splash_service_interface.dart';
import 'package:mazzraati_vendor_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/settings/controllers/business_controller.dart';
import 'package:mazzraati_vendor_app/features/transaction/domain/repositories/transaction_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/transaction/domain/services/transaction_service.dart';
import 'package:mazzraati_vendor_app/features/transaction/domain/services/transaction_service_interface.dart';
import 'package:mazzraati_vendor_app/features/wallet/controllers/wallet_controller.dart';
import 'package:mazzraati_vendor_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:mazzraati_vendor_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/wallet/domain/services/wallet_service.dart';
import 'package:mazzraati_vendor_app/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:mazzraati_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:mazzraati_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:mazzraati_vendor_app/features/coupon/controllers/coupon_controller.dart';
import 'package:mazzraati_vendor_app/features/delivery_man/controllers/delivery_man_controller.dart';
import 'package:mazzraati_vendor_app/features/emergency_contract/controllers/emergency_contact_controller.dart';
import 'package:mazzraati_vendor_app/features/language/controllers/language_controller.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:mazzraati_vendor_app/features/order/controllers/location_controller.dart';
import 'package:mazzraati_vendor_app/features/order/controllers/order_controller.dart';
import 'package:mazzraati_vendor_app/features/product/controllers/product_controller.dart';
import 'package:mazzraati_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:mazzraati_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:mazzraati_vendor_app/features/refund/controllers/refund_controller.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:mazzraati_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:mazzraati_vendor_app/features/transaction/controllers/transaction_controller.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/services/product_service_interface.dart';
import 'features/review/domain/repositories/product_review_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());

  //interface
  AuthRepositoryInterface authRepoInterface =
      AuthRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => authRepoInterface);
  BankInfoRepositoryInterface bankInfoRepoInterface =
      BankInfoRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => bankInfoRepoInterface);
  ChatRepositoryInterface chatRepoInterface = ChatRepository(dioClient: sl());
  sl.registerLazySingleton(() => chatRepoInterface);
  CouponRepositoryInterface couponRepoInterface =
      CouponRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => couponRepoInterface);
  DeliveryManRepositoryInterface deliveryManRepoInterface =
      DeliveryManRepository(dioClient: sl());
  sl.registerLazySingleton(() => deliveryManRepoInterface);
  EmergencyContractRepositoryInterface emergencyContractRepoInterface =
      EmergencyContactRepository(dioClient: sl());
  sl.registerLazySingleton(() => emergencyContractRepoInterface);
  OrderRepositoryInterface orderRepoInterface =
      OrderRepository(dioClient: sl());
  sl.registerLazySingleton(() => orderRepoInterface);
  ProductRepositoryInterface productRepoInterface =
      ProductRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => productRepoInterface);
  ProfileRepositoryInterface profileRepoInterface =
      ProfileRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => profileRepoInterface);
  RefundRepositoryInterface refundRepoInterface =
      RefundRepository(dioClient: sl());
  sl.registerLazySingleton(() => refundRepoInterface);
  ProductReviewRepositoryInterface productReviewRepoInterface =
      ProductReviewRepository(dioClient: sl());
  sl.registerLazySingleton(() => productReviewRepoInterface);
  BusinessRepositoryInterface businessRepoInterface = BusinessRepository();
  sl.registerLazySingleton(() => businessRepoInterface);
  ShippingRepositoryInterface shippingRepoInterface =
      ShippingRepository(dioClient: sl());
  sl.registerLazySingleton(() => shippingRepoInterface);
  AddProductRepositoryInterface addProductRepositoryInterface =
      AddProductRepository(dioClient: sl());
  sl.registerLazySingleton(() => addProductRepositoryInterface);
  SplashRepositoryInterface splashRepoInterface =
      SplashRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => splashRepoInterface);
  TransactionRepositoryInterface transactionRepoInterface =
      TransactionRepository(dioClient: sl());
  sl.registerLazySingleton(() => transactionRepoInterface);
  NotificationRepositoryInterface notificationRepoInterface =
      NotificationRepository(dioClient: sl());
  sl.registerLazySingleton(() => notificationRepoInterface);
  WalletRepositoryInterface walletRepoInterface =
      WalletRepository(dioClient: sl());
  sl.registerLazySingleton(() => walletRepoInterface);
  LocationRepositoryInterface locationRepositoryInterface =
      LocationRepository(dioClient: sl());
  sl.registerLazySingleton(() => locationRepositoryInterface);
  CartRepositoryInterface cartRepositoryInterface =
      CartRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => cartRepositoryInterface);
  ShopRepositoryInterface shopRepositoryInterface =
      ShopRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => shopRepositoryInterface);
  OrderDetailsRepositoryInterface orderDetailsRepositoryInterface =
      OrderDetailsRepository(dioClient: sl());
  sl.registerLazySingleton(() => orderDetailsRepositoryInterface);
  ProductDetailsRepositoryInterface productDetailsRepositoryInterface =
      ProductDetailsRepository(dioClient: sl());
  sl.registerLazySingleton(() => productDetailsRepositoryInterface);
  BarcodeRepositoryInterface barcodeRepositoryInterface =
      BarcodeRepository(dioClient: sl());
  sl.registerLazySingleton(() => barcodeRepositoryInterface);

  AuthServiceInterface authServiceInterface =
      AuthService(authRepoInterface: sl());
  sl.registerLazySingleton(() => authServiceInterface);
  BankInfoServiceInterface bankInfoServiceInterface =
      BankInfoService(bankInfoRepoInterface: sl());
  sl.registerLazySingleton(() => bankInfoServiceInterface);
  ChatServiceInterface chatServiceInterface =
      ChatService(chatRepoInterface: sl());
  sl.registerLazySingleton(() => chatServiceInterface);
  CouponServiceInterface couponServiceInterface =
      CouponService(couponRepoInterface: sl());
  sl.registerLazySingleton(() => couponServiceInterface);
  DeliveryServiceInterface deliveryServiceInterface =
      DeliveryService(deliveryManRepoInterface: sl());
  sl.registerLazySingleton(() => deliveryServiceInterface);
  EmergencyServiceInterface emergencyServiceInterface =
      EmergencyService(emergencyContractRepoInterface: sl());
  sl.registerLazySingleton(() => emergencyServiceInterface);
  OrderServiceInterface orderServiceInterface =
      OrderService(orderRepoInterface: sl());
  sl.registerLazySingleton(() => orderServiceInterface);
  ProductServiceInterface productServiceInterface =
      ProductService(productRepoInterface: sl());
  sl.registerLazySingleton(() => productServiceInterface);
  ProfileServiceInterface profileServiceInterface =
      ProfileService(profileRepoInterface: sl());
  sl.registerLazySingleton(() => profileServiceInterface);
  RefundServiceInterface refundServiceInterface =
      RefundService(refundRepoInterface: sl());
  sl.registerLazySingleton(() => refundServiceInterface);
  ReviewServiceInterface reviewServiceInterface =
      ReviewService(productReviewRepoInterface: sl());
  sl.registerLazySingleton(() => reviewServiceInterface);
  BusinessServiceInterface businessServiceInterface =
      BusinessService(businessRepoInterface: sl());
  sl.registerLazySingleton(() => businessServiceInterface);
  ShippingServiceInterface shippingServiceInterface =
      ShippingService(shippingRepoInterface: sl());
  sl.registerLazySingleton(() => shippingServiceInterface);
  AddProductServiceInterface addProductServiceInterface =
      AddProductService(shopRepoInterface: sl());
  sl.registerLazySingleton(() => addProductServiceInterface);
  SplashServiceInterface splashServiceInterface =
      SplashService(splashRepoInterface: sl());
  sl.registerLazySingleton(() => splashServiceInterface);
  TransactionServiceInterface transactionServiceInterface =
      TransactionService(transactionRepoInterface: sl());
  sl.registerLazySingleton(() => transactionServiceInterface);
  NotificationServiceInterface notificationServiceInterface =
      NotificationService(notificationRepoInterface: sl());
  sl.registerLazySingleton(() => notificationServiceInterface);
  WalletServiceInterface walletServiceInterface =
      WalletService(walletRepoInterface: sl());
  sl.registerLazySingleton(() => walletServiceInterface);
  LocationServiceInterface locationServiceInterface =
      LocationService(locationRepositoryInterface: sl());
  sl.registerLazySingleton(() => locationServiceInterface);
  CartServiceInterface cartServiceInterface =
      CartService(cartRepositoryInterface: sl());
  sl.registerLazySingleton(() => cartServiceInterface);
  ShopServiceInterface shopServiceInterface =
      ShopService(shopRepositoryInterface: sl());
  sl.registerLazySingleton(() => shopServiceInterface);
  OrderDetailsServiceInterface orderDetailsServiceInterface =
      OrderDetailsService(orderDetailsRepositoryInterface: sl());
  sl.registerLazySingleton(() => orderDetailsServiceInterface);
  ProductDetailsServiceInterface productDetailsServiceInterface =
      ProductDetailsService(productDetailsRepositoryInterface: sl());
  sl.registerLazySingleton(() => productDetailsServiceInterface);
  BarcodeServiceInterface barcodeServiceInterface =
      BarcodeService(barcodeRepositoryInterface: sl());
  sl.registerLazySingleton(() => barcodeServiceInterface);

  //services
  sl.registerLazySingleton(() => AuthService(authRepoInterface: sl()));
  sl.registerLazySingleton(() => BankInfoService(bankInfoRepoInterface: sl()));
  sl.registerLazySingleton(() => ChatService(chatRepoInterface: sl()));
  sl.registerLazySingleton(() => CouponService(couponRepoInterface: sl()));
  sl.registerLazySingleton(
      () => DeliveryService(deliveryManRepoInterface: sl()));
  sl.registerLazySingleton(
      () => EmergencyService(emergencyContractRepoInterface: sl()));
  sl.registerLazySingleton(() => OrderService(orderRepoInterface: sl()));
  sl.registerLazySingleton(() => ProductService(productRepoInterface: sl()));
  sl.registerLazySingleton(() => ProfileService(profileRepoInterface: sl()));
  sl.registerLazySingleton(() => RefundService(refundRepoInterface: sl()));
  sl.registerLazySingleton(
      () => ReviewService(productReviewRepoInterface: sl()));
  sl.registerLazySingleton(() => BusinessService(businessRepoInterface: sl()));
  sl.registerLazySingleton(() => ShippingService(shippingRepoInterface: sl()));
  sl.registerLazySingleton(() => AddProductService(shopRepoInterface: sl()));
  sl.registerLazySingleton(() => SplashService(splashRepoInterface: sl()));
  sl.registerLazySingleton(
      () => TransactionService(transactionRepoInterface: sl()));
  sl.registerLazySingleton(
      () => NotificationService(notificationRepoInterface: sl()));
  sl.registerLazySingleton(() => WalletService(walletRepoInterface: sl()));
  sl.registerLazySingleton(
      () => LocationService(locationRepositoryInterface: sl()));
  sl.registerLazySingleton(() => CartService(cartRepositoryInterface: sl()));
  sl.registerLazySingleton(() => ShopService(shopRepositoryInterface: sl()));
  sl.registerLazySingleton(
      () => OrderDetailsService(orderDetailsRepositoryInterface: sl()));
  sl.registerLazySingleton(
      () => ProductDetailsService(productDetailsRepositoryInterface: sl()));
  sl.registerLazySingleton(
      () => BarcodeService(barcodeRepositoryInterface: sl()));

  // Repository
  sl.registerLazySingleton(
      () => AuthRepository(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => SplashRepository(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => ProfileRepository(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ShopRepository(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepository(dioClient: sl()));
  sl.registerLazySingleton(
      () => BankInfoRepository(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepository(dioClient: sl()));
  sl.registerLazySingleton(() => BusinessRepository());
  sl.registerLazySingleton(() => TransactionRepository(dioClient: sl()));
  sl.registerLazySingleton(() => AddProductRepository(dioClient: sl()));
  sl.registerLazySingleton(
      () => ProductRepository(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductReviewRepository(dioClient: sl()));
  sl.registerLazySingleton(() => ShippingRepository(dioClient: sl()));
  sl.registerLazySingleton(() => DeliveryManRepository(dioClient: sl()));
  sl.registerLazySingleton(() => RefundRepository(dioClient: sl()));
  sl.registerLazySingleton(
      () => CartRepository(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => EmergencyContactRepository(dioClient: sl()));
  sl.registerLazySingleton(() => LocationRepository(dioClient: sl()));
  sl.registerLazySingleton(
      () => CouponRepository(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepository(dioClient: sl()));
  sl.registerLazySingleton(() => WalletRepository(dioClient: sl()));
  sl.registerLazySingleton(() => OrderDetailsRepository(dioClient: sl()));
  sl.registerLazySingleton(() => ProductDetailsRepository(dioClient: sl()));
  sl.registerLazySingleton(() => BarcodeRepository(dioClient: sl()));

  // Controller
  sl.registerFactory(() => AuthController(authServiceInterface: sl()));
  sl.registerFactory(() => BankInfoController(bankInfoServiceInterface: sl()));
  sl.registerFactory(() => ChatController(chatServiceInterface: sl()));
  sl.registerFactory(() => CouponController(couponServiceInterface: sl()));
  sl.registerFactory(
      () => DeliveryManController(deliveryServiceInterface: sl()));
  sl.registerFactory(
      () => EmergencyContactController(emergencyServiceInterface: sl()));
  sl.registerFactory(() => OrderController(orderServiceInterface: sl()));
  sl.registerFactory(() => ProductController(productServiceInterface: sl()));
  sl.registerFactory(() => ProfileController(profileServiceInterface: sl()));
  sl.registerFactory(() => RefundController(refundServiceInterface: sl()));
  sl.registerFactory(
      () => ProductReviewController(reviewServiceInterface: sl()));
  sl.registerFactory(() => BusinessController(businessServiceInterface: sl()));
  sl.registerFactory(() => ShippingController(shippingServiceInterface: sl()));
  sl.registerFactory(() => AddProductController(shopServiceInterface: sl()));
  sl.registerFactory(() => SplashController(serviceInterface: sl()));
  sl.registerFactory(
      () => TransactionController(transactionServiceInterface: sl()));
  sl.registerFactory(
      () => NotificationController(notificationServiceInterface: sl()));
  sl.registerFactory(() => WalletController(walletServiceInterface: sl()));
  sl.registerFactory(
      () => OrderDetailsController(orderDetailsServiceInterface: sl()));
  sl.registerFactory(
      () => ProductDetailsController(productDetailsServiceInterface: sl()));
  sl.registerFactory(() => ThemeController(sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationController(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageController());
  sl.registerFactory(() => ShopController(shopServiceInterface: sl()));
  sl.registerFactory(() => CartController(cartServiceInterface: sl()));
  sl.registerFactory(() => BottomMenuController());
  sl.registerFactory(() => LocationController(locationServiceInterface: sl()));
  sl.registerFactory(() => BarcodeController(barcodeServiceInterface: sl()));
  sl.registerFactory(() => AddAuctionController());
}
