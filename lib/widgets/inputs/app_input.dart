import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';

class AppInput extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    required this.validator,
    required this.onChanged,
    this.customHint,
    this.keyboardType = TextInputType.text,
    this.showValue = true,
    this.suffix,
    this.hPadding = 16,
    this.vPadding = 6,
  });
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Function onChanged;
  final String? customHint;
  final TextInputType keyboardType;
  final bool showValue;
  final Widget? suffix;
  final double hPadding;
  final double vPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: !showValue,
            onChanged: (value) {
              onChanged();
            },
            style: bodyLarge,
            // Fill, border and hint colour come from the theme.
            decoration: InputDecoration(
              hintText: customHint,
              suffixIcon: suffix,
            ),
          ),
        ],
      ),
    );
  }
}
