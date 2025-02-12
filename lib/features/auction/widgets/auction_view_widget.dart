import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/models/category_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazzraati_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:mazzraati_vendor_app/features/auction/controllers/add_auction_controller.dart';
import 'package:mazzraati_vendor_app/features/auction/domain/models/auction_model.dart';
import 'package:mazzraati_vendor_app/features/auction/screens/add_auction_screen.dart';
import 'package:mazzraati_vendor_app/features/auction/screens/auction_details_screen.dart';
import 'package:mazzraati_vendor_app/features/barcode/screens/bar_code_generator_screen.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class AuctionWidget extends StatefulWidget {
  final Auction? auction;
  final bool isDetails;
  const AuctionWidget(
      {super.key, required this.auction, this.isDetails = false});

  @override
  State<AuctionWidget> createState() => _AuctionWidgetState();
}

class _AuctionWidgetState extends State<AuctionWidget> {
  var extend = false;
  var mini = true;
  var visible = true;
  var buttonSize = const Size(35.0, 35.0);
  var childrenButtonSize = const Size(45.0, 45.0);
  var speedDialDirection;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    speedDialDirection =
        Provider.of<LocalizationController>(context, listen: false).isLtr
            ? SpeedDialDirection.left
            : SpeedDialDirection.right;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: GestureDetector(
            onTap: widget.isDetails
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AuctionDetailsScreen(
                            auctionModel: widget.auction))),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeMedium,
                  vertical: Dimensions.paddingSizeSmall),
              decoration:
                  BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 2))
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.10),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                              ),
                              width: 110,
                              height: 110,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                                child: CustomImageWidget(
                                  image: widget.auction?.imagesUrl.isNotEmpty ??
                                          false
                                      ? widget.auction!.imagesUrl[0]
                                      : '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.auction!.itemName ?? '',
                                  style: robotoRegular.copyWith(
                                      color:
                                          ColorResources.titleColor(context)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Text(
                                '${getTranslated('starting_bid', context)}: ${widget.auction!.startingBid}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
                              ),
                              Text(
                                '${getTranslated('current_bid', context)}: ${widget.auction!.currentBid}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
                              ),
                              Text(
                                '${getTranslated('auction_status', context)}: ${getTranslated(widget.auction!.auctionStatus, context)}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        extend
            ? Align(
                alignment: speedDialDirection == SpeedDialDirection.left
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      width: 205,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).hintColor,
                                spreadRadius: .1,
                                blurRadius: .2,
                                offset: Offset.fromDirection(2, 1))
                          ],
                          borderRadius: BorderRadius.circular(
                              Dimensions.iconSizeExtraLarge))),
                ),
              )
            : const SizedBox(),
        !widget.isDetails
            ? Align(
                alignment: speedDialDirection == SpeedDialDirection.left
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SpeedDial(
                    animationDuration: const Duration(milliseconds: 150),
                    overlayOpacity: 0,
                    icon: Icons.more_horiz,
                    activeIcon: Icons.close,
                    spacing: 10,
                    mini: mini,
                    openCloseDial: isDialOpen,
                    childPadding: const EdgeInsets.all(5),
                    spaceBetweenChildren: 5,
                    buttonSize: buttonSize,
                    childrenButtonSize: childrenButtonSize,
                    visible: visible,
                    direction: speedDialDirection,
                    switchLabelPosition: false,
                    closeManually: true,
                    renderOverlay: true,
                    useRotationAnimation: true,
                    backgroundColor: Theme.of(context).cardColor,
                    foregroundColor: Theme.of(context).disabledColor,
                    elevation: extend ? 0 : 8.0,
                    animationCurve: Curves.elasticInOut,
                    isOpenOnStart: false,
                    shape: const StadiumBorder(),
                    onOpen: () {
                      setState(() {
                        extend = true;
                      });
                    },
                    onClose: () {
                      setState(() {
                        extend = false;
                      });
                    },
                    children: [
                      SpeedDialChild(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(Images.editIcon),
                        ),
                        onTap: () async {
                          setState(() {
                            isDialOpen.value = false;
                            extend = false;
                          });
                          // CategoryModel currentcat = Provider.of<
                          //         AddProductController>(context, listen: false)
                          //     .categoryList!
                          //     .firstWhere((category) =>
                          //         category.name == widget.auction!.category);

                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(currentcat.name);
                          // print(currentcat.);
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          // print(
                          //     "222222222222222222222222222222222222222222222222222222");
                          Provider.of<AddProductController>(context,
                                  listen: false)
                              .setCategoryIndex(
                                  widget.auction!.categoryIndex, true);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AddAuctionScreen(
                              auction: widget.auction,
                            );
                          }));
                        },
                      ),
                      SpeedDialChild(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(Images.delete),
                        ),
                        onTap: () async {
                          setState(() {
                            isDialOpen.value = false;
                            extend = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialogWidget(
                                    icon: Images.deleteProduct,
                                    refund: false,
                                    description: getTranslated(
                                        'are_you_sure_want_to_delete_this_auction',
                                        context),
                                    onYesPressed: () {
                                      Provider.of<AddAuctionController>(context,
                                              listen: false)
                                          .deleteAuction(
                                              widget.auction!.auctionId,
                                              context)
                                          .whenComplete(() {
                                        Navigator.pop(context);
                                      });
                                    });
                              });
                        },
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
