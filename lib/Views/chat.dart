import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireflutterchatapp/Controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class Chat extends StatefulWidget {
  final myData;
  final userData;

  const Chat({Key? key, this.myData, this.userData}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chatController = Get.put(ChatController());
  var uniqueId;
  final TextEditingController _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    if ('${widget.myData['_id']}'.compareTo('${widget.userData['_id']}') < 0) {
      uniqueId = widget.myData['_id'] + widget.userData['_id'];
    } else {
      uniqueId = widget.userData['_id'] + widget.myData['_id'];
    }
    chatController.fetchMessages(uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _chatsStream = FirebaseFirestore.instance
        .collection('Chats/$uniqueId/messages')
        .orderBy('time', descending: false)
        .snapshots();

    return StreamBuilder(
      stream: _chatsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  '${widget.userData['name']}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            body: const Center(
              child: Text('Something went wrong'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  '${widget.userData['name']}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                '${widget.userData['name']}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          title: Align(
                            alignment:
                                data['sender'] == '${widget.myData['_id']}'
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Text(
                              data['message'],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(6),
                  child: TextFormField(
                    controller: _message,
                    decoration: InputDecoration(
                      hintText: 'write a message...',
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (_message.text.isNotEmpty) {
                            chatController.sendMessage(
                              _message.text,
                              widget.myData['_id'],
                              widget.userData['_id'],
                              uniqueId,
                            );
                          }
                          _message.clear();
                        },
                        child: Transform.rotate(
                          angle: -math.pi / 4,
                          child: const Icon(Icons.send),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
