import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final String? title;
  final String? text;
  final String? image;
  final bool requiredField;
  final Function? selectDate;
  const CustomDatePickerWidget(
      {super.key,
      this.title,
      this.text,
      this.image,
      this.requiredField = false,
      this.selectDate});

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.title,
              style: robotoRegular.copyWith(
                  color: ColorResources.getTextColor(context)),
              children: <TextSpan>[
                widget.requiredField
                    ? TextSpan(
                        text: '  *',
                        style: robotoBold.copyWith(color: Colors.red))
                    : const TextSpan(),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Container(
            height: 50,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              border: Border.all(
                  color: ColorResources.getPrimary(context), width: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: InkWell(
              onTap: widget.selectDate as void Function()?,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 20, height: 20, child: Image.asset(widget.image!)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(
                    widget.text!,
                    style: robotoRegular.copyWith(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
