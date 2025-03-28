import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mazzraati_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:mazzraati_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/api_response.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponse> login({String? emailAddress, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"phone": emailAddress, "password": password},
      );
      AppConstants.logWithColor(response.data.toString(), AppConstants.red);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> setLanguageCode(String languageCode) async {
    try {
      final response = await dioClient!.post(AppConstants.setCurrentLanguageUri,
          data: {'current_language': languageCode, '_method': 'put'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> forgotPassword(String identity) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.forgotPasswordUri, data: {"identity": identity});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    try {
      log("Sending data: identity=$identity, otp=$otp, password=$password");

      Response response = await dioClient!.put(
        AppConstants.resetPasswordUri,
        data: {
          "identity": identity,
          "otp": int.tryParse(otp) ?? otp,
          "password": password,
          "confirm_password": confirmPassword
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      log("Response Data: ${response.data}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      log("Error: ${e.toString()}");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> sendOtp(String phone) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.SendOtpUri, data: {"phone": phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> verifyOtp(String phoneNumber, String otp) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyOtpUri,
          data: {"phone": phoneNumber, "otp": otp});
      AppConstants.logWithColor(response.data.toString(), AppConstants.red);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resetPasswordVerifyOtp(
      String identity, String otp) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.resetPasswordVerifyOtpUri,
          data: {"identity": identity, "otp": otp});
      log("${response.headers} ${response.data}");
      log("Request URL: ${AppConstants.resetPasswordVerifyOtpUri}");
      log("Request Headers: ${dioClient!.dio!.options.headers}");
      log("Request Data: {'identity': $identity, 'otp': $otp}");
      log(response.data.toString());
      AppConstants.logWithColor(response.data.toString(), AppConstants.red);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      log(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateToken() async {
    try {
      String? deviceToken = await _getDeviceToken();
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: {"_method": "put", "cm_firebase_token": deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> _getDeviceToken() async {
    String? deviceToken;
    if (Platform.isIOS) {
      deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }

    if (kDebugMode) {
      print('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }

  @override
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  @override
  Future<bool> clearSharedData() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
    return sharedPreferences!.remove(AppConstants.token);
  }

  @override
  Future<void> saveUserCredentials(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.userPassword, password);
      await sharedPreferences!.setString(AppConstants.userEmail, number);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserEmail() {
    return sharedPreferences!.getString(AppConstants.userEmail) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.userPassword) ?? "";
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.userPassword);
    return await sharedPreferences!.remove(AppConstants.userEmail);
  }

  @override
  Future<ApiResponse> registration(
      XFile? profileImage,
      XFile? shopLogo,
      XFile? shopBanner,
      XFile? secondaryBanner,
      RegisterModel registerModel) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.registration}'));
    if (profileImage != null) {
      Uint8List list = await profileImage.readAsBytes();
      var part = http.MultipartFile(
          'image', profileImage.readAsBytes().asStream(), list.length,
          filename: basename(profileImage.path));
      request.files.add(part);
    }
    if (shopLogo != null) {
      Uint8List list = await shopLogo.readAsBytes();
      var part = http.MultipartFile(
          'logo', shopLogo.readAsBytes().asStream(), list.length,
          filename: basename(shopLogo.path));
      request.files.add(part);
    }
    if (shopBanner != null) {
      Uint8List list = await shopBanner.readAsBytes();
      var part = http.MultipartFile(
          'banner', shopBanner.readAsBytes().asStream(), list.length,
          filename: basename(shopBanner.path));
      request.files.add(part);
    }
    if (secondaryBanner != null) {
      Uint8List list = await secondaryBanner.readAsBytes();
      var part = http.MultipartFile('bottom_banner',
          secondaryBanner.readAsBytes().asStream(), list.length,
          filename: basename(secondaryBanner.path));
      request.files.add(part);
    }
    const String countryCode = '+966';
    if (registerModel.phone!.startsWith(countryCode)) {
      registerModel.phone = registerModel.phone!.substring(countryCode.length);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'f_name': registerModel.fName!,
      'l_name': registerModel.lName!,
      'phone': registerModel.phone!,
      'email': registerModel.email!,
      'national_id': registerModel.id!,
      'lng': registerModel.longitude!,
      'lat': registerModel.latitude!,
      'password': registerModel.password!,
      'confirm_password': registerModel.confirmPassword!,
      'shop_name': registerModel.shopName!,
      'shop_address': registerModel.shopAddress!,
    });

    request.fields.addAll(fields);
    if (kDebugMode) {
      print('=====> ${request.url.path}\n${request.fields}');
    }

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print('=====Response body is here==>${res.body}');
    }

    try {
      return ApiResponse.withSuccess(Response(
          statusCode: response.statusCode,
          requestOptions: RequestOptions(path: ''),
          statusMessage: response.reasonPhrase,
          data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
