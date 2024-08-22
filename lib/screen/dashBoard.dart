import 'package:approver/core/theme.dart';
import 'package:approver/provider/provider.dart';
import 'package:approver/screen/overview.dart';
import 'package:approver/widgets/Navigatorfunc.dart';
import 'package:approver/widgets/customListtile.dart';
import 'package:approver/widgets/customloader.dart';
import 'package:approver/widgets/customselectiontile.dart';
import 'package:approver/widgets/customsnackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  TabController? tab;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
    tab = TabController(length: 2, vsync: this);
  }

  fetchdata() async {
    try {
      loadingAlertBox(context);
      Provider.of<DashData>(context, listen: false).changesortvalue(value: "");
      await Provider.of<DashData>(context, listen: false).getapprovalhistory();
      await Provider.of<DashData>(context, listen: false).getapprovallist();
      Navigator.pop(context);
    } catch (e) {
      // TODO
      Navigator.pop(context);
      showSnackbar(context, e.toString(), Colors.red);
    }
  }

  final GlobalKey<ScaffoldState> Key = GlobalKey<ScaffoldState>();
  TextEditingController Pending_search = TextEditingController();
  TextEditingController History_search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () async {
                await fetchdata();
              },
              child: Icon(Icons.refresh_rounded)),
          SizedBox(
            width: 10,
          )
        ],
        title: const Text("Approvals"),
        centerTitle: true,
      ),
      key: Key,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<DashData>(builder: (context, data, child) {
                return data.sorteddata.isNotEmpty
                    ? SizedBox(
                        height: 120,
                        width: double.maxFinite,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SelectionTile(
                                  shadow: data.sortvalue == "",
                                  onTap: () {
                                    data.changesortvalue(value: "");
                                    data.searchbarsor(enteredValue: "");
                                    if (tab!.index == 1) {
                                      tab!.animateTo(0,
                                          duration: Duration(),
                                          curve: Curves.bounceIn);
                                    }
                                  },
                                  heading: "All Requests",
                                  count: data.alldata.length),
                              ...data.sorteddata
                                  .map(
                                    (e) => SelectionTile(
                                        shadow:
                                            data.sortvalue == e["approvalType"],
                                        // shadow: data.sortedlist[0]
                                        //         ["approvalType:"] ==
                                        //     e["approvalType"],
                                        onTap: () {
                                          data.changesortvalue(
                                              value: e["approvalType"]);
                                          data.searchbarsor(
                                              enteredValue: e["approvalType"]);
                                          if (tab!.index == 1) {
                                            tab!.animateTo(0,
                                                duration: Duration(),
                                                curve: Curves.bounceIn);
                                          }
                                        },
                                        heading: e["approvalType"],
                                        count: e["list"].length),
                                  )
                                  .toList(),
                            ]))
                    : SizedBox();
              }),
              Provider.of<DashData>(context).sorteddata.length > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Swipe >>",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    )
                  : SizedBox(),
              const SizedBox(
                height: 20,
              ),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: maincolor,
                labelStyle: TextStyle(fontSize: 17),
                padding: EdgeInsets.all(10),
                labelPadding: EdgeInsets.all(15),
                labelColor: maincolor,
                unselectedLabelColor: Colors.black,
                controller: tab,
                tabs: [const Text("Pending"), const Text("History")],
              ),
              Consumer<DashData>(builder: (context, data, child) {
                return Expanded(
                    child: TabBarView(controller: tab, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        onRefresh: () async {
                          try {
                            // data.changesortvalue(value: "");
                            await data.getapprovallist();
                          } catch (e) {
                            // TODO
                            showSnackbar(context, e.toString(), Colors.red);
                          }
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: data.alldata.isNotEmpty,
                              child: Transform.scale(
                                scale: 0.9,
                                child: TextFormField(
                                  controller: Pending_search,
                                  onChanged: (enteredValue) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      // if (tab!.index == 1) {
                                      //   tab!.animateTo(0,
                                      //       duration: Duration(),
                                      //       curve: Curves.bounceIn);
                                      // }
                                      data.searchbarsor(
                                          enteredValue: Pending_search.text);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      // border: OutlineInputBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(15)),
                                      prefixIcon: Icon(Icons.search_sharp),
                                      hintText: "search"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                                child: data.alldata.isEmpty || data.shownodata
                                    ? ListView(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          Center(
                                            child: Text("No data"),
                                          ),
                                        ],
                                      )
                                    : ListView(
                                        children: List.generate(
                                            data.sortedlist.isNotEmpty
                                                ? data.sortedlist.length
                                                : data.alldata.length, (i) {
                                          List listdata =
                                              data.sortedlist.isNotEmpty
                                                  ? data.sortedlist
                                                  : data.alldata;
                                          return customtile(
                                              title: listdata[i]["title"],
                                              onTap: () {
                                                if (data.connectivityStatus !=
                                                    ConnectivityResult.none) {
                                                  Navigatorfunc(
                                                          context: context,
                                                          page: Overview(
                                                              date: listdata[i][
                                                                      "createdDate"]
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                              typeid: listdata[
                                                                      i][
                                                                  "approvalTypeId"],
                                                              id: listdata[i][
                                                                  "approvalID"]))
                                                      .then((value) {
                                                    if (value == true) {
                                                      print(
                                                          "enteredd then----");
                                                      Pending_search.text = '';
                                                    }
                                                  });
                                                } else {
                                                  showSnackbar(
                                                      context,
                                                      "Check Your Internet connection",
                                                      Colors.red);
                                                }
                                              },
                                              time: listdata[i]["createdDate"],
                                              status: listdata[i]["status"],
                                              avatartext: listdata[i]
                                                      ["createdBy"]
                                                  .toString()
                                                  .split("@")
                                                  .toList()[0]
                                                  .toUpperCase(),
                                              name:
                                                  "${listdata[i]["createdBy"].toString().split("@").toList()[0].toString().toUpperCase()}",
                                              type: listdata[i]
                                                      ["approvalType"] ??
                                                  "",
                                              context: context);
                                        }),
                                      ))
                          ],
                        )),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: RefreshIndicator(
                  //     triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  //     onRefresh: () async {
                  //       await fetchdata();
                  //     },
                  //     child: data.historyData.isEmpty
                  //         ? ListView(
                  //             children: [
                  //               SizedBox(
                  //                 height: 50,
                  //               ),
                  //               Center(
                  //                 child: Text("No data"),
                  //               ),
                  //             ],
                  //           )
                  //         : ListView.separated(
                  //             separatorBuilder: (context, index) =>
                  //                 const SizedBox(height: 10),
                  //             itemCount: data.historyData.length,
                  //             itemBuilder: (context, i) {
                  //               return customtile(
                  //                 onTap: () {
                  //                   if (data.connectivityStatus !=
                  //                       ConnectivityResult.none) {
                  //                     Navigatorfunc(
                  //                       context: context,
                  //                       page: Overview(
                  //                           date: data.historyData[i]
                  //                                   ["createdDate"]
                  //                               .toString()
                  //                               .substring(0, 10),
                  //                           typeid: data.historyData[i]
                  //                               ["approvalTypeId"],
                  //                           id: data.historyData[i]
                  //                               ["approvalID"]),
                  //                     );
                  //                   } else {
                  //                     showSnackbar(
                  //                         context,
                  //                         "Check Your Internet connection",
                  //                         Colors.red);
                  //                   }
                  //                 },
                  //                 time: data.historyData[i]["createdDate"]
                  //                     .toString(),
                  //                 status: "Process",
                  //                 avatartext: data.historyData[i]["createdBy"]
                  //                         .toString()
                  //                         .split("@")[0]
                  //                         .toUpperCase() ??
                  //                     "",
                  //                 name:
                  //                     "${data.historyData[i]["createdBy"].toString().split("@").first.toUpperCase()}",
                  //                 type:
                  //                     data.historyData[i]["approvalType"] ?? "",
                  //                 context: context,
                  //               );
                  //             },
                  //           ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        onRefresh: () async {
                          try {
                            data.changesortvalue(value: "");
                            await data.getapprovalhistory();
                          } catch (e) {
                            // TODO
                            showSnackbar(context, e.toString(), Colors.red);
                          }
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: data.historyData.isNotEmpty,
                              child: Transform.scale(
                                scale: 0.9,
                                child: TextFormField(
                                  controller: History_search,
                                  onChanged: (enteredValue) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      // if (tab!.index == 1) {
                                      //   tab!.animateTo(0,
                                      //       duration: Duration(),
                                      //       curve: Curves.bounceIn);
                                      // }
                                      data.searchbarsor(
                                          ishistory: true,
                                          enteredValue: enteredValue);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      // border: OutlineInputBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(20)),
                                      prefixIcon: Icon(Icons.search_sharp),
                                      hintText: "search"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                                child: data.historyData.isEmpty ||
                                        data.historyshownodata
                                    ? ListView(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          Center(
                                            child: Text("No data"),
                                          ),
                                        ],
                                      )
                                    : ListView(
                                        children: List.generate(
                                            data.historySortedList.isNotEmpty
                                                ? data.historySortedList.length
                                                : data.historyData.length, (i) {
                                          List listdata =
                                              data.historySortedList.isNotEmpty
                                                  ? data.historySortedList
                                                  : data.historyData;

                                          return customtile(
                                            title: listdata[i]["title"],
                                            onTap: () {
                                              if (data.connectivityStatus !=
                                                  ConnectivityResult.none) {
                                                Navigatorfunc(
                                                  context: context,
                                                  page: Overview(
                                                      date: listdata[i]
                                                              ["createdDate"]
                                                          .toString()
                                                          .substring(0, 10),
                                                      typeid: listdata[i]
                                                          ["approvalTypeId"],
                                                      id: listdata[i]
                                                          ["approvalID"]),
                                                );
                                              } else {
                                                showSnackbar(
                                                    context,
                                                    "Check Your Internet connection",
                                                    Colors.red);
                                              }
                                            },
                                            time: listdata[i]["createdDate"]
                                                .toString(),
                                            status: listdata[i]["status"],
                                            avatartext: listdata[i]["createdBy"]
                                                    .toString()
                                                    .split("@")[0]
                                                    .toUpperCase() ??
                                                "",
                                            name:
                                                "${listdata[i]["createdBy"].toString().split("@").first.toUpperCase()}",
                                            type: data.historyData[i]
                                                    ["approvalType"] ??
                                                "",
                                            context: context,
                                          );
                                        }),
                                      ))
                          ],
                        )),
                  ),
                ]));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
