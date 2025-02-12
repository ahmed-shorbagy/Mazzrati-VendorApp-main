// // class SuggestedProduct {
// //   final int id;
// //   final String addedBy;
// //   final int userId;
// //   final String name;
// //   final String slug;
// //   final String productType;
// //   final String categoryIds;
// //   final int categoryId;
// //   final int? subCategoryId;
// //   final int? subSubCategoryId;
// //   final int brandId;
// //   final String unit;
// //   final int minQty;
// //   final int refundable;
// //   final String? digitalProductType;
// //   final String digitalFileReady;
// //   final String? digitalFileReadyStorageType;
// //   final String images;
// //   final String colorImage;
// //   final String thumbnail;
// //   final String thumbnailStorageType;
// //   final int? featured;
// //   final int? flashDeal;
// //   final String videoProvider;
// //   final String? videoUrl;
// //   final String colors;
// //   final int variantProduct;
// //   final String attributes;
// //   final String choiceOptions;
// //   final String variation;
// //   final List<dynamic> digitalProductFileTypes;
// //   final List<dynamic> digitalProductExtensions;
// //   final int published;
// //   final double unitPrice;
// //   final double purchasePrice;
// //   final double tax;
// //   final String taxType;
// //   final String taxModel;
// //   final double discount;
// //   final String discountType;
// //   final int currentStock;
// //   final int minimumOrderQty;
// //   final String details;
// //   final int freeShipping;
// //   final String? attachment;
// //   final DateTime createdAt;
// //   final DateTime updatedAt;
// //   final int status;
// //   final int featuredStatus;
// //   final String? metaTitle;
// //   final String? metaDescription;
// //   final String? metaImage;
// //   final int requestStatus;
// //   final String? deniedNote;
// //   final double shippingCost;
// //   final int multiplyQty;
// //   final double? tempShippingCost;
// //   final int? isShippingCostUpdated;
// //   final String code;
// //   final String productPurpose;
// //   final int isShopTemporaryClose;
// //   final ThumbnailFullUrl thumbnailFullUrl;
// //   final List<ColorImageFullUrl> colorImagesFullUrl;
// //   final MetaImageFullUrl metaImageFullUrl;
// //   final List<ImageFullUrl> imagesFullUrl;
// //   final DigitalFileReadyFullUrl digitalFileReadyFullUrl;
// //   final List<dynamic> translations;
// //   final List<dynamic> reviews;

// //   SuggestedProduct({
// //     required this.id,
// //     required this.addedBy,
// //     required this.userId,
// //     required this.name,
// //     required this.slug,
// //     required this.productType,
// //     required this.categoryIds,
// //     required this.categoryId,
// //     this.subCategoryId,
// //     this.subSubCategoryId,
// //     required this.brandId,
// //     required this.unit,
// //     required this.minQty,
// //     required this.refundable,
// //     this.digitalProductType,
// //     required this.digitalFileReady,
// //     this.digitalFileReadyStorageType,
// //     required this.images,
// //     required this.colorImage,
// //     required this.thumbnail,
// //     required this.thumbnailStorageType,
// //     this.featured,
// //     this.flashDeal,
// //     required this.videoProvider,
// //     this.videoUrl,
// //     required this.colors,
// //     required this.variantProduct,
// //     required this.attributes,
// //     required this.choiceOptions,
// //     required this.variation,
// //     required this.digitalProductFileTypes,
// //     required this.digitalProductExtensions,
// //     required this.published,
// //     required this.unitPrice,
// //     required this.purchasePrice,
// //     required this.tax,
// //     required this.taxType,
// //     required this.taxModel,
// //     required this.discount,
// //     required this.discountType,
// //     required this.currentStock,
// //     required this.minimumOrderQty,
// //     required this.details,
// //     required this.freeShipping,
// //     this.attachment,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     required this.status,
// //     required this.featuredStatus,
// //     this.metaTitle,
// //     this.metaDescription,
// //     this.metaImage,
// //     required this.requestStatus,
// //     this.deniedNote,
// //     required this.shippingCost,
// //     required this.multiplyQty,
// //     this.tempShippingCost,
// //     this.isShippingCostUpdated,
// //     required this.code,
// //     required this.productPurpose,
// //     required this.isShopTemporaryClose,
// //     required this.thumbnailFullUrl,
// //     required this.colorImagesFullUrl,
// //     required this.metaImageFullUrl,
// //     required this.imagesFullUrl,
// //     required this.digitalFileReadyFullUrl,
// //     required this.translations,
// //     required this.reviews,
// //   });

