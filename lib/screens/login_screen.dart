// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter_developer_assessment/api_services/usrls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_developer_assessment/components/customTextField.dart';
import 'package:flutter_developer_assessment/utils/custom_colloer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String emailErrorText = '';
  String passwordErrorText = '';
  String suffixText = 'Show';
  bool obscureText = true;
  bool btnLoader = false;

  toggleSuffixText() {
    if (suffixText == 'Show') {
      setState(() {
        suffixText = 'Hide';
      });
    } else {
      setState(() {
        suffixText = 'Show';
      });
    }
  }

  void handleLogin() async {
    setState(() {
      emailErrorText = '';
      passwordErrorText = '';
    });
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        btnLoader = true;
      });
      try {
        final response = await http.post(
          Uri.parse(loginUrl),
          body: {
            'username': emailController.text.trim(),
            'password': passwordController.text.trim(),
          },
        );
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          String token = responseData['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          setState(() {
            btnLoader = false;
          });
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          final responseData = json.decode(response.body);
          setState(() {
            btnLoader = false;
          });
          String errMsg = responseData['message'];
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                  content: Text(errMsg),
                );
              });
        }
      } on SocketException catch (_) {
        setState(() {
          btnLoader = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
                content: const Text('No network connection...'),
              );
            });
      }on HandshakeException catch (e) {
   showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
                content: Text(e.message.toString()),
              );
            });
  }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor().customWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 169,
                  height: 20,
                  margin: const EdgeInsets.only(top: 30),
                  child: const Text(
                    'Login to your account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'Email',
                        controller: emailController,
                        obscureText: false,
                        suffixText: '',
                        errorText: emailErrorText,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return 'Please enter a valid email address';
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: 'Password',
                        controller: passwordController,
                        errorText: emailErrorText,
                        suffixText: suffixText,
                        obscureText: obscureText,
                        onTap: () {
                          toggleSuffixText();

                          setState(() {
                            obscureText = !obscureText;
                          });
                          return;
                        },
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return 'Please enter a your correct password';
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.13,
                ),
                Container(
                  width: size.width * 0.95,
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(size.width * 0.95, 51),
                            backgroundColor: CustomColor().customGreen,
                            elevation: 0,
                          ),
                          onPressed: handleLogin,
                          child: btnLoader
                              ?  CircularProgressIndicator(
                                  color: CustomColor().customWhite,
                                )
                              :  Text(
                            'Log In',
                            style: TextStyle(
                                color: CustomColor().customWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Forgot your password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: CustomColor().customGreen,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
