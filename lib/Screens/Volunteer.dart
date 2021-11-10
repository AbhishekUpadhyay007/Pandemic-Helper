// import '../http/UsersPost.dart';
import 'package:covid/widgets/Volunteer/UsersPost.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/Volunteer/AddPost.dart';

class VolunteerScreen extends StatefulWidget {
  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen>
    with AutomaticKeepAliveClientMixin<VolunteerScreen> {
  @override
  bool get wantKeepAlive => true;

  final dbRef = FirebaseDatabase.instance
      .reference()
      .child("Users Post")
      .limitToFirst(50);
  var future;

  @override
  void initState() {
    super.initState();

    // future = Provider.of<PostListener>(context, listen: false)
    //     .fetchAllPosts(FirebaseAuth.instance.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Map<dynamic, dynamic>> _postsList = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Volunteer'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

          if (map == null) {
            return Center(
              child: Text('No post(s) uploaded by anyone'),
            );
          }

          _postsList.clear();
          map.forEach((key, value) {
            _postsList.add(value);
          });
          _postsList = _postsList.reversed.toList();
          return Container();
          // return ListView.builder(
          //     itemCount: _postsList.length,
          //     itemBuilder: (ctx, index) {
          //       return Container(
          //         margin:
          //             const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(20),
          //             boxShadow: [BoxShadow(color: Colors.grey)]),
          //         child: UsersPost(_postsList.elementAt(index)),
          //       );

          //       // return Container(
          //       //   margin: const EdgeInsets.symmetric(vertical: 10),
          //       //   height: 100,
          //       //   color: Colors.red,
          //       // );
          //     });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => AddPost(), fullscreenDialog: true),
          );
        },
      ),
    );
  }
}
