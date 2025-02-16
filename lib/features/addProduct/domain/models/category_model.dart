import 'package:mazzraati_vendor_app/data/model/image_full_url.dart';

class CategoryModel {
  int? id;
  String? name;
  String? slug;
  String? icon;
  String? iconStorageType;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  int? homeStatus;
  int? priority;
  List<CategoryModel>? subCategories;
  List<Translation>? translations;
  ImageFullUrl? iconFullUrl;
  bool? isSelected;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.icon,
    this.iconStorageType,
    this.parentId,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.homeStatus,
    this.priority,
    this.subCategories,
    this.translations,
    this.iconFullUrl,
    this.isSelected = false,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    iconStorageType = json['icon_storage_type'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    homeStatus = json['home_status'];
    priority = json['priority'];
    isSelected = false;

    if (json['childes'] != null) {
      subCategories = [];
      json['childes'].forEach((v) {
        subCategories!.add(CategoryModel.fromJson(v));
      });
    }

    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }

    iconFullUrl = json['icon_full_url'] != null
        ? ImageFullUrl.fromJson(json['icon_full_url'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['icon'] = icon;
    data['icon_storage_type'] = iconStorageType;
    data['parent_id'] = parentId;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['home_status'] = homeStatus;
    data['priority'] = priority;

    if (subCategories != null) {
      data['childes'] = subCategories!.map((v) => v.toJson()).toList();
    }

    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }

    if (iconFullUrl != null) {
      data['icon_full_url'] = iconFullUrl!.toJson();
    }

    return data;
  }

  String getTranslatedName(String languageCode) {
    if (translations != null && languageCode == 'sa') {
      for (var translation in translations!) {
        if (translation.locale == 'sa' && translation.key == 'name') {
          return translation.value ?? name ?? '';
        }
      }
    }
    return name ?? '';
  }
}

class Translation {
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  int? id;

  Translation({
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
    this.id,
  });

  Translation.fromJson(Map<String, dynamic> json) {
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['id'] = id;
    return data;
  }
}

class SubCategory {
  int? _id;
  String? _name;
  String? _slug;
  String? _icon;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  List<SubSubCategory>? _subSubCategories;
  bool? isSelected;

  SubCategory({
    int? id,
    String? name,
    String? slug,
    String? icon,
    int? parentId,
    int? position,
    String? createdAt,
    String? updatedAt,
    List<SubSubCategory>? subSubCategories,
    bool? isSelected,
  }) {
    _id = id;
    _name = name;
    _slug = slug;
    _icon = icon;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _subSubCategories = subSubCategories;
    isSelected = isSelected;
  }

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get icon => _icon;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<SubSubCategory>? get subSubCategories => _subSubCategories;

  SubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['childes'] != null) {
      _subSubCategories = [];
      json['childes'].forEach((v) {
        _subSubCategories!.add(SubSubCategory.fromJson(v));
      });
    }
    isSelected = false;
  }
}

class SubSubCategory {
  int? _id;
  String? _name;
  String? _slug;
  String? _icon;
  int? _parentId;
  int? _position;
  String? _createdAt;
  String? _updatedAt;

  SubSubCategory(
      {int? id,
      String? name,
      String? slug,
      String? icon,
      int? parentId,
      int? position,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _name = name;
    _slug = slug;
    _icon = icon;
    _parentId = parentId;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get icon => _icon;
  int? get parentId => _parentId;
  int? get position => _position;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  SubSubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
}
