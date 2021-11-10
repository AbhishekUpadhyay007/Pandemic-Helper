import 'dart:io';

import 'package:covid/Screens/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  static const routeName = './profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  var dbRef = FirebaseDatabase.instance.reference().child('UserInfo');
  var storageRef = FirebaseStorage.instance.ref();
  var mAuth = FirebaseAuth.instance;
  Map<dynamic, dynamic> map;
  bool isPhotoUploading = false;
  var _profileUrl;

  @override
  void initState() {
    super.initState();
    print('profile called');
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      dbRef.child(mAuth.currentUser.uid).once().then((snapshot) {
        map = snapshot.value;
        setState(() {});
        _fetchUserProfile();
        // print(map);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      _profileUrl = await storageRef
          .child('Users Profile')
          .child(FirebaseAuth.instance.currentUser.uid)
          .getDownloadURL()
          .whenComplete(() {
        setState(() {});
      }).onError((error, stackTrace) {
        throw Exception('File Not Exists');
      });
    } catch (error) {
      print(error);
    }
  }

  _imageFromGalary() async {
    try {
      PickedFile image = await ImagePicker.platform
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (image.path == null) {
        return;
      }
      _uploadOnServer(image);
    } catch (error) {
      print('Something went wrong $error');
    }
  }

  _uploadOnServer(PickedFile image) async {
    try {
      setState(() {
        isPhotoUploading = true;
      });
      storageRef
          .child('Users Profile')
          .child(FirebaseAuth.instance.currentUser.uid)
          .putFile(File(image.path))
          .whenComplete(() {
        print('uploaded');
        isPhotoUploading = false;
        _fetchUserProfile();
      });
    } catch (error) {
      print('Something went Wrong');
    }
  }

  _imageFromCamera() async {
    try {
      PickedFile image = await ImagePicker.platform
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      if (image.path == null) {
        return;
      }
      _uploadOnServer(image);
    } catch (error) {
      print('Something went wrong $error');
    }
  }

  Future<void> _uploadProfile() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imageFromGalary();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imageFromCamera()();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void updateUi() async {
    DataSnapshot data = await dbRef.child(mAuth.currentUser.uid).get();
  }

  Widget _editDialogBox(BuildContext context) {
    var name = TextEditingController(text: map['name']);
    var email = TextEditingController(text: map['email']);
    var address = TextEditingController(text: map['address']);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 270,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' Update',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.account_circle_outlined)),
                    ),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline)),
                    ),
                    TextField(
                        controller: address,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.home_max_outlined))),
                    SizedBox(
                      width: 320.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.pink),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                        ),
                        onPressed: () {
                          try {
                            dbRef.child(mAuth.currentUser.uid).set({
                              'address': address.text.toString(),
                              'email': email.text,
                              'name': name.text,
                              'phone': mAuth.currentUser.phoneNumber.toString(),
                              'userId': mAuth.currentUser.uid.toString()
                            }).whenComplete(() {
                              Navigator.pop(context);
                              _fetchUserData();
                            });
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .3,
              width: double.infinity,
              color: Colors.pinkAccent,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.pink[400],
                        backgroundImage: _profileUrl != null
                            ? NetworkImage(_profileUrl)
                            : AssetImage('assets/images/signedout.png'),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 10,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            onPressed: _uploadProfile,
                            icon: Icon(
                              Icons.image,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      if (isPhotoUploading)
                        Positioned(
                          left: 62,
                          top: 62,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  if (map != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        map['name'],
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _userDetailsRow('Name', 'name'),
            _userDetailsRow('Email', 'email'),
            _userDetailsRow('Phone', 'phone'),
            _userDetailsRow('Address', 'address'),
            TextButton.icon(
                onPressed: () => _editDialogBox(context),
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.pink[400],
                ),
                label: Text('Edit', style: TextStyle(color: Colors.pink[400]))),
            Divider(
              height: 2,
              thickness: 1,
              color: Colors.pink,
            ),
            TextButton.icon(
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                overlayColor: MaterialStateProperty.all<Color>(Colors.pink[50]),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(
                    context, Authentication.routeName);
              },
              icon: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.pink[400],
              ),
              label: Text('Logout', style: TextStyle(color: Colors.pink[400])),
            ),
            Divider(
              height: 1,
            ),
            TextButton.icon(
              style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.pink[50])),
              onPressed: () async {
                final Uri params = Uri(
                    scheme: 'mailto',
                    path: 'uabhi641@gmail.com',
                    query:
                        'subject=Covid-help bug query: initial release Feedback&body=*Please describe in 50 words*');

                if (await canLaunch(params.toString())) {
                  await launch(params.toString());
                } else {
                  throw 'Could not launch ${params.toString()}';
                }
              },
              icon: Icon(Icons.email_outlined, color: Colors.pink[400]),
              label: Text(
                'Report Bugs',
                style: TextStyle(color: Colors.pink[400]),
              ),
            ),
            TextButton.icon(
              style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.pink[50])),
              onPressed: () {},
              icon: Icon(Icons.note_alt_outlined, color: Colors.pink[400]),
              label: Text(
                'About us',
                style: TextStyle(color: Colors.pink[400]),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _userDetailsRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          map == null
              ? CircularProgressIndicator(
                  value: 5,
                )
              : Text(
                  map[val],
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.pink[400]),
                )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
