import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/helpers/functions.dart';
import 'package:onstagram/main.dart';

class SplashScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                          "assets/images/logo_typography.png",
                          width: getSize(context).width * 0.44,
                        )
                        .animate(
                          onComplete: (v) {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ScreenRouter(),
                              ),
                            );
                          },
                        )
                        .fadeIn(
                          delay: Duration(milliseconds: 300),
                          duration: Duration(milliseconds: 600),
                        )
                        .fadeOut(
                          delay: Duration(seconds: 3),
                          duration: Duration(milliseconds: 600),
                        ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Like "from Meta" under Instagram's logo.
              Text("from", style: bodySmall.copyWith(color: greyTextColor)),
              Text("Alsaee.dev", style: labelLarge),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
