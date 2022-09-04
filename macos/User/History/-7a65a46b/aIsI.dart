import 'package:http/http.dart' as http;

var baseUrl = Uri.parse('https://api.com');

Future<String> login({
  required String email,
  required String password,
}) async {
    try {
      final url = Uri.parse(baseUrl, "/endpoint");
      var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
      final res = await _client.post<Map<String, dynamic>>("/login", data: {
        "login": email,
        "password": password,
      });
      final String? token = res.data?["token"];
      if (token == null) throw Unauthorized();
      return token;
    } on DioError catch (e) {
      throw e.toDomain();
    }
  }
}