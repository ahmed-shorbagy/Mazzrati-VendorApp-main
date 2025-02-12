import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/features/auction/controllers/add_auction_controller.dart';
import 'package:mazzraati_vendor_app/features/auction/domain/models/auction_model.dart';
import 'package:mazzraati_vendor_app/features/auction/widgets/add_auction_section_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class AddAuctionScreen extends StatefulWidget {
  final Auction? auction;

  const AddAuctionScreen({super.key, this.auction});

  @override
  _AddAuctionScreenState createState() => _AddAuctionScreenState();
}

class _AddAuctionScreenState extends State<AddAuctionScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _startingBidController = TextEditingController();
  final TextEditingController _bidIncrementController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<File> _images = []; // Store selected images here
  List<String> _imageUrls = [];
  bool _isLoading = false; // Loading state variable

  @override
  void initState() {
    if (widget.auction != null) {
      _productNameController.text = widget.auction!.itemName;
      _productDescriptionController.text = widget.auction!.itemDescription;
      _startingBidController.text = widget.auction!.startingBid.toString();
      _bidIncrementController.text = widget.auction!.bidIncrement.toString();
      _startTime = widget.auction!.startTime;
      _endTime = widget.auction!.endTime;
      _imageUrls = widget.auction!.imagesUrl;
    }
    super.initState();
  }

  Future<void> _selectImage(ImageSource source) async {
    if (_images.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 4 images.')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _showImageSourceSelection() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslated("select_image_source", context) ?? ""),
          actions: <Widget>[
            TextButton(
              child: Text(getTranslated('camera', context) ?? ""),
              onPressed: () {
                Navigator.of(context).pop();
                _selectImage(ImageSource.camera);
              },
            ),
            TextButton(
              child: Text(getTranslated('gallery', context) ?? ""),
              onPressed: () {
                Navigator.of(context).pop();
                _selectImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    DateTime currentDate = DateTime.now();
    DateTime? chosenDate = isStartDate ? _startTime : _endTime;

    // Ensure the initial date is not before the current date
    DateTime initialDate =
        (chosenDate != null && chosenDate.isAfter(currentDate))
            ? chosenDate
            : currentDate;

    bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 5),
      locale: isLtr ? const Locale('en') : const Locale('ar'),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        final DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            _startTime = selectedDateTime;
          } else {
            _endTime = selectedDateTime;
          }
        });
      }
    }
  }

  String _getAuctionDuration(BuildContext context) {
    if (_startTime == null || _endTime == null) {
      return getTranslated("please_select_start_and_end_times", context) ?? "";
    }

    final Duration duration = _endTime!.difference(_startTime!);
    final bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;

    final int days = duration.inDays;
    final int hours = duration.inHours % 24;
    final int minutes = duration.inMinutes % 60;

    if (isLtr) {
      return '$days days, $hours hours, $minutes minutes';
    } else {
      return '$days يوم, $hours ساعة, $minutes دقيقة';
    }
  }

  void _editImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _startingBidController.dispose();
    _bidIncrementController.dispose();
    super.dispose();
  }

  void _submitForm(AddAuctionController auctionController,
      AddProductController productController) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      try {
        if (widget.auction == null) {
          // Create new auction
          await auctionController.createAuction(
            context: context,
            productName: _productNameController.text.trim(),
            productDescription: _productDescriptionController.text.trim(),
            startingBid: double.parse(_startingBidController.text.trim()),
            category: productController
                .categoryList![productController.categoryIndex!].name!,
            categoryIndex: productController.categoryIndex!,
            bidIncrement: double.parse(_bidIncrementController.text.trim()),
            startTime: _startTime ?? DateTime.now(),
            endTime: _endTime ?? DateTime.now().add(const Duration(days: 1)),
            images: _images,
          );
          productController.setCategoryIndex(0, true);
        } else {
          // Update existing auction
          await auctionController.updateAuction(
            auctionId: widget.auction!.auctionId,
            productName: _productNameController.text.trim(),
            categoryIndex: productController.categoryIndex!,
            productDescription: _productDescriptionController.text.trim(),
            startingBid: double.parse(_startingBidController.text.trim()),
            bidIncrement: double.parse(_bidIncrementController.text.trim()),
            startTime: _startTime ?? widget.auction!.startTime,
            endTime: _endTime ?? widget.auction!.endTime,
            images: _images.isNotEmpty ? _images : null,
            context: context,
          );
          Navigator.pop(context);
          productController.setCategoryIndex(0, true);
        }
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;

    // Define the format based on the locale
    final String formatPattern =
        isLtr ? 'dd/MM/yyyy hh:mm a' : 'dd/MM/yyyy hh:mm a';
    final DateFormat dateFormat =
        DateFormat(formatPattern, isLtr ? 'en' : 'ar');

    return dateFormat.format(dateTime);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.auction == null
            ? getTranslated("create_auction", context)
            : getTranslated("update_auction", context) ?? "",
      ),
      body: Consumer<AddAuctionController>(
        builder: (context, auctionController, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddAuctionSectionWidget(
                          title: getTranslated('product_name', context) ?? "",
                          childrens: [
                            CustomTextFieldWidget(
                              textInputAction: TextInputAction.next,
                              controller: _productNameController,
                              textInputType: TextInputType.name,
                              required: true,
                              hintText:
                                  getTranslated('product_name', context) ?? "",
                              border: true,
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            CustomTextFieldWidget(
                              required: true,
                              isDescription: true,
                              controller: _productDescriptionController,
                              textInputType: TextInputType.multiline,
                              maxLine: 3,
                              border: true,
                              hintText: getTranslated(
                                      'product_description', context) ??
                                  "",
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            Consumer<AddProductController>(
                                builder: (context, resProvider, child) {
                              return resProvider.categoryList != null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        border: Border.all(
                                            width: .5,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.7)),
                                      ),
                                      child: DropdownButton<int>(
                                          value: resProvider.categoryIndex,
                                          items: resProvider.categoryIds
                                              .map((int? value) {
                                            return DropdownMenuItem<int>(
                                              value: resProvider.categoryIds
                                                  .indexOf(value),
                                              child: Text(value != 0
                                                  ? resProvider
                                                      .categoryList![
                                                          (resProvider
                                                                  .categoryIds
                                                                  .indexOf(
                                                                      value) -
                                                              1)]
                                                      .name!
                                                  : getTranslated(
                                                      'select_category',
                                                      context)!),
                                            );
                                          }).toList(),
                                          onChanged: (int? value) {
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

                                            print(resProvider
                                                .categoryList![
                                                    resProvider.categoryIndex!]
                                                .name);
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                            print(
                                                "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

                                            resProvider.setCategoryIndex(
                                                value, true);
                                          },
                                          isExpanded: true,
                                          underline: const SizedBox()))
                                  : const Center(
                                      child: CircularProgressIndicator());
                            }),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        AddAuctionSectionWidget(
                          title: getTranslated('bid_details', context) ?? "",
                          childrens: [
                            CustomTextFieldWidget(
                              textInputAction: TextInputAction.next,
                              controller: _startingBidController,
                              textInputType: TextInputType.number,
                              required: true,
                              hintText:
                                  getTranslated('starting_bid', context) ?? "",
                              border: true,
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            CustomTextFieldWidget(
                              textInputAction: TextInputAction.done,
                              controller: _bidIncrementController,
                              textInputType: TextInputType.number,
                              required: true,
                              hintText: getTranslated("bid_increment", context),
                              border: true,
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge),
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(.75),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _startTime == null
                                  ? getTranslated(
                                          "select_start_date_time", context) ??
                                      ""
                                  : '${getTranslated('start', context)}: ${_formatDateTime(_startTime!)}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: _endTime != null
                                    ? Colors.black
                                    : Theme.of(context)
                                        .hintColor
                                        .withOpacity(.75),
                              ),
                            ),
                          ),
                          onPressed: () => _selectDateTime(context, true),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(.75),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _endTime == null
                                  ? getTranslated(
                                          "select_end_date_time", context) ??
                                      ""
                                  : '${getTranslated('end', context)}: ${_formatDateTime(_endTime!)}',
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: _endTime != null
                                      ? Colors.black
                                      : Theme.of(context)
                                          .hintColor
                                          .withOpacity(.75)),
                            ),
                          ),
                          onPressed: () => _selectDateTime(context, false),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        if (_startTime != null && _endTime != null)
                          Text(
                            '${getTranslated('auction_duration', context) ?? ""}: ${_getAuctionDuration(context)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        if (widget.auction == null) ...[
                          CustomButtonWidget(
                              btnTxt:
                                  getTranslated("select_images", context) ?? "",
                              backgroundColor: Theme.of(context).primaryColor,
                              onTap: () =>
                                  _showImageSourceSelection() ?? () {}),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          _images.isNotEmpty
                              ? SizedBox(
                                  height: 160,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _images.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeBorder),
                                        margin: const EdgeInsets.only(
                                          right: Dimensions.paddingSizeBorder,
                                          left: Dimensions.paddingSizeBorder,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(.75),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: widget.auction == null
                                                  ? Image.file(
                                                      _images[index],
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      _imageUrls[index],
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.blue),
                                                  onPressed: () =>
                                                      _editImage(index),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      FontAwesomeIcons.remove,
                                                      color: Colors.red),
                                                  onPressed: () =>
                                                      _deleteImage(index),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text(getTranslated(
                                      "no_images_selected", context) ??
                                  ""),
                        ],
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : CustomButtonWidget(
                                btnTxt: widget.auction == null
                                    ? getTranslated(
                                        "confirm_create_auction", context)
                                    : getTranslated(
                                            "update_auction", context) ??
                                        "",
                                backgroundColor: Theme.of(context).primaryColor,
                                onTap: () {
                                  if (_productNameController.text.isEmpty) {
                                    showCustomSnackBarWidget(
                                        getTranslated("enter_product_name",
                                                context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  } else if (_productDescriptionController
                                      .text.isEmpty) {
                                    showCustomSnackBarWidget(
                                        getTranslated(
                                                "enter_product_description",
                                                context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  } else if (Provider.of<AddProductController>(
                                              context,
                                              listen: false)
                                          .categoryIndex ==
                                      0) {
                                    showCustomSnackBarWidget(
                                        getTranslated(
                                                "select_category", context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  } else if (_startingBidController
                                      .text.isEmpty) {
                                    showCustomSnackBarWidget(
                                        getTranslated("enter_starting_bid",
                                                context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  } else if (_bidIncrementController
                                      .text.isEmpty) {
                                    showCustomSnackBarWidget(
                                        getTranslated("enter_bid_increment",
                                                context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  } else if (_startTime == null ||
                                      _endTime == null) {
                                    showCustomSnackBarWidget(
                                        getTranslated(
                                                "select_start_and_end_date_time",
                                                context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  } else if (_images.isEmpty &&
                                      widget.auction == null) {
                                    showCustomSnackBarWidget(
                                        getTranslated(
                                                "select_images", context) ??
                                            "",
                                        context,
                                        sanckBarType: SnackBarType.warning,
                                        isToaster: true);
                                  }
                                  _submitForm(
                                      auctionController,
                                      Provider.of<AddProductController>(context,
                                          listen: false));
                                }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
