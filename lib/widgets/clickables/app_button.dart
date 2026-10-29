import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';

class AppButton extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.btnColor,
    required this.onPressed,
    this.hPadding = 16,
    this.vPadding = 6,
    this.internalPadding = 9,
  });
  final String label;
  final Color btnColor;
  final Function onPressed;
  final double hPadding;
  final double vPadding;
  final double internalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          elevation: 0,
          // 9 + one line of text (26) + 9 = 44 high, like Instagram.
          padding: EdgeInsets.all(internalPadding),
          minimumSize: Size(double.infinity, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(label, style: labelLarge.copyWith(color: whiteColor)),
      ),
    );
  }
}
