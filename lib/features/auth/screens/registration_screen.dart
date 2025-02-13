import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/auth/domain/models/register_model.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/info_field_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/register_first_tab.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/register_successfull_dialog_widget.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/helper/email_checker.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  bool? fromOptions;
  RegistrationScreen({super.key, this.fromOptions = false});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false)
          .setTabController(_tabController!);
    });

    Provider.of<AuthController>(Get.context!, listen: false).setCountryDialCode(
        CountryCode.fromCountryCode(
                Provider.of<SplashController>(context, listen: false)
                        .configModel!
                        .countryCode ??
                    'BD')
            .dialCode);
    Provider.of<AuthController>(Get.context!, listen: false)
        .emptyRegistrationData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        if (widget.fromOptions == false) {
          if (_tabController?.index == 1) {
            _tabController?.index = 0;
            Provider.of<AuthController>(Get.context!, listen: false)
                .setIndexForTabBar(1);
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: widget.fromOptions == true
            ? CustomAppBarWidget(
                title: getTranslated('shop_application', context),
                isBackButtonExist: true,
                onBackPressed: () {
                  if (_tabController?.index == 1) {
                    _tabController?.index = 0;
                    Provider.of<AuthController>(Get.context!, listen: false)
                        .setIndexForTabBar(1);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              )
            : null,
        body:
            Consumer<AuthController>(builder: (authContext, authController, _) {
          return Column(children: [
            const SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            Expanded(
                child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                VerifyPhone(),
                InfoFieldVIewWidget(
                  isShopInfo: true,
                ),
              ],
            )),
          ]);
        }),
        bottomNavigationBar:
            Consumer<AuthController>(builder: (context, authController, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              authController.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeSmall,
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration:
                          BoxDecoration(color: Theme.of(context).cardColor),
                      child: (authController.registerTabController?.index != 1)
                          ? const SizedBox()
                          : Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    backgroundColor:
                                        !authController.isTermsAndCondition!
                                            ? Theme.of(context).hintColor
                                            : Theme.of(context).primaryColor,
                                    btnTxt: getTranslated(
                                        'craete_account', context),
                                    onTap: !authController.isTermsAndCondition!
                                        ? null
                                        : () {
                                            if (authController
                                                .phoneController.text.isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'phone_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                .idController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'id_required', context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                    .phoneController.text
                                                    .trim()
                                                    .length <
                                                8) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'phone_minimum_length_is_8',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                .passwordController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'password_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                    .passwordController.text
                                                    .trim()
                                                    .length <
                                                8) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'password_minimum_length_is_6',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                .confirmPasswordController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'confirm_password_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                    .passwordController.text
                                                    .trim() !=
                                                authController
                                                    .confirmPasswordController
                                                    .text
                                                    .trim()) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'password_is_mismatch',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                    .passwordController.text
                                                    .trim()
                                                    .isNotEmpty &&
                                                !authController
                                                    .isPasswordValid()) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'enter_valid_password',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                    .selectedLocation ==
                                                null) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'location_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else {
                                              _tabController!.animateTo(
                                                  (_tabController!.index + 1) %
                                                      2);
                                              selectedIndex =
                                                  _tabController!.index + 1;
                                              authController.setIndexForTabBar(
                                                  selectedIndex);
                                            }
                                            if (authController
                                                .firstNameController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'first_name_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                .lastNameController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'last_name_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                    .emailController.text
                                                    .trim()
                                                    .isNotEmpty &&
                                                EmailChecker.isNotValid(
                                                    authController
                                                        .emailController.text
                                                        .trim())) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'enter_valid_email',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                .shopNameController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'shop_name_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else if (authController
                                                .shopAddressController.text
                                                .trim()
                                                .isEmpty) {
                                              showCustomSnackBarWidget(
                                                  getTranslated(
                                                      'shop_address_is_required',
                                                      context),
                                                  context,
                                                  sanckBarType:
                                                      SnackBarType.warning);
                                            } else {
                                              RegisterModel registerModel = RegisterModel(
                                                  fName: authController
                                                      .firstNameController.text
                                                      .trim(),
                                                  lName: authController
                                                      .lastNameController.text
                                                      .trim(),
                                                  phone:
                                                      "${authController.countryDialCode}${authController.phoneController.text.trim()}",
                                                  id: authController.idController.text
                                                      .trim(),
                                                  latitude: authController
                                                          .selectedLocation
                                                          ?.latitude
                                                          .toString() ??
                                                      '',
                                                  longitude: authController
                                                          .selectedLocation
                                                          ?.longitude
                                                          .toString() ??
                                                      '',
                                                  email: authController
                                                      .emailController.text
                                                      .trim(),
                                                  password: authController
                                                      .passwordController.text
                                                      .trim(),
                                                  confirmPassword:
                                                      authController.confirmPasswordController.text.trim(),
                                                  shopName: authController.shopNameController.text.trim(),
                                                  shopAddress: authController.shopAddressController.text.trim());
                                              authController
                                                  .registration(
                                                      context, registerModel)
                                                  .then((value) {
                                                if (value
                                                        .response!.statusCode ==
                                                    200) {
                                                  showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (_) =>
                                                          const RegisterSuccessfulWidget());
                                                }
                                                authController
                                                    .registrationReset();
                                              });
                                            }
                                          },
                                  ),
                                ),
                              ],
                            ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
