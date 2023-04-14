import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/helper.dart';
import '../provider/auth_provider.dart';
import '../widgets/header_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkedValue = false;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 250,
              child: HeaderWidget(250, true, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Consumer<AuthProvider>(builder: (context, authProvider, _) {
                    return Form(
                      key: authProvider.signUpFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: ThemeHelper.inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: authProvider.fNameController,
                              decoration: ThemeHelper.textInputDecoration(
                                  'First Name', 'Enter your first name'),
                              validator: validateName,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: ThemeHelper.inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: authProvider.lNameController,
                              decoration: ThemeHelper.textInputDecoration(
                                  'Last Name', 'Enter your last name'),
                              validator: validateName,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: ThemeHelper.inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: authProvider.emailController,
                              decoration: ThemeHelper.textInputDecoration(
                                  "Email address", "Enter your email"),
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: ThemeHelper.inputBoxDecorationShaddow(),
                            child: TextFormField(
                                controller: authProvider.passwordController,
                                obscureText: true,
                                decoration: ThemeHelper.textInputDecoration(
                                    "Password", "Enter your password"),
                                validator: validatePassword),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration:
                                ThemeHelper.buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper.buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Register".toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (authProvider.signUpFormKey.currentState!
                                    .validate()) {
                                  authProvider.signUp();
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 30.0),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
