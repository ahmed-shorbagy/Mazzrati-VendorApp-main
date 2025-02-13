import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/auth_screen.dart';
import 'package:mazzraati_vendor_app/features/auth/screens/registration_screen.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  OptionScreenState createState() => OptionScreenState();
}

class OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SplashController>(
        builder: (context, splashController, child) => Column(
          children: [
            // ClipPath for the top curved shape
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 250,
                color: ColorResources.primaryMaterial,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            getTranslated('welcome_to', context) ??
                                'مرحبا بك في',
                            style: const TextStyle(
                              fontFamily: 'DINNextLTArabic',
                              fontWeight: FontWeight.w400, // Regular
                              fontSize: 18,
                              color: ColorResources.white,
                            ),
                          ),
                          Text(
                            getTranslated('mazzraati', context) ?? "مزرعتي",
                            style: const TextStyle(
                              fontFamily: 'DINNextLTArabic',
                              fontWeight: FontWeight.bold, // Bold
                              fontSize: 48,
                              color: ColorResources.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // New Farm Account button
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: CustomButtonWidget(
                borderRadius: 7,
                height: 50,
                backgroundColor: Theme.of(context).primaryColor,
                btnTxt: getTranslated('new_farm_account', context),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return RegistrationScreen(
                      fromOptions: true,
                    );
                  }));
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            // Login button
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: CustomButtonWidget(
                borderRadius: 7,
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                backgroundColor: ColorResources.white,
                fontColor: ColorResources.primaryMaterial,
                height: 50,
                btnTxt: getTranslated('login', context),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const AuthScreen();
                  }));
                },
              ),
            ),
            const Spacer(),
            // Terms & Conditions
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //       vertical: Dimensions.paddingSizeMedium),
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => HtmlViewScreen(
            //                     title: getTranslated(
            //                         'terms_and_condition', context),
            //                     url: splashController
            //                         .configModel!.termsConditions,
            //                   )));
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           getTranslated('terms_and_condition', context)!,
            //           style: robotoMedium.copyWith(
            //             color: Theme.of(context).primaryColor,
            //             decoration: TextDecoration.underline,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the top curved shape
class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom left
    path.quadraticBezierTo(size.width / 5, size.height, size.width / 2,
        size.height - 20); // First wave curve
    path.quadraticBezierTo(size.width * 3 / 4, size.height - 40, size.width,
        size.height - 20); // Second wave curve
    path.lineTo(size.width, 0); // Go to top right
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
