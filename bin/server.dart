import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

import 'jsonModel.dart';
import 'jsonPostModel.dart';

Future connectDB() async {}

Future<JsonModel> fetch() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var jsonObject = JsonModel.fromJson(jsonResponse);
    return jsonObject;
  } else {
    throw Error();
  }
}

Future<JsonModelPost> fetchPost(Request req) async {
  var url = Uri.parse('https://randomuser.me/api');
  var response = await http.get(url);
  var jsonResponse = jsonDecode(response.body);
  var jsonObject =
      JsonModelPost.fromJson(jsonResponse['results'][0]['name']['first']);

  var settings = ConnectionSettings(
      host: 'host.docker.internal',
      port: 3306,
      user: 'root',
      password: '',
      db: 'dart_host');
  var conn = await MySqlConnection.connect(settings);
  conn.query('INSERT INTO users(name) VALUES(%s)', ([jsonObject.name]));
  await conn.close();
  return jsonObject;
}

// Configure routes.dart.
final _router = Router()
  ..get('/', _rootHandler)
  ..post('/post', _postHandler)
  ..get('/echo/<message>', _echoHandler);

Future<Response> _rootHandler(Request req) async {
  final teste = await fetch();
  return Response.ok(teste.title.toString());
}

Future<Response> _postHandler(Request req) async {
  final post = await fetchPost(req);
  return Response.ok(post);
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