// //   factory SuggestedProduct.fromJson(Map<String, dynamic> json) {
// //     return SuggestedProduct(
// //       id: json['id'],
// //       addedBy: json['added_by'],
// //       userId: json['user_id'],
// //       name: json['name'],
// //       slug: json['slug'],
// //       productType: json['product_type'],
// //       categoryIds: json['category_ids'],
// //       categoryId: json['category_id'],
// //       subCategoryId: json['sub_category_id'],
// //       subSubCategoryId: json['sub_sub_category_id'],
// //       brandId: json['brand_id'],
// //       unit: json['unit'],
// //       minQty: json['min_qty'],
// //       refundable: json['refundable'],
// //       digitalProductType: json['digital_product_type'],
// //       digitalFileReady: json['digital_file_ready'],
// //       digitalFileReadyStorageType: json['digital_file_ready_storage_type'],
// //       images: json['images'],
// //       colorImage: json['color_image'],
// //       thumbnail: json['thumbnail'],
// //       thumbnailStorageType: json['thumbnail_storage_type'],
// //       featured: json['featured'],
// //       flashDeal: json['flash_deal'],
// //       videoProvider: json['video_provider'],
// //       videoUrl: json['video_url'],
// //       colors: json['colors'],
// //       variantProduct: json['variant_product'],
// //       attributes: json['attributes'],
// //       choiceOptions: json['choice_options'],
// //       variation: json['variation'],
// //       digitalProductFileTypes:
// //           List<dynamic>.from(json['digital_product_file_types']),
// //       digitalProductExtensions:
// //           List<dynamic>.from(json['digital_product_extensions']),
// //       published: json['published'],
// //       unitPrice: json['unit_price'].toDouble(),
// //       purchasePrice: json['purchase_price'].toDouble(),
// //       tax: json['tax'].toDouble(),
// //       taxType: json['tax_type'],
// //       taxModel: json['tax_model'],
// //       discount: json['discount'].toDouble(),
// //       discountType: json['discount_type'],
// //       currentStock: json['current_stock'],
// //       minimumOrderQty: json['minimum_order_qty'],
// //       details: json['details'],
// //       freeShipping: json['free_shipping'],
// //       attachment: json['attachment'],
// //       createdAt: DateTime.parse(json['created_at']),
// //       updatedAt: DateTime.parse(json['updated_at']),
// //       status: json['status'],
// //       featuredStatus: json['featured_status'],
// //       metaTitle: json['meta_title'],
// //       metaDescription: json['meta_description'],
// //       metaImage: json['meta_image'],
// //       requestStatus: json['request_status'],
// //       deniedNote: json['denied_note'],
// //       shippingCost: json['shipping_cost'].toDouble(),
// //       multiplyQty: json['multiply_qty'],
// //       tempShippingCost: json['temp_shipping_cost'],
// //       isShippingCostUpdated: json['is_shipping_cost_updated'],
// //       code: json['code'],
// //       productPurpose: json['product_purpose'],
// //       isShopTemporaryClose: json['is_shop_temporary_close'],
// //       thumbnailFullUrl: ThumbnailFullUrl.fromJson(json['thumbnail_full_url']),
// //       colorImagesFullUrl: List<ColorImageFullUrl>.from(
// //           json['color_images_full_url']
// //               .map((x) => ColorImageFullUrl.fromJson(x))),
// //       metaImageFullUrl: MetaImageFullUrl.fromJson(json['meta_image_full_url']),
// //       imagesFullUrl: List<ImageFullUrl>.from(
// //           json['images_full_url'].map((x) => ImageFullUrl.fromJson(x))),
// //       digitalFileReadyFullUrl:
// //           DigitalFileReadyFullUrl.fromJson(json['digital_file_ready_full_url']),
// //       translations: List<dynamic>.from(json['translations']),
// //       reviews: List<dynamic>.from(json['reviews']),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'added_by': addedBy,
// //       'user_id': userId,
// //       'name': name,
// //       'slug': slug,
// //       'product_type': productType,
// //       'category_ids': categoryIds,
// //       'category_id': categoryId,
// //       'sub_category_id': subCategoryId,
// //       'sub_sub_category_id': subSubCategoryId,
// //       'brand_id': brandId,
// //       'unit': unit,
// //       'min_qty': minQty,
// //       'refundable': refundable,
// //       'digital_product_type': digitalProductType,
// //       'digital_file_ready': digitalFileReady,
// //       'digital_file_ready_storage_type': digitalFileReadyStorageType,
// //       'images': images,
// //       'color_image': colorImage,
// //       'thumbnail': thumbnail,
// //       'thumbnail_storage_type': thumbnailStorageType,
// //       'featured': featured,
// //       'flash_deal': flashDeal,
// //       'video_provider': videoProvider,
// //       'video_url': videoUrl,
// //       'colors': colors,
// //       'variant_product': variantProduct,
// //       'attributes': attributes,
// //       'choice_options': choiceOptions,
// //       'variation': variation,
// //       'digital_product_file_types': digitalProductFileTypes,
// //       'digital_product_extensions': digitalProductExtensions,
// //       'published': published,
// //       'unit_price': unitPrice,
// //       'purchase_price': purchasePrice,
// //       'tax': tax,
// //       'tax_type': taxType,
// //       'tax_model': taxModel,
// //       'discount': discount,
// //       'discount_type': discountType,
// //       'current_stock': currentStock,
// //       'minimum_order_qty': minimumOrderQty,
// //       'details': details,
// //       'free_shipping': freeShipping,
// //       'attachment': attachment,
// //       'created_at': createdAt.toIso8601String(),
// //       'updated_at': updatedAt.toIso8601String(),
// //       'status': status,
// //       'featured_status': featuredStatus,
// //       'meta_title': metaTitle,
// //       'meta_description': metaDescription,
// //       'meta_image': metaImage,
// //       'request_status': requestStatus,
// //       'denied_note': deniedNote,
// //       'shipping_cost': shippingCost,
// //       'multiply_qty': multiplyQty,
// //       'temp_shipping_cost': tempShippingCost,
// //       'is_shipping_cost_updated': isShippingCostUpdated,
// //       'code': code,
// //       'product_purpose': productPurpose,
// //       'is_shop_temporary_close': isShopTemporaryClose,
// //       'thumbnail_full_url': thumbnailFullUrl.toJson(),
// //       'color_images_full_url':
// //           List<dynamic>.from(colorImagesFullUrl.map((x) => x.toJson())),
// //       'meta_image_full_url': metaImageFullUrl.toJson(),
// //       'images_full_url':
// //           List<dynamic>.from(imagesFullUrl.map((x) => x.toJson())),
// //       'digital_file_ready_full_url': digitalFileReadyFullUrl.toJson(),
// //       'translations': translations,
// //       'reviews': reviews,
// //     };
// //   }
// // }

