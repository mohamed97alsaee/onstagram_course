import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:emails_validator/emails_validator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';
import 'package:onstagram/helpers/functions.dart';
import 'package:onstagram/providers/auth_provider.dart';
import 'package:onstagram/providers/dark_mode_provider.dart';
import 'package:onstagram/screens/auth_screens/register_screen.dart';
import 'package:onstagram/widgets/clickables/app_button.dart';
import 'package:onstagram/widgets/inputs/app_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  // Lets us ask the whole form: are all fields valid?
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
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
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: darkModeConsumer.isDark
                        ? darkButtonColor
                        : buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
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
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo_typography.png",
                      width: getSize(context).width * 0.44,
                    ),
                    SizedBox(height: 38),
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
                        if (v!.isEmpty) {
                          return "Enter your password";
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
                      label: "Log in",
                      btnColor: blueColor,
                      isLoading: authConsumer.busy,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authConsumer
                              .login({
                                "email": emailController.text,
                                "password": passwordController.text,
                              })
                              .then((loginResult) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: loginResult.success
                                          ? greenColor
                                          : redColor,
                                      content: Text(loginResult.message),
                                    ),
                                  );
                                }
                              });
                        }
                      },
                    ),
                  ],
                ),
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
                        "Don’t have an account?",
                        style: bodyMedium.copyWith(color: greyTextColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
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
