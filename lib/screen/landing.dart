import 'package:approver/core/theme.dart';
import 'package:approver/main.dart';
import 'package:approver/provider/provider.dart';
import 'package:approver/screen/Notifications.dart';
import 'package:approver/screen/dashBoard.dart';
import 'package:approver/screen/login.dart';
import 'package:approver/widgets/customloader.dart';
import 'package:approver/widgets/customsnackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:approver/widgets/Navigatorfunc.dart';
import 'package:approver/widgets/custombutton.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class landing extends StatefulWidget {
  const landing({super.key});

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firebase();
    });
  }

  firebase() async {
    await Provider.of<DashData>(context, listen: false).firebase();
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scafoldkey = GlobalKey<ScaffoldState>();
    DashData provider = Provider.of<DashData>(context);
    print("${provider.features}-----features");
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height * 0.25,
              child: ListTile(
                title: Text(
                  provider.user.split("@").toList()[0].toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                subtitle: Text(
                  provider.user,
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Icon(
                  size: 40,
                  Icons.person,
                  color: maincolor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                leading: Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                leading: Icon(Icons.support_agent_outlined),
                title: const Text("Support"),
                onTap: () {},
              ),
            ),
            const Expanded(child: Text("")),
            CustomButton(
                onPressed: () async {
                  try {
                    loadingAlertBox(context);
                    await provider.logoutFCMTokens();
                    Navigator.pop(context);
                    NavigatorRemoveUntil(context: context, page: login());
                  } catch (e) {
                    // TODO
                    Navigator.pop(context);
                    Navigator.pop(context);

                    showSnackbar(context, e.toString(), Colors.red);
                  }
                },
                content: "Logout",
                color: Colors.red),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      key: scafoldkey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              // gradient: RadialGradient(
              //   begin: Alignment.center,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     // Colors.blue.withOpacity(0.1),
              //     // Colors.white,

              //     Colors.white,
              //     Colors.white,
              //     Colors.blue.withOpacity(0.1),
              //   ],
              // ),
              ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(255, 5, 79, 139),
                        maincolor,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          scafoldkey.currentState!.openDrawer();
                        },
                        child: const Icon(
                          Icons.menu_open_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                    Text(
                      "SPARK",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigatorfunc(
                            context: context, page: const NotificationScreen());
                      },
                      child: Transform.scale(
                        scale: 0.8,
                        child: Stack(
                          children: [
                            Positioned(
                              child: CircleAvatar(
                                  minRadius: 25,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    size: 35,
                                    Icons.notifications,
                                    color: maincolor,
                                  )),
                            ),
                            provider.notify.isNotEmpty
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      maxRadius: 10,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        provider.notify.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          "Quick Services",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        provider.features.contains("Approvals")
                            ? InkWell(
                                onTap: () async {
                                  loadingAlertBox(context);
                                  try {
                                    await Provider.of<DashData>(context,
                                            listen: false)
                                        .getapprovallist();
                                    await Provider.of<DashData>(context,
                                            listen: false)
                                        .getapprovalhistory();
                                    Navigator.pop(context);
                                    Navigatorfunc(
                                        context: context, page: Dashboard());
                                  } catch (e) {
                                    showSnackbar(
                                        context, e.toString(), Colors.red);
                                    Navigator.pop(context);
                                    if (provider.connectivityStatus !=
                                        ConnectivityResult.none) {
                                      Navigatorfunc(
                                          context: context, page: Dashboard());
                                    }
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.white,
                                              maincolor.withOpacity(0.5),
                                              maincolor
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: maincolor.withOpacity(0.3),
                                            border: Border.all(
                                                color: maincolor, width: 10)),
                                        child:
                                            // Icon(
                                            //   Icons.approval_rounded,
                                            //   color: maincolor,
                                            //   size: 40,
                                            // ),
                                            Center(
                                          child: Text(
                                            "A",
                                            style: TextStyle(
                                                color: maincolor,
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Approvals",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