// // class ThumbnailFullUrl {
// //   final String key;
// //   final String path;
// //   final int status;

// //   ThumbnailFullUrl({
// //     required this.key,
// //     required this.path,
// //     required this.status,
// //   });

// //   factory ThumbnailFullUrl.fromJson(Map<String, dynamic> json) {
// //     return ThumbnailFullUrl(
// //       key: json['key'],
// //       path: json['path'],
// //       status: json['status'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'key': key,
// //       'path': path,
// //       'status': status,
// //     };
// //   }
// // }

// // class ColorImageFullUrl {
// //   final String key;
// //   final String path;
// //   final int status;

// //   ColorImageFullUrl({
// //     required this.key,
// //     required this.path,
// //     required this.status,
// //   });

// //   factory ColorImageFullUrl.fromJson(Map<String, dynamic> json) {
// //     return ColorImageFullUrl(
// //       key: json['key'],
// //       path: json['path'],
// //       status: json['status'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'key': key,
// //       'path': path,
// //       'status': status,
// //     };
// //   }
// // }

// // class MetaImageFullUrl {
// //   final String? key;
// //   final String? path;
// //   final int status;

// //   MetaImageFullUrl({
// //     required this.key,
// //     required this.path,
// //     required this.status,
// //   });

// //   factory MetaImageFullUrl.fromJson(Map<String, dynamic> json) {
// //     return MetaImageFullUrl(
// //       key: json['key'],
// //       path: json['path'],
// //       status: json['status'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'key': key,
// //       'path': path,
// //       'status': status,
// //     };
// //   }
// // }

// // class ImageFullUrl {
// //   final String key;
// //   final String path;
// //   final int status;

// //   ImageFullUrl({
// //     required this.key,
// //     required this.path,
// //     required this.status,
// //   });

// //   factory ImageFullUrl.fromJson(Map<String, dynamic> json) {
// //     return ImageFullUrl(
// //       key: json['key'],
// //       path: json['path'],
// //       status: json['status'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'key': key,
// //       'path': path,
// //       'status': status,
// //     };
// //   }
// // }

// // class DigitalFileReadyFullUrl {
// //   final String key;
// //   final String? path;
// //   final int status;

// //   DigitalFileReadyFullUrl({
// //     required this.key,
// //     required this.path,
// //     required this.status,
// //   });

// //   factory DigitalFileReadyFullUrl.fromJson(Map<String, dynamic> json) {
// //     return DigitalFileReadyFullUrl(
// //       key: json['key'],
// //       path: json['path'],
// //       status: json['status'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'key': key,
// //       'path': path,
// //       'status': status,
// //     };
// //   }
// // }

// import 'package:mazzraati_vendor_app/data/model/image_full_url.dart';

