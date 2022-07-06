import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var users = [].obs;

  fetchUsers() async {
    await firestore.collection('Users').get().then((value) {
      var data = [];
      for (var element in value.docs) {
        data.add(element.data());
      }
      users.value = data;
    });
  }
}
