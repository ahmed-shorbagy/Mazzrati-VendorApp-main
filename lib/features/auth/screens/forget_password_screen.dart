import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/otp_verification_screen.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/code_picker_widget.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isBackButtonExist: true,
        title: getTranslated('forget_password', context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 95),
              Image.asset(Images.forgotPasswordIcon, height: 100, width: 100),
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Text('${getTranslated('forget_password', context)}?',
                    style: robotoMedium),
              ),
              Text(
                getTranslated(
                    'enter_phone_number_for_password_reset', context)!,
                style: titilliumRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeDefault,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).hintColor.withOpacity(.35),
                  ),
                  color: Theme.of(context).highlightColor,
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                margin: const EdgeInsets.only(
                  left: Dimensions.paddingSizeSmall,
                  right: Dimensions.paddingSizeSmall,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      CodePickerWidget(
                        onChanged: null,
                        initialSelection: '+966',
                        favorite: const ['+966'],
                        showDropDownButton: false,
                        padding: EdgeInsets.zero,
                        showFlagMain: true,
                        enabled: false,
                        textStyle: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        ),
                      ),
                      Expanded(
                        child: CustomTextFieldWidget(
                          hintText: getTranslated('mobile_hint', context),
                          controller: _numberController,
                          focusNode: _numberFocus,
                          maxSize: 9,
                          idDate: false,
                          isPhoneNumber: true,
                          border: false,
                          focusBorder: false,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.phone,
                          onChanged: (value) {
                            if (value.startsWith('0')) {
                              _numberController.text = value.substring(1);
                              _numberController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _numberController.text.length),
                              );
                            } else if (!value.startsWith('5') &&
                                value.isNotEmpty) {
                              showCustomSnackBarWidget(
                                getTranslated(
                                    'phone_must_start_with_5', context),
                                context,
                                sanckBarType: SnackBarType.warning,
                              );
                              _numberController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Consumer<AuthController>(builder: (context, authProvider, _) {
                return !authProvider.isLoading
                    ? CustomButtonWidget(
                        borderRadius: 10,
                        btnTxt: getTranslated('send_otp', context),
                        onTap: () {
                          String phone = _numberController.text.trim();
                          if (phone.isEmpty) {
                            showCustomSnackBarWidget(
                              getTranslated('phone_is_required', context),
                              context,
                              sanckBarType: SnackBarType.warning,
                            );
                          } else if (!phone.startsWith('5') ||
                              phone.length != 9) {
                            showCustomSnackBarWidget(
                              getTranslated(
                                  'please_enter_valid_phone', context),
                              context,
                              sanckBarType: SnackBarType.warning,
                            );
                          } else {
                            // Format phone number with country code
                            String formattedPhone = '+966$phone';
                            authProvider.sendOtp(formattedPhone).then((value) {
                              if (authProvider.isOTPSent) {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                      'otp_sent_successfully', context),
                                  context,
                                  sanckBarType: SnackBarType.success,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerificationScreen(
                                      formattedPhone,
                                      fromForgetPassword: true,
                                    ),
                                  ),
                                );
                              }
                            });
                          }
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
