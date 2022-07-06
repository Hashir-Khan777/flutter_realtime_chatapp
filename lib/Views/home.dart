import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireflutterchatapp/Controllers/home_controller.dart';
import 'package:fireflutterchatapp/Views/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final user;

  const Home({Key? key, this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homeController = Get.put(HomeController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeController.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('Users').snapshots();

    return StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Center(
                child: Text(
                  'Chat App',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
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
              automaticallyImplyLeading: false,
              title: const Center(
                child: Text(
                  'Chat App',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
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
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text(
                'Chat App',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  child: const Text(
                    'My account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text(widget.user['name']),
                  subtitle: Text(widget.user['email']),
                ),
                if (snapshot.hasData)
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      'Chats',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ListView(
                  primary: false,
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    if (widget.user['_id'] != data['_id']) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(Chat(
                            myData: widget.user,
                            userData: data,
                          ));
                        },
                        child: ListTile(
                          title: Text(data['name']),
                          subtitle: Text(data['email']),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
