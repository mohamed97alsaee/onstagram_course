import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:emails_validator/emails_validator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/helpers/functions.dart';
import 'package:onstagram/main.dart';
import 'package:onstagram/providers/auth_provider.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:onstagram/widgets/clickables/app_button.dart';
import 'package:onstagram/widgets/inputs/app_input.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassword = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Waits for a pause in typing before asking the server.
  Timer? debounce;
  String? message;
  // null until the server answers about the current username.
  bool? available;

  @override
  void dispose() {
    // A timer left running would still send a request after the screen closes.
    debounce?.cancel();
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DarkModeProvider, AuthProvider>(
      builder: (context, darkModeConsumer, authConsumer, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left, size: 28),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo_typography.png",
                    width: getSize(context).width * 0.44,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 26),
                    child: Text(
                      "Sign up to share photos and follow other developers.",
                      textAlign: TextAlign.center,
                      style: bodyMedium.copyWith(color: greyTextColor),
                    ),
                  ),
                  AppInput(
                    customHint: "Full name",
                    controller: nameController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Enter your name";
                      }
                      return null;
                    },
                    onChanged: () {},
                  ),
                  AppInput(
                    customHint: "Username",
                    controller: usernameController,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "At least 3 characters";
                      }
                      return null;
                    },
                    suffix: authConsumer.busyMore
                        ? Padding(
                            padding: const EdgeInsets.all(14),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: hintColor,
                            ),
                          )
                        : Icon(
                            available == false
                                ? Icons.error_outline
                                : Icons.check,
                            size: 20,
                            color: available == null
                                ? Colors.transparent
                                : available!
                                ? greenColor
                                : redColor,
                          ),
                    underWidget: message == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              message!,
                              style: bodySmall.copyWith(
                                color: available! ? greenColor : redColor,
                              ),
                            ),
                          ),
                    onChanged: () {
                      // Every key press restarts the wait:
                      // fast typing sends one request, not one per key.
                      debounce?.cancel();
                      setState(() {
                        message = null;
                        available = null;
                      });
                      debounce = Timer(Duration(milliseconds: 500), () {
                        String un = usernameController.text;
                        if (un.length < 3) return;

                        authConsumer.checkUsername(un).then((checkResult) {
                          // Still the same name? The user may have typed on.
                          if (mounted && un == usernameController.text) {
                            setState(() {
                              message = checkResult.message;
                              available = checkResult.success;
                            });
                          }
                        });
                      });
                    },
                  ),
                  AppInput(
                    customHint: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Enter your email";
                      }
                      if (!EmailsValidator.validate(v)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    onChanged: () {},
                  ),
                  AppInput(
                    customHint: "Password",
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (v) {
                      if (v!.length < 8) {
                        return "At least 8 characters";
                      }
                      return null;
                    },
                    showValue: showPassword,
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                        showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: greyTextColor,
                      ),
                    ),
                    onChanged: () {},
                  ),
                  AppButton(
                    label: "Sign up",
                    btnColor: blueColor,
                    // A taken username can't sign up: try another one.
                    enabled: available != false,
                    isLoading: authConsumer.busy,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authConsumer
                            .register({
                              "name": nameController.text,
                              "username": usernameController.text,
                              "email": emailController.text,
                              "password": passwordController.text,
                            })
                            .then((registerResult) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: registerResult.success
                                        ? greenColor
                                        : redColor,
                                    content: Text(registerResult.message),
                                  ),
                                );
                                if (registerResult.success) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => ScreenRouter(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              }
                            });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: darkModeConsumer.isDark
                      ? darkBorderColor
                      : buttonColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: bodyMedium.copyWith(color: greyTextColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Log in",
                          style: labelLarge.copyWith(color: blueColor),
                        ),
                      ),
                    ],
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
