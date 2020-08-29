import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this._baseUrl);

  final String _baseUrl;

  String urlBuilder({List<String> levels, Map<String, dynamic> params}) {
    StringBuffer url = StringBuffer(_baseUrl);
    for (String level in levels) {
      url.write("/$level");
    }
    if (params.isNotEmpty) {
      url.write("?");
      params.forEach((key, value) {
        url.write("&$key=$value");
      });
    }
    return url.toString();
  }

  Future<dynamic> getConversion({String url}) async {
    String _url = url == null ? _baseUrl : url;

    http.Response response = await http.get(_url);

    if (response.statusCode == 200) {
      String data = response.body;
      if (data is String) {}

      return jsonDecode(data);
    } else
      return response.statusCode;
  }
}
