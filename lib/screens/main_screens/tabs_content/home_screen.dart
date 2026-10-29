import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/functions.dart';

class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo_typography.png",
          width: getSize(context).width * 0.35,
        ),
      ),
    );
  }
}
