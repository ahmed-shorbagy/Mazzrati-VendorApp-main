import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/api_response.dart';
import 'package:mazzraati_vendor_app/data/model/response/base/error_response.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/features/settings/screens/order_wise_shipping_list_screen.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/models/category_wise_shipping_model.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/services/shipping_service_interface.dart';
import 'package:mazzraati_vendor_app/features/shipping/screens/category_wise_shipping_screen.dart';
import 'package:mazzraati_vendor_app/features/shipping/widgets/product_wise_shipping_widget.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/helper/api_checker.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:provider/provider.dart';

class ShippingRange {
  final int startKm;
  final int endKm;
  final TextEditingController priceController;

  ShippingRange({
    required this.startKm,
    required this.endKm,
    required this.priceController,
  });
}

class ShippingController extends ChangeNotifier {
  final ShippingServiceInterface shippingServiceInterface;
  ShippingController({required this.shippingServiceInterface});

  List<ShippingModel>? _shippingList;
  List<ShippingModel>? get shippingList => _shippingList;
  int _shippingIndex = 0;
  int get shippingIndex => _shippingIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AllCategoryShippingCost>? _categoryWiseShipping;
  List<AllCategoryShippingCost>? get categoryWiseShipping =>
      _categoryWiseShipping;

  List<ShippingRange> _shippingRanges = [];
  List<ShippingRange> get shippingRanges => _shippingRanges;

