import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/features/auction/screens/all_bids_screen.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:mazzraati_vendor_app/features/auction/domain/models/auction_model.dart'; // Update with your actual path
import 'package:mazzraati_vendor_app/features/auction/widgets/auction_details_widget.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';

import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';

class AuctionDetailsScreen extends StatefulWidget {
  final Auction? auctionModel;
  const AuctionDetailsScreen({super.key, this.auctionModel});

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool isAuctionClosed = false;
  Bid? winnerBid;

  @override
  void initState() {
    super.initState();

    if (widget.auctionModel != null) {
      isAuctionClosed =
          widget.auctionModel!.calculateAuctionState() == 'closed';
      if (isAuctionClosed && widget.auctionModel!.bids.isNotEmpty) {
        // Sort bids to find the highest bid
        widget.auctionModel!.bids
            .sort((a, b) => b.bidAmount.compareTo(a.bidAmount));
        winnerBid = widget.auctionModel!.bids.last;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated('auction_details', context) ?? '',
        isBackButtonExist: true,
        isAction: true,
        productSwitch: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Consumer<AuthController>(
          builder: (authContext, authProvider, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Carousel Slider for Auction Images
                  if (widget.auctionModel?.imagesUrl.isNotEmpty ?? false) ...[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: widget.auctionModel!.imagesUrl.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      carouselController: _carouselController,
                    ),

                    const SizedBox(height: 10),

                    // Smooth Page Indicator
                    AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: widget.auctionModel!.imagesUrl.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey,
                      ),
                      onDotClicked: (index) {
                        _carouselController.animateToPage(index);
                      },
                    ),
                  ],

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Auction Details Widget
                  AuctionDetailsWidget(
                    auction: widget.auctionModel!,
                  ),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  if (isAuctionClosed && winnerBid != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ColorResources.primaryMaterial.withOpacity(.15),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            getTranslated('auction_ended', context) ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${getTranslated('winner', context)}: ${winnerBid?.user.fName ?? ""} ${winnerBid?.user.lName ?? ""}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${getTranslated('email', context)}: ${winnerBid?.user.email ?? ""}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy,
                                    size: 18, color: Colors.black),
                                onPressed: () {
                                  String email = winnerBid?.user.email ?? "";
                                  if (email.isNotEmpty) {
                                    Clipboard.setData(
                                        ClipboardData(text: email));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'email_copied', context)!)),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'no_email_to_copy', context)!)),
                                    );
                                  }
                                },
                                tooltip: getTranslated('copy_email', context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${getTranslated('phone', context)}: ${winnerBid?.user.phone ?? ""}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy,
                                    size: 18, color: Colors.black),
                                onPressed: () {
                                  String phone = winnerBid?.user.phone ?? "";
                                  if (phone.isNotEmpty) {
                                    Clipboard.setData(
                                        ClipboardData(text: phone));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                                  'phone_copied', context) ??
                                              "")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                                  'no_phone_to_copy',
                                                  context) ??
                                              "")),
                                    );
                                  }
                                },
                                tooltip: getTranslated('copy_phone', context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${getTranslated('final_bid', context)}: SAR ${widget.auctionModel?.currentBid}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  widget.auctionModel!.bids.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: CustomButtonWidget(
                            btnTxt: getTranslated("all_bids", context) ?? "",
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllBidsScreen(
                                    auctionId: widget.auctionModel!.auctionId),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
