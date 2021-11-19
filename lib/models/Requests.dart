class Request {
  String? uid;
  String? email;
  String? phoneNumber;
  String? emergencyTypeRequest;
  String? fullName;
  String? address;

  Request(
      {this.uid,
      this.email,
      this.phoneNumber,
      this.emergencyTypeRequest,
      this.fullName,
      this.address});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email.toString(),
      'phoneNumber': phoneNumber,
      'emergencyTypeRequest': emergencyTypeRequest,
      'fullName': fullName,
      'address': address,
    };
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // User? user = FirebaseAuth.instance.currentUser;
    //
    // Future<void> addUser() {
    //   // Call the user's CollectionReference to add a new user
    //   return users
    //       .add({
    //         'uid': uid,
    //         'email': email.toString(),
    //         'phoneNumber': phoneNumber,
    //         'emergencyTypeRequest': emergencyTypeRequest,
    //         'fullName': fullName,
    //         'address': address,
    //       })
    //       .then(
    //         (value) => Fluttertoast.showToast(msg: "Successfully requested"),
    //       )
    //       .catchError(
    //         (error) =>
    //             Fluttertoast.showToast(msg: "failed to send details $error"),
    //       );
  }
}