// class SuggestedProduct {
//   int? id;
//   String? addedBy;
//   int? userId;
//   String? name;
//   String? slug;
//   String? productType;
//   String? code;
//   int? brandId;
//   List<CategoryIds>? categoryIds;
//   String? unit;
//   List<String?>? images;
//   List<ImageFullUrl>? imagesFullUrl;
//   String? thumbnail;
//   ImageFullUrl? thumbnailFullUrl;
//   List<ProductColors>? colors;
//   List<int?>? attributes;
//   List<ChoiceOptions>? choiceOptions;
//   List<Variation>? variation;
//   List<String>? digitalProductFileTypes;
//   Map<String, dynamic>? digitalProductExtensions;
//   double? unitPrice;
//   double? purchasePrice;
//   double? tax;
//   String? taxModel;
//   int? minQty;
//   String? taxType;
//   double? discount;
//   String? discountType;
//   int? currentStock;
//   String? details;
//   String? createdAt;
//   String? updatedAt;
//   int? status;
//   int? requestStatus;
//   List<Rating>? rating;
//   String? metaTitle;
//   String? metaDescription;
//   String? metaImage;
//   double? shippingCost;
//   int? multiplyWithQuantity;
//   int? minimumOrderQty;
//   String? digitalProductType;
//   String? digitalFileReady;
//   int? reviewsCount;
//   String? averageReview;
//   List<Reviews>? reviews;
//   String? deniedNote;
//   List<Tags>? tags;
//   MetaSeoInfo? metaSeoInfo;
//   List<DigitalVariation>? digitalVariation;
//   ImageFullUrl? metaImageFullUrl;

//   SuggestedProduct(
//       {this.id,
//       this.addedBy,
//       this.userId,
//       this.name,
//       this.slug,
//       this.productType,
//       this.code,
//       this.brandId,
//       this.categoryIds,
//       this.unit,
//       this.minQty,
//       this.images,
//       this.imagesFullUrl,
//       this.thumbnail,
//       this.thumbnailFullUrl,
//       this.metaImageFullUrl,
//       this.colors,
//       String? variantProduct,
//       this.attributes,
//       this.choiceOptions,
//       this.variation,
//       this.digitalProductFileTypes,
//       this.digitalProductExtensions,
//       this.unitPrice,
//       this.purchasePrice,
//       this.tax,
//       this.taxModel,
//       this.taxType,
//       this.discount,
//       this.discountType,
//       this.currentStock,
//       this.details,
//       String? attachment,
//       this.createdAt,
//       this.updatedAt,
//       this.status,
//       this.requestStatus,
//       int? featuredStatus,
//       this.rating,
//       this.metaTitle,
//       this.metaDescription,
//       this.metaImage,
//       this.shippingCost,
//       this.multiplyWithQuantity,
//       this.minimumOrderQty,
//       String? digitalProductType,
//       String? digitalFileReady,
//       int? reviewsCount,
//       String? averageReview,
//       List<Reviews>? reviews,
//       String? deniedNote,
//       List<Tags>? tags,
//       this.metaSeoInfo,
//       this.digitalVariation}) {
//     if (digitalProductType != null) {
//       this.digitalProductType = digitalProductType;
//     }
//     if (digitalFileReady != null) {
//       this.digitalFileReady = digitalFileReady;
//     }
//     if (reviewsCount != null) {
//       this.reviewsCount = reviewsCount;
//     }
//     if (averageReview != null) {
//       this.averageReview = averageReview;
//     }
//     if (reviews != null) {
//       this.reviews = reviews;
//     }
//     if (deniedNote != null) {
//       this.deniedNote = deniedNote;
//     }
//     if (tags != null) {
//       this.tags = tags;
//     }
//   }

//   SuggestedProduct.fromJson(Map<String, dynamic> json,
//       {bool fromGetProducts = false}) {
//     id = json['id'];
//     addedBy = json['added_by'];
//     userId = json['user_id'];
//     name = json['name'];
//     slug = json['slug'];
//     productType = json['product_type'];
//     code = json['code'];
//     brandId = json['brand_id'];
//     if (json['category_ids'] != null && json['category_ids'] is! String) {
//       categoryIds = [];
//       json['category_ids'].forEach((v) {
//         categoryIds!.add(CategoryIds.fromJson(v));
//       });
//     }
//     unit = json['unit'];
//     minQty = json['min_qty'];
//     if (json['images'] != null &&
//         json['category_ids'] is! String &&
//         json['images'] is List) {
//       images = json['images'] != null ? json['images'].cast<String>() : [];
//     }

