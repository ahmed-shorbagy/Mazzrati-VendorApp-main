import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/localization/models/language_model.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';

class LanguageController with ChangeNotifier {
  int _selectIndex = 0;

  int get selectIndex => _selectIndex;

  void setSelectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  List<LanguageModel> _languages = [];

  List<LanguageModel> get languages => _languages;

  void searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
      notifyListeners();
    } else {
      _selectIndex = -1;
      _languages = [];
      for (var product in AppConstants.languages) {
        if (product.languageName!.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(product);
        }
      }
      notifyListeners();
    }
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
    }
  }
}
