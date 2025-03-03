import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class CustomSearchFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String prefix;
  final Function iconPressed;
  final Function? onSubmit;
  final Function? onChanged;
  final Function? filterAction;
  final bool isFilter;
  const CustomSearchFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefix,
    required this.iconPressed,
    this.onSubmit,
    this.onChanged,
    this.filterAction,
    this.isFilter = false,
  });

  @override
  State<CustomSearchFieldWidget> createState() =>
      _CustomSearchFieldWidgetState();
}

class _CustomSearchFieldWidgetState extends State<CustomSearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).disabledColor.withOpacity(.5)),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeSmall),
              ),
              filled: true,
              fillColor: Theme.of(context).primaryColor.withOpacity(.07),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: .70),
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeSmall),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                child: SizedBox(
                    width: Dimensions.iconSizeExtraSmall,
                    child: Image.asset(widget.prefix)),
              ),
            ),
            onSubmitted: widget.onSubmit as void Function(String)?,
            onChanged: widget.onChanged as void Function(String)?,
          ),
        ),
        widget.isFilter
            ? Padding(
                padding: EdgeInsets.only(
                    left: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? Dimensions.paddingSizeExtraSmall
                        : 0,
                    right: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? 0
                        : Dimensions.paddingSizeExtraSmall),
                child: GestureDetector(
                  onTap: widget.filterAction as void Function()?,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeExtraSmall),
                      ),
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeMedium),
                      child: Image.asset(Images.filterIcon,
                          width: Dimensions.paddingSizeLarge)),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
