import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_pass_textfeild_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';

class PasswordValidationWidget extends StatelessWidget {
  const PasswordValidationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Password input field
        CustomPasswordTextFieldWidget(
          border: true,
          hintTxt: getTranslated('enter_your_password', context),
          textInputAction: TextInputAction.next,
          focusNode: authProvider.passwordNode,
          nextNode: authProvider.confirmPasswordNode,
          controller: authProvider.passwordController,
          onChanged: (value) {
            if (value != null && value.isNotEmpty) {
              authProvider.validPassCheck(value);
            }
          },
        ),

        const SizedBox(height: Dimensions.paddingSizeMedium),

        // Validation criteria with checkboxes
        PasswordValidationCheckbox(
          text: getTranslated('at_least_8_characters', context) ?? "",
          isChecked: authProvider.lengthCheck,
        ),
        PasswordValidationCheckbox(
          text: getTranslated('at_least_1_lowercase_letter', context) ?? "",
          isChecked: authProvider.lowercaseCheck,
        ),
        PasswordValidationCheckbox(
          text: getTranslated('at_least_1_uppercase_letter', context) ?? "",
          isChecked: authProvider.uppercaseCheck,
        ),
        PasswordValidationCheckbox(
          text: getTranslated('at_least_1_number', context) ?? "",
          isChecked: authProvider.numberCheck,
        ),
        PasswordValidationCheckbox(
          text: getTranslated('at_least_1_special_character', context) ?? "",
          isChecked: authProvider.spatialCheck,
        ),
      ],
    );
  }
}

// Checkbox with text widget
class PasswordValidationCheckbox extends StatelessWidget {
  final String text;
  final bool isChecked;

  const PasswordValidationCheckbox({
    super.key,
    required this.text,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: null, // Make it non-editable
        ),
        Text(
          text,
          style: TextStyle(
            color: isChecked
                ? Colors.green
                : Colors.red, // Text color based on condition
          ),
        ),
      ],
    );
  }
}

class PasswordCheckRow extends StatelessWidget {
  final bool isValid;
  final String text;

  const PasswordCheckRow({
    super.key,
    required this.isValid,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 20.0,
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
