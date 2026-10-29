import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:onstagram/screens/main_screens/tabs_content/home_screen.dart';
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
      providers: [ChangeNotifierProvider(create: (_) => DarkModeProvider())],
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
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
