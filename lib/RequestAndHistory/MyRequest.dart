import 'package:afpemergencyapplication/MainSreens/HomeScreen.dart';
import 'package:afpemergencyapplication/RequestAndHistory/EditRequest.dart';
import 'package:afpemergencyapplication/RequestAndHistory/MainAlertTypeScreen.dart';
import 'package:afpemergencyapplication/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class MyRequest extends StatefulWidget {
  const MyRequest({Key? key}) : super(key: key);
  static const routeName = '/myRequestScreen';

  @override
  _MyRequestState createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  Logger logger = Logger();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  UserModel userModel = UserModel();
  List requestList = [];
  String uid = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> ambulanceRequestStream = FirebaseFirestore.instance
        .collection("ambulance-requests")
        .where('owner', isEqualTo: user!.uid)
        .snapshots();
    // Stream<QuerySnapshot> fireRequestStream = FirebaseFirestore.instance
    //     .collection("fire-fighter-request")
    //     .where('owner', isEqualTo: user!.uid)
    //     .snapshots();
    // Stream<QuerySnapshot> policeRequestStream = FirebaseFirestore.instance
    //     .collection("police-requests")
    //     .where('owner', isEqualTo: user!.uid)
    //     .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        title: const Text("My Request"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainAlertTypeScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.house),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmergencyType(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ambulanceRequestStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //TO DO
          if (snapshot.hasError) {
            return Stack(
              children: const [
                Text('Something went wrong'),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: const [
                Text('Loading information'),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        data['fullName'],
                        style: const TextStyle(color: Colors.green),
                      ),
                      subtitle: ExpansionTile(
                        title: const Text(
                          "More",
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        children: [
                          const Text(
                            "EM Type: ",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            data['emergencyTypeRequest'],
                            style: const TextStyle(
                              color: Colors.purple,
                            ),
                          ),
                          const Text("Phone Number"),
                          Text(
                            data["phoneNumber"],
                            style: const TextStyle(
                              letterSpacing: 3,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   data['emergencyTypeRequest'],
                      //   style: const TextStyle(color: Colors.red),
                      // ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(
                          data['fullName'][0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height + 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Address",
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(
                              data['address'],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () async {
                              setState(() {
                                const CircularProgressIndicator();
                              });
                              try {
                                FirebaseFirestore.instance
                                    .collection('ambulance-requests')
                                    .doc(document.id)
                                    .delete()
                                    .then((value) => logger.i(document.id));
                                Fluttertoast.showToast(
                                    msg: 'Request Deleted',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.grey,
                                    fontSize: 16.0);
                              } catch (error) {
                                logger.i("failed $error ");
                                Fluttertoast.showToast(
                                    msg: 'Request failed to Deleted $error',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.grey,
                                    fontSize: 16.0);
                              }
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  EditRequest.routeName, (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
