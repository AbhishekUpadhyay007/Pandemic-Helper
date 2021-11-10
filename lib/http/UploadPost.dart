import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Post {
  var postId;
  var userId;
  var likes = 0;
  List<String> likedList = ["n"];
  DateTime time;
  final String title;
  final String description;
  List<File> imageFiles;
  // final String location;

  Post(this.title, this.description, {this.imageFiles});
}

class UploadPost with ChangeNotifier {
  List<String> imgUrl = [];
  final dbref = FirebaseDatabase.instance.reference();

  Future<void> uploadPost(Post post, BuildContext context) async {
    imgUrl.clear();
    try {
      var userId = FirebaseAuth.instance.currentUser.uid;

      var uniqueid = dbref.push().key;
      post.userId = userId;
      post.postId = uniqueid;
      post.time = DateTime.now();

      if (post.imageFiles.isNotEmpty) {
        await uploadToStorage(post.imageFiles, uniqueid);
        while (imgUrl.length != post.imageFiles.length) {
          await Future.delayed(Duration(milliseconds: 600));
        }
        print(imgUrl);
      }
      dbref.child('Users Post').child(uniqueid).set({
        'postId': post.postId,
        'userId': post.userId,
        'likes': post.likes,
        'likedBy': {},
        'datetime': post.time.toIso8601String(),
        'title': post.title,
        'phone': FirebaseAuth.instance.currentUser.phoneNumber,
        'description': post.description,
        'images': post.imageFiles.isNotEmpty ? imgUrl.toList() : null
      }).then((value) {
        imgUrl.clear();
        print('Data Successfully uploaded');
        Navigator.of(context).pop();
      });

      dbref.child('Users').child(userId).push().set({
        'postId': post.postId,
        'datetime': post.time.toIso8601String(),
      }).whenComplete(() => print('data reference saved in user private node'));
    } catch (error) {
      print(error);
      throw Exception('Something went wrong');
    }
  }

  Future<void> uploadToStorage(List<File> imageFiles, String postKey) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('User Posts')
        .child(FirebaseAuth.instance.currentUser.uid);
    print('Enteered');
    try {
      int i = 0;
      imageFiles.forEach((image) {
        UploadTask task =
            ref.child('$postKey/file-$i').putFile(imageFiles.elementAt(i));
        task.whenComplete(() async {
          String url = await task.snapshot.ref.getDownloadURL();
          imgUrl.add(url);
          print(url);
        });
        i++;
      });
    } catch (error) {
      throw Exception('Server Side Exception');
    }
  }
}
