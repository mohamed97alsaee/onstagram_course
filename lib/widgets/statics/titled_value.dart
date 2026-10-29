import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';

class TitledValue extends StatelessWidget {
  const new({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: titleMedium),
        Text(title, style: bodySmall),
      ],
    );
  }
}
