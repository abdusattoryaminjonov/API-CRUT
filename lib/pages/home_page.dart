import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:ngdemo13_rest/models/post_model.dart';
import 'package:ngdemo13_rest/services/http_service.dart';

import 'package:ngdemo13_rest/services/log_service.dart';

import 'add_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

enum Actions{edit,delete}

class _HomePageState extends State<HomePage> {

  String data = "no data";
  bool isLoading = true;
  List<Post> posts = [];

  loadPosts() async {
    var response =
    await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    LogService.d(response!);
    List<Post> postList = Network.parsePostList(response!);
    setState(() {
      posts = postList;
      isLoading = false;
    });
  }

  updatePost()async{

  }


  Future _callAddPostPage() async {
    bool result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddPostPage();
    }));

    if (result) {
      loadPosts();
    }
  }

  Future _editPost(int id ) async {
    bool result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return  AddPostPage(id: id,isEdit: false,);
    }));

    if (result) {
      loadPosts();
    }
  }

  void _deletePost(int id,Post post) async{
      var response = await Network.DEL(Network.API_POST_DELETE +id.toString(),  Network.paramsEmpty());
      LogService.d(response!);
      setState(() {
        data = response;
        loadPosts();
      });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPosts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Networking"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: posts.length,
            itemBuilder: (ctx, index) {
              return _itemOfPost(posts[index]);
            },
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          _callAddPostPage();
        },
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: const [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'edit',
            onPressed: null,
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'delete',
            onPressed: null,
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(post.body!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                  child: MaterialButton(
                      onPressed: (){
                        _editPost(post.id!);
                      },
                      child: Center(
                        child: Icon(Icons.edit,color: Colors.white),
                      )
                  )
                ),
                SizedBox(width: 10,),
                Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                    child: MaterialButton(
                      onPressed: (){
                        _deletePost(post.id!,post);
                      },
                      child: Center(
                        child: Icon(Icons.delete,color: Colors.white),
                      )
                    )
                )
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
