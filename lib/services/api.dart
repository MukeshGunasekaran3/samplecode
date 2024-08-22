import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final BuildContext context;

  // String mainurl = "http://192.168.2.114:27094";
  String mainurl = "http://192.168.2.5:27094";

  ApiService({required this.context});
  postapi(
      {required String user, required String endpoint, required body}) async {
    try {
      var res = await http.post(Uri.parse("$mainurl$endpoint"),
          headers: {"USER": user}, body: body);
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json["status"] == "S") {
          return json;
        } else {
          throw json["msg"];
        }
      } else {
        throw "status code error";
      }
    } catch (e) {
      throw "Something went wrong please try again later";
    }
  }

  getApi({required String user, required String endpoint}) async {
    try {
      var res = await http
          .get(Uri.parse("$mainurl$endpoint"), headers: {"USER": user});
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json["status"] == "S") {
          return json;
        } else {
          throw "Error msg";
        }
      } else {
        throw "status code error";
      }
    } catch (e) {
      throw "Something went wrong please try again later";
    }
  }
}
