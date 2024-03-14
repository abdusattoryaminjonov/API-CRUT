import 'dart:convert';

import 'package:http/http.dart';

import '../models/post_model.dart';
import '../models/post_rest_model.dart';

class Network{
  static String BASE = "jsonplaceholder.typicode.com";
  static Map<String,String> headers = {'Content-Type':'application/json; charset=UTF-8'};

  /* Http Apis*/
  static String API_POST_LIST = "/posts";
  static String API_POST_CREATE = "/posts";
  static String API_POST_UPDATE = "/posts/"; //{id}
  static String API_POST_DELETE = "/posts/"; //{id}

  /* Http Requests */
  static Future<String?> GET(String api, Map<String, String> params) async{
    var uri = Uri.http(BASE, api, params);
    var response = await get(uri, headers: headers);
    if(response.statusCode == 200){
      return response.body;
    }
    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async{
    var uri = Uri.http(BASE, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.body;
    }
    return null;
  }

  static Future<String?> PUT(String api, Map<String, String> params) async{
    var uri = Uri.http(BASE, api);
    var response = await put(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200){
      return response.body;
    }
    return null;
  }

  static Future<String?> DEL(String api, Map<String, String> params) async{
    var uri = Uri.http(BASE, api, params);
    var response = await delete(uri, headers: headers);
    if(response.statusCode == 200){
      return response.body;
    }
    return null;
  }

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = Map();
    return params;
  }

  static Map<String, String> paramsCreate(Post post) {
    Map<String, String> params = new Map();
    params.addAll({
      'title': post.title!,
      'body': post.body!,
      'userId': post.userId.toString(),
    });
    return params;
  }

  static Map<String, String> paramsUpdate(Post post) {
    Map<String, String> params = new Map();
    params.addAll({
      'id': post.id.toString(),
      'title': post.title!,
      'body': post.body!,
      'userId': post.userId.toString(),
    });
    return params;
  }

  /* Http Parsing */

  static List<Post> parsePostList(String response) {
    dynamic json = jsonDecode(response);
    return List<Post>.from(json.map((x) => Post.fromJson(x)));
  }

  static Post parsePost(String response) {
    dynamic json = jsonDecode(response);
    return Post.fromJson(json);
  }

  static PostRes parsePostRes(String response) {
    dynamic json = jsonDecode(response);
    return PostRes.fromJson(json);
  }
}