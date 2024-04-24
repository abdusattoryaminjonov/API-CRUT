import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post_model.dart';
import '../models/post_rest_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class UpdatePage extends StatefulWidget {
  final Post post;
  const UpdatePage({super.key,required this.post});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();


  _updatePost() async{
    String title = _titleController.text.toString().trim();
    String body = _bodyController.text.toString().trim();

    Post newPost = widget.post;
    newPost.title = title;
    newPost.body = body;

    var response = await Network.PUT(Network.API_POST_UPDATE + newPost.id.toString(), Network.paramsUpdate(newPost));
    LogService.d(response!);
    PostRes postRes = Network.parsePostRes(response);

    backToFinish();
  }

  backToFinish(){
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.post.title!;
    _bodyController.text = widget.post.body!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Update Post"),
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
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        _updatePost();
                      },
                      child: Text("Update"),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }

}