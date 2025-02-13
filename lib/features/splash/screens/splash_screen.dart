import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/options_screen.dart';
import 'package:mazzraati_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/helper/network_info.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initCall();
  }

  Future<void> initCall() async {
    NetworkInfo.checkConnectivity(context);
    Provider.of<SplashController>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashController>(context, listen: false)
            .initShippingTypeList(context, '');
        Timer(const Duration(seconds: 1), () async {
          if (Provider.of<AuthController>(context, listen: false)
              .isLoggedIn()) {
            await Provider.of<AuthController>(context, listen: false)
                .updateToken(context);
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const DashboardScreen()));
          } else {
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const OptionScreen()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.primaryMaterial,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero(
              //     tag: 'logo',
              //     child: Image.asset(Images.whiteLogo,
              //         height: 80.0, fit: BoxFit.cover, width: 80.0)),
              // const SizedBox(
              //   height: Dimensions.paddingSizeExtraLarge,
              // ),
              Text(
                AppConstants.appName,
                style: titilliumBold.copyWith(
                    fontSize: Dimensions.fontSizeWallet, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
