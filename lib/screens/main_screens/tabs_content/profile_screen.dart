import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/providers/auth_provider.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:onstagram/widgets/clickables/app_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DarkModeProvider, AuthProvider>(
      builder: (context, darkModeConsumer, authConsumer, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.lock_outline, size: 16),
                SizedBox(width: 6),
                Text(authConsumer.currentUser?.username ?? "..."),
              ],
            ),
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text("Hello, ${authConsumer.currentUser?.name ?? "..."}"),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: "Log out",
                      btnColor: darkModeConsumer.isDark
                          ? darkButtonColor
                          : buttonColor,
                      txtColor: darkModeConsumer.isDark
                          ? darkTextColor
                          : textColor,
                      hPadding: 0,
                      vPadding: 0,
                      internalPadding: 3,
                      isLoading: authConsumer.busy,
                      onPressed: () {
                        // The ScreenRouter sees the change and shows login.
                        authConsumer.logout();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: darkModeConsumer.isDark
                          ? darkButtonColor
                          : buttonColor,
                      borderRadius: BorderRadius.circular(8),
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
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
