import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var messages = [].obs;

  void fetchMessages(uniqueId) {
    var allMessages = [];
    firestore.collection('Chats/$uniqueId/messages').get().then((value) {
      allMessages = value.docs.map((e) => e.data()).toList();
      allMessages.sort((a, b) => a?['time'].compareTo(b?['time']));
      messages.value = allMessages;
    });
  }

  void sendMessage(message, myId, userId, uniqueId) {
    var allMessages = [];
    var docId = firestore.collection('Chats').doc().id;
    messages.add({
      '_id': docId,
      'sender': myId,
      'receiver': userId,
      'message': message,
    });
    firestore.collection('Chats/$uniqueId/messages').doc(docId).set({
      '_id': docId,
      'sender': myId,
      'receiver': userId,
      'message': message,
      'time': DateTime.now()
    });
    firestore.collection('Chats/$uniqueId/messages').get().then((value) {
      allMessages = value.docs.map((e) => e.data()).toList();
      allMessages.sort((a, b) => a?['time'].compareTo(b?['time']));
      messages.value = allMessages;
    });
  }
}
