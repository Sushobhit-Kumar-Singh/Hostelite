import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hostelite/student_screens/home_screen_Student.dart';
import 'package:geolocator/geolocator.dart';

class MarkingEntry extends StatefulWidget {
  const MarkingEntry({Key? key}) : super(key: key);

  @override
  _MarkingEntryState createState() => _MarkingEntryState();
}

Dialog leadDialog = Dialog(
  child: Container(
    height: 300,
    width: 360,
    child: Column(
      children: <Widget>[
        Center(
          child: Image(
            image: AssetImage('assets/create_account_page/Vector.png'),
            height: 150,
            width: 150,
          ),
        ),
        Text(
          'Entry Marked',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Successfully',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Container(
          width: 150.0,
          height: 40.0,
          child: Builder(builder: (context) {
            return MaterialButton(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              color: Colors.pinkAccent[100],
              minWidth: 100.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeScreenStudent();
                }));
              },
            );
          }),
        ),
      ],
    ),
  ),
);

//Dialog to be displayed when the user is late (after 9 pm)
Dialog leadDialogLate = Dialog(
  child: Container(
    height: 300,
    width: 360,
    child: Column(
      children: <Widget>[
        Center(
          child: Image(
            image: AssetImage('assets/create_account_page/Vector.png'),
            height: 150,
            width: 150,
          ),
        ),
        Text(
          'You are late',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'for entry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Container(
          width: 150.0,
          height: 40.0,
          child: Builder(builder: (context) {
            return MaterialButton(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              color: Colors.pinkAccent[100],
              minWidth: 100.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeScreenStudent();
                }));
              },
            );
          }),
        ),
      ],
    ),
  ),
);

//another dialog to be implemented later when the user is not at hostel

class _MarkingEntryState extends State<MarkingEntry> {
  var db = FirebaseFirestore.instance;
  bool isLocationLoading = false;
  bool isLoading = false;
  List alerts = [];
  int? entrytoken;
  String? roomNumber;
  String? rollNumber;
  String? studentloc;
  String? hostel;
  var nowTime = DateTime.now();
  var locationMessage = '';
  late Position position;

  var stdentdb = FirebaseFirestore.instance
      .collection("studentUsers")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("exit");

  var entrydbcol = FirebaseFirestore.instance
      .collection("studentUsers")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("entry");

  var entryadmindb = FirebaseFirestore.instance.collection("Exits");

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage = 'Location Not Available!';
        });
      }
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      isLocationLoading = false;
      locationMessage =
          'Longitude: ${position.longitude} \n Latitude: ${position.latitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Entry'),
        backgroundColor: Color(0xFFFE96FA),
        foregroundColor: Color(0xFF4E4E4E),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/second_page/Group 33694.png'),
                  fit: BoxFit.contain)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Roll No.',
                        filled: true,
                        fillColor: Color(0xffFFFFFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 1.0)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          rollNumber = value.trim();
                        });
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Room No.',
                        filled: true,
                        fillColor: Color(0xffFFFFFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 1.0)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          roomNumber = value.trim();
                        });
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Hostel Name',
                        filled: true,
                        fillColor: Color(0xffFFFFFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 1.0)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          hostel = value.trim();
                        });
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter token provided during exit',
                        filled: true,
                        fillColor: Color(0xffFFFFFF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.cyan, width: 1.0)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          entrytoken = int.parse(value);
                        });
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white38.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(1, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              child: Text('Your Location',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(locationMessage,
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                MaterialButton(
                  child: isLocationLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.0,
                          ),
                          height: 10,
                          width: 10,
                        )
                      : Text(
                          'Get location',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                  color: Color(0xffFE96FA),
                  minWidth: 100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () {
                    if (isLocationLoading) return;
                    setState(() {
                      isLocationLoading = true;
                    });
                    getCurrentLocation();
                  },
                ),
                SizedBox(height: 40),
                Container(
                  width: 130,
                  height: 50,
                  child: MaterialButton(
                    child: isLoading
                        ? SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                            height: 25,
                            width: 25,
                          )
                        : Text(
                            'Mark Entry',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15),
                          ),
                    color: Color(0xffFE96FA),
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () async {
                      if (isLoading) return;
                      setState(() {
                        isLoading = true;
                      });
                      if (roomNumber == null ||
                          rollNumber == null ||
                          hostel == null ||
                          locationMessage == '') {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter all fields")));
                        return;
                      }
                      if ((nowTime.hour >= 21)) {
                        FirebaseFirestore.instance.collection('alerts').add({
                          "position": position.toString(),
                          "name":
                              FirebaseAuth.instance.currentUser!.displayName,
                          "rollNumber": rollNumber,
                          "roomNumber": roomNumber,
                          "hostel": hostel,
                          "userUid": FirebaseAuth.instance.currentUser!.uid,
                          "time": DateTime.now().toLocal(),
                        });
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => leadDialogLate);
                      } else {
                        stdentdb
                            .where("token", isEqualTo: entrytoken)
                            .where("rollNumber", isEqualTo: rollNumber)
                            .where("roomNumber", isEqualTo: roomNumber)
                            .where("hostelName", isEqualTo: hostel)
                            .get()
                            .then((snapshots) => {
                                  if (snapshots.size == 1)
                                    {
                                      for (var snapshot in snapshots.docs)
                                        {
                                          stdentdb.doc(snapshot.id).update({
                                            "entryTime":
                                                DateTime.now().toLocal(),
                                            "token": "0"
                                          })
                                        }
                                    }
                                });
                        entryadmindb
                            .where("token", isEqualTo: entrytoken)
                            .where("rollNumber", isEqualTo: rollNumber)
                            .where("roomNumber", isEqualTo: roomNumber)
                            .where("hostelName", isEqualTo: hostel)
                            .get()
                            .then((snapshots) => {
                                  if (snapshots.size == 1)
                                    {
                                      for (var snapshot in snapshots.docs)
                                        {
                                          entryadmindb.doc(snapshot.id).update({
                                            "entryTime":
                                                DateTime.now().toLocal(),
                                            "token": "0"
                                          })
                                        }
                                    }
                                });
                        entrydbcol.add({
                          "name": FirebaseAuth.instance.currentUser!.email,
                          "rollNumber": rollNumber,
                          "roomNumber": roomNumber,
                          "hostel": hostel,
                          "userUid": FirebaseAuth.instance.currentUser!.uid,
                          "time": DateTime.now().toLocal(),
                          "location": locationMessage,
                        });
                        FirebaseFirestore.instance.collection('Entries').add({
                          "name": FirebaseAuth.instance.currentUser!.email,
                          "rollNumber": rollNumber,
                          "roomNumber": roomNumber,
                          "hostel": hostel,
                          "userUid": FirebaseAuth.instance.currentUser!.uid,
                          "time": DateTime.now().toLocal(),
                          "location": locationMessage,
                        });

                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => leadDialog);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
