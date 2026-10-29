import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/helpers/functions.dart';
import 'package:onstagram/services/api.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Api api = Api();
  bool busy = false;
  String serverMessage = "";

  void pingApi() async {
    setState(() {
      busy = true;
    });

    final response = await api.get("/api/test");

    // The screen may have closed while we waited.
    if (!mounted) return;
    setState(() {
      busy = false;
      serverMessage =
          "${response.statusCode}: ${json.decode(response.body)['message']}";
    });
  }

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
            SizedBox(height: 24),
            FilledButton(
              onPressed: busy ? null : pingApi,
              child: Text(busy ? "Waiting..." : "Ping API"),
            ),
            SizedBox(height: 16),
            Text(serverMessage),
          ],
        ),
      ),
    );
  }
}
