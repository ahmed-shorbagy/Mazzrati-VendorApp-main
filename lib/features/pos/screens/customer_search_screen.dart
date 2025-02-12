import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/features/pos/domain/models/customer_model.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:mazzraati_vendor_app/features/coupon/controllers/coupon_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_divider_widget.dart';

import 'package:mazzraati_vendor_app/common/basewidgets/custom_search_field_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/no_data_screen.dart';

class CustomerSearchScreen extends StatefulWidget {
  final bool isCoupon;
  const CustomerSearchScreen({super.key, this.isCoupon = false});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: getTranslated('search_customer', context),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 85,
              child: Consumer<CartController>(
                  builder: (context, customerProvider, _) {
                return Consumer<CouponController>(
                    builder: (context, couponProvider, _) {
                  return Container(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeDefault),
                      child: CustomSearchFieldWidget(
                        controller: searchController,
                        hint: getTranslated('search', context),
                        prefix: Images.iconsSearch,
                        iconPressed: () => () {
                          if (widget.isCoupon) {
                            if (widget.isCoupon) {
                              couponProvider.getCouponCustomerList(
                                  context, searchController.text);
                            } else {
                              customerProvider.searchCustomer(
                                  context, searchController.text);
                            }
                          } else {
                            if (widget.isCoupon) {
                              couponProvider.getCouponCustomerList(
                                  context, searchController.text);
                            } else {
                              customerProvider.searchCustomer(
                                  context, searchController.text);
                            }
                          }
                        },
                        onSubmit: (text) => () {
                          if (widget.isCoupon) {
                            couponProvider.getCouponCustomerList(
                                context, searchController.text);
                          } else {
                            customerProvider.searchCustomer(
                                context, searchController.text);
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (widget.isCoupon) {
                              couponProvider.getCouponCustomerList(
                                  context, value);
                            } else {
                              customerProvider.searchCustomer(context, value);
                            }
                          }
                        },
                      ),
                    ),
                  );
                });
              }),
            ),
            Expanded(
              child: Consumer<CouponController>(
                  builder: (context, couponProvider, _) {
                return Consumer<CartController>(
                    builder: (context, customerProvider, child) {
                  List<Customers>? customerList;
                  if (widget.isCoupon) {
                    customerList = couponProvider.couponCustomerList;
                  } else {
                    customerList = customerProvider.searchedCustomerList;
                  }
                  return customerList!.isNotEmpty &&
                          (searchController.text.isNotEmpty)
                      ? ListView.builder(
                          itemCount: customerList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                if (widget.isCoupon) {
                                  couponProvider.setCustomerInfo(
                                      customerList![index].id,
                                      '${customerList[index].fName} ${customerList[index].lName}',
                                      true);
                                  couponProvider.searchCustomerController.text =
                                      '${customerList[index].fName ?? ''} ${customerList[index].lName ?? ''}';
                                } else {
                                  customerProvider.setCustomerInfo(
                                      customerList![index].id,
                                      '${customerList[index].fName} ${customerList[index].lName}',
                                      customerProvider
                                          .searchedCustomerList![index].phone,
                                      true);
                                  customerProvider
                                          .searchCustomerController.text =
                                      '${customerList[index].fName} ${customerList[index].lName}';
                                }
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeSmall),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${customerList![index].fName} ${customerList[index].lName}',
                                            style: robotoRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeDefault)),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeMedium,
                                        ),
                                        CustomDividerWidget(
                                            height: .5,
                                            color: Theme.of(context).hintColor),
                                      ],
                                    )),
                              ),
                            );
                          })
                      : widget.isCoupon
                          ? const SizedBox()
                          : const NoDataScreen();
                });
              }),
            )
          ],
        ));
  }
}
