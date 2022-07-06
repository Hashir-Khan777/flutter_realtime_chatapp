import 'dart:convert';

import 'package:fireflutterchatapp/Controllers/login_controller.dart';
import 'package:fireflutterchatapp/Views/home.dart';
import 'package:fireflutterchatapp/Views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginController = Get.put(LoginController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var email;
  var password;
  var obscureText = true;

  @override
  void initState() {
    super.initState();
    _prefs.then((prefs) {
      final user = json.decode('${prefs.getString('user')}');
      if (user['email'] != null) {
        Get.offAll(
          Home(
            user: {
              '_id': user?['_id'],
              'name': user?['name'],
              'email': user?['email'],
              'password': user?['password'],
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Chat App',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: GetX<LoginController>(
        builder: (controller) {
          if (controller.loading.isTrue) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (controller.error.isNotEmpty)
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                margin: const EdgeInsets.only(bottom: 30),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xffffe0e0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${controller.error}',
                                  style: const TextStyle(
                                    color: Color(0xffa02020),
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'email',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email)),
                                keyboardType: TextInputType.emailAddress,
                                initialValue: email,
                                onChanged: (text) {
                                  setState(() {
                                    email = text;
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'password',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    child: Icon(obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: obscureText,
                                initialValue: password,
                                onChanged: (text) {
                                  setState(() {
                                    password = text;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.login(email, password);
                              },
                              child: Text('Login'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(
                            children: [
                              const Text('Do not have an account ?'),
                              TextButton(
                                onPressed: () {
                                  Get.to(const Register());
                                },
                                child: const Text('Create account'),
                              ),
                            ],
                          ),
                        ),
                        const Text('OR'),
                        SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            loginController.signInWithGoogle();
                          },
                        ),
                        SignInButton(
                          Buttons.Facebook,
                          onPressed: () {
                            loginController.signInWithFacebook();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