  Future<void> getShippingList(String token) async {
    _shippingIndex = 0;
    ApiResponse apiResponse =
        await shippingServiceInterface.getShippingMethod(token);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingList = [];
      apiResponse.response!.data.forEach((shippingMethod) =>
          _shippingList!.add(ShippingModel.fromJson(shippingMethod)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future addShippingMethod(ShippingModel? shipping, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await shippingServiceInterface.addShipping(shipping);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      callback(true, '');
      notifyListeners();
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print(errorResponse.errors![0].message);
        }
        errorMessage = errorResponse.errors![0].message;
      }
      callback(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future updateShippingMethod(String? title, String? duration, double? cost,
      int? id, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shippingServiceInterface.updateShipping(
        title, duration, cost, id);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      callback(true, '');
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print(errorResponse.errors![0].message);
        }
        errorMessage = errorResponse.errors![0].message;
      }
      callback(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteShipping(int? id) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await shippingServiceInterface.deleteShipping(id);
    if (response.response!.statusCode == 200) {
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(
          getTranslated('shipping_method_deleted_successfully', Get.context!),
          Get.context!,
          isError: false);
      getShippingList(Provider.of<AuthController>(Get.context!, listen: false)
          .getUserToken());
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    notifyListeners();
  }

  List<bool> _isMultiply = [];
  List<int> _isMultiplyInt = [];
  List<int> get isMultiplyInt => _isMultiplyInt;
  List<bool> get isMultiply => _isMultiply;
  void toggleMultiply(BuildContext context, bool isOk, int index) {
    _isMultiply[index] = isOk;
    if (_isMultiply[index]) {
      _isMultiplyInt[index] = 1;
    } else {
      _isMultiplyInt[index] = 0;
    }
    notifyListeners();
  }

  List<int?> _ids = [];
  List<int?> get ids => _ids;
  Future<void> getCategoryWiseShippingMethod() async {
    ApiResponse apiResponse =
        await shippingServiceInterface.getCategoryWiseShippingMethod();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _categoryWiseShipping = [];
      _isMultiply = [];
      _isMultiplyInt = [];
      _ids = [];
      _categoryWiseShipping!.addAll(
          CategoryWiseShippingModel.fromJson(apiResponse.response!.data)
              .allCategoryShippingCost!);
      apiResponse.response!.data['all_category_shipping_cost']
          .forEach((isMulti) {
        AllCategoryShippingCost shippingCost =
            AllCategoryShippingCost.fromJson(isMulti);
        _ids.add(shippingCost.id);
        if (shippingCost.multiplyQty ?? false) {
          _isMultiply.add(true);
          _isMultiplyInt.add(1);
        } else {
          _isMultiply.add(false);
          _isMultiplyInt.add(0);
        }
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  String? _selectedShippingType = '';
  String? get selectedShippingType => _selectedShippingType;
  Future<void> getSelectedShippingMethodType(BuildContext context) async {
    ApiResponse apiResponse =
        await shippingServiceInterface.getSelectedShippingMethodType();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _selectedShippingType = apiResponse.response!.data['type'];
      Provider.of<SplashController>(Get.context!, listen: false)
          .initShippingType(_selectedShippingType);
      if (_selectedShippingType == 'order_wise') {
        setShippingType(0);
      } else if (_selectedShippingType == 'product_wise') {
        setShippingType(1);
      } else {
        setShippingType(2);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setShippingType(int index) {
    _shippingIndex = index;
    notifyListeners();
  }

  Future<ApiResponse> setShippingMethodType(
      BuildContext context, String? type) async {
    ApiResponse apiResponse =
        await shippingServiceInterface.setShippingMethodType(type);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(
          getTranslated('shipping_method_updated_successfully', Get.context!),
          Get.context!,
          isToaster: true,
          isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> setCategoryWiseShippingCost(BuildContext context,
      List<int?> ids, List<double> cost, List<int> multiPly) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shippingServiceInterface
        .setCategoryWiseShippingCost(ids, cost, multiPly);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getCategoryWiseShippingMethod();
      showCustomSnackBarWidget(
          getTranslated('category_cost_updated_successfully', Get.context!),
          Get.context!,
          isToaster: true,
          isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
    return apiResponse;
  }

  List<TextEditingController> _shippingCostController = [];
  List<TextEditingController> get shippingCostController =>
      _shippingCostController;
  List<FocusNode> _shippingCostNode = [];
  List<FocusNode> get shippingCostNode => _shippingCostNode;

  void setShippingCost() {
    _shippingCostController = [];
    _shippingCostNode = [];
    for (int i = 0; i < categoryWiseShipping!.length; i++) {
      for (var categoryWiseShipping in categoryWiseShipping!) {
        _shippingCostController.add(
            TextEditingController(text: categoryWiseShipping.cost.toString()));
        _shippingCostNode.add(FocusNode());
      }
    }
  }

  List<String> shippingType = ['category_wise', 'order_wise', 'product_type'];
  int _selectedShippingTypeIndex = 0;
  int get selectedShippingTypeIndex => _selectedShippingTypeIndex;

  String _selectedShippingTypeName = 'category_wise';
  String get selectedShippingTypeName => _selectedShippingTypeName;

  void iniType(String name) {
    _selectedShippingTypeName = name;
  }

  void setShippingTypeIndex(BuildContext context, int value,
      {bool notify = false}) {
    _selectedShippingTypeIndex = value;
    if (_selectedShippingTypeIndex == 0) {
      _selectedShippingTypeName = 'category_wise';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const CategoryWiseShippingScreen()));
    } else if (_selectedShippingTypeIndex == 1) {
      _selectedShippingTypeName = 'order_wise';
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const OrderWiseShippingScreen()));
    } else {
      _selectedShippingTypeName = 'product_type';
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ProductWiseShippingWidget()));
    }
    notifyListeners();
  }

  Future shippingOnOff(
      BuildContext context, int? id, int status, int? index) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await shippingServiceInterface.shippingOnOff(id, status);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingList![index!].status = status;
      showCustomSnackBarWidget(
          getTranslated('status_updated_successfully', Get.context!),
          Get.context!,
          isError: false);
    } else {}
    _isLoading = false;
    notifyListeners();
  }

  void initializeShippingRanges() {
    _shippingRanges = [
      ShippingRange(
          startKm: 0, endKm: 50, priceController: TextEditingController()),
      ShippingRange(
          startKm: 51, endKm: 150, priceController: TextEditingController()),
      ShippingRange(
          startKm: 151, endKm: 350, priceController: TextEditingController()),
      ShippingRange(
          startKm: 351,
          endKm: -1,
          priceController: TextEditingController()), // -1 indicates unlimited
    ];
    notifyListeners();
  }

  Map<String, dynamic> getShippingRangesJson() {
    return {
      'shipping_ranges': _shippingRanges
          .map((range) => {
                'start_km': range.startKm,
                'end_km': range.endKm,
                'price': double.tryParse(range.priceController.text) ?? 0.0,
              })
          .toList(),
    };
  }

  bool _isLoadingShippingPrices = false;
  bool get isLoadingShippingPrices => _isLoadingShippingPrices;

  dynamic _shippingPricesResponse;
  dynamic get shippingPricesResponse => _shippingPricesResponse;

  Future<void> getShippingPrices() async {
    _isLoadingShippingPrices = true;
    _shippingPricesResponse = null;
    notifyListeners();

    try {
      ApiResponse apiResponse =
          await shippingServiceInterface.getShippingPrices();
      log("shippingPricesResponse: ${apiResponse.response!.data}");
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _shippingPricesResponse = apiResponse.response!.data;
        _shippingRanges = []; // Clear existing ranges

        // Check if response is a List (direct shipping ranges)
        if (_shippingPricesResponse is List) {
          final shippingRangesData = _shippingPricesResponse as List;

          for (var rangeData in shippingRangesData) {
            if (rangeData is Map) {
              final startKm = rangeData['distance_from'] as int? ?? 0;
              final endKm = rangeData['distance_to'] as int? ?? -1;
              final price = rangeData['shipping_price']?.toString() ?? '0.0';

              _shippingRanges.add(ShippingRange(
                startKm: startKm,
                endKm: endKm,
                priceController: TextEditingController(text: price),
              ));
            }
          }
        }
        // Backward compatibility - check if it's a Map with shipping_ranges key
        else if (_shippingPricesResponse is Map &&
            (_shippingPricesResponse as Map).containsKey('shipping_ranges')) {
          final shippingRangesData =
              (_shippingPricesResponse as Map)['shipping_ranges'] as List?;

          if (shippingRangesData != null) {
            for (var rangeData in shippingRangesData) {
              if (rangeData is Map) {
                final startKm = rangeData['distance_from'] as int? ?? 0;
                final endKm = rangeData['distance_to'] as int? ?? -1;
                final price = rangeData['shipping_price']?.toString() ?? '0.0';

                _shippingRanges.add(ShippingRange(
                  startKm: startKm,
                  endKm: endKm,
                  priceController: TextEditingController(text: price),
                ));
              }
            }
          }
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e) {
      log('Error fetching shipping prices: $e');
    } finally {
      _isLoadingShippingPrices = false;
      notifyListeners();
    }
  }

  Future<bool> addShippingRange(
      int distanceFrom, int distanceTo, double shippingPrice) async {
    try {
      ApiResponse apiResponse = await shippingServiceInterface.addShippingRange(
        distanceFrom: distanceFrom,
        distanceTo: distanceTo,
        shippingPrice: shippingPrice,
      );

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        // Refresh shipping ranges after successful addition
        await getShippingPrices();
        return true;
      } else {
        ApiChecker.checkApi(apiResponse);
        return false;
      }
    } catch (e) {
      log('Error adding shipping range: $e');
      return false;
    }
  }

  void setShippingRangePrice(int index, String price) {
    if (index < _shippingRanges.length) {
      _shippingRanges[index].priceController.text = price;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var range in _shippingRanges) {
      range.priceController.dispose();
    }
    super.dispose();
  }
}
