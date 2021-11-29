import 'package:afpemergencyapplication/RequestAndHistory/FireFighterRequest.dart';
import 'package:afpemergencyapplication/models/GetLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class EditFireFighterRequest extends StatefulWidget {
  const EditFireFighterRequest({Key? key}) : super(key: key);
  static const routeName = '/editFireFighterRequest';

  @override
  _EditFireFighterRequestState createState() => _EditFireFighterRequestState();
}

class _EditFireFighterRequestState extends State<EditFireFighterRequest> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey();
  GetLocation getLocation = GetLocation();
  Logger log = Logger(printer: PrettyPrinter(colors: true));

  // String uid = "";
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController emergencyTypeRequest = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> fireFighterRequestStream = FirebaseFirestore.instance
        .collection("fire-fighter-request")
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, FireFighterRequest.routeName, (route) => false);
          },
        ),
        backgroundColor: Colors.green,
        title: const Text('Edit My Fire Request'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: fireFighterRequestStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //TO DO
          if (snapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Something went wrong'),
                SizedBox(
                  height: 10.0,
                ),
                CircularProgressIndicator(),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Loading information'),
                CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ],
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                child: Card(
                  elevation: 8,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //////////////////////////
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: TextFormField(
                              controller: emergencyTypeRequest,
                              onSaved: (value) {
                                setState(() {
                                  emergencyTypeRequest.text = value!;
                                });
                              },
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.purple),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Emergency Type',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.purple),
                                ),
                                hintText: 'Enter Emergency Type',
                                prefix: Icon(
                                  Icons.help,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5, top: 5),
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
                              bottom: 5,
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
                              bottom: 5,
                            ),
                            child: TextFormField(
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
                                suffix: IconButton(
                                  onPressed: () async {
                                    getLocation.currentPosition;
                                    log.i(getLocation.getCurrentLocation());

                                    if (kDebugMode) {
                                      print(getLocation.getCurrentLocation());
                                    }
                                    setState(() {
                                      address.text =
                                          getLocation.currentAddress!;
                                    });
                                  },
                                  icon: const Icon(Icons.my_location),
                                  color: Colors.green,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await firebaseFirestore
                                    .collection('fire-fighter-request')
                                    .doc(document.id)
                                    .get()
                                    .then(
                                  (value) {
                                    setState(
                                      () {
                                        // String uid = "";
                                        fullName.text = data['fullName'];
                                        email.text = data['email'];
                                        phoneNumber.text = data['phoneNumber'];
                                        address.text = data['address'];
                                        emergencyTypeRequest.text =
                                            data['emergencyTypeRequest'];
                                      },
                                    );
                                  },
                                );
                              } catch (e) {
                                setState(() {
                                  const CircularProgressIndicator();
                                });
                                Fluttertoast.showToast(
                                    msg: '$e',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16);
                              }
                            },
                            child: const Text(
                              "Get information",
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                  // foregroundColor:
                                  //     MaterialStateProperty.all<Color>(Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          side: const BorderSide(
                                              color: Colors.green)))),
                              onPressed: () async {
                                //Send this information to the database
                                setState(() {
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                                try {
                                  //writing to firebase
                                  //adding the details to the constructor
                                  await firebaseFirestore
                                      .collection("fire-fighter-request")
                                      .doc(document.id)
                                      .update({
                                    'fullName': fullName.text,
                                    'email': email.text,
                                    'phoneNumber': phoneNumber.text,
                                    'address': address.text,
                                    'emergencyTypeRequest':
                                        emergencyTypeRequest.text,
                                  }).whenComplete(
                                    () => Fluttertoast.showToast(
                                        msg: 'Update Complete',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16),
                                  ); //writing to firebase
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      FireFighterRequest.routeName,
                                      (route) => false);
                                } catch (e) {
                                  setState(() {
                                    const CircularProgressIndicator();
                                  });
                                  Fluttertoast.showToast(
                                      msg: '$e',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16);
                                }
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
