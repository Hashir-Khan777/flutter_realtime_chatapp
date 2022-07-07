import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutterchatapp/Views/home.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var loading = false.obs;
  var error = "".obs;

  login(email, password) async {
    loading.value = true;
    try {
      if (email == null && password == null) {
        loading.value = false;
        error.value = "Email and Password can't be empty";
      } else {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        await firestore
            .collection('Users')
            .doc(userCredential.user?.uid)
            .get()
            .then((value) {
          _prefs.then(
            (prefs) => {
              prefs.setString('user', json.encode(value.data())),
            },
          );
          loading.value = false;
          Get.offAll(Home(
            user: value.data(),
          ));
        });
      }
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      error.value = '${e.message}';
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
    }
    var future = Future.delayed(const Duration(seconds: 4));
    future.asStream().listen((event) {
      error.value = "";
    });
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      loading.value = true;
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await firestore.collection('Users').doc(userCredential.user?.uid).set({
        '_id': userCredential.user?.uid,
        'email': userCredential.user?.email,
        'name': userCredential.user?.displayName,
      });
      _prefs.then(
        (prefs) => {
          prefs.setString(
            'user',
            json.encode(
              {
                '_id': userCredential.user?.uid,
                'email': userCredential.user?.email,
                'name': userCredential.user?.displayName,
              },
            ),
          ),
        },
      );
      firestore
          .collection('Users')
          .doc(userCredential.user?.uid)
          .get()
          .then((value) {
        loading.value = false;
        Get.offAll(Home(
          user: value.data(),
        ));
      });
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      error.value = '${e.message}';
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
    }
    var future = Future.delayed(const Duration(seconds: 4));
    future.asStream().listen((event) {
      error.value = "";
    });
  }

  signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      loading.value = true;
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      var userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      await firestore.collection('Users').doc(userCredential.user?.uid).set({
        '_id': userCredential.user?.uid,
        'email': userCredential.user?.email,
        'name': userCredential.user?.displayName,
      });
      _prefs.then(
        (prefs) => {
          prefs.setString(
            'user',
            json.encode(
              {
                '_id': userCredential.user?.uid,
                'email': userCredential.user?.email,
                'name': userCredential.user?.displayName,
              },
            ),
          ),
        },
      );
      firestore
          .collection('Users')
          .doc(userCredential.user?.uid)
          .get()
          .then((value) {
        loading.value = false;
        Get.offAll(Home(
          user: value.data(),
        ));
      });
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      error.value = '${e.message}';
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
    }
    var future = Future.delayed(const Duration(seconds: 4));
    future.asStream().listen((event) {
      error.value = "";
    });
  }
}
