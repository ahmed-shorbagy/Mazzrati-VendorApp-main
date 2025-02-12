import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:mazzraati_vendor_app/features/settings/widgets/choose_shipping_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/features/auction/screens/auction_list_screen.dart';
import 'package:mazzraati_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_bottom_sheet_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:mazzraati_vendor_app/features/chat/screens/inbox_screen.dart';
import 'package:mazzraati_vendor_app/features/coupon/screens/coupon_list_screen.dart';
import 'package:mazzraati_vendor_app/features/dashboard/screens/nav_bar_screen.dart';
import 'package:mazzraati_vendor_app/features/delivery_man/screens/delivery_man_setup_screen.dart';
import 'package:mazzraati_vendor_app/features/menu/widgets/sign_out_confirmation_dialog_widget.dart';
import 'package:mazzraati_vendor_app/features/more/screens/html_view_screen.dart';
import 'package:mazzraati_vendor_app/features/product/screens/product_list_screen.dart';
import 'package:mazzraati_vendor_app/features/profile/screens/profile_view_screen.dart';
import 'package:mazzraati_vendor_app/features/review/screens/product_review_screen.dart';
import 'package:mazzraati_vendor_app/features/settings/screens/setting_screen.dart';
import 'package:mazzraati_vendor_app/features/shop/screens/shop_screen.dart';
import 'package:mazzraati_vendor_app/features/wallet/screens/wallet_screen.dart';
import 'package:mazzraati_vendor_app/features/bank_info/screens/bank_info_screen.dart';

class MenuBottomSheetWidget extends StatelessWidget {
  const MenuBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace missing image with a default image
    const defaultProfileImage = Images.profile;

