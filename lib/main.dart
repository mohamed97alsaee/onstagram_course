import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/providers/auth_provider.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:onstagram/screens/auth_screens/login_screen.dart';
import 'package:onstagram/screens/handling_screens/loading_screen.dart';
import 'package:onstagram/screens/handling_screens/splash_screen.dart';
import 'package:onstagram/screens/main_screens/tabs_content/profile_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    // Above MaterialApp, so every screen can reach the providers.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkModeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<DarkModeProvider>(
        builder: (context, darkModeConsumer, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Onstagram",
            themeMode: darkModeConsumer.isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: theme,
            darkTheme: darkTheme,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

// The one place that decides the screen: login and logout
// only change authStatus, and this rebuilds.
class ScreenRouter extends StatefulWidget {
  const new({super.key});

  @override
  State<ScreenRouter> createState() => _ScreenRouterState();
}

class _ScreenRouterState extends State<ScreenRouter> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).initAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authConsumer, _) {
        return switch (authConsumer.authStatus) {
          AuthStatus.authenticated => ProfileScreen(),
          AuthStatus.unauthenticated => LoginScreen(),
          AuthStatus.uninitialized ||
          AuthStatus.authenticating => LoadingScreen(),
        };
      },
    );
  }
}
