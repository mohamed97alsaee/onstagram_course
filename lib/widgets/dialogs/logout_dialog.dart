import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/main.dart';
import 'package:onstagram/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LogoutDialog extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authConsumer, _) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text("Log out of Onstagram?", style: titleMedium),
                      SizedBox(height: 4),
                      Text(
                        "You’ll need your password to log back in.",
                        textAlign: TextAlign.center,
                        style: bodyMedium.copyWith(color: greyTextColor),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: TextButton(
                    onPressed: () {
                      if (authConsumer.busy) return;
                      authConsumer.logout().then((logoutResult) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: logoutResult.success
                                  ? greenColor
                                  : redColor,
                              content: Text(logoutResult.message),
                            ),
                          );
                          // A clean stack: nothing of the old session stays.
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ScreenRouter(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    },
                    child: authConsumer.busy
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: redColor,
                            ),
                          )
                        : Text(
                            "Log out",
                            style: labelLarge.copyWith(color: redColor),
                          ),
                  ),
                ),
                Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
