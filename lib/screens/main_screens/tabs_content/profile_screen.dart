import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/models/user_profile_model.dart';
import 'package:onstagram/providers/auth_provider.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:onstagram/widgets/clickables/app_button.dart';
import 'package:onstagram/widgets/clickables/dark_mode_button.dart';
import 'package:onstagram/widgets/dialogs/logout_dialog.dart';
import 'package:onstagram/widgets/statics/empty_posts.dart';
import 'package:onstagram/widgets/statics/titled_value.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // After the first frame: getMe() tells its listeners right away,
    // and that is not allowed while this screen is being built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).getMe();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DarkModeProvider, AuthProvider>(
      builder: (context, darkModeConsumer, authConsumer, _) {
        UserProfileModel? user = authConsumer.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.lock_outline, size: 16),
                SizedBox(width: 6),
                Text(user?.username ?? "..."),
              ],
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: darkModeConsumer.isDark
                          ? darkButtonColor
                          : buttonColor,
                      backgroundImage: user?.photo == null
                          ? null
                          : NetworkImage(user!.photo!),
                      // No photo yet: the first letter of the name.
                      child: user?.photo == null
                          ? Text(
                              user?.name[0].toUpperCase() ?? "",
                              style: titleLarge,
                            )
                          : null,
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitledValue(
                              title: "posts",
                              value: user?.stats.postsCount.toString() ?? "...",
                            ),
                            TitledValue(
                              title: "followers",
                              value:
                                  user?.stats.followersCount.toString() ??
                                  "...",
                            ),
                            TitledValue(
                              title: "following",
                              value:
                                  user?.stats.followingsCount.toString() ??
                                  "...",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? "...", style: labelLarge),
                    if (user?.bio != null) Text(user!.bio!),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
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
                        onPressed: () {
                          // Ask first: Log out is easy to tap by mistake.
                          showDialog(
                            context: context,
                            builder: (context) => LogoutDialog(),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    DarkModeButton(compact: true),
                  ],
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                child: Icon(Icons.grid_on),
              ),
              EmptyPosts(),
            ],
          ),
        );
      },
    );
  }
}
