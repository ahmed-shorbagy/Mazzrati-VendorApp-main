import 'package:image_picker/image_picker.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/api_response.dart';
import 'package:mazzraati_vendor_app/data/model/response/response_model.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/models/register_model.dart';

abstract class AuthServiceInterface {
  Future<ApiResponse> login({String? emailAddress, String? password});
  Future<void> saveUserToken(String token);
  Future<ApiResponse> updateToken();
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserNumberAndPassword(String number, String password);
  String getUserEmail();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  Future<ResponseModel> forgotPassword(String identity);
  Future<ResponseModel> verifyOtp(String identity, String otp);
  Future<ResponseModel> resetPassword(
      String identity, String otp, String password, String confirmPassword);
  Future<ResponseModel> resetPasswordVerifyOtp(String identity, String otp);
  Future<ApiResponse> registration(XFile? profileImage, XFile? shopLogo,
      XFile? shopBanner, XFile? secondaryBanner, RegisterModel registerModel);
  Future<ApiResponse> setLanguageCode(String languageCode);
  Future<ResponseModel> sendOtp(String identity);
}
