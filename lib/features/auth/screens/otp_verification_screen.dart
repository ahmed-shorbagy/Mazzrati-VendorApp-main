import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_pass_textfeild_widget.dart';
import 'package:mazzraati_vendor_app/data/model/response/response_model.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool fromForgetPassword;

  const VerificationScreen(this.phoneNumber,
      {this.fromForgetPassword = false, super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode newPasswordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isOtpVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated(
          isOtpVerified ? 'enter_new_password' : 'verify_otp',
          context,
        ),
        isBackButtonExist: true,
      ),
      body: Consumer<AuthController>(builder: (context, authProvider, child) {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                if (!isOtpVerified) ...[
                  Text(
                    getTranslated('please_enter_4_digit_code', context)!,
                    style: titilliumRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeLarge,
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: TextField(
                              controller: authProvider.controllers[index],
                              focusNode: authProvider.focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.titleSmall,
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                authProvider.handleTextChange(
                                    value, index, context);
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
                if (isOtpVerified) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    child: Column(
                      children: [
                        CustomPasswordTextFieldWidget(
                          border: true,
                          hintTxt: getTranslated('new_password', context),
                          controller: newPasswordController,
                          focusNode: newPasswordNode,
                          nextNode: confirmPasswordNode,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        CustomPasswordTextFieldWidget(
                          border: true,
                          hintTxt: getTranslated('confirm_password', context),
                          controller: confirmPasswordController,
                          focusNode: confirmPasswordNode,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ],
                !authProvider.isPhoneNumberVerificationButtonLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                        ),
                        child: CustomButtonWidget(
                          btnTxt: getTranslated(
                            isOtpVerified ? 'reset_password' : 'verify',
                            context,
                          ),
                          onTap: () async {
                            String otp = authProvider.controllers
                                .take(4) // Take only first 4 controllers
                                .map((controller) => controller.text)
                                .join();
                            if (otp.length != 4) {
                              showCustomSnackBarWidget(
                                getTranslated('input_valid_otp', context),
                                context,
                                sanckBarType: SnackBarType.error,
                              );
                            } else if (!isOtpVerified) {
                              // Remove country code if present
                              String phoneWithoutCode = widget.phoneNumber;
                              if (phoneWithoutCode.startsWith('+966')) {
                                phoneWithoutCode =
                                    phoneWithoutCode.substring(4);
                              } else if (phoneWithoutCode.startsWith('966')) {
                                phoneWithoutCode =
                                    phoneWithoutCode.substring(3);
                              }
                              log(phoneWithoutCode);
                              // First verify OTP using resetPasswordVerifyOtp
                              final response =
                                  await authProvider.resetPasswordVerifyOtp(
                                      phoneWithoutCode, otp);

                              if (response.isSuccess) {
                                setState(() {
                                  isOtpVerified = true;
                                });
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      'otp_verified_successfully', context),
                                  context,
                                  sanckBarType: SnackBarType.success,
                                );
                              } else {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      response.message ?? 'invalid_otp',
                                      context),
                                  context,
                                  sanckBarType: SnackBarType.error,
                                );
                              }
                            } else {
                              // Handle password reset after OTP verification
                              if (newPasswordController.text.isEmpty) {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      'password_is_required', context),
                                  context,
                                  sanckBarType: SnackBarType.warning,
                                );
                              } else if (newPasswordController.text.length <
                                  8) {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      'password_minimum_length_is_6', context),
                                  context,
                                  sanckBarType: SnackBarType.warning,
                                );
                              } else if (confirmPasswordController
                                  .text.isEmpty) {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      'confirm_password_is_required', context),
                                  context,
                                  sanckBarType: SnackBarType.warning,
                                );
                              } else if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      'password_is_mismatch', context),
                                  context,
                                  sanckBarType: SnackBarType.warning,
                                );
                              } else {
                                log(widget.phoneNumber);
                                log(otp);
                                log(newPasswordController.text);
                                log(confirmPasswordController.text);
                                try {
                                  ResponseModel response =
                                      await authProvider.resetPassword(
                                    widget.phoneNumber,
                                    otp,
                                    newPasswordController.text,
                                    confirmPasswordController.text,
                                  );

                                  if (response.isSuccess) {
                                    if (!mounted) return;

                                    // First show success message
                                    showCustomSnackBarWidget(
                                      getTranslated(
                                          'password_reset_successfully',
                                          context),
                                      context,
                                      sanckBarType: SnackBarType.success,
                                    );

                                    // Then navigate to login screen
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        '/login',
                                        (route) => false,
                                      );
                                    });
                                  } else {
                                    if (!mounted) return;
                                    showCustomSnackBarWidget(
                                      getTranslated(
                                          response.message ??
                                              'something_went_wrong',
                                          context),
                                      context,
                                      sanckBarType: SnackBarType.error,
                                    );
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  showCustomSnackBarWidget(
                                    getTranslated(
                                        'something_went_wrong', context),
                                    context,
                                    sanckBarType: SnackBarType.error,
                                  );
                                }
                              }
                            }
                          },
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                if (!isOtpVerified) ...[
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  TextButton(
                    onPressed: () {
                      authProvider.sendOtp(widget.phoneNumber);
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${getTranslated('i_didnt_receive_the_code', context)} ",
                            style: titilliumRegular.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          TextSpan(
                            text: getTranslated('resend_code', context),
                            style: titilliumRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