    List<CustomBottomSheetWidget> activateMenu = [
      CustomBottomSheetWidget(
        image: Provider.of<ProfileController>(context, listen: false)
                .userInfoModel
                ?.imageFullUrl
                ?.path ??
            defaultProfileImage,
        isProfile: true,
        title: getTranslated('profile', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreenView()),
        ),
      ),
      CustomBottomSheetWidget(
        image: Images.myShop,
        title: getTranslated('my_shop', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ShopScreen()),
        ),
      ),
      // CustomBottomSheetWidget(
      //   image: Images.addProduct,
      //   title: getTranslated('add_product', context),
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const AddProductScreen()),
      //   ),
      // ),
      // CustomBottomSheetWidget(
      //   image: Images.productIconPp,
      //   title: getTranslated('products', context),
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const ProductListMenuScreen()),
      //   ),
      // ),
      if (Provider.of<SplashController>(context, listen: false)
              .configModel!
              .shippingMethod ==
          'sellerwise_shipping') ...[
        CustomBottomSheetWidget(
          image: Images.ship,
          title: getTranslated('shipping_setting', context),
          onTap: () => showAnimatedDialogWidget(
              context, const ChooseShippingDialogWidget()),
        ),
      ],
      CustomBottomSheetWidget(
        image: Images.reviewIcon,
        title: getTranslated('reviews', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductReviewScreen()),
        ),
      ),
      CustomBottomSheetWidget(
        image: Images.couponIcon,
        title: getTranslated('coupons', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CouponListScreen()),
        ),
      ),
      if (Provider.of<SplashController>(context, listen: false)
              .configModel
              ?.shippingMethod ==
          'sellerwise_shipping')
        CustomBottomSheetWidget(
          image: Images.deliveryManIcon,
          title: getTranslated('deliveryman', context),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DeliveryManSetupScreen()),
          ),
        ),
      if (Provider.of<SplashController>(context, listen: false)
                  .configModel
                  ?.posActive ==
              1 &&
          Provider.of<ProfileController>(context, listen: false)
                  .userInfoModel
                  ?.posActive ==
              1)
        CustomBottomSheetWidget(
          image: Images.pos,
          title: getTranslated('pos', context),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NavBarScreen()),
          ),
        ),
      CustomBottomSheetWidget(
        image: Images.settings,
        title: getTranslated('settings', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
      ),
      CustomBottomSheetWidget(
        image: Images.wallet,
        title: getTranslated('wallet', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WalletScreen()),
        ),
      ),
      // CustomBottomSheetWidget(
      //   image: Images.message,
      //   title: getTranslated('message', context),
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const InboxScreen()),
      //   ),
      // ),
      CustomBottomSheetWidget(
        image: Images.bankingInfo,
        title: getTranslated('bank_info', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            context.read<BankInfoController>().isBankInfoCompleted();
            return const BankInfoScreen();
          }),
        ),
      ),
      CustomBottomSheetWidget(
        image: Images.termsAndCondition,
        title: getTranslated('terms_and_condition', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HtmlViewScreen(
              title: getTranslated('terms_and_condition', context),
              url: Provider.of<SplashController>(context, listen: false)
                  .configModel!
                  .termsConditions!,
            ),
          ),
        ),
      ),
      CustomBottomSheetWidget(
        image: Images.aboutUs,
        title: getTranslated('about_us', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HtmlViewScreen(
              title: getTranslated('about_us', context),
              url: Provider.of<SplashController>(context, listen: false)
                  .configModel!
                  .aboutUs!,
            ),
          ),
        ),
      ),
      CustomBottomSheetWidget(
        image: Images.privacyPolicy,
        title: getTranslated('privacy_policy', context),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HtmlViewScreen(
              title: getTranslated('privacy_policy', context),
              url: Provider.of<SplashController>(context, listen: false)
                  .configModel!
                  .privacyPolicy!,
            ),
          ),
        ),
      ),
      if (Provider.of<SplashController>(context, listen: false)
              .configModel!
              .refundPolicy!
              .status ==
          1)
        CustomBottomSheetWidget(
          image: Images.refundPolicy,
          title: getTranslated('refund_policy', context),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HtmlViewScreen(
                title: getTranslated('refund_policy', context),
                url: Provider.of<SplashController>(context, listen: false)
                    .configModel!
                    .refundPolicy!
                    .content!,
              ),
            ),
          ),
        ),
      if (Provider.of<SplashController>(context, listen: false)
              .configModel!
              .returnPolicy!
              .status ==
          1)
        CustomBottomSheetWidget(
          image: Images.returnPolicy,
          title: getTranslated('return_policy', context),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HtmlViewScreen(
                title: getTranslated('return_policy', context),
                url: Provider.of<SplashController>(context, listen: false)
                    .configModel!
                    .returnPolicy!
                    .content!,
              ),
            ),
          ),
        ),
      // if (Provider.of<SplashController>(context, listen: false)
      //         .configModel!
      //         .cancellationPolicy!
      //         .status ==
      //     1)
      // CustomBottomSheetWidget(
      //   image: Images.cPolicy,
      //   title: getTranslated('cancellation_policy', context),
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => HtmlViewScreen(
      //         title: getTranslated('cancellation_policy', context),
      //         url: Provider.of<SplashController>(context, listen: false)
      //             .configModel!
      //             .cancellationPolicy!
      //             .content!,
      //       ),
      //     ),
      //   ),
      // ),
      // CustomBottomSheetWidget(
      //   image: Images.order,
      //   title: getTranslated('auctions', context) ?? '',
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => AuctionListScreen(),
      //     ),
      //   ),
      // ),

      //!!!!!!!!!!!!!!!!!!!!!!!!logout !!!!!!!!!!!!!!!!!!!!!
      // CustomBottomSheetWidget(
      //   image: Images.logOut,
      //   title: getTranslated('logout', context),
      //   onTap: () => showCupertinoModalPopup(
      //     context: context,
      //     builder: (_) => const SignOutConfirmationDialogWidget(),
      //   ),
      // ),
      //  Provider.of<SplashController>(context, listen: false)
      //             .configModel!
      //             .shippingMethod ==
      //         'sellerwise_shipping'
      //     ? TitleButton(
      //         icon: Images.ship,
      //         title: '${getTranslated('shipping_setting', context)}',
      //         onTap: () => showAnimatedDialogWidget(
      //             context, const ChooseShippingDialogWidget()),
      //       )
      //     : const SizedBox(),

      // CustomBottomSheetWidget(
      //   image: Images.appInfo,
      //   title: 'v - ${AppConstants.appVersion}',
      //   onTap: () {},
      // ),
    ];

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated('menu', context),
        isBackButtonExist: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: ColorResources.getHomeBg(context),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(Dimensions.paddingSizeDefault),
            topLeft: Radius.circular(Dimensions.paddingSizeDefault),
          ),
        ),
        child: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: Dimensions.paddingSizeDefault,
            //     top: Dimensions.paddingSizeDefault,
            //   ),
            //   child: Text(
            //     getTranslated('menu', context)!,
            //     style: Theme.of(context).textTheme.displayMedium!.copyWith(
            //           fontWeight: FontWeight.w600,
            //           color: ColorResources.titleColor(context),
            //         ),
            //   ),
            // ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            GridView.builder(
              itemCount: activateMenu.length,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (1 / 1),
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
              ),
              itemBuilder: (BuildContext context, int index) =>
                  activateMenu[index],
            ),
          ],
        ),
      ),
    );
  }
}
