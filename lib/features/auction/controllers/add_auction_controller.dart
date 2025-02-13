import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/features/auction/domain/models/auction_model.dart';
import 'package:mazzraati_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:mazzraati_vendor_app/features/profile/domain/models/profile_info.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';

class AddAuctionController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> _uploadImage(File imageFile) async {
    log("Starting image upload");
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('auction_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Track the progress of the upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        log('Task state: ${snapshot.state}'); // e.g. running, paused, success
        log('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      log("Ending image upload");
      return downloadUrl;
    } catch (e) {
      log("Error in image upload: $e");
      throw Exception('Image upload failed: $e');
    }
  }

  Future<void> createAuction({
    required String productName,
    required String productDescription,
    required double startingBid,
    required double bidIncrement,
    required DateTime startTime,
    required DateTime endTime,
    required List<File> images,
    required int categoryIndex,
    required String category,
    required BuildContext context,
  }) async {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
      String auctionId = auctions.doc().id;

      // Asynchronously upload images
      List<Future<String>> uploadFutures =
          images.map((image) => _uploadImage(image)).toList();
      List<String> imageUrls = await Future.wait(uploadFutures);
      ProfileInfoModel? user =
          Provider.of<ProfileController>(context, listen: false).userInfoModel;

      Map<String, dynamic> auctionData = {
        'ownerId': user?.id,
        'auctionId': auctionId,
        'itemName': productName,
        'createdAt': Timestamp.now(),
        'itemDescription': productDescription,
        'startingBid': startingBid,
        'currentBid': startingBid,
        'category': category,
        "categoryIndex": categoryIndex,
        'bidIncrement': bidIncrement,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'imagesUrl': imageUrls,
        'auctionStatus': 'active',
        'bids': [],
      };

      await auctions.doc(auctionId).set(auctionData);
      showCustomSnackBarWidget(
          getTranslated('auction_created_successfully', context), context,
          isError: false);
      Navigator.pop(context);
      notifyListeners();
    } catch (error) {
      showCustomSnackBarWidget(
          getTranslated('error_creating_auction', context), context,
          sanckBarType: SnackBarType.warning, isError: true);
      throw Exception('Error creating auction: $error');
    }
  }

  Future<void> updateAuction(
      {required String auctionId,
      String? productName,
      String? productDescription,
      double? startingBid,
      String? category,
      double? bidIncrement,
      int? categoryIndex,
      DateTime? startTime,
      DateTime? endTime,
      List<File>? images,
      required BuildContext context}) async {
    try {
      DocumentReference auctionDoc =
          _firestore.collection('MazzrattiAuctions').doc(auctionId);

      // Prepare the data to be updated
      Map<String, dynamic> updateData = {};
      if (productName != null) updateData['itemName'] = productName;
      if (productDescription != null) {
        updateData['itemDescription'] = productDescription;
      }
      if (startingBid != null) updateData['startingBid'] = startingBid;
      if (categoryIndex != null) updateData['categoryIndex'] = categoryIndex;
      if (bidIncrement != null) updateData['bidIncrement'] = bidIncrement;
      if (startTime != null) {
        updateData['startTime'] = Timestamp.fromDate(startTime);
      }
      if (category != null) updateData['category'] = category;
      if (endTime != null) updateData['endTime'] = Timestamp.fromDate(endTime);

      // If new images are provided, upload them and update the URLs
      if (images != null && images.isNotEmpty) {
        List<String> newImageUrls = await Future.wait(
            images.map((image) => _uploadImage(image)).toList());
        updateData['imagesUrl'] =
            newImageUrls; // You may need to handle old image URLs here if needed
      }

      await auctionDoc.update(updateData);
      showCustomSnackBarWidget(
          getTranslated('auction_updated_successfully', context), context,
          isError: false);
      notifyListeners();
    } catch (error) {
      showCustomSnackBarWidget(
        getTranslated('error_updating_auction', context),
        context,
        isError: true,
        sanckBarType: SnackBarType.warning,
      );
      throw Exception('Error updating auction: $error');
    }
  }

  Future<void> deleteAuction(String auctionId, BuildContext context) async {
    try {
      DocumentReference auctionDoc =
          _firestore.collection('MazzrattiAuctions').doc(auctionId);

      // Fetch the auction to get image URLs
      DocumentSnapshot auctionSnapshot = await auctionDoc.get();
      if (auctionSnapshot.exists) {
        Map<String, dynamic>? auctionData =
            auctionSnapshot.data() as Map<String, dynamic>?;
        List<dynamic>? imageUrlsDynamic =
            auctionData?['imagesUrl'] as List<dynamic>?;

        // Convert List<dynamic> to List<String> if needed
        List<String> imageUrls =
            imageUrlsDynamic?.map((e) => e.toString()).toList() ?? [];

        // Delete images from Firebase Storage
        for (String url in imageUrls) {
          try {
            Reference imageRef = _storage.refFromURL(url);
            await imageRef.delete();
          } catch (e) {
            // Handle error if needed
            print('Error deleting image $url: $e');
          }
        }
      }

      // Delete the auction document
      await auctionDoc.delete();
      showCustomSnackBarWidget(
          getTranslated('auction_deleted_successfully', context), context,
          isError: false);

      notifyListeners();
    } catch (error) {
      showCustomSnackBarWidget(
          getTranslated('error_deleting_auction', context), context,
          sanckBarType: SnackBarType.warning, isError: true);
      throw Exception('Error deleting auction: $error');
    }
  }

  Stream<List<Bid>> getBidsStream(BuildContext context, String auctionId) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      // Stream to get the auction document with a specific ID
      return auctions.doc(auctionId).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          final auction =
              Auction.fromFirestore(docSnapshot.data() as Map<String, dynamic>);
          return auction.bids; // Return the list of bids from the auction
        } else {
          return []; // Return an empty list if the document doesn't exist
        }
      });
    } catch (error) {
      log("Error getting bids for auction: $error");
      throw Exception('Error fetching bids for auction: $error');
    }
  }

  // Future<List<Auction>> getAllAuctions(BuildContext context) async {
  //   try {
  //     CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
  //     ProfileInfoModel? user =
  //         Provider.of<ProfileController>(context, listen: false).userInfoModel;

  //     if (user == null) {
  //       throw Exception('User not found');
  //     }

  //     // Query to get auctions where ownerId equals user's ID
  //     QuerySnapshot querySnapshot =
  //         await auctions.where('ownerId', isEqualTo: user.id).get();

  //     List<Auction> auctionList = querySnapshot.docs
  //         .map((doc) =>
  //             Auction.fromFirestore(doc.data() as Map<String, dynamic>))
  //         .toList();

  //     return auctionList;
  //   } catch (error) {
  //     log("Error in getting all auctions: $error");
  //     throw Exception('Error fetching auctions: $error');
  //   }
  // }
  Stream<List<Auction>> getAllActiveAuctionsStream(
      BuildContext context, String status) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
      ProfileInfoModel? user =
          Provider.of<ProfileController>(context, listen: false).userInfoModel;

      if (user == null) {
        throw Exception('User not found');
      }

      // Stream to get auctions where ownerId equals user's ID
      return auctions
          .where('ownerId', isEqualTo: user.id)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) {
              Auction auction =
                  Auction.fromFirestore(doc.data() as Map<String, dynamic>);
              auction.auctionStatus = auction.calculateAuctionState();
              return auction;
            })
            .where((auction) =>
                auction.auctionStatus == status) // Filter by auctionStatus
            .toList();
      });
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }

  Stream<List<Auction>> getAllEndedAuctionsStream(
      BuildContext context, String status) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
      ProfileInfoModel? user =
          Provider.of<ProfileController>(context, listen: false).userInfoModel;

      if (user == null) {
        throw Exception('User not found');
      }

      // Stream to get auctions where ownerId equals user's ID
      return auctions
          .where('ownerId', isEqualTo: user.id)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) {
                Auction auction =
                    Auction.fromFirestore(doc.data() as Map<String, dynamic>);
                auction.auctionStatus = auction.calculateAuctionState();
                return auction;
              })
              .where((auction) => auction.auctionStatus == status)
              .toList());
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }

  Stream<List<Auction>> getAllUpcomingAuctionsStream(
      BuildContext context, String status) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
      ProfileInfoModel? user =
          Provider.of<ProfileController>(context, listen: false).userInfoModel;

      if (user == null) {
        throw Exception('User not found');
      }

      // Stream to get auctions where ownerId equals user's ID
      return auctions
          .where('ownerId', isEqualTo: user.id)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) {
                Auction auction =
                    Auction.fromFirestore(doc.data() as Map<String, dynamic>);
                auction.auctionStatus = auction.calculateAuctionState();
                return auction;
              })
              .where((auction) => auction.auctionStatus == status)
              .toList());
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }
  // Stream<List<Auction>> getAllAuctionsStream(BuildContext context) {
  //   try {
  //     CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
  //     ProfileInfoModel? user =
  //         Provider.of<ProfileController>(context, listen: false).userInfoModel;

  //     if (user == null) {
  //       throw Exception('User not found');
  //     }

  //     // Stream to get auctions where ownerId equals user's ID, ordered by createdAt field in descending order
  //     return auctions
  //         .where('ownerId', isEqualTo: user.id)
  //         .orderBy('startTime',
  //             descending:
  //                 true) // Order by 'createdAt' field in descending order
  //         .snapshots()
  //         .map((querySnapshot) => querySnapshot.docs.map((doc) {
  //               Auction auction =
  //                   Auction.fromFirestore(doc.data() as Map<String, dynamic>);
  //               auction.auctionStatus = auction.calculateAuctionState();
  //               return auction;
  //             }).toList());
  //   } catch (error) {
  //     log("Error in getting all auctions: $error");
  //     throw Exception('Error fetching auctions: $error');
  //   }
  // }
}
