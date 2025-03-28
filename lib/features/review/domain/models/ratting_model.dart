import 'package:mazzraati_vendor_app/features/review/domain/models/review_model.dart';

class RattingModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<ReviewModel>? reviews;

  RattingModel({this.totalSize, this.limit, this.offset, this.reviews});

  RattingModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['reviews'] != null) {
      reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Reviews {
//   int? id;
//   int? productId;
//   int? customerId;
//   String? comment;
//   List<String>? attachment;
//   double? rating;
//   int? status;
//   bool? isSaved;
//   String? createdAt;
//   String? updatedAt;
//   Product? product;
//   Customer? customer;
//   List<ImageFullUrl>? attachmentFullUrl;
//   Reply? reply;
//
//   Reviews(
//       {this.id,
//         this.productId,
//         this.customerId,
//         this.comment,
//         this.attachment,
//         this.rating,
//         this.status,
//         this.isSaved,
//         this.createdAt,
//         this.updatedAt,
//         this.product,
//         this.customer,
//         this.attachmentFullUrl,
//         this.reply,
//       });
//
//   Reviews.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     customerId = json['customer_id'];
//     comment = json['comment'];
//     if(json['attachment'] != null && json['attachment'] is List){
//       attachment = json['attachment'].cast<String>();
//     }
//     rating = json['rating'].toDouble();
//     status = json['status']??false;
//     isSaved = json['is_saved']??false;
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     product =
//     json['product'] != null ? Product.fromJson(json['product']) : null;
//     customer = json['customer'] != null
//         ? Customer.fromJson(json['customer'])
//         : null;
//     if (json['attachment_full_url'] != null) {
//       attachmentFullUrl = <ImageFullUrl>[];
//       json['attachment_full_url'].forEach((v) {
//         attachmentFullUrl!.add(ImageFullUrl.fromJson(v));
//       });
//     }
//     reply = json['reply'] != null ?  Reply.fromJson(json['reply']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['customer_id'] = customerId;
//     data['comment'] = comment;
//     data['attachment'] = attachment;
//     data['rating'] = rating;
//     data['status'] = status;
//     data['is_saved'] = isSaved;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (product != null) {
//       data['product'] = product!.toJson();
//     }
//     if (customer != null) {
//       data['customer'] = customer!.toJson();
//     }
//     if (reply != null) {
//       data['reply'] = reply!.toJson();
//     }
//     return data;
//   }
// }

//
// class Reply {
//   int? id;
//   int? reviewId;
//   String? addedBy;
//   String? replyText;
//   String? createdAt;
//   String? updatedAt;
//
//   Reply(
//       {this.id,
//         this.reviewId,
//         this.addedBy,
//         this.replyText,
//         this.createdAt,
//         this.updatedAt});
//
//   Reply.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     reviewId = json['review_id'];
//     addedBy = json['added_by'];
//     replyText = json['reply_text'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['review_id'] = this.reviewId;
//     data['added_by'] = this.addedBy;
//     data['reply_text'] = this.replyText;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

