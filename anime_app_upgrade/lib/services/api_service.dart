import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String base = 'https://lnn-api.vercel.app/api';

  Future<Map?> fetchHome() async {
    final res = await http.get(Uri.parse('\$base/home'));
    if (res.statusCode == 200) {
      return json.decode(res.body);
    }
    return null;
  }

  Future<List?> search(String q) async {
    final res = await http.get(Uri.parse('\$base/search?query=' + Uri.encodeComponent(q)));
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return body['data'] ?? [];
    }
    return null;
  }

  Future<Map?> animeDetail(String slug) async {
    final res = await http.get(Uri.parse('\$base/anime/' + slug));
    if (res.statusCode == 200) {
      return json.decode(res.body);
    }
    return null;
  }
}
