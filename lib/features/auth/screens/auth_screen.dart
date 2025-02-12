import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/registration_screen.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String login = getTranslated('login', context) ?? '';
    String register = getTranslated('new_account', context) ?? '';

    return Scaffold(
      body: Consumer<AuthController>(builder: (context, auth, child) {
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: ColorResources.primaryMaterial,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.5,
                      spreadRadius: 0.5,
                      offset: Offset(0, 0.5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                height: 170,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'مزرعتي',
                      style: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                        fontWeight: FontWeight.bold,
                        fontSize: 80,
                        color: ColorResources.white,
                      ),
                    ),
                    Text(
                      'تطبيق المزرعة',
                      style: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: ColorResources.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: ColorResources.primaryMaterial,
                  labelStyle: titilliumSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                  unselectedLabelColor: ColorResources.black.withOpacity(.5),
                  unselectedLabelStyle: titilliumRegular.copyWith(),
                  onTap: (value) {
                    if (value == 0) {
                      auth.registrationReset();
                      auth.setIndexForTabBar(0);
                    }
                  },
                  indicatorWeight: 1.5,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: login),
                    Tab(text: register),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeSmall),
                            child: Text(
                              getTranslated(
                                      'ُenter_to_farm_account', context) ??
                                  '',
                              style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: ColorResources.titleColor(context),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          const LoginScreen(),
                        ],
                      ),
                    ),
                    RegistrationScreen(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
