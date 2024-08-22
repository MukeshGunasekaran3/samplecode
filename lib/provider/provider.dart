import 'dart:typed_data';
import 'package:approver/services/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashData extends ChangeNotifier {
  ///////States
  final Connectivity connectivity = Connectivity();
  ConnectivityResult connectivityStatus = ConnectivityResult.none;
  String user = "";
  BuildContext context;
  Map overviewResponse = {};
  List alldata = [];
  List sorteddata = [];
  List historyData = [];
  ApiService apiService;
  Uint8List? bytes;
  List sortedlist = [];
  List typesOfApproval = [];
  String overviewType = "";
  bool loginloader = false;
  String userid = "";
  String otp = "";
  String apiotp = "";
  SharedPreferences? shared;
  bool shownodata = false;
  bool historyshownodata = false;
  String sortvalue = "";
  List historySortedList = [];
  List notify = [
    {
      'content': 'Your order has been shipped',
      'date': '2024-07-24 10:30',
      'type': 'Shipping'
    },
    {
      'content': 'New message from John',
      'date': '2024-07-24 14:45',
      'type': 'Message'
    },
    {
      'content': 'Your package has been delivered',
      'date': '2024-07-25 09:00',
      'type': 'Delivery'
    },
    {
      'content': 'Reminder: Doctor appointment at 3 PM',
      'date': '2024-07-25 15:00',
      'type': 'Reminder'
    },
    {
      'content': 'Weekly report is ready',
      'date': '2024-07-26 08:00',
      'type': 'Report'
    },
    {
      'content': 'Security alert: New login from unknown device',
      'date': '2024-07-26 12:30',
      'type': 'Alert'
    }
  ];

  String features = "";

  DashData(this.context, this.apiService) {
    connectivity.onConnectivityChanged.listen((event) {
      connectivityStatus = event.first;
      notifyListeners();
    });
    checkConnectivity();
    initiatedata();
  }

