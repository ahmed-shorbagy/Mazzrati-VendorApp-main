import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/code_picker_widget.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({super.key});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  String? _countryDialCode = "+880";

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashController>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;
    if (Provider.of<AuthController>(context, listen: false).countryDialCode !=
        _countryDialCode) {
      _countryDialCode =
          Provider.of<AuthController>(context, listen: false).countryDialCode;
    }

    Provider.of<AuthController>(context, listen: false)
        .validPassCheck('', isUpdate: false);
  }

  void _navigateToNextScreen() {
    // Navigate to the next screen or perform any action you need
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (authContext, authProvider, _) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Dimensions.paddingEye),
                      ),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.04),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Provider.of<ThemeController>(context,
                                      listen: false)
                                  .darkTheme
                              ? Theme.of(context).primaryColor.withOpacity(0)
                              : Theme.of(context).primaryColor.withOpacity(.10),
                          offset: const Offset(0, 2.0),
                          blurRadius: 4.0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            getTranslated('create_an_account', context)!,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Divider(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.04),
                          height: 0,
                          indent: 0,
                          thickness: 1,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall,
                            right: Dimensions.paddingSizeSmall,
                          ),
                          child: Text(
                            getTranslated('phone', context)!,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color:
                                  Theme.of(context).hintColor.withOpacity(.35),
                            ),
                            color: Theme.of(context).highlightColor,
                            borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeExtraSmall,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall,
                            right: Dimensions.paddingSizeSmall,
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              children: [
                                // Fixed Country Picker for Saudi Arabia
                                CodePickerWidget(
                                  onChanged:
                                      null, // Disable country code changes
                                  initialSelection:
                                      '+966', // Pre-set country code to Saudi Arabia
                                  favorite: const [
                                    '+966'
                                  ], // Set Saudi Arabia as favorite
                                  showDropDownButton: false,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  enabled:
                                      false, // Make country code non-editable
                                  textStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color,
                                  ),
                                ),

                                Expanded(
                                  child: CustomTextFieldWidget(
                                    idDate: authProvider.isOTPSent,
                                    hintText:
                                        getTranslated('mobile_hint', context),
                                    controller: authProvider.phoneController,
                                    focusNode: authProvider.phoneNode,
                                    maxSize: 10,
                                    nextNode: authProvider.passwordNode,
                                    isPhoneNumber: true,
                                    border: false,
                                    focusBorder: false,
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.phone,
                                    onChanged: (value) {
                                      if (value.startsWith('0')) {
                                        authProvider.phoneController.text =
                                            value.substring(1);
                                      }
                                      // if (value.length == 9) {
                                      //   authProvider.SendOtp(
                                      //           authProvider.phoneController.text)
                                      //       .then((value) {
                                      //     for (var controller
                                      //         in authProvider.controllers) {
                                      //       controller.clear();
                                      //     }
                                      //     if (authProvider.isOTPSent) {
                                      //       SystemChannels.textInput
                                      //           .invokeMethod('TextInput.show');
                                      //       FocusScope.of(context).requestFocus(
                                      //           authProvider.focusNodes[0]);
                                      //     }
                                      // });
                                      // }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        if (!authProvider.isOTPSent)
                          authProvider.isPhoneNumberVerificationButtonLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeSmall,
                                    right: Dimensions.paddingSizeSmall,
                                  ),
                                  child: CustomButtonWidget(
                                      btnTxt:
                                          "${getTranslated('send_otp', context)}",
                                      onTap: () async {
                                        authProvider.sendOtp(
                                            authProvider.phoneController.text);
                                      }),
                                ),
                        if (authProvider.isOTPSent) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                            ),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return SizedBox(
                                    width: 40,
                                    height: 50,
                                    child: TextField(
                                      controller:
                                          authProvider.controllers[index],
                                      focusNode: authProvider.focusNodes[index],
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      keyboardType: TextInputType.number,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                          const SizedBox(height: Dimensions.paddingSize),
                          Container(
                            margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                            ),
                            child: CustomButtonWidget(
                                btnTxt: getTranslated('verify_otp', context),
                                onTap: () async {
                                  String OTP = authProvider.controllers
                                      .map((controller) => controller.text)
                                      .join();
                                  if (OTP.length < 6) {
                                    null;
                                  } else {
                                    bool isPhoneVerified =
                                        await authProvider.verify_Otp(
                                            authProvider.phoneController.text,
                                            OTP);

                                    if (isPhoneVerified) {
                                      // _tabController?.index = 1;
                                      authProvider.switchTab(1);
                                    }
                                  }
                                }),
                          ),
                          const SizedBox(height: Dimensions.paddingSize),
                          authProvider.isPhoneNumberVerificationButtonLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeSmall,
                                    right: Dimensions.paddingSizeSmall,
                                  ),
                                  child: CustomButtonWidget(
                                      btnTxt:
                                          "${getTranslated('resend_code', context)}",
                                      onTap: () async {
                                        for (var controller
                                            in authProvider.controllers) {
                                          controller.clear();
                                        }
                                        authProvider.sendOtp(
                                            authProvider.phoneController.text);
                                      }),
                                ),
                          Center(
                            child: TextButton(
                                onPressed: () {
                                  authProvider.registrationReset();
                                },
                                child: Text(getTranslated(
                                        'change_phone_number', context) ??
                                    "Change Phone Number")),
                          )
                        ],
                        // CustomButtonWidget(
                        //     btnTxt: "",
                        //     onTap: () {
                        //       authProvider.registrationReset();
                        //     }),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
