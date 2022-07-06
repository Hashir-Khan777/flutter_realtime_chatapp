import 'dart:convert';

import 'package:fireflutterchatapp/Controllers/register_controller.dart';
import 'package:fireflutterchatapp/Views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final registerController = Get.put(RegisterController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var name = "";
  var email = "";
  var password = "";
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
        title: const Text('Register'),
      ),
      body: GetX<RegisterController>(
        builder: (controller) {
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
                                'Register',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (controller.error.isNotEmpty)
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                margin: const EdgeInsets.only(bottom: 30),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xffffe0e0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${controller.error}',
                                  style: TextStyle(
                                    color: Color(0xffa02020),
                                  ),
                                ),
                              ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width - 40,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'username',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person)),
                                keyboardType: TextInputType.text,
                                initialValue: name,
                                onChanged: (text) {
                                  setState(() {
                                    name = text;
                                  });
                                },
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
                                    )),
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
                                controller.register(name, email, password);
                              },
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Row(
                            children: [
                              const Text('Already have an account ?'),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Login'),
                              )
                            ],
                          ),
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
