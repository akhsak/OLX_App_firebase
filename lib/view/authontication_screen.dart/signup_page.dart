// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:olx_app_firebase/controller/authontication_provider.dart';
import 'package:olx_app_firebase/widgets/bottom_screen.dart';
import 'package:olx_app_firebase/widgets/button_widget.dart';
import 'package:olx_app_firebase/widgets/snackbar_widget.dart';
import 'package:olx_app_firebase/widgets/text_formfield.dart';
import 'package:olx_app_firebase/widgets/text_style.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  bool isLoading = false;
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: size.height * .07, left: 15, right: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        authProvider.clearSignupControllers();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
               
                ],
              ),
              textPoppins(
                name: 'Hi !',
                fontsize: 30,
                fontweight: FontWeight.bold

              ),
               textPoppins(
                name: 'create a new account',
                fontsize: 20,
                

              ),
             // SizedBox(height: size.height * .1),
              SizedBox(
                height: size.height * .5,
                child: Form(
                  key: authProvider.signupFormkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextFormField(
                         prefixIcon: Icon(Icons.email,color: Colors.black),
                        labelText: 'Email',
                        controller: authProvider.signupEmailController,
                        validateMsg: 'Enter a Email',
                      ),
                      Consumer<AuthenticationProvider>(
                          builder: (context, value, child) {
                        return Column(
                          children: [
                            CustomTextFormField(
                               prefixIcon: Icon(Icons.lock,color: Colors.black),
                              labelText: 'Password',
                              controller:
                                  authProvider.signupPasswordController,
                              validateMsg: 'Enter a New Password',
                              obscureText: value.obscureText,
                              suffixIcon: IconButton(
                                icon: Icon(value.obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () {
                                  value.obscureChange();
                                },
                              ),
                            ),
                            SizedBox(height: size.height * .035),
                            CustomTextFormField(
                              prefixIcon: Icon(Icons.lock,color: Colors.black),
                              labelText: 'Confirm password',
                              controller:
                                  authProvider.confirmPasswordController,
                              obscureText: value.obscureText,
                              validateMsg: 'Re-Enter Your Password',
                            ),
                          ],
                        );
                      }),
                      ButtonWidgets().rectangleButton(
                        size,
                        name: 'Sign Up',
                        onPressed: () async {
                          if (authProvider.signupFormkey.currentState!
                              .validate()) {
                            try {
                              if (authProvider
                                      .signupPasswordController.text ==
                                  authProvider.confirmPasswordController.text) {
                                await authProvider.signupUser(
                                    authProvider.signupEmailController.text,
                                    authProvider
                                        .signupPasswordController.text);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BottomScreen()));

                                authProvider.clearSignupControllers();
                                SnackBarWidget().showSuccessSnackbar(
                                    context, 'Registeration success');
                              } else {
                                SnackBarWidget().showErrorSnackbar(
                                    context, 'passwords does not match');
                              }
                            } catch (e) {
                              SnackBarWidget().showErrorSnackbar(context,
                                  'Already existed E-mail or invalid E-mail');
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textPoppins(name: "Already have an account? "),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      authProvider.clearSignupControllers();
                    },
                    child: textAbel(
                        name: 'Login Now',
                        color: Colors.blueAccent[400],
                        fontsize: 17,
                        fontweight: FontWeight.w700),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  circularIndicator() {
    if (isLoading = true) {
      return const CircularProgressIndicator(
        color: Color.fromARGB(255, 38, 17, 111),
      );
    }
  }
}