import 'package:afpemergencyapplication/HomeScreen.dart';
import 'package:afpemergencyapplication/LogIn.dart';
import 'package:afpemergencyapplication/updateProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/UserModel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  static const routeName = '/UserProfile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  bool showProgressBar = false;
  bool progressBar = false;

  String uid = "";
  String email = "";
  String phoneNumber = "";
  String fullName = "";
  String address = "";

  @override
  void initState() {
    super.initState();
    // _fetch();
    // FirebaseFirestore.instance.collection("users").doc().get().then(
    //     (value) => userModel = UserModel.fromMap(value.data().toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pushReplacementNamed(context, EmergencyType.routeName);
          },
        ),
        backgroundColor: Colors.green,
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, UpdateProfile.routeName);
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  height: 70,
                  margin: const EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.my_location,
                      size: 70,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "My Profile",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                /////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////
                ////////////////////////////////////////////////////////////////////////

                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 2.0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: _fetch(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              "$fullName",
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return const Text("Loading data, please wait");
                          }
                        },
                      ),
                    ),
                  ),
                ),
                /////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////
                ////////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await firebaseAuth.signOut();
                      Navigator.pushReplacementNamed(context, LogIn.routeName);
                    },
                    child: const Text(
                      "Sign out",
                      style:
                          TextStyle(fontFamily: 'Mplus', color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogIn()));
    setState(() {});
  }

  _fetch() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((value) {
        userModel = UserModel.fromMap(value.data());
      });
    }
  }

///////////////////////////////////////////////////////////////

}
