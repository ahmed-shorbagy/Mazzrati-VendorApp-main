import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/features/order/screens/order_screen.dart';
import 'package:mazzraati_vendor_app/features/pos/screens/pos_product_screen.dart';
import 'package:mazzraati_vendor_app/features/pos/screens/pos_screen.dart';

class BottomMenuController extends ChangeNotifier {
  int _currentTab = 0;
  int get currentTab => _currentTab;
  final List<Widget> screen = [
    const PosScreen(),
    const OrderScreen(),
    const POSProductScreen(),
  ];
  Widget _currentScreen = const PosScreen();
  Widget get currentScreen => _currentScreen;

  resetNavBar() {
    _currentScreen = const PosScreen();
    _currentTab = 0;
  }

  selectHomePage() {
    _currentScreen = const PosScreen();
    _currentTab = 0;
    notifyListeners();
  }

  selectPosScreen() {
    _currentScreen = const OrderScreen();
    _currentTab = 1;
    notifyListeners();
  }

  selectItemsScreen() {
    _currentScreen = const POSProductScreen();
    _currentTab = 2;
    notifyListeners();
  }
}