//     thumbnail = json['thumbnail'];
//     if (json['colors_formatted'] != null && json['category_ids'] is! String) {
//       colors = [];
//       json['colors_formatted'].forEach((v) {
//         colors!.add(ProductColors.fromJson(v));
//       });
//     }
//     if (json['attributes'] != null && json['category_ids'] is! String) {
//       attributes = [];
//       for (int index = 0; index < json['attributes'].length; index++) {
//         attributes!.add(int.parse(json['attributes'][index].toString()));
//       }
//     }
//     if (json['choice_options'] != null && json['category_ids'] is! String) {
//       choiceOptions = [];
//       json['choice_options'].forEach((v) {
//         choiceOptions!.add(ChoiceOptions.fromJson(v));
//       });
//     }
//     if (json['variation'] != null && json['category_ids'] is! String) {
//       variation = [];
//       json['variation'].forEach((v) {
//         variation!.add(Variation.fromJson(v));
//       });
//     }
//     if (json['digital_product_file_types'] != null) {
//       digitalProductFileTypes =
//           json['digital_product_file_types'].cast<String>();
//     } else {
//       digitalProductFileTypes = [];
//     }

//     if (json['digital_product_extensions'] != null &&
//         json['digital_product_extensions'] is! List) {
//       digitalProductExtensions =
//           (json['digital_product_extensions'] as Map<String, dynamic>).map(
//         (key, value) => MapEntry(key, List<String>.from(value)),
//       );
//     }
//     unitPrice = json['unit_price'].toDouble();
//     purchasePrice = json['purchase_price'].toDouble();
//     tax = json['tax'].toDouble();
//     taxModel = json['tax_model'];
//     taxType = json['tax_type'];
//     discount = json['discount'].toDouble();
//     discountType = json['discount_type'];
//     currentStock = json['current_stock'];
//     details = json['details'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     status = json['status'];
//     if (json['request_status'] != null) {
//       try {
//         requestStatus = json['request_status'];
//       } catch (e) {
//         requestStatus = int.parse(json['request_status']);
//       }
//     }
//     deniedNote = json['denied_note'];

//     if (json['rating'] != null) {
//       rating = [];
//       json['rating'].forEach((v) {
//         rating!.add(Rating.fromJson(v));
//       });
//     }
//     metaTitle = json['meta_title'];
//     metaDescription = json['meta_description'];
//     metaImage = json['meta_image'];
//     if (json['shipping_cost'] != null) {
//       shippingCost = json['shipping_cost'].toDouble();
//     }
//     if (json['multiply_qty'] != null) {
//       multiplyWithQuantity = json['multiply_qty'];
//     }
//     if (json['minimum_order_qty'] != null) {
//       try {
//         minimumOrderQty = json['minimum_order_qty'];
//       } catch (e) {
//         minimumOrderQty = int.parse(json['minimum_order_qty'].toString());
//       }
//     }
//     if (json['digital_product_type'] != null) {
//       digitalProductType = json['digital_product_type'];
//     }
//     if (json['digital_file_ready'] != null) {
//       digitalFileReady = json['digital_file_ready'];
//     }
//     if (json['reviews_count'] != null) {
//       reviewsCount = int.parse(json['reviews_count'].toString());
//     } else {
//       reviewsCount = 0;
//     }

//     averageReview = json['average_review'].toString();
//     if (json['reviews'] != null) {
//       reviews = <Reviews>[];
//       json['reviews'].forEach((v) {
//         reviews!.add(Reviews.fromJson(v));
//       });
//     }
//     if (json['tags'] != null) {
//       tags = <Tags>[];
//       json['tags'].forEach((v) {
//         tags!.add(Tags.fromJson(v));
//       });
//     }
//     metaSeoInfo = json['seo_info'] != null
//         ? MetaSeoInfo.fromJson(json['seo_info'],
//             fromGetProducts: fromGetProducts)
//         : null;

//     thumbnailFullUrl = json['thumbnail_full_url'] != null
//         ? ImageFullUrl.fromJson(json['thumbnail_full_url'])
//         : null;
//     metaImageFullUrl = json['meta_image_full_url'] != null
//         ? ImageFullUrl.fromJson(json['meta_image_full_url'])
//         : null;

//     if (json['images_full_url'] != null) {
//       imagesFullUrl = <ImageFullUrl>[];
//       json['images_full_url'].forEach((v) {
//         imagesFullUrl!.add(ImageFullUrl.fromJson(v));
//       });
//     }

