import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/api_response.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/error_response.dart';
import 'package:mazzraati_vendor_app/data/model/response/response_model.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future<bool> clearSharedData() {
    return authRepoInterface.clearSharedData();
  }

  @override
  Future<bool> clearUserNumberAndPassword() {
    return authRepoInterface.clearUserNumberAndPassword();
  }

  @override
  Future<ResponseModel> forgotPassword(String identity) async {
    try {
      ApiResponse apiResponse =
          await authRepoInterface.forgotPassword(identity);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        return ResponseModel(true, apiResponse.response!.data["message"]);
      } else {
        String errorMessage = apiResponse.error is String
            ? apiResponse.error.toString()
            : apiResponse.error?.errors?[0]?.message ?? 'something_went_wrong';
        return ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log("Forgot Password Exception: $e");
      return ResponseModel(false, e.toString());
    }
  }

  @override
  String getUserEmail() {
    return authRepoInterface.getUserEmail();
  }

  @override
  String getUserPassword() {
    return authRepoInterface.getUserPassword();
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();
  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  Future<ApiResponse> login({String? emailAddress, String? password}) async {
    ApiResponse apiResponse = await authRepoInterface.login(
        emailAddress: emailAddress, password: password);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = map["token"];
      saveUserToken(token);
    } else if (apiResponse.error == 'pending') {
      showCustomSnackBarWidget(
          getTranslated('your_account_is_in_review_process', Get.context!),
          Get.context!,
          sanckBarType: SnackBarType.error);
    } else if (apiResponse.error == 'unauthorized') {
      showCustomSnackBarWidget(
          getTranslated('invalid_credential', Get.context!), Get.context!,
          sanckBarType: SnackBarType.error);
    } else {
      showCustomSnackBarWidget(
          getTranslated('account_not_verified_yet', Get.context!), Get.context!,
          sanckBarType: SnackBarType.error);
    }
    return apiResponse;
  }

  @override
  Future<ApiResponse> registration(
      XFile? profileImage,
      XFile? shopLogo,
      XFile? shopBanner,
      XFile? secondaryBanner,
      RegisterModel registerModel) async {
    return authRepoInterface.registration(
        profileImage, shopLogo, shopBanner, secondaryBanner, registerModel);
  }

  @override
  Future<ResponseModel> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    try {
      ApiResponse apiResponse = await authRepoInterface.resetPassword(
          identity, otp, password, confirmPassword);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        return ResponseModel(true, apiResponse.response!.data["message"]);
      } else {
        log("Reset Password Error Response: ${apiResponse.response?.data.toString() ?? ''}");
        String errorMessage = 'Something went wrong';

        if (apiResponse.error is String) {
          errorMessage = apiResponse.error.toString();
        } else if (apiResponse.response?.data != null) {
          final data = apiResponse.response!.data;
          if (data is Map && data.containsKey('message')) {
            errorMessage = data['message'];
          } else if (data is Map && data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map) {
              var firstError = errors.values.first;
              if (firstError is List) {
                errorMessage = firstError[0]?.toString() ?? errorMessage;
              } else if (firstError is String) {
                errorMessage = firstError;
              }
            }
          }
        }

        return ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log("Reset Password Exception: $e");
      return ResponseModel(false, e.toString());
    }
  }

  @override
  Future<ResponseModel> resetPasswordVerifyOtp(
      String identity, String otp) async {
    try {
      ApiResponse apiResponse =
          await authRepoInterface.resetPasswordVerifyOtp(identity, otp);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        return ResponseModel(true, apiResponse.response!.data["message"]);
      } else {
        String errorMessage = 'Something went wrong';

        if (apiResponse.error is String) {
          errorMessage = apiResponse.error.toString();
        } else if (apiResponse.response?.data != null) {
          final data = apiResponse.response!.data;
          if (data is Map && data.containsKey('message')) {
            errorMessage = data['message'];
          } else if (data is Map && data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map) {
              var firstError = errors.values.first;
              if (firstError is List) {
                errorMessage = firstError[0]?.toString() ?? errorMessage;
              } else if (firstError is String) {
                errorMessage = firstError;
              }
            }
          }
        }

        return ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log("Reset Password Verify OTP Exception: $e");
      return ResponseModel(false, e.toString());
    }
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password) {
    return authRepoInterface.saveUserCredentials(number, password);
  }

  @override
  Future<void> saveUserToken(String token) {
    return authRepoInterface.saveUserToken(token);
  }

  @override
  Future<ApiResponse> setLanguageCode(String languageCode) {
    return authRepoInterface.setLanguageCode(languageCode);
  }

  @override
  Future<ApiResponse> updateToken() async {
    ApiResponse apiResponse = await authRepoInterface.updateToken();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      return apiResponse;
    } else {
      // ApiChecker.checkApi(apiResponse);
      return apiResponse;
    }
  }

  @override
  Future<ResponseModel> verifyOtp(String identity, String otp) async {
    ApiResponse apiResponse = await authRepoInterface.verifyOtp(identity, otp);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      return ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print(errorResponse.errors![0].message);
        }
        errorMessage = errorResponse.errors![0].message;
      }
      return ResponseModel(false, errorMessage);
    }
  }

  @override
  Future<ResponseModel> sendOtp(String identity) async {
    ApiResponse apiResponse = await authRepoInterface.sendOtp(identity);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      log(apiResponse.response.toString());
      return ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print(errorResponse.errors![0].message);
        }
        errorMessage = errorResponse.errors![0].message;
      }
      log(errorMessage ?? "");
      return ResponseModel(false, errorMessage);
    }
  }
}
