import 'package:covid/Screens/Authentication.dart';
import 'package:covid/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  static const routeName = '/Signupform';

  final _formkey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  // final _phoneController = TextEditingController();

  var dbRef = FirebaseDatabase.instance.reference().child('UserInfo');

  void _validateFields(BuildContext context) async {
    try {
      bool validate = _formkey.currentState.validate();
      if (validate) {
        dbRef.child(FirebaseAuth.instance.currentUser.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'phone': FirebaseAuth.instance.currentUser.phoneNumber,
          'userId': FirebaseAuth.instance.currentUser.uid
        }).then((_) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => MyHomePage()),
              ModalRoute.withName(Authentication.routeName));
        });
      }
    } catch (error) {
      print('Something went wrong: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formkey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome,',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.red[400],
                      // fontFamily: 'Ariel',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Please enter below details to create new account',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Note: Please provide valid details',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Name',
                    style: Theme.of(context).textTheme.headline4,
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    cursorHeight: 20,
                    cursorColor: Colors.red[400],
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                        hintText: 'Enter your name here',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        prefixIcon: Icon(Icons.account_box_outlined,
                            color: Colors.red[400])),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Provide your name here!';
                      }
                      return null;
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Email',
                    style: Theme.of(context).textTheme.headline4,
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(bottom: 15, top: 10),
                  child: TextFormField(
                    cursorHeight: 20,
                    cursorColor: Colors.red[400],
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                        hintText: 'Enter Email Here',
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        // disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        border: InputBorder.none,
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.red[400])),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email field is Mandatory!';
                      }
                      return null;
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Address',
                    style: Theme.of(context).textTheme.headline4,
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    cursorHeight: 20,
                    cursorColor: Colors.red[400],
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                        hintText: 'Enter Address here',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        prefixIcon:
                            Icon(Icons.home_outlined, color: Colors.red[400])),
                    controller: _addressController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Provide your name here!';
                      }
                      return null;
                    },
                  ),
                ),
                // RichText(
                //   text: TextSpan(
                //     text: 'Phone Number',
                //     style: Theme.of(context).textTheme.headline4,
                //     children: [
                //       TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: const EdgeInsets.only(bottom: 15, top: 10),
                //   decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black, width: 1),
                //       borderRadius: BorderRadius.circular(20)),
                //   child: TextFormField(
                //     cursorHeight: 20,
                //     cursorColor: Colors.red[400],
                //     decoration: InputDecoration(
                //         hintStyle: TextStyle(
                //           fontSize: 16,
                //         ),
                //         hintText: 'Enter your phone number',
                //         focusedBorder: InputBorder.none,
                //         enabledBorder: InputBorder.none,
                //         errorBorder: InputBorder.none,
                //         disabledBorder: InputBorder.none,
                //         contentPadding: EdgeInsets.all(15),
                //         prefixIcon: Icon(Icons.mobile_screen_share_outlined,
                //             color: Colors.red[400])),
                //     controller: _phoneController,
                //     keyboardType: TextInputType.name,
                //     validator: (value) {
                //       if (value.isEmpty) {
                //         return 'Phone number is mandatory';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[400]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () => _validateFields(context),
                      icon: Icon(Icons.arrow_right_alt_outlined),
                      label: Text(
                        'Signup',
                        style: TextStyle(fontSize: 16),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
