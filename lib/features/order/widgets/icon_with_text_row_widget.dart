import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class IconWithTextRowWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final bool bold;
  const IconWithTextRowWidget(
      {super.key,
      required this.text,
      required this.icon,
      this.iconColor,
      this.textColor,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            color:
                iconColor ?? Theme.of(context).primaryColor.withOpacity(.30)),
        const SizedBox(
          width: Dimensions.paddingSizeSmall,
        ),
        Expanded(
          child: Text(text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bold
                  ? titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault)
                  : titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: textColor ??
                          Theme.of(context).textTheme.bodyLarge?.color)),
        ),
      ],
    );
  }
}
