import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutterchatapp/Views/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var loading = false.obs;
  var error = "".obs;

  register(name, email, password) async {
    loading.value = true;
    try {
      if (name == null && email == null && password == null) {
        loading.value = false;
        error.value = "Name, Email and Password can't be empty";
      } else {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);
        await firestore.collection('Users').doc(userCredential.user?.uid).set({
          '_id': userCredential.user?.uid,
          'name': name,
          'email': email,
          'password': password,
        });
        _prefs.then(
          (prefs) => {
            prefs.setString(
              'user',
              json.encode(
                {
                  '_id': userCredential.user?.uid,
                  'name': name,
                  'email': email,
                  'password': password,
                },
              ),
            ),
          },
        );
        loading.value = false;
        Get.offAll(Home(
          user: {
            '_id': userCredential.user?.uid,
            'name': name,
            'email': email,
            'password': password,
          },
        ));
      }
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      error.value = '${e.message}';
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
    }
    var future = Future.delayed(Duration(seconds: 4));
    future.asStream().listen((event) {
      error.value = "";
    });
  }
}