//     if (json['digital_variation'] != null) {
//       digitalVariation = <DigitalVariation>[];
//       json['digital_variation'].forEach((v) {
//         digitalVariation!.add(DigitalVariation.fromJson(v));
//       });
//     } else {
//       digitalVariation = [];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['added_by'] = addedBy;
//     data['user_id'] = userId;
//     data['name'] = name;
//     data['slug'] = slug;
//     data['product_type'] = productType;
//     data['code'] = code;
//     data['brand_id'] = brandId;
//     if (categoryIds != null) {
//       data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
//     }
//     data['unit'] = unit;
//     data['min_qty'] = minQty;
//     data['images'] = images;
//     data['thumbnail'] = thumbnail;
//     if (colors != null) {
//       data['colors_formatted'] = colors!.map((v) => v.toJson()).toList();
//     }
//     data['attributes'] = attributes;
//     if (choiceOptions != null) {
//       data['choice_options'] = choiceOptions!.map((v) => v.toJson()).toList();
//     }
//     if (variation != null) {
//       data['variation'] = variation!.map((v) => v.toJson()).toList();
//     }
//     data['unit_price'] = unitPrice;
//     data['purchase_price'] = purchasePrice;
//     data['tax'] = tax;
//     data['tax_model'] = taxModel;
//     data['tax_type'] = taxType;
//     data['discount'] = discount;
//     data['discount_type'] = discountType;
//     data['current_stock'] = currentStock;
//     data['details'] = details;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['status'] = status;
//     data['denied_note'] = deniedNote;
//     data['request_status'] = requestStatus;
//     if (rating != null) {
//       data['rating'] = rating!.map((v) => v.toJson()).toList();
//     }
//     data['meta_title'] = metaTitle;
//     data['meta_description'] = metaDescription;
//     data['meta_image'] = metaImage;
//     data['shipping_cost'] = shippingCost;
//     data['multiply_qty'] = multiplyWithQuantity;
//     data['minimum_order_qty'] = minimumOrderQty;
//     data['digital_product_type'] = digitalProductType;
//     data['digital_file_ready'] = digitalFileReady;
//     data['reviews_count'] = reviewsCount;
//     data['average_review'] = averageReview;
//     if (reviews != null) {
//       data['reviews'] = reviews!.map((v) => v.toJson()).toList();
//     }
//     if (tags != null) {
//       data['tags'] = tags!.map((v) => v.toJson()).toList();
//     }
//     if (metaSeoInfo != null) {
//       data['seo_info'] = metaSeoInfo!.toJson();
//     }
//     return data;
//   }
// }

// class DigitalVariation {
//   int? id;
//   int? productId;
//   String? variantKey;
//   String? sku;
//   int? price;
//   String? file;
//   String? createdAt;
//   String? updatedAt;

//   DigitalVariation(
//       {this.id,
//       this.productId,
//       this.variantKey,
//       this.sku,
//       this.price,
//       this.file,
//       this.createdAt,
//       this.updatedAt});

//   DigitalVariation.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     variantKey = json['variant_key'];
//     sku = json['sku'];
//     price = json['price'];
//     file = json['file'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['variant_key'] = variantKey;
//     data['sku'] = sku;
//     data['price'] = price;
//     data['file'] = file;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }

// class CategoryIds {
//   String? id;
//   int? position;

//   CategoryIds({this.id, this.position});

//   CategoryIds.fromJson(Map<String, dynamic> json) {
//     id = json['id'].toString();
//     position = json['position'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['position'] = position;
//     return data;
//   }
// }

// class ProductColors {
//   String? _name;
//   String? _code;

//   ProductColors({String? name, String? code}) {
//     _name = name;
//     _code = code;
//   }

//   String? get name => _name;
//   String? get code => _code;

//   ProductColors.fromJson(Map<String, dynamic> json) {
//     _name = json['name'];
//     _code = json['code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = _name;
//     data['code'] = _code;
//     return data;
//   }
// }

// class ChoiceOptions {
//   String? _name;
//   String? _title;
//   List<String>? _options;

//   ChoiceOptions({String? name, String? title, List<String>? options}) {
//     _name = name;
//     _title = title;
//     _options = options;
//   }

//   String? get name => _name;
//   String? get title => _title;
//   List<String>? get options => _options;

//   ChoiceOptions.fromJson(Map<String, dynamic> json) {
//     _name = json['name'];
//     _title = json['title'];
//     _options = json['options'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = _name;
//     data['title'] = _title;
//     data['options'] = _options;
//     return data;
//   }
// }

// class Variation {
//   String? _type;
//   double? _price;
//   String? _sku;
//   int? _qty;

//   Variation({String? type, double? price, String? sku, int? qty}) {
//     _type = type;
//     _price = price;
//     _sku = sku;
//     _qty = qty;
//   }

//   String? get type => _type;
//   double? get price => _price;
//   String? get sku => _sku;
//   int? get qty => _qty;

//   Variation.fromJson(Map<String, dynamic> json) {
//     _type = json['type'];
//     _price = json['price'].toDouble();
//     _sku = json['sku'];
//     _qty = json['qty'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = _type;
//     data['price'] = _price;
//     data['sku'] = _sku;
//     data['qty'] = _qty;
//     return data;
//   }
// }

// class Rating {
//   String? _average;
//   int? _productId;

