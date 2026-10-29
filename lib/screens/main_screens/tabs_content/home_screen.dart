import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/helpers/functions.dart';

class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/logo_typography.png",
              width: getSize(context).width * 0.35,
            ),
            SizedBox(height: 24),
            // Never show the key itself, only whether it arrived.
            Text(
              studentApiKey.isNotEmpty
                  ? "Student key: loaded"
                  : "Student key: missing (see README)",
            ),
          ],
        ),
      ),
    );
  }
}
