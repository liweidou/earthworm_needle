import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';

import 'Global.dart';

class NetworkUtil {
  static String getRequestUrl(String url) {
    return Global.BASE_URL + url;
  }

  static Future<http.Response> postWithBody(
      String url, var body, bool useToken) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {
        "Authorization": Global.API_TOKEN,
        "content-type": "application/json"
      };
      response =
          await http.post(getRequestUrl(url), headers: headers, body: body);
    } else
      response = await http.post(getRequestUrl(url), body: body);
    return response;
  }

  static Future<http.Response> post(
      String url, Map<String, Object> params, bool useToken) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response =
          await http.post(getRequestUrl(url), headers: headers, body: params);
    } else
      response = await http.post(getRequestUrl(url), body: params);
    return response;
  }

  static Future<http.Response> get(String url, bool useToken) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response = await http.get(getRequestUrl(url), headers: headers);
    } else
      response = await http.get(getRequestUrl(url));
    return response;
  }

  static Future<http.Response> delete(String url, bool useToken) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response = await http.delete(getRequestUrl(url), headers: headers);
    } else
      response = await http.delete(getRequestUrl(url));
    return response;
  }

  static Future<http.Response> put(String url, bool useToken) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response = await http.put(getRequestUrl(url), headers: headers);
    } else
      response = await http.put(getRequestUrl(url));
    return response;
  }

  static Future<http.Response> putWithParams(
      String url, Map<String, Object> params, bool useToken) async {
    http.Response response = null;
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      response =
          await http.put(getRequestUrl(url), headers: headers, body: params);
    } else
      response = await http.put(getRequestUrl(url), body: params);
    return response;
  }

  static Future<String> uploadFile(
      String url, File imageFile, bool useToken) async {
    http.StreamedResponse response = null;
    var postUri = Uri.parse(url);
    print("url:" + url + " imageFile:" + imageFile.path);
    var request = http.MultipartRequest("POST", postUri);
    if (useToken) {
      Map<String, String> headers = {"Authorization": Global.API_TOKEN};
      request.headers.addAll(headers);
    }
    request.fields["name"] = "image";
    request.files.add(http.MultipartFile.fromBytes(
        "image", await imageFile.readAsBytes(),
        contentType: MediaType("image", "jpeg"),filename: "image"));
    response = await request.send();
    print("result:" + response.reasonPhrase);
    return "";
  }
}