//   Rating({String? average, int? productId}) {
//     _average = average;
//     _productId = productId;
//   }

//   String? get average => _average;
//   int? get productId => _productId;

//   Rating.fromJson(Map<String, dynamic> json) {
//     _average = json['average'].toString();
//     _productId = json['product_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['average'] = _average;
//     data['product_id'] = _productId;
//     return data;
//   }
// }

// class Reviews {
//   int? _id;
//   int? _productId;
//   int? _customerId;
//   String? _comment;
//   String? _attachment;
//   int? _rating;
//   int? _status;
//   String? _createdAt;
//   String? _updatedAt;
//   Customer? _customer;
//   List<ImageFullUrl>? _attachmentFullUrl;

//   Reviews(
//       {int? id,
//       int? productId,
//       int? customerId,
//       String? comment,
//       String? attachment,
//       int? rating,
//       int? status,
//       String? createdAt,
//       String? updatedAt,
//       Customer? customer,
//       List<ImageFullUrl>? attachmentFullUrl}) {
//     if (id != null) {
//       _id = id;
//     }
//     if (productId != null) {
//       _productId = productId;
//     }
//     if (customerId != null) {
//       _customerId = customerId;
//     }
//     if (comment != null) {
//       _comment = comment;
//     }
//     if (attachment != null) {
//       _attachment = attachment;
//     }
//     if (rating != null) {
//       _rating = rating;
//     }
//     if (status != null) {
//       _status = status;
//     }
//     if (createdAt != null) {
//       _createdAt = createdAt;
//     }
//     if (updatedAt != null) {
//       _updatedAt = updatedAt;
//     }
//     if (customer != null) {
//       _customer = customer;
//     }
//     if (attachmentFullUrl != null) {
//       _attachmentFullUrl = attachmentFullUrl;
//     }
//   }

//   int? get id => _id;
//   int? get productId => _productId;
//   int? get customerId => _customerId;
//   String? get comment => _comment;
//   String? get attachment => _attachment;
//   int? get rating => _rating;
//   int? get status => _status;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   Customer? get customer => _customer;
//   List<ImageFullUrl>? get attachmentFullUrl => _attachmentFullUrl;

//   Reviews.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _productId = json['product_id'];
//     _customerId = json['customer_id'];
//     _comment = json['comment'];
//     if (json['attachment'] is String) {
//       _attachment = json['attachment'];
//     }
//     _rating = json['rating'];
//     _status = json['status'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _customer =
//         json['customer'] != null ? Customer.fromJson(json['customer']) : null;
//     if (json['attachment_images_full_url'] != null) {
//       _attachmentFullUrl = <ImageFullUrl>[];
//       json['attachment_images_full_url'].forEach((v) {
//         _attachmentFullUrl!.add(ImageFullUrl.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = _id;
//     data['product_id'] = _productId;
//     data['customer_id'] = _customerId;
//     data['comment'] = _comment;
//     data['attachment'] = _attachment;
//     data['rating'] = _rating;
//     data['status'] = _status;
//     data['created_at'] = _createdAt;
//     data['updated_at'] = _updatedAt;
//     if (_customer != null) {
//       data['customer'] = _customer!.toJson();
//     }
//     return data;
//   }
// }

// class Customer {
//   int? _id;
//   String? _fName;
//   String? _lName;
//   String? _phone;
//   String? _image;
//   String? _email;
//   ImageFullUrl? _imageFullUrl;

//   Customer({
//     int? id,
//     String? fName,
//     String? lName,
//     String? phone,
//     String? image,
//     String? email,
//     ImageFullUrl? imageFullUrl,
//   }) {
//     if (id != null) {
//       _id = id;
//     }
//     if (fName != null) {
//       _fName = fName;
//     }
//     if (lName != null) {
//       _lName = lName;
//     }
//     if (phone != null) {
//       _phone = phone;
//     }
//     if (image != null) {
//       _image = image;
//     }
//     if (email != null) {
//       _email = email;
//     }

//     if (imageFullUrl != null) {
//       _imageFullUrl = imageFullUrl;
//     }
//   }

//   int? get id => _id;
//   String? get fName => _fName;
//   String? get lName => _lName;
//   String? get phone => _phone;
//   String? get image => _image;
//   String? get email => _email;
//   ImageFullUrl? get imageFullUrl => _imageFullUrl;

//   Customer.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _fName = json['f_name'];
//     _lName = json['l_name'];
//     _phone = json['phone'];
//     _image = json['image'];
//     _email = json['email'];
//     _imageFullUrl = json['image_full_url'] != null
//         ? ImageFullUrl.fromJson(json['image_full_url'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = _id;
//     data['f_name'] = _fName;
//     data['l_name'] = _lName;
//     data['phone'] = _phone;
//     data['image'] = _image;
//     data['email'] = _email;

