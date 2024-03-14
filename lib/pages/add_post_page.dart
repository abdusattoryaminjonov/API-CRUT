import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/post_model.dart';
import '../models/post_rest_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class AddPostPage extends StatefulWidget {
  final int? id;
  final Post? post;
  final bool? isEdit;

  const AddPostPage({super.key,this.id,this.post,this.isEdit});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool? isEdit ;

  _addPost() async{
    String title = _titleController.text.toString().trim();
    String body = _bodyController.text.toString().trim();
    Post post = Post(userId: 1,title: title, body: body);

    var response = await Network.POST(Network.API_POST_CREATE, Network.paramsCreate(post));
    LogService.d(response!);
    PostRes postRes = Network.parsePostRes(response);
    backToFinish();
  }

  _editPost() async{
    String title = _titleController.text.toString().trim();
    String body = _bodyController.text.toString().trim();
    Post post = Post(userId: 1,title: title, body: body);

    var response = await Network.POST(Network.API_POST_UPDATE + widget.id.toString(), Network.paramsCreate(post));
    LogService.d(response!);
    PostRes postRes = Network.parsePostRes(response);
    backToFinish();
  }


  backToFinish(){
    Navigator.of(context).pop(true);
  }



  @override
  Widget build(BuildContext context) {
     widget.isEdit == null ?  isEdit = true : isEdit =widget.isEdit!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Stack(
          children: [
            Container(
              child: Text("Edit Post"),
            ),
            isEdit! ? Text("Add Post") :SizedBox.shrink(),
          ],
        )
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: "Title"
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                    hintText: "Body"
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child:Stack(
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        _editPost();
                      },
                      child: Text("edit"),
                    ),
                    isEdit! ?  MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        _addPost();
                      },
                      child: Text("Add"),
                    ): SizedBox.shrink(),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}