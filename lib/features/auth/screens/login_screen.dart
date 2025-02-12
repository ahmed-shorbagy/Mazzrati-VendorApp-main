import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/code_picker_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/social_button.dart';
import 'package:mazzraati_vendor_app/features/more/screens/html_view_screen.dart';
import 'package:mazzraati_vendor_app/helper/email_checker.dart';
import 'package:mazzraati_vendor_app/helper/phone_checker.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/registration_screen.dart';
import 'package:mazzraati_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController!.text =
        (Provider.of<AuthController>(context, listen: false).getUserEmail());
    _passwordController!.text =
        (Provider.of<AuthController>(context, listen: false).getUserPassword());
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthController>(context, listen: false).isActiveRememberMe;

    return Consumer<AuthController>(
      builder: (context, authProvider, child) => Form(
        key: _formKeyLogin,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).hintColor.withOpacity(.35)),
                    color: Theme.of(context).highlightColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  margin: const EdgeInsets.only(
                      left: Dimensions.paddingSizeLarge,
                      right: Dimensions.paddingSizeLarge,
                      bottom: Dimensions.paddingSizeSmall),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        // Fixed Country Picker for Saudi Arabia
                        CodePickerWidget(
                          onChanged: null, // Disable country code changes
                          initialSelection:
                              '+966', // Pre-set country code to Saudi Arabia
                          favorite: const [
                            '+966'
                          ], // Set Saudi Arabia as favorite
                          showDropDownButton: false,
                          padding: EdgeInsets.zero,
                          showFlagMain: true,
                          enabled: false, // Make country code non-editable
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Expanded(
                          child: CustomTextFieldWidget(
                            hintText: getTranslated('phone_no', context),
                            controller: _emailController,
                            maxSize: 10,
                            isPhoneNumber: true,
                            border: false,
                            focusBorder: false,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.phone,
                            focusNode: _emailFocus,
                            nextNode: _passwordFocus,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeDefault),
                      child: CustomTextFieldWidget(
                        border: true,
                        isPassword: true,
                        prefixIcon: Icons.lock,
                        hintText: getTranslated('password_hint', context),
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: Dimensions.paddingSizeLarge),
                    child: Consumer<AuthController>(
                        builder: (context, authProvider, child) =>
                            Row(children: [
                              InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen())),
                                  child: Text(
                                      '${getTranslated('forget_password', context)!} ؟',
                                      style: robotoRegular.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      )))
                            ]))),
                const SizedBox(height: Dimensions.paddingSizeButton),
                !authProvider.isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: CustomButtonWidget(
                          height: 50,
                          borderRadius: 7,
                          backgroundColor: Theme.of(context).primaryColor,
                          btnTxt: getTranslated('login', context),
                          onTap: () async {
                            String email = _emailController!.text.trim();
                            String password = _passwordController!.text.trim();
                            log(email);
                            if (email.startsWith('0')) {
                              email = email.substring(1);
                            }
                            log(email);
                            if (email.isEmpty) {
                              showCustomSnackBarWidget(
                                  getTranslated('enter_phone_number', context),
                                  context,
                                  sanckBarType: SnackBarType.warning);
                            } else if (PhoneNumberChecker.isNotValid(email)) {
                              showCustomSnackBarWidget(
                                  getTranslated('enter_valid_phone', context),
                                  context,
                                  sanckBarType: SnackBarType.warning);
                            } else if (password.isEmpty) {
                              showCustomSnackBarWidget(
                                  getTranslated('enter_password', context),
                                  context,
                                  sanckBarType: SnackBarType.warning);
                            } else if (password.length < 6) {
                              showCustomSnackBarWidget(
                                  getTranslated('password_should_be', context),
                                  context,
                                  sanckBarType: SnackBarType.warning);
                            } else {
                              authProvider
                                  .login(context,
                                      emailAddress: email, password: password)
                                  .then((status) async {
                                if (status.response!.statusCode == 200) {
                                  if (authProvider.isActiveRememberMe) {
                                    authProvider.saveUserNumberAndPassword(
                                        email, password);
                                  } else {
                                    authProvider.clearUserEmailAndPassword();
                                  }
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const DashboardScreen()));
                                }
                              });
                            }
                          },
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
