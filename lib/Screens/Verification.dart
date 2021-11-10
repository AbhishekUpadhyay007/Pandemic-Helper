import 'package:covid/Screens/SignUpForm.dart';
import 'package:covid/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage(this.number);
  final String number;

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _smsController = TextEditingController();
  var _verificationId;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.reference().child('UserInfo');

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber(widget.number);
  }

  void verifyPhoneNumber(String number) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91$number',
          verificationCompleted: (PhoneAuthCredential credential) {
            var code = credential.smsCode;
            _smsController.text = code;
            mAuth.signInWithCredential(credential);
            // print('Verfication Completed! with ${mAuth.currentUser. uid}');
            var q = dbRef.orderByChild('phone').equalTo("+91$number");
            q.once().then((value) {
              if (value.value == null) {
                Navigator.of(context).pushNamed(SignUpForm.routeName);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(MyHomePage.routeName);

                print(value.value);
              }
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
              Navigator.of(context).pop('invalid');
              return;
            }

            print('Phone verfication failed: ${e.message}');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Phone verfication failed: ${e.message}')));
          },
          codeSent: (String verificationId, int resendToken) async {
            _verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          });
    } catch (error) {
      print('Something went wrong: ' + error);
    }
  }

  void signInWithPhoneNumber(context) async {
    try {
      // final AuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: _verificationId, smsCode: _smsController.text);

      // final User user = (await mAuth.signInWithCredential(credential)).user;
      var q = dbRef.orderByChild('phone').equalTo('+91${widget.number}');
      q.once().then((value) {
        if (value.value == null) {
          Navigator.of(context).pushNamed(SignUpForm.routeName);
        } else {
          Navigator.of(context).popAndPushNamed(MyHomePage.routeName);

          print(value.value);
        }
      });

      print('Signed in successfully');
    } catch (error) {
      print('Failed to sign in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.red),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontWeight: FontWeight.bold),
                controller: _smsController,
                maxLength: 6,
                decoration: InputDecoration(
                    hintText: 'OTP',
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.ac_unit),
              label: Text('Sign in'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[400])),
              onPressed: () {
                if (_smsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter OTP first'),
                    ),
                  );
                  return;
                }

                signInWithPhoneNumber(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
