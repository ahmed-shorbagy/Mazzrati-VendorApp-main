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
    if (productId == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      ApiResponse apiResponse =
          await productDetailsServiceInterface.getProductDetails(productId);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _productDetails = Product.fromJson(apiResponse.response!.data);
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');
    } finally {
      _isLoading = false;
      // Use addPostFrameCallback to avoid calling notifyListeners during build
      if (Get.context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        notifyListeners();
      }
    }
  }

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      // Use addPostFrameCallback to avoid calling notifyListeners during build
      if (Get.context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        notifyListeners();
      }
    }
  }

  Future<bool> productStatusOnOff(
      BuildContext context, int? productId, int status) async {
    if (productId == null) {
      return false;
    }

    setLoading(true);

    try {
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

        return true;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e) {
      debugPrint('Error updating product status: $e');
    } finally {
      // Use addPostFrameCallback to avoid calling setLoading during build
      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setLoading(false);
        });
      } else {
        setLoading(false);
      }
    }

    return false;
  }
}
