import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/api_response.dart';
import 'package:mazzraati_vendor_app/data/model/response/response_model.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final String _loginErrorMessage = '';
  String get loginErrorMessage => _loginErrorMessage;
  XFile? _sellerProfileImage;
  XFile? _shopLogo;
  XFile? _shopBanner;
  XFile? secondaryBanner;
  XFile? offerBanner;
  XFile? get sellerProfileImage => _sellerProfileImage;
  XFile? get shopLogo => _shopLogo;
  XFile? get shopBanner => _shopBanner;
  bool? _isTermsAndCondition = false;
  bool? get isTermsAndCondition => _isTermsAndCondition;
  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;
  int _selectionTabIndex = 1;
  int get selectionTabIndex => _selectionTabIndex;
  String _verificationCode = '';
  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;
  String? _verificationMsg = '';
  String? get verificationMessage => _verificationMsg;
  final String _email = '';
  final String _phone = '';
  String get email => _email;
  String get phone => _phone;
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String? _countryDialCode = '+880';
  String? get countryDialCode => _countryDialCode;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: 'info@mazzraati.com');
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode idNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode shopNameNode = FocusNode();
  FocusNode shopAddressNode = FocusNode();

  bool _lengthCheck = false;
  bool _numberCheck = false;
  bool _uppercaseCheck = false;
  bool _lowercaseCheck = false;
  bool _spatialCheck = false;
  bool _showPassView = false;
  bool _passwordsMatch =
      false; // Default to true (or false based on your logic)

  bool get lengthCheck => _lengthCheck;
  bool get numberCheck => _numberCheck;
  bool get uppercaseCheck => _uppercaseCheck;
  bool get lowercaseCheck => _lowercaseCheck;
  bool get spatialCheck => _spatialCheck;
  bool get showPassView => _showPassView;

  bool get passwordsMatch => _passwordsMatch;

  Future<ApiResponse> login(BuildContext context,
      {String? emailAddress, String? password}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authServiceInterface.login(
        emailAddress: emailAddress, password: password);
    _isLoading = false;
    notifyListeners();
    await Provider.of<AuthController>(Get.context!, listen: false)
        .updateToken(Get.context!);
    setCurrentLanguage(
        Provider.of<LocalizationController>(Get.context!, listen: false)
                .getCurrentLanguage() ??
            'en');
    notifyListeners();
    return apiResponse;
  }

  Future<void> setCurrentLanguage(String currentLanguage) async {
    await authServiceInterface.setLanguageCode(currentLanguage);
  }

  Future<ResponseModel> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel =
        await authServiceInterface.forgotPassword(email);
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> updateToken(BuildContext context) async {
    await authServiceInterface.updateToken();
  }

  void updateTermsAndCondition(bool? value) {
    _isTermsAndCondition = value;
    notifyListeners();
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  void setIndexForTabBar(int index, {bool isNotify = true}) {
    _selectionTabIndex = index;
    if (isNotify) {
      notifyListeners();
    }
  }

  TabController? registerTabController;

  void setTabController(TabController tabController) {
    registerTabController = tabController;
    notifyListeners();
  }

  @override
  notifyListeners();

  void switchTab(int index) {
    registerTabController!.animateTo(index);
    notifyListeners();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authServiceInterface.saveUserNumberAndPassword(number, password);
  }

  String getUserEmail() {
    return authServiceInterface.getUserEmail();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return await authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  Future<ResponseModel> verifyOtp(String phone, verificationCode) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ResponseModel responseModel =
        await authServiceInterface.verifyOtp(phone, verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    _verificationMsg = responseModel.message;
    notifyListeners();
    return responseModel;
  }

  String _responseMessage = '';
  // bool _isLoading = false;

  String get responseMessage => _responseMessage;
  // bool get isLoading => _isLoading;

  Future<bool> verify_Otp(String phone, String otp) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/api/v3/seller/registration/verify-phone-otp');

    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );
    log(response.body);
    AppConstants.logWithColor(response.body, AppConstants.cyan);

    if (response.statusCode == 200) {
      _responseMessage = 'Verification successful: ${response.body}';

      showCustomSnackBarWidget(
          getTranslated("phone_number_verified_successfully", Get.context!),
          Get.context!,
          isError: false,
          sanckBarType: SnackBarType.success);

      _isLoading = false;
      notifyListeners();

      return true;
    } else {
      _responseMessage = 'Error: ${response.reasonPhrase}';
      showCustomSnackBarWidget(
          getTranslated("error_verifying_otp", Get.context!), Get.context!,
          isError: true, sanckBarType: SnackBarType.error);

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future sendOtp(String phone) async {
    final url = Uri.parse('${AppConstants.baseUrl}${AppConstants.SendOtpUri}');
    _isPhoneNumberVerificationButtonLoading = true;

    notifyListeners();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    log(response.body);
    log(response.statusCode.toString());
    AppConstants.logWithColor(response.body, AppConstants.cyan);
// !! [log] {"success":false,"errors":{"phone":["The phone has already been taken."]}}
//!!![log] {"success":true,"message":"OTP sent successfully","phone":"0548303002"}

    Map<String, dynamic> body = json.decode(response.body);

    if (response.statusCode == 200) {
      _responseMessage = 'OTP Send successful: ${response.body}';

      showCustomSnackBarWidget(
          jsonDecode(response.body)['message'], Get.context!,
          isError: false, sanckBarType: SnackBarType.success);

      _isPhoneNumberVerificationButtonLoading = false;
      isOTPSent = true;
      notifyListeners();
    } else if (response.statusCode == 400) {
      _responseMessage = 'Error: ${response.reasonPhrase}';
      showCustomSnackBarWidget(
          getTranslated('phone_number_is_already_exist', Get.context!),
          Get.context!,
          isError: true,
          sanckBarType: SnackBarType.error);

      _isPhoneNumberVerificationButtonLoading = false;
      isOTPSent = false;
      notifyListeners();
    } else {
      _responseMessage = 'Error: ${response.reasonPhrase}';
      showCustomSnackBarWidget(
          jsonDecode(response.body)['message'], Get.context!,
          isError: true, sanckBarType: SnackBarType.error);
      _isPhoneNumberVerificationButtonLoading = false;
      isOTPSent = false;
      notifyListeners();
    }
  }

  bool isOTPSent = false;
  Future<ResponseModel> SendOtp(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ResponseModel responseModel = await authServiceInterface.sendOtp(phone);
    showCustomSnackBarWidget(responseModel.message, Get.context!,
        isError: false, sanckBarType: SnackBarType.success);
    log(responseModel.message!);
    isOTPSent = true;
    _isPhoneNumberVerificationButtonLoading = false;
    _verificationMsg = responseModel.message;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();

    // Format phone number if needed
    String formattedPhone = identity.startsWith('+966')
        ? identity
        : identity.startsWith('966')
            ? '+$identity'
            : '+966$identity';

    // Create request body
    Map<String, dynamic> body = {
      "identity": formattedPhone,
      "otp": otp,
      "password": password,
      "confirm_password": confirmPassword,
      "_method": "put"
    };

    ResponseModel responseModel = await authServiceInterface.resetPassword(
        formattedPhone, otp, password, confirmPassword);

    _isPhoneNumberVerificationButtonLoading = false;
    _verificationMsg = responseModel.message;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> resetPasswordVerifyOtp(
      String identity, String otp) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();

    try {
      // Format phone number if needed
      String formattedPhone = identity.startsWith('+966')
          ? identity
          : identity.startsWith('966')
              ? '+$identity'
              : '+966$identity';

      ResponseModel responseModel = await authServiceInterface
          .resetPasswordVerifyOtp(formattedPhone, otp);

      _isPhoneNumberVerificationButtonLoading = false;
      _verificationMsg = responseModel.message;
      notifyListeners();
      return responseModel;
    } catch (e) {
      _isPhoneNumberVerificationButtonLoading = false;
      notifyListeners();
      return ResponseModel(false, e.toString());
    }
  }

  void pickImage(bool isProfile, bool shopLogo, bool isRemove,
      {bool secondary = false, bool offer = false}) async {
    if (isRemove) {
      _sellerProfileImage = null;
      _shopLogo = null;
      _shopBanner = null;
      secondaryBanner = null;
    } else {
      if (isProfile) {
        _sellerProfileImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else if (shopLogo) {
        _shopLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else if (secondary) {
        secondaryBanner =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else if (offer) {
        offerBanner =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _shopBanner =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      }
    }
    notifyListeners();
  }

  Future<XFile> convertAssetToXFile(String assetPath) async {
    // Load the image from the asset
    ByteData byteData = await rootBundle.load(assetPath);

    // Convert to Uint8List
    Uint8List imageData = byteData.buffer.asUint8List();

    // Convert the image data to an XFile
    XFile xFile = XFile.fromData(
      imageData,
      name: assetPath
          .split('/')
          .last, // Extracts the file name from the asset path
      mimeType: 'image/jpeg', // Change mimeType based on your image type
    );

    log("XFile Path: ${xFile.mimeType}");

    return xFile;
  }

  Future<XFile> saveImageFromAssets(String assetPath) async {
    // Load the image from assets
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    // Define the path for the new image
    final String filePath =
        '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Save the image to a file
    final File file = File(filePath);
    await file.writeAsBytes(bytes);

    // Return the file as an XFile
    return XFile(file.path);
  }

  Future<ApiResponse> registration(
      BuildContext context, RegisterModel registerModel) async {
    _isLoading = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _sellerProfileImage = XFile(prefs.getString(Images.storeImage) ?? '');
    _shopLogo = XFile(prefs.getString(Images.storeImage) ?? '');
    _shopBanner = XFile(prefs.getString(Images.storeBanner) ?? '');
    secondaryBanner = XFile(prefs.getString(Images.storeBanner) ?? '');
    registerModel.phone?.replaceFirst("+966", '');
    log(registerModel.toString());

    ApiResponse response = await authServiceInterface.registration(
        _sellerProfileImage,
        _shopLogo,
        _shopBanner,
        secondaryBanner,
        registerModel);
    if (response.response?.statusCode == 200) {
      _isLoading = false;
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      emailController.clear();
      confirmPasswordController.clear();
      _selectedLocation = null;
      passwordController.clear();
      confirmPasswordController.clear();
      shopNameController.clear();
      shopAddressController.clear();
      _sellerProfileImage = null;
      _shopLogo = null;
      _shopBanner = null;
      secondaryBanner = null;
      showCustomSnackBarWidget(
          getTranslated("you_are_successfully_registered", Get.context!),
          Get.context!,
          isError: false,
          sanckBarType: SnackBarType.success);
    } else {
      log("---->log===> ${response.response?.statusCode}/${response.error}/${response.response?.statusMessage}/${response.response?.data}");
      _isLoading = false;
      showCustomSnackBarWidget("The email has already been taken", Get.context!,
          sanckBarType: SnackBarType.warning);
    }
    _isLoading = false;
    notifyListeners();
    return response;
  }

  void setCountryDialCode(String? setValue) {
    _countryDialCode = setValue;
  }

  void emptyRegistrationData({bool isUpdate = false}) {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    idController.clear();
    _selectedLocation = null;
    confirmPasswordController.clear();
    shopNameController.clear();
    shopAddressController.clear();
    _sellerProfileImage = null;
    _shopLogo = null;
    _shopBanner = null;
    secondaryBanner = null;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}) {
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if (pass.length > 7) {
      _lengthCheck = true;
    }
    if (pass.contains(RegExp(r'[a-z]'))) {
      _lowercaseCheck = true;
    }
    if (pass.contains(RegExp(r'[A-Z]'))) {
      _uppercaseCheck = true;
    }
    if (pass.contains(RegExp(r'[ .!@#$&*~^%]'))) {
      _spatialCheck = true;
    }
    if (pass.contains(RegExp(r'[\d+]'))) {
      _numberCheck = true;
    }
    if (isUpdate) {
      notifyListeners();
    }
  }

  void showHidePass({bool isUpdate = true}) {
    _showPassView = !_showPassView;
    if (isUpdate) {
      notifyListeners();
    }
  }

  checkPasswordMatch() {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Convert both passwords to the same direction for comparison
    String normalizedPassword = password;
    String normalizedConfirmPassword = confirmPassword;

    // Remove any whitespace and normalize the strings
    normalizedPassword = normalizedPassword.replaceAll(RegExp(r'\s+'), '');
    normalizedConfirmPassword =
        normalizedConfirmPassword.replaceAll(RegExp(r'\s+'), '');

    if (normalizedPassword == normalizedConfirmPassword) {
      _passwordsMatch = true;
    } else {
      _passwordsMatch = false;
    }
    notifyListeners();
  }

  bool isPasswordValid() {
    String password = passwordController.text.trim();
    // Remove any whitespace for validation
    password = password.replaceAll(RegExp(r'\s+'), '');

    return (password.length >= 8 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')));
  }

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<TextEditingController> get controllers => _controllers;
  List<FocusNode> get focusNodes => _focusNodes;

  void handleTextChange(String value, int index, BuildContext context) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  String _address = "None";

  String get address => _address;
  LatLng? _selectedLocation;

  LatLng? get selectedLocation => _selectedLocation;

  void setAddress(String value, {LatLng? location}) {
    // Trim and format the address
    _address = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    _selectedLocation = location;
    Logger(
      printer: PrettyPrinter(),
    ).d(_address);
    notifyListeners();
  }

  void registrationReset() {
    isOTPSent = false;
    phoneController.clear();
    notifyListeners();
  }
}
