import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';

class LoadingScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: hintColor),
        ),
      ),
    );
  }
}
