import 'package:flutter/cupertino.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/api_response.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/product_details/domain/services/product_details_service_interface.dart';
import 'package:mazzraati_vendor_app/helper/api_checker.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';

class ProductDetailsController extends ChangeNotifier {
  final ProductDetailsServiceInterface productDetailsServiceInterface;
  ProductDetailsController({required this.productDetailsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Product? _productDetails;
  Product? get productDetails => _productDetails;

  Future<void> getProductDetails(int? productId) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse =
        await productDetailsServiceInterface.getProductDetails(productId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productDetails = Product.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> productStatusOnOff(
      BuildContext context, int? productId, int status) async {
    setLoading(true);

    ApiResponse apiResponse = await productDetailsServiceInterface
        .productStatusOnOff(productId, status);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      // Update the local state directly if the API call is successful
      _productDetails?.status = status;

      showCustomSnackBarWidget(
        getTranslated('status_updated_successfully', Get.context!),
        Get.context!,
        isError: false,
      );

      setLoading(false);
      notifyListeners(); // Notify listeners to update the UI
      return true;
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    setLoading(false);
    return false;
  }
}
