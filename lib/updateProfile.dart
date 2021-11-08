import 'package:afpemergencyapplication/LogIn.dart';
import 'package:afpemergencyapplication/UserProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/UserModel.dart';

class UpdateProfile extends StatefulWidget {
  static const routeName = '/updateProfile';

  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  UserModel userModel = UserModel();

  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String uid = "";
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _uploadUserData();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pushReplacementNamed(context, UserProfile.routeName);
          },
        ),
        backgroundColor: Colors.green,
        title: const Text('Profile'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 25.0,
                  ),

                  Container(
                    height: 60,
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
                  Divider(
                    height: 8.0,
                    color: Colors.green[100],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    child: const Center(
                      child: Text(
                        "Details Update",
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 2.0,
                    shadowColor: Colors.green,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Form(
                        key: _formKey,
                        child: Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: TextFormField(
                                  controller: email,
                                  onSaved: (value) {
                                    setState(() {
                                      email.text = value!;
                                      if (kDebugMode) {
                                        print("email: $email");
                                      }
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Enter email");
                                    }
                                    if (!value.contains("@")) {
                                      return ("Please Enter a valid email");
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                  decoration: const InputDecoration(
                                    prefix: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    label: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.purple),
                                    ),
                                    hintText: 'email@gmail.com',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: TextFormField(
                                  // obscureText: true,
                                  controller: fullName,
                                  onSaved: (value) {
                                    //Do something with the user input.
                                    setState(() {
                                      fullName.text = value!;
                                    });
                                  },
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                  decoration: const InputDecoration(
                                    label: Text(
                                      'Full Names',
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.purple),
                                    ),
                                    hintText: 'Full Names',
                                    prefix: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: TextFormField(
                                  controller: phoneNumber,
                                  onSaved: (value) {
                                    setState(() {
                                      phoneNumber.text = value!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("10 digit number is required");
                                    }
                                    if (value.length < 10) {
                                      return ("Enter a valid phone number with 10 digits");
                                    } else if (value.length > 10) {
                                      return ("Too many digits entered");
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                  decoration: const InputDecoration(
                                    label: Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.purple),
                                    ),
                                    hintText: 'Phone Number',
                                    prefix: Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: TextFormField(
                                  // obscureText: true,
                                  controller: address,
                                  onSaved: (value) {
                                    //Do something with the user input.
                                    setState(() {
                                      address.text = value!;
                                    });
                                  },
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                  decoration: InputDecoration(
                                    label: const Text('Address'),
                                    hintText: 'Address',
                                    // prefix: const Icon(
                                    //   Icons.my_location,
                                    //   color: Colors.grey,
                                    // ),
                                    suffix: IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.my_location),
                                      color: Colors.green,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  //////////////buttons///////////////

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          // foregroundColor:
                          //     MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      side: const BorderSide(
                                          color: Colors.green)))),
                      onPressed: () {
                        _uploadUserData();
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const Divider(
                    height: 4.0,
                    color: Colors.grey,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: const Text(
                        "SOCORO",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),
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

  ///////////////////////////////////////////
  //            fetch user data            //
  //////////////////////////////////////////
  Future<void> _getUserData() async {
    //instantiate the classes
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    await firebaseFirestore
        .collection('users')
        // .document((await FirebaseAuth.instance.currentUser()).uid)
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        fullName.text = value.data()!['fullName'].toString();
        email.text = value.data()!['email'].toString();
        phoneNumber.text = value.data()!['phoneNumber'].toString();
        address.text = value.data()!['address'].toString();
      });
    });
  }

  ///////////////////////////////////////////
  //           upload user data           //
  //////////////////////////////////////////
  Future<void> _uploadUserData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      //writing to firebase
      //adding the details to the constructor
      await firebaseFirestore.collection("users").doc(user?.uid).update({
        'fullName': fullName.text,
        'email': email.text,
        'phoneNumber': phoneNumber.text,
        'address': address.text
      }).whenComplete(
        () => Fluttertoast.showToast(
            msg: 'Update Complete',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16),
      ); //writing to firebase
    } catch (e) {
      setState(() {
        const CircularProgressIndicator(
          backgroundColor: Colors.red,
        );
      });
      Fluttertoast.showToast(
          msg: '$e',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16);
    }
  }
}
