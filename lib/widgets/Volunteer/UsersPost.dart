import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../http/PostListener.dart';

// ignore: must_be_immutable
class UsersPost extends StatefulWidget {
  final Map<dynamic, dynamic> post;
  UsersPost(this.post);

  @override
  _UsersPostState createState() => _UsersPostState();
}

class _UsersPostState extends State<UsersPost> {
  final dbRef = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> likedBy;
  bool isLiked = false;
  bool isScaffoldOpen = false;
  Map<dynamic, dynamic> uMap;
  final mAuth = FirebaseAuth.instance;
  final storageRef = FirebaseStorage.instance.ref();

  var userId;

  var url;
  var future, _nameFuture;

  @override
  void initState() {
    super.initState();
    userId = mAuth.currentUser.uid;

    future = storageRef.child('Users Profile').child(userId).getDownloadURL();
    _nameFuture = dbRef.child('UserInfo').child(userId).once();
  }

  void _showHelpBottomSheet(BuildContext context) {
    isScaffoldOpen = true;
    Scaffold.of(context).showBottomSheet((context) {
      return FutureBuilder(
        future: dbRef.child('UserInfo').child(userId).once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          var map = snapshot.data.value;
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.purple, blurRadius: 10.0)
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        'You are going to do a great job',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                      ListTile(
                        title: Text(
                          'Email them on:',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          map['email'],
                          style: TextStyle(color: Colors.amber[800]),
                        ),
                        trailing: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.email_outlined,
                            color: Colors.amber[800],
                          ),
                          label: Text(
                            'Email',
                            style: TextStyle(
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Call this user via:',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          map['phone'],
                          style: TextStyle(color: Colors.amber[800]),
                        ),
                        trailing: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.call,
                              color: Colors.amber[800],
                            ),
                            label: Text(
                              'Call',
                              style: TextStyle(
                                  color: Colors.amber[800],
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    var dateTimeString = widget.post['datetime'].toString();
    final dateTime = DateTime.parse(dateTimeString);
    final curr = DateTime.now();
    var diff = curr.difference(dateTime).inDays;

    // print(diff);
    var clockString;
    if (diff == 0) {
      final format = DateFormat('HH:mm a');
      clockString = 'Today at ${format.format(dateTime)}';
    } else if (diff <= 5 && diff >= 1) {
      final format = DateFormat('HH:mm a');
      clockString = '$diff days ago at ${format.format(dateTime)}';
    } else {
      final format = DateFormat('dd/MM/yyyy HH:mm a');
      clockString = format.format(dateTime);
    }

    return Padding(
      padding: isVertical
          ? EdgeInsets.symmetric(horizontal: 1)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
              child: Row(
                children: [
                  FutureBuilder(
                      future: future,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/signedout.png'),
                          );
                        }

                        return CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(snapshot.data));
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  FutureBuilder(
                      future: _nameFuture,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Fetching...');
                        }

                        return Text(snapshot.data.value['name']);
                      }),
                ],
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: .7,
            color: Colors.purple,
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post['title'],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(widget.post['description'],
                      style: Theme.of(context).textTheme.headline4),
                ],
              ),
            ),
          ),
          if (widget.post['images'] != null)
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 250,
              child: Carousel(
                  dotSize: 4.0,
                  dotIncreaseSize: 1.8,
                  dotSpacing: 12,
                  dotVerticalPadding: 0,
                  dotBgColor: Colors.transparent,
                  autoplay: true,
                  dotColor: Colors.grey,
                  dotIncreasedColor: Colors.purple,
                  dotPosition: DotPosition.bottomRight,
                  autoplayDuration: Duration(milliseconds: 3000),
                  animationDuration: Duration(milliseconds: 600),
                  images: widget.post['images']
                      .map(
                        (item) => Image(
                            image: NetworkImage(item.toString()),
                            fit: BoxFit.contain),
                      )
                      .toList()),
            ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text(
              'Uploaded on: $clockString',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              'Liked by other(s)',
              style: TextStyle(fontSize: 12, color: Colors.purple[400]),
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    // widget.post['likedBy'][userId] == true
                    //     ? Icons.thumb_up
                    Icons.thumb_down_alt_outlined,
                    color: Colors.purple,
                  ),
                  label: Text(
                    'Like',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showHelpBottomSheet(context);
                  },
                  icon: Icon(Icons.add, color: Colors.purple),
                  label: Text(
                    'Join',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.share, color: Colors.purple),
                  label: Text(
                    'Share',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
