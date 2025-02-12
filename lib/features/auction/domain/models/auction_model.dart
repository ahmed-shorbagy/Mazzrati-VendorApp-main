import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';

class Auction {
  String auctionId;
  String itemName;
  String itemDescription;
  double startingBid;
  double currentBid;
  double bidIncrement;
  String category;
  int categoryIndex;
  DateTime createdAt;
  DateTime startTime;
  DateTime endTime;
  List<String> imagesUrl;
  String auctionStatus;
  List<Bid> bids; // List of bids associated with the auction

  Auction({
    required this.auctionId,
    required this.itemName,
    required this.itemDescription,
    required this.startingBid,
    required this.category,
    required this.categoryIndex,
    required this.currentBid,
    required this.bidIncrement,
    required this.createdAt,
    required this.startTime,
    required this.endTime,
    required this.imagesUrl,
    required this.auctionStatus,
    required this.bids,
  });

  // Convert a Firestore document to an Auction object
  factory Auction.fromFirestore(Map<String, dynamic> data) {
    var bidList = (data['bids'] as List<dynamic>)
        .map((bid) => Bid.fromFirestore(bid as Map<String, dynamic>))
        .toList();

    // Ensure imagesUrl is a list of strings
    var imagesUrlList = List<String>.from(data['imagesUrl'] ?? []);

    return Auction(
      auctionId: data['auctionId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      itemName: data['itemName'],
      category: data['category'] ?? "اعلاف",
      categoryIndex: data['categoryIndex'] ?? 1,
      itemDescription: data['itemDescription'],
      startingBid: (data['startingBid'] as num).toDouble(),
      currentBid: (data['currentBid'] as num).toDouble(),
      bidIncrement: (data['bidIncrement'] as num).toDouble(),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      imagesUrl: imagesUrlList,
      auctionStatus: data['auctionStatus'],
      bids: bidList,
    );
  }

  // Convert an Auction object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'imagesUrl': imagesUrl,
      'auctionId': auctionId,
      "categoryIndex": categoryIndex,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'startingBid': startingBid,
      'currentBid': currentBid,
      'bidIncrement': bidIncrement,
      'category': category,
      'startTime': startTime,
      'endTime': endTime,
      'auctionStatus': auctionStatus,
      'bids': bids.map((bid) => bid.toFirestore()).toList(),
    };
  }

  String calculateAuctionState() {
    final now = DateTime.now();

    if (now.isBefore(startTime)) {
      return "Upcoming";
    } else if (now.isAfter(endTime)) {
      return "closed";
    } else {
      return "active";
    }
  }
}

class Bid {
  String bidId;
  String userId;
  double bidAmount;
  Customer user;
  double currentbid;
  DateTime bidTime;

  Bid({
    required this.bidId,
    required this.currentbid,
    required this.userId,
    required this.bidAmount,
    required this.bidTime,
    required this.user,
  });

  // Convert a Firestore document to a Bid object
  factory Bid.fromFirestore(Map<String, dynamic> data) {
    return Bid(
      bidId: data['bidId'],
      userId: data['userId'],
      currentbid: data['currentBid'],
      bidAmount: data['bidAmount'].toDouble(),
      user: Customer.fromJson(data['customer'] as Map<String, dynamic>),
      bidTime: (data['bidTime']).toDate(),
    );
  }

  // Convert a Bid object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'bidId': bidId,
      'userId': userId,
      'customer': user.toJson(),
      'currentBid': currentbid,
      'bidAmount': bidAmount,
      'bidTime': bidTime,
    };
  }
}