//     return data;
//   }
// }

// class Tags {
//   int? id;
//   String? tag;

//   Tags({this.id, this.tag});

//   Tags.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     tag = json['tag'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['tag'] = tag;
//     return data;
//   }
// }

// class MetaSeoInfo {
//   int? metaId;
//   int? metaProductId;
//   String? metaTitle;
//   String? metaDescription;
//   String? metaIndex;
//   String? metaNoFollow;
//   String? metaNoImageIndex;
//   String? metaNoArchive;
//   String? metaNoSnippet;
//   String? metaMaxSnippet;
//   String? metaMaxSnippetValue;
//   String? metaMaxVideoPreview;
//   String? metaMaxVideoPreviewValue;
//   String? metaMaxImagePreview;
//   String? metaMaxImagePreviewValue;
//   String? metaImage;
//   String? metaCreatedAt;
//   String? metaUpdatedAt;
//   ImageFullUrl? imageFullUrl;

//   MetaSeoInfo(
//       {this.metaId,
//       this.metaProductId,
//       this.metaTitle,
//       this.metaDescription,
//       this.metaIndex = 'noindex',
//       this.metaNoFollow = 'nonofollow',
//       this.metaNoImageIndex = '0',
//       this.metaNoArchive = '0',
//       this.metaNoSnippet = '0',
//       this.metaMaxSnippet = '0',
//       this.metaMaxSnippetValue,
//       this.metaMaxVideoPreview = '0',
//       this.metaMaxVideoPreviewValue,
//       this.metaMaxImagePreview = '0',
//       this.metaMaxImagePreviewValue,
//       this.metaImage,
//       this.metaCreatedAt,
//       this.metaUpdatedAt,
//       this.imageFullUrl});

//   MetaSeoInfo.fromJson(Map<String, dynamic> json,
//       {bool fromGetProducts = false}) {
//     metaTitle = fromGetProducts ? json['title'] : json['meta_title'];
//     metaDescription =
//         fromGetProducts ? json['description'] : json['meta_description'];
//     metaIndex = fromGetProducts ? json['index'] : json['meta_index'];
//     metaNoFollow = fromGetProducts ? json['no_follow'] : json['meta_no_follow'];
//     metaNoImageIndex =
//         fromGetProducts ? json['no_image_index'] : json['meta_no_image_index'];
//     metaNoArchive =
//         fromGetProducts ? json['no_archive'] : json['meta_no_archive'];
//     metaNoSnippet =
//         fromGetProducts ? json['no_snippet'] : json['meta_no_snippet'];
//     metaMaxSnippet =
//         fromGetProducts ? json['max_snippet'] : json['meta_max_snippet'];
//     metaMaxSnippetValue = fromGetProducts
//         ? json['max_snippet_value']
//         : json['meta_max_snippet_value'];
//     metaMaxVideoPreview = fromGetProducts
//         ? json['max_video_preview']
//         : json['meta_max_video_preview'];
//     metaMaxVideoPreviewValue = fromGetProducts
//         ? json['max_video_preview_value']
//         : json['meta_max_video_preview_value'];
//     metaMaxImagePreview = fromGetProducts
//         ? json['max_image_preview']
//         : json['meta_max_image_preview'];
//     metaMaxImagePreviewValue = fromGetProducts
//         ? json['max_image_preview_value']
//         : json['meta_max_image_preview_value'];
//     metaImage = fromGetProducts ? json['meta_image'] : json['meta_image'];
//     imageFullUrl = json['image_full_url'] != null
//         ? ImageFullUrl.fromJson(json['image_full_url'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['meta_id'] = metaId;
//     data['meta_product_id'] = metaProductId;
//     data['meta_title'] = metaTitle;
//     data['meta_description'] = metaDescription;
//     data['meta_index'] = metaIndex;
//     data['meta_no_follow'] = metaNoFollow;
//     data['meta_no_image_index'] = metaNoImageIndex;
//     data['meta_no_archive'] = metaNoArchive;
//     data['meta_no_snippet'] = metaNoSnippet;
//     data['meta_max_snippet'] = metaMaxSnippet;
//     data['meta_max_snippet_value'] = metaMaxSnippetValue;
//     data['meta_max_video_preview'] = metaMaxVideoPreview;
//     data['meta_max_video_preview_value'] = metaMaxVideoPreviewValue;
//     data['meta_max_image_preview'] = metaMaxImagePreview;
//     data['meta_max_image_preview_value'] = metaMaxImagePreviewValue;
//     data['meta_image'] = metaImage;
//     data['meta_created_at'] = metaCreatedAt;
//     data['meta_updated_at'] = metaUpdatedAt;
//     return data;
//   }
// }
