import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_pass_textfeild_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/code_picker_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/location_picker_screen.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/validate_password_widget.dart';
import 'package:mazzraati_vendor_app/features/more/screens/html_view_screen.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class InfoFieldVIewWidget extends StatefulWidget {
  final bool isShopInfo;
  const InfoFieldVIewWidget({super.key, this.isShopInfo = false});

  @override
  State<InfoFieldVIewWidget> createState() => _InfoFieldVIewWidgetState();
}

class _InfoFieldVIewWidgetState extends State<InfoFieldVIewWidget> {
  String? _countryDialCode = "+880";
  String currency = '', country = '', selectedTimeZone = '';
  GoogleMapController? _controller;
  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashController>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;
    if (Provider.of<AuthController>(Get.context!, listen: false)
            .countryDialCode !=
        _countryDialCode) {
      _countryDialCode =
          Provider.of<AuthController>(Get.context!, listen: false)
              .countryDialCode;
    }

    Provider.of<AuthController>(context, listen: false)
        .validPassCheck('', isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (authContext, authProvider, _) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (!widget.isShopInfo)
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
                            Radius.circular(Dimensions.paddingEye)),
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.04)),
                        boxShadow: [
                          BoxShadow(
                            color: Provider.of<ThemeController>(context,
                                        listen: false)
                                    .darkTheme
                                ? Theme.of(context).primaryColor.withOpacity(0)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.10),
                            offset: const Offset(0, 2.0),
                            blurRadius: 4.0,
                          )
                        ]),
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
                                    fontSize: Dimensions.fontSizeLarge))),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Divider(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.04),
                            height: 0,
                            indent: 0,
                            thickness: 1),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Padding(
                            padding: const EdgeInsets.only(
                                left: Dimensions.paddingSizeSmall,
                                right: Dimensions.paddingSizeSmall),
                            child: TitleWidget(
                                title: getTranslated('phone', context)!)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(.35)),
                            color: Theme.of(context).highlightColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeExtraSmall),
                          ),
                          margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall),

                          // child: Row(children: [
                          //   CodePickerWidget(
                          //     onChanged: (CountryCode countryCode) {
                          //       // _countryDialCode = countryCode.dialCode;
                          //       // authProvider.setCountryDialCode(_countryDialCode);
                          //     },
                          //     initialSelection: _countryDialCode,
                          //     favorite: [authProvider.countryDialCode!],
                          //     showDropDownButton: true,
                          //     padding: EdgeInsets.zero,
                          //     showFlagMain: true,
                          //     textStyle: TextStyle(
                          //         color: Theme.of(context)
                          //             .textTheme
                          //             .displayLarge!
                          //             .color),
                          //   ),
                          //   Expanded(
                          //       child: CustomTextFieldWidget(
                          //     hintText: getTranslated('mobile_hint', context),
                          //     controller: authProvider.phoneController,
                          //     focusNode: authProvider.phoneNode,
                          //     nextNode: authProvider.passwordNode,
                          //     isPhoneNumber: true,
                          //     border: false,
                          //     focusBorder: false,
                          //     textInputAction: TextInputAction.next,
                          //     textInputType: TextInputType.phone,
                          //   )),
                          // ]),
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
                                    hintText:
                                        getTranslated('mobile_hint', context),
                                    controller: authProvider.phoneController,
                                    focusNode: authProvider.phoneNode,
                                    maxSize: 10,
                                    idDate: true,
                                    nextNode: authProvider.passwordNode,
                                    isPhoneNumber: true,
                                    border: false,
                                    focusBorder: false,
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.phone,
                                    // Add Saudi phone number validation
                                    // validator: (value) {
                                    //   String pattern = r'^[5]\d{8}$'; // Saudi mobile number pattern
                                    //   RegExp regExp = new RegExp(pattern);
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Please enter a phone number';
                                    //   } else if (!regExp.hasMatch(value)) {
                                    //     return 'Please enter a valid Saudi phone number';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeMedium),
                        //!Email field
                        Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.paddingSizeSmall,
                                right: Dimensions.paddingSizeSmall,
                                bottom: Dimensions.paddingSizeSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${getTranslated('email', context)!} (${getTranslated('optional', context)!})",
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: CustomTextFieldWidget(
                                    border: true,
                                    hintText:
                                        getTranslated('email_hint', context),
                                    focusNode: authProvider.emailNode,
                                    nextNode: authProvider.phoneNode,
                                    textInputType: TextInputType.emailAddress,
                                    controller: authProvider.emailController,
                                    textInputAction: TextInputAction.next,
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        //!Id field
                        Container(
                            margin: const EdgeInsets.only(
                                left: Dimensions.paddingSizeSmall,
                                right: Dimensions.paddingSizeSmall,
                                bottom: Dimensions.paddingSizeSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleWidget(
                                    title: getTranslated('id', context)!),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: CustomTextFieldWidget(
                                    border: true,
                                    hintText: getTranslated('id_hint', context),
                                    focusNode: authProvider.idNode,
                                    maxSize: 10,
                                    nextNode: authProvider.phoneNode,
                                    textInputType: TextInputType.number,
                                    controller: authProvider.idController,
                                    textInputAction: TextInputAction.next,
                                    required: true,
                                  ),
                                )
                              ],
                            )),
                        //!Location field
                        Container(
                          margin: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall,
                            right: Dimensions.paddingSizeSmall,
                            bottom: Dimensions.paddingSizeSmall,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidget(
                                  title: getTranslated('location', context) ??
                                      "Location"),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              CustomButtonWidget(
                                btnTxt: authProvider.selectedLocation != null
                                    ? authProvider.address.trim()
                                    : getTranslated("Pick_Location", context) ??
                                        "Pick Location",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LocationPicker()));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),

                        // Container(
                        //     margin: const EdgeInsets.only(
                        //         left: Dimensions.paddingSizeSmall,
                        //         right: Dimensions.paddingSizeSmall,
                        //         bottom: Dimensions.paddingSizeSmall),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(getTranslated('id', context)!,
                        //             style: robotoRegular.copyWith(
                        //                 fontSize: Dimensions.fontSizeDefault)),
                        //         const SizedBox(
                        //             height: Dimensions.paddingSizeSmall),
                        //         CustomButtonWidget(
                        //             btnTxt: "location",
                        //             onTap: () {
                        //               Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                       builder: (context) =>
                        //                           SelectLocationScreen(
                        //                             googleMapController:
                        //                                 _controller,
                        //                           )));
                        //             }),
                        //       ],
                        //     )),
                        // const SizedBox(
                        //     height: Dimensions.paddingSizeExtraSmall),
                        //!!!!!!!!!!!!!!!!!!!!!Password!!!!!!!!!!!!!!
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: authProvider.showPassView
                                ? Dimensions.paddingSizeExtraSmall
                                : Dimensions.paddingSizeDefault,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated('new_password', context)!,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeMedium),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: CustomPasswordTextFieldWidget(
                                  border: true,
                                  hintTxt: getTranslated(
                                      'enter_your_password', context),
                                  textInputAction: TextInputAction.next,
                                  focusNode: authProvider.passwordNode,
                                  nextNode: authProvider.confirmPasswordNode,
                                  controller: authProvider.passwordController,
                                  onChanged: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (!authProvider.showPassView) {
                                        authProvider.showHidePass();
                                      }
                                      authProvider.validPassCheck(value);
                                    } else {
                                      if (authProvider.showPassView) {
                                        authProvider.showHidePass();
                                      }
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              // Password validation checklist UI
                              if (authProvider
                                  .passwordController.text.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PasswordCheckRow(
                                      isValid: authProvider.lengthCheck,
                                      text: getTranslated(
                                              '8_or_more_character', context) ??
                                          "",
                                    ),
                                    PasswordCheckRow(
                                      isValid: authProvider.numberCheck,
                                      text:
                                          getTranslated('1_number', context) ??
                                              "",
                                    ),
                                    PasswordCheckRow(
                                      isValid: authProvider.uppercaseCheck,
                                      text: getTranslated(
                                              '1_upper_case', context) ??
                                          "",
                                    ),
                                    PasswordCheckRow(
                                      isValid: authProvider.lowercaseCheck,
                                      text: getTranslated(
                                              '1_lower_case', context) ??
                                          "",
                                    ),
                                    PasswordCheckRow(
                                      isValid: authProvider.spatialCheck,
                                      text: getTranslated(
                                              '1_special_character', context) ??
                                          "",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        authProvider.showPassView
                            ? const SizedBox(
                                height: Dimensions.paddingSizeSmall)
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeDefault),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated('confirm_password', context)!,
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault)),
                              const SizedBox(
                                  height: Dimensions.paddingSizeMedium),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: CustomPasswordTextFieldWidget(
                                  border: true,
                                  hintTxt: getTranslated(
                                      'confirm_password', context),
                                  textInputAction: TextInputAction.done,
                                  focusNode: authProvider.confirmPasswordNode,
                                  controller:
                                      authProvider.confirmPasswordController,
                                  onChanged: (value) {
                                    authProvider.checkPasswordMatch();
                                  },
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),

                              // Show error message if passwords do not match
                              if (authProvider
                                  .confirmPasswordController.text.isNotEmpty)
                                PasswordCheckRow(
                                  isValid: authProvider.passwordsMatch,
                                  text: getTranslated(
                                          authProvider.passwordsMatch
                                              ? 'passwords_match'
                                              : 'passwords_not_match',
                                          context) ??
                                      "",
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // if (widget.isShopInfo)
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimensions.paddingEye)),
                      border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.04)),
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
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: Dimensions.paddingSizeSmall),
                      // Align(
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //         getTranslated('create_an_account', context)!,
                      //         style: robotoMedium.copyWith(
                      //             fontSize: Dimensions.fontSizeLarge))),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      // Divider(
                      //     color:
                      //         Theme.of(context).primaryColor.withOpacity(0.04),
                      //     height: 0,
                      //     indent: 0,
                      //     thickness: 1),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall),
                          child: Text(
                              getTranslated('seller_information', context)!,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge))),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        margin: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall,
                            right: Dimensions.paddingSizeSmall,
                            bottom: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            TitleWidget(
                                title: getTranslated('first_name', context)!),
                            CustomTextFieldWidget(
                              border: true,
                              hintText:
                                  getTranslated('first_name_hint', context),
                              focusNode: authProvider.firstNameNode,
                              nextNode: authProvider.lastNameNode,
                              textInputType: TextInputType.name,
                              controller: authProvider.firstNameController,
                              textInputAction: TextInputAction.next,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeSmall),
                          child: Column(
                            children: [
                              TitleWidget(
                                  title: getTranslated('last_name', context)!),
                              CustomTextFieldWidget(
                                border: true,
                                hintText:
                                    getTranslated('last_name_hint', context),
                                focusNode: authProvider.lastNameNode,
                                nextNode: authProvider.emailNode,
                                textInputType: TextInputType.name,
                                controller: authProvider.lastNameController,
                                textInputAction: TextInputAction.next,
                              )
                            ],
                          )),
                      //! vendor image
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Theme.of(context).cardColor,
                      //       borderRadius: const BorderRadius.all(
                      //           Radius.circular(Dimensions.paddingEye)),
                      //       border: Border.all(
                      //           color: Theme.of(context)
                      //               .primaryColor
                      //               .withOpacity(0.04)),
                      //     ),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(
                      //               vertical: Dimensions.paddingSizeSmall),
                      //           child: Align(
                      //               alignment: Alignment.center,
                      //               child: DottedBorder(
                      //                 color: Theme.of(context).hintColor,
                      //                 dashPattern: const [5, 5],
                      //                 borderType: BorderType.RRect,
                      //                 radius: const Radius.circular(
                      //                     Dimensions.paddingSizeSmall),
                      //                 child: Stack(children: [
                      //                   ClipRRect(
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               Dimensions
                      //                                   .paddingSizeSmall),
                      //                       child: authProvider
                      //                                   .sellerProfileImage !=
                      //                               null
                      //                           ? Image.file(
                      //                               File(authProvider
                      //                                   .sellerProfileImage!
                      //                                   .path),
                      //                               width: 150,
                      //                               height: 150,
                      //                               fit: BoxFit.cover,
                      //                             )
                      //                           : SizedBox(
                      //                               height: 150,
                      //                               width: 150,
                      //                               child: Center(
                      //                                 child: Column(
                      //                                     mainAxisAlignment:
                      //                                         MainAxisAlignment
                      //                                             .center,
                      //                                     children: [
                      //                                       Image.asset(
                      //                                           Images
                      //                                               .uploadImageIcon,
                      //                                           scale: 3),
                      //                                       const SizedBox(
                      //                                           height: Dimensions
                      //                                               .paddingSizeSmall),
                      //                                       Text(
                      //                                           getTranslated(
                      //                                               'upload_file',
                      //                                               context)!,
                      //                                           style: robotoMedium.copyWith(
                      //                                               fontSize:
                      //                                                   Dimensions
                      //                                                       .fontSizeSmall,
                      //                                               color: Theme.of(
                      //                                                       context)
                      //                                                   .hintColor))
                      //                                     ]),
                      //                               ),
                      //                             )),
                      //                   Positioned(
                      //                     bottom: 0,
                      //                     right: 0,
                      //                     top: 0,
                      //                     left: 0,
                      //                     child: InkWell(
                      //                       onTap: () =>
                      //                           authProvider.pickImage(
                      //                               true, false, false),
                      //                       child: Container(
                      //                         decoration: BoxDecoration(
                      //                           color: Theme.of(context)
                      //                               .hintColor
                      //                               .withOpacity(.08),
                      //                           borderRadius: BorderRadius
                      //                               .circular(Dimensions
                      //                                   .paddingSizeSmall),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ]),
                      //               )),
                      //         ),
                      //         const SizedBox(
                      //             height: Dimensions.paddingSizeSmall),
                      //         Text(getTranslated('seller_image', context)!,
                      //             style: robotoMedium.copyWith(
                      //                 fontSize: Dimensions.fontSizeLarge)),
                      //         const SizedBox(
                      //             height: Dimensions.paddingSizeExtraSmall),
                      //         Text(getTranslated('image_ratio', context)!,
                      //             style: robotoRegular.copyWith(
                      //                 fontSize: Dimensions.fontSizeDefault,
                      //                 color: Theme.of(context).hintColor)),
                      //         const SizedBox(
                      //             height: Dimensions.paddingSizeExtraSmall),
                      //         Text(getTranslated('image_size_2_mb', context)!,
                      //             style: robotoRegular.copyWith(
                      //                 fontSize: Dimensions.fontSizeDefault,
                      //                 color: Theme.of(context).hintColor)),
                      //         const SizedBox(
                      //             height: Dimensions.paddingSizeDefault),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Divider(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.04),
                          height: 0,
                          indent: 0,
                          thickness: 1),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeSmall),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidget(
                                  title: getTranslated('shop_name', context)!),
                              CustomTextFieldWidget(
                                border: true,
                                hintText:
                                    getTranslated('store_name_hint', context),
                                focusNode: authProvider.shopNameNode,
                                nextNode: authProvider.shopAddressNode,
                                textInputType: TextInputType.name,
                                controller: authProvider.shopNameController,
                                textInputAction: TextInputAction.next,
                              )
                            ],
                          )),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeSmall),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidget(
                                  title:
                                      getTranslated('shop_address', context)!),
                              CustomTextFieldWidget(
                                border: true,
                                hintText:
                                    getTranslated('address_hint', context),
                                focusNode: authProvider.shopAddressNode,
                                textInputType: TextInputType.name,
                                controller: authProvider.shopAddressController,
                                textInputAction: TextInputAction.done,
                              )
                            ],
                          )),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Container(
                        margin: const EdgeInsets.only(
                            right: Dimensions.paddingSizeSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Consumer<AuthController>(
                                    builder: (context, authProvider, child) =>
                                        Checkbox(
                                            checkColor: ColorResources.white,
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: authProvider
                                                .isTermsAndCondition,
                                            onChanged: authProvider
                                                .updateTermsAndCondition)),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => HtmlViewScreen(
                                                  title: getTranslated(
                                                      'terms_and_condition',
                                                      context),
                                                  url: Provider.of<
                                                              SplashController>(
                                                          context,
                                                          listen: false)
                                                      .configModel!
                                                      .termsConditions)));
                                    },
                                    child: Row(children: [
                                      Text(getTranslated(
                                          'i_agree_to_your', context)!),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(
                                          getTranslated(
                                              'terms_and_condition', context)!,
                                          style: robotoMedium),
                                    ])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])
          ],
        ),
      );
    });
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text(title,
              style:
                  robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
          Text(' *',
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge, color: Colors.red)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ],
    );
  }
}
