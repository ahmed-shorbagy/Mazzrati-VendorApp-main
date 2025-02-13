import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/auction/screens/add_auction_screen.dart';
import 'package:provider/provider.dart'; // Ensure you have provider package
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:mazzraati_vendor_app/features/auction/controllers/add_auction_controller.dart';
import 'package:mazzraati_vendor_app/features/auction/domain/models/auction_model.dart';
import 'package:mazzraati_vendor_app/features/auction/widgets/auction_view_widget.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';

// class AuctionListScreen extends StatelessWidget {
//   bool isFromButtonNavBar;
//   AuctionListScreen({super.key, this.isFromButtonNavBar = false});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Auction List'),

//       // ),
//       appBar: CustomAppBarWidget(
//         title: getTranslated("auction_list", context) ?? "",
//         isBackButtonExist: isFromButtonNavBar ? false : true,
//       ),
//       body: Consumer<AddAuctionController>(
//         builder: (context, controller, child) {
//           return StreamBuilder<List<Auction>>(
//             stream: controller.getAllAuctionsStream(context),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('No auctions available'));
//               } else {
//                 List<Auction> auctions = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: auctions.length,
//                   itemBuilder: (context, index) {
//                     return AuctionWidget(auction: auctions[index]);
//                   },
//                 );
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// Ensure you have provider package

class AuctionListScreen extends StatelessWidget {
  bool isFromButtonNavBar;
  AuctionListScreen({super.key, this.isFromButtonNavBar = false});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBarWidget(
            title: getTranslated("auction_list", context) ?? "",
            isBackButtonExist: isFromButtonNavBar ? false : true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: TabBar(
                labelPadding: const EdgeInsets.only(left: 5, right: 5),
                tabs: [
                  Tab(
                      text: getTranslated("active_auction", context) ??
                          "Active Auction"),
                  Tab(
                      text: getTranslated("closed_auction", context) ??
                          "Closed Auction"),
                  Tab(
                      text: getTranslated("Upcoming_auction", context) ??
                          "Upcoming Auction"),
                ],
              ),
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Provider.of<AddProductController>(context, listen: false)
                .getCategoryList(context, null, 'en');
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddAuctionScreen()));
          },
        ),
        body: Consumer<AddAuctionController>(
          builder: (context, controller, child) {
            return TabBarView(
              children: [
                AuctionListTab(
                    controller: controller,
                    stream: controller.getAllActiveAuctionsStream(
                        context, 'active')),
                AuctionListTab(
                    controller: controller,
                    stream: controller.getAllEndedAuctionsStream(
                        context, 'closed')),
                AuctionListTab(
                    controller: controller,
                    stream: controller.getAllUpcomingAuctionsStream(
                        context, 'Upcoming')),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AuctionListTab extends StatelessWidget {
  final AddAuctionController controller;
  final Stream<List<Auction>>? stream;

  const AuctionListTab(
      {super.key, required this.controller, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Auction>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const NoDataScreen();
        } else {
          List<Auction> auctions = snapshot.data!;
          return ListView.builder(
            itemCount: auctions.length,
            itemBuilder: (context, index) {
              return AuctionWidget(auction: auctions[index]);
            },
          );
        }
      },
    );
  }
}
