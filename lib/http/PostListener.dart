import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PostListener with ChangeNotifier {
  final dateeTime;
  final description;
  final emailId;
  final phone;
  final postId;
  final title;
  final userId;
  var isLiked;
  final likedList;
  final images;

  PostListener(
      {@required this.dateeTime,
      @required this.description,
      @required this.emailId,
      @required this.phone,
      @required this.postId,
      @required this.title,
      @required this.userId,
      @required this.isLiked,
      @required this.images,
      @required this.likedList});

  List<PostListener> postList = [];

  get fetchedPosts {
    return [...postList.reversed];
  }

  Future<void> fetchAllPosts(String userId) async {
    try {
      postList.clear();
      var snapshot = await FirebaseDatabase.instance
          .reference()
          .child('Users Post')
          .limitToLast(50)
          .once();
      Map<dynamic, dynamic> map = snapshot.value;
      map.forEach((key, value) {
        var isLiked = map[key]['likedBy'][userId] != null ? true : false;
        postList.add(new PostListener(
            dateeTime: map[key]['datetime'],
            description: map[key]['description'],
            emailId: map[key]['emailId'],
            phone: map[key]['phone'],
            postId: map[key]['postId'],
            title: map[key]['title'],
            userId: map[key]['userId'],
            isLiked: isLiked,
            images: map[key]['images'],
            likedList: map[key]['likedBy']));
      });
    } catch (error) {}
  }

  Future<void> toggleLiked(String postId, String userId) async {
    final favStatus = isLiked;
    isLiked = !isLiked;
    notifyListeners();

    try {
      //   var response = await FirebaseDatabase.instance
      //       .reference()
      //       .child('Users Post')
      //       .child(postId)
      //       .child('likedBy')
      //       .once();
      //   Map<dynamic, dynamic> map = response.value;
      //   if (likeBy) {
      //     map.remove(userId);
      //   } else {
      //     map[userId] = true;
      //   }
      //   await FirebaseDatabase.instance
      //       .reference()
      //       .child('Users Post')
      //       .child(postId)
      //       .child('likedBy')
      //       .set(map)
      //       .then((_) {
      //     likeBy = !likeBy;
      //     notifyListeners();
      //   });
    } catch (error) {
      print(error);
    }
  }
}
