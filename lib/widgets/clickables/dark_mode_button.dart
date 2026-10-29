import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:provider/provider.dart';

// A grey circle on the login screen, a small grey square (compact)
// next to the profile's Log out.
class DarkModeButton extends StatelessWidget {
  const new({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (context, darkModeConsumer, _) {
        return Container(
          width: compact ? 32 : 40,
          height: compact ? 32 : 40,
          decoration: BoxDecoration(
            color: darkModeConsumer.isDark ? darkButtonColor : buttonColor,
            shape: compact ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: compact ? BorderRadius.circular(8) : null,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Provider.of<DarkModeProvider>(
                context,
                listen: false,
              ).switchMode();
            },
            icon: Icon(
              darkModeConsumer.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              size: compact ? 18 : 20,
            ),
          ),
        );
      },
    );
  }
}
