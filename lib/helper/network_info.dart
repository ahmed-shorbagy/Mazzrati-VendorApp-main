import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// التأكد من استدعاء الترجمة/الملفات المناسبة
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  /// بدلًا من إرجاع ConnectivityResult واحد،
  /// الإصدارات الجديدة تعيد List<ConnectivityResult>.
  /// لهذا نتحقق من وجود أي نوع اتصال != none.
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results =
        await connectivity.checkConnectivity();
    // إذا لم تكن القائمة فارغة، وتحتوي على أي نوع != none،
    // فهذا يعني وجود اتصال.
    return results.any((element) => element != ConnectivityResult.none);
  }

  static void checkConnectivity(BuildContext context) {
    /// أيضًا في الإصدارات الجديدة `onConnectivityChanged`
    /// قد تعيد Stream<List<ConnectivityResult>> بدلاً من Stream<ConnectivityResult>.
    Connectivity().onConnectivityChanged.listen((dynamic event) {
      // تأكّد من نوع الـ event.
      // في الإصدارات الأحدث سيأتي على شكل List<ConnectivityResult>.
      final List<ConnectivityResult> results =
          event is List<ConnectivityResult> ? event : [event];
      //  في حال استخدم إصدار لم يغيّر ستريم قيمته بعد

      if (Provider.of<SplashController>(context, listen: false)
          .firstTimeConnectionCheck) {
        Provider.of<SplashController>(context, listen: false)
            .setFirstTimeConnectionCheck(false);
      } else {
        // إذا كانت القائمة تحتوي فقط على none، فنحن غير متصلين
        bool isNotConnected =
            results.length == 1 && results.first == ConnectivityResult.none;

        // في حالة عدم الاتصال، لن نخفي Snackbar بل نظهر رسالة بعد الـSizedBox
        if (!isNotConnected) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)!
                : getTranslated('connected', context)!,
            textAlign: TextAlign.center,
          ),
        ));
      }
    });
  }
}
