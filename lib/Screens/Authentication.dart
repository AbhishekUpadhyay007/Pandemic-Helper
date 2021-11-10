import 'package:flutter/material.dart';
import './Verification.dart';

class Authentication extends StatefulWidget {
  static const routeName = '/AuthScreen';

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'Hi.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red[400],
                fontFamily: 'Ariel',
                fontWeight: FontWeight.bold,
                fontSize: 55),
          ),
          Text(
            'Proceed with your',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            'Login',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15, top: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red[400], width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  prefix: Text(
                    '+91 ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[400],
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: Colors.red[400],
                  ),
                  hintText: 'Enter phone number',
                  focusColor: Colors.red[400],
                  errorStyle: TextStyle(height: 0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  hoverColor: Colors.red[400]),
              onSubmitted: (string) {
                if (string.isEmpty || string.length < 10) {
                  return 'Please enter valid number';
                }
              },
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[400])),
              onPressed: () {
                if (textController.text.length == 10) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => VerificationPage(textController.text)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter Valid Number'),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                }
              },
              child: Text('Verify'))
        ],
      ),
    ));
  }
}