///////////////////Api calls

  getuserdetails() async {
    if (connectivityStatus != ConnectivityResult.none) {
      try {
        Map m = {"emailid": userid, "otp": int.parse(otp)};
        // Map m = {"emailid": userid, "otp": 123456};

        var res = await apiService.postapi(
            endpoint: "/getuserdetails", body: jsonEncode(m), user: userid);
        // print("login rees------$res");
        if (res["spmLogin"]["status"] == "Y") {
          shared!.setString("features", res["spmLogin"]["role"]);
          shared!.setString("user", userid);
          features = shared!.getString("features") ?? "";
          user = shared!.getString("user") ?? "";
          print("features-------$features------$user");
          apiotp = "";
          // if (shared!.getString("token") == null) {
          // await firebase();
          // }
          notifyListeners();
        } else {
          throw "Invalid userid";
        }
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  getuserotp() async {
    if (connectivityStatus != ConnectivityResult.none) {
      try {
        var res = await apiService
            .postapi(user: userid, endpoint: "/getUserOtp", body: {});
        apiotp = res["getMobileNumber"]["otp"].toString();
        print("apiotp------------$apiotp");
        notifyListeners();
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  getapprovallist() async {
    if (connectivityStatus != ConnectivityResult.none) {
      // sortedlist = [];

      try {
        Map res = await apiService
            .postapi(user: user, endpoint: "/getapprovallist", body: {});

        print(res);

        alldata = res["approvals"];
        sorteddata = [];
        print("alldata-----$alldata");
        await getapprovaltype(data: alldata);
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  getapprovaltype({required List data}) async {
    if (connectivityStatus != ConnectivityResult.none) {
      try {
        var res = await apiService
            .postapi(user: user, endpoint: "/getapprovaltype", body: {});
        sorteddata = [...res["approval"]];
        typesOfApproval = [...sorteddata];

        print("sorteddata----$sorteddata");
        sorteddata.forEach((element) {
          element["list"] = [];
        });
        print("approval type-----$typesOfApproval");
        data.forEach((element) {
          sorteddata.forEach((e) {
            if (element["approvalType"] == e["approvalType"]) {
              element["approvalTypeId"] = e["approvalTypeId"];
              e["list"].add({...element as Map});
            }
          });
        });

        sorteddata.sort((a, b) => b['list'].length.compareTo(a['list'].length));
        sorteddata.removeWhere((e) => e["list"].length == 0);
        print("sorteddata-------$sorteddata-------all----$alldata");
        notifyListeners();
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  approvalDetailRequest(
      {required String approvalid, required String apporvaltypeId}) async {
    if (connectivityStatus != ConnectivityResult.none) {
      overviewType = "";
      overviewResponse = {};
      print("$approvalid--------$apporvaltypeId-------$user");
      notifyListeners();
      try {
        await Future.delayed(Duration(seconds: 2));
        print("approvalDetail enteredddd");
        var res = await apiService.postapi(
            user: user,
            endpoint: "/getapprovaldetails",
            body: jsonEncode([
              {
                "approvalID": approvalid,
                "approver": user,
                "approvalType": apporvaltypeId
              }
            ]));

        overviewResponse = res["approvalDetails"][0];
        print(overviewResponse);
        notifyListeners();
        await getApprovalType(id: overviewResponse["approvalType"]);
        if (overviewResponse["status"] != "P" ||
            overviewResponse["status"] != "S") {
          await getapprovallist();
          await getapprovalhistory();
        }
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  getapprovalhistory() async {
    if (connectivityStatus != ConnectivityResult.none) {
      historySortedList = [];
      try {
        var res = await apiService
            .postapi(user: user, endpoint: "/getapprovalhistory", body: {});
        historyData = res["approvals"];
        print("approvaltype------$typesOfApproval");
        historyData.forEach((element) {
          typesOfApproval.forEach((e) {
            if (element["approvalType"] == e["approvalType"]) {
              element["approvalTypeId"] = e["approvalTypeId"];
            }
          });
        });
        print(historyData);

        notifyListeners();
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  settoken({required String token}) async {
    if (connectivityStatus != ConnectivityResult.none) {
      print(token);
      Map m = {
        "user": user,
        "fcmToken": token,
        "platform": "mobile",
        "projectID": "00001"
      };
      try {
        print("enmterd");
        var response = await http.post(
            Uri.parse(
              "http://192.168.2.114:2205/insertFCMTokens",
            ),
            headers: {"user": user},
            body: jsonEncode(m));
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);

          if (json["status"] == "S") {
            shared!.setString("token", token);

            notifyListeners();
          } else {
            throw "insertion error";
          }
        } else {
          throw "status code error";
        }
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  loadimage({required String imageid}) async {
    if (connectivityStatus != ConnectivityResult.none) {
      print("loadimage api (+)");
      print(imageid);
      try {
        print("enmterd");
        var response = await http.get(
          Uri.parse("http://192.168.150.21:29091/getUploadFile?docid=$imageid"),
        );
        if (response.statusCode == 200) {
          print("loadimage api (-)");
          bytes = response.bodyBytes;
          notifyListeners();
          return response.bodyBytes;
        } else {
          print("loadimage api (-)");

          return "something went wrong";
        }
      } catch (e) {
        print("loadimage api (-)");
        print("exception");
        return "something went wrong";
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  sendapprovalresult(
      {required String approvalid,
      required String approvaltype,
      required String status,
      required String comment}) async {
    if (connectivityStatus != ConnectivityResult.none) {
      print("Inserting status=-----$status");
      try {
        var res = await apiService.postapi(
            user: user,
            endpoint: "/sendapprovalresult",
            body: jsonEncode([
              {
                "approvalID": approvalid,
                "approver": user,
                "approvalType": approvaltype,
                "status": status,
                "comment": comment
              }
            ]));
        await getapprovallist();
        await getapprovalhistory();
        changesortvalue(value: "");
        sortedlist = [];
        overviewType = "";
        notifyListeners();
        return res;
      } catch (e) {
        throw e.toString();
      }
    } else {
      throw "Check your Internet connection";
    }
  }

  firebase() async {
    print("entered firebase funcccc");
    final FirebaseMessaging fbmesage = FirebaseMessaging.instance;
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print(' permission granted');

      String? token = await fbmesage.getToken();
      print("token------$token");

      await settoken(token: token!);
    }
  }

  logoutFCMTokens() async {
    if (connectivityStatus != ConnectivityResult.none) {
      // Map m = {"user": user, "platform": "mobile", "projectID": "00001"};
      // var response = await http.post(
      //     Uri.parse(
      //       "http://192.168.2.114:2205/logoutFCMTokens",
      //     ),
      //     headers: {"user": user},
      //     body: jsonEncode(m));
      // if (response.statusCode == 200) {
      if (true) {
        // var json = jsonDecode(response.body);

        // if (json["status"] == "S") {
        if (true) {
          shared!.setString("user", "");
          shared!.setString("features", "");
          print("logged out");
        } else {
          throw "something went wrong";
        }
      } else {
        throw "status code error";
      }
    } else {
      throw "Check your Internet connection";
    }
  }

////////////////////Functions

  useridvaluechange({required String data, bool isotp = false}) {
    if (isotp) {
      otp = data;
    } else {
      print("value changing");
      userid = data.toLowerCase();
    }
    notifyListeners();
  }

  changesortvalue({required String value}) {
    sortvalue = value;
    notifyListeners();
  }

  changesloginloader() {
    loginloader = !loginloader;

    notifyListeners();
  }

  changeuser({required String newuser}) {
    user = newuser;
    notifyListeners();
  }

  getApprovalType({required String id}) async {
    typesOfApproval.forEach((e) {
      if (e["approvalTypeId"] == id) {
        overviewType = e["approvalType"];
      }
    });
    if (overviewType.contains("Vendor")) {
      await loadimage(imageid: overviewResponse["attachment"][0]["content"]);
    }
    notifyListeners();
  }

  searchbarsor({required String enteredValue, bool ishistory = false}) {
    print(enteredValue);
    if (!ishistory) {
      sortedlist = alldata
          .where((e) =>
              e["approvalType"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()) ||
              e["createdBy"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()) ||
              e["createdDate"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()) ||
              e["title"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()))
          .toList();
      if (sortedlist.isEmpty && enteredValue.isNotEmpty) {
        shownodata = true;
      } else {
        shownodata = false;
      }
    } else {
      historySortedList = historyData
          .where((e) =>
              e["approvalType"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()) ||
              e["createdBy"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()) ||
              e["createdDate"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()) ||
              e["title"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredValue.toLowerCase()))
          .toList();

      notifyListeners();
      if (historySortedList.isEmpty && enteredValue.isNotEmpty) {
        historyshownodata = true;
      } else {
        historyshownodata = false;
      }
    }

    notifyListeners();
  }

  removeNotify({required int index}) {
    notify.removeAt(index);
    notifyListeners();
  }

  checkConnectivity() async {
    final result = await connectivity.checkConnectivity();
    connectivityStatus = result.first;
    notifyListeners();
    print(" status-----  $connectivityStatus");
  }

  initiatedata() async {
    shared = await SharedPreferences.getInstance();
    notifyListeners();
    features = shared!.getString("features") ?? "";
    user = shared!.getString("user") ?? "";
  }
}
