import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:ngdemo13_rest/pages/update_page.dart';
import '../models/post_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
import 'create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Post> posts = [];

  _loadPosts() async {
    setState(() {
      isLoading = true;
    });

    var response = await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    LogService.d(response!);
    List<Post> postList = Network.parsePostList(response);

    setState(() {
      posts = postList;
      isLoading = false;
    });
  }

  _deletePost(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(Network.API_POST_DELETE + post.id.toString(), Network.paramsEmpty());
    LogService.d(response!);
    _loadPosts();
  }

  Future _callCreatePage() async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const CreatePage();
    }));

    if (result) {
      _loadPosts();
    }
  }

  Future _callUpdatePage(Post post) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return UpdatePage(post: post);
    }));

    if (result) {
      _loadPosts();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPosts();
  }

  Future<void> _handleRefresh() async {
    _loadPosts();
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
          RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (ctx, index) {
                return _itemOfPost(posts[index]);
              },
            ),
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _callCreatePage();
        },
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _callUpdatePage(post);
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                _deletePost(post);
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
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
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              Divider(),
            ],
          ),
        ));
  }
}