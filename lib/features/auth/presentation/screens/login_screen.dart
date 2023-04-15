import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_app/features/auth/presentation/screens/signUp_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/helper.dart';

import '../provider/auth_provider.dart';
import '../widgets/header_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      const Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30.0),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          {
                            return Form(
                              key: authProvider.loginFormKey,
                              child: Column(
                                children: [
                                  Container(
                                    decoration:
                                        ThemeHelper.inputBoxDecorationShaddow(),
                                    child: TextFormField(
                                      controller: authProvider.emailController,
                                      decoration:
                                          ThemeHelper.textInputDecoration(
                                              'Email', 'Enter your email'),
                                      validator: validateEmail,
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
                                  Container(
                                    decoration:
                                        ThemeHelper.inputBoxDecorationShaddow(),
                                    child: TextFormField(
                                      controller:
                                          authProvider.passwordController,
                                      obscureText: true,
                                      decoration:
                                          ThemeHelper.textInputDecoration(
                                              'Password',
                                              'Enter your password'),
                                      validator: validatePassword,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    decoration: ThemeHelper.buttonBoxDecoration(
                                        context),
                                    child: ElevatedButton(
                                      style: ThemeHelper.buttonStyle(),
                                      onPressed: authProvider.loading
                                          ? null
                                          : () {
                                              if (authProvider
                                                  .loginFormKey.currentState!
                                                  .validate()) {
                                                authProvider.signIn();
                                              }
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 10, 40, 10),
                                        child: Text(
                                          authProvider.loading
                                              ? '. . . .'
                                              : 'Sign In'.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 20),
                                    //child: Text('Don\'t have an account? Create'),
                                    child: Text.rich(TextSpan(children: [
                                      const TextSpan(
                                          text: "Don\'t have an account? "),
                                      TextSpan(
                                        text: 'Create',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            push(context, const SignUpScreen());
                                          },
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ])),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
