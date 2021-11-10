import 'dart:io';

import 'package:covid/http/PostListener.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../http/UploadPost.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  var isLoading = false;
  List<File> _images = [];

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descController.dispose();
  }

  void imagePicker() async {
    _images.clear();
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: ['.jpg', '.png', '.jpeg'],
        type: FileType.custom);

    if (result != null) {
      List<String> filepaths = result.paths;
      for (int i = 0; i < filepaths.length; i++) {
        _images.add(new File(filepaths.elementAt(i)));
      }
    }
    setState(() {});
  }

  void _deleteImage(int index) {
    _images.removeAt(index);
    setState(() {});
  }

  void uploadPost(context) async {
    bool isValid = _formKey.currentState.validate();
    _formKey.currentState.save();
    if (isValid) {
      setState(() {
        isLoading = true;
      });

      Post post = new Post(_titleController.text, _descController.text,
          imageFiles: _images);
      Provider.of<UploadPost>(context, listen: false)
          .uploadPost(post, context)
          .then((value) {
        Provider.of<PostListener>(context, listen: false)
            .fetchAllPosts(FirebaseAuth.instance.currentUser.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Add a post'),
        actions: [
          TextButton.icon(
            onPressed: () => uploadPost(context),
            icon: Icon(Icons.save, color: Colors.white),
            label: Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Title', style: Theme.of(context).textTheme.headline4),
              RichText(
                text: TextSpan(
                  text: 'Title',
                  style: Theme.of(context).textTheme.headline4,
                  children: [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                  ],
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0), labelText: 'hey there'),
                cursorHeight: 14,
                style: TextStyle(
                  fontSize: 16,
                ),
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Description',
                  style: Theme.of(context).textTheme.headline4,
                  children: [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                  ],
                ),
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                    labelText: 'What\'s on your mind?',
                    contentPadding: EdgeInsets.all(0)),
                cursorHeight: 14,
                style: TextStyle(
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple[400])),
                onPressed: () {
                  imagePicker();
                },
                icon: Icon(Icons.image),
                label: Text('Select images'),
              ),
              SizedBox(
                height: 20,
              ),
              if (_images.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1),
                    itemCount: _images.length,
                    itemBuilder: (ctx, index) => Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: FileImage(_images.elementAt(index)),
                                fit: BoxFit.cover),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _deleteImage(index),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red[400],
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (isLoading) CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
