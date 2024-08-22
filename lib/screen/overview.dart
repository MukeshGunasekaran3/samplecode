import 'package:approver/core/constant.dart';
import 'package:approver/widgets/customalert.dart';
import 'package:pdfx/pdfx.dart';
import 'package:approver/core/theme.dart';
import 'package:approver/provider/provider.dart';
import 'package:approver/widgets/custombutton.dart';
import 'package:approver/widgets/customloader.dart';
import 'package:approver/widgets/customsnackbar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Overview extends StatefulWidget {
  final String date;
  final String id;
  final String typeid;
  const Overview(
      {super.key, required this.id, required this.typeid, required this.date});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  TextEditingController rejectnote = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  String? selectedvalue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getdata());
  }

  getdata() async {
    try {
      loadingAlertBox(context);
      await Provider.of<DashData>(context, listen: false).approvalDetailRequest(
          apporvaltypeId: widget.typeid, approvalid: widget.id);
    } catch (e) {
      showSnackbar(context, e.toString(), Colors.red);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashData>(builder: (context, data, child) {
      if (data.overviewType == "") {
        return Scaffold(
          appBar: AppBar(),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          // if (data.overviewResponse["status"] == "AA") {
          //   showSnackbar(context, "Content already approved", maincolor);

          //   Navigator.pop(context);
          // }
          // if (data.overviewResponse["status"] == "A" ||
          //     data.overviewResponse["status"] == "C") {
          //   showSnackbar(context, "Content already been approved", maincolor);
          // }
          // if (data.overviewResponse["status"] == "R") {
          //   showSnackbar(context, "Content already been Rejected", Colors.red);
          // }
        });
        return Scaffold(
          appBar: AppBar(
            title: Text(
                // data.overviewResponse["requestDetails"] != []
                //   ? heading(data.overviewResponse["requestDetails"])
                //   : ""
                data.overviewType),
            actions: [
              data.overviewResponse["history"] != []
                  ? InkWell(
                      onTap: () {
                        historyAlert(
                            context: context,
                            data: data.overviewResponse["history"]);
                      },
                      child: const Icon(Icons.history_rounded))
                  : const SizedBox(),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          minRadius: 30,
                          backgroundColor: getRandomPastelColor(),
                          child: Text(
                            data.overviewResponse["approver"]
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.overviewResponse["approver"],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.date,
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        const Expanded(child: Text("")),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          moreOptionsAlert(
                              context: context,
                              data: data.overviewResponse['requestDetails']);
                        },
                        child: Text(
                          "More Details",
                          style: TextStyle(
                            color: maincolor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15)),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        data.overviewType.contains("App")
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  data.overviewResponse["attachment"].length !=
                                          0
                                      ? data.overviewResponse["attachment"][0]
                                              ["content"]
                                          .toString()
                                      : "",
                                  textAlign: TextAlign.justify,
                                ),
                              )
                            : const SizedBox(),
                        data.overviewType.contains("Email")
                            ? HtmlWidget(
                                data.overviewResponse["attachment"].length != 0
                                    ? data.overviewResponse["attachment"][0]
                                            ["content"]
                                        .toString()
                                    : "",
                                onTapUrl: (p0) {
                                  launchUrlString(p0,
                                      mode: LaunchMode.externalApplication);
                                  return true;
                                },
                              )
                            : const SizedBox(),
                        data.overviewType.contains("Vendor")
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: data.bytes == null
                                    ? const SizedBox()
                                    : PdfView(
                                        scrollDirection: Axis.vertical,
                                        controller: PdfController(
                                            document: PdfDocument.openData(
                                                data.bytes!)),
                                      ))
                            // SizedBox()
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     moreOptionsAlert(
                        //         context: context,
                        //         data: data.overviewResponse['requestDetails']);
                        //   },
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //         width: 20,
                        //       ),
                        //       Text(
                        //         "Other Details...",
                        //         style: TextStyle(
                        //           color: maincolor,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  data.overviewResponse["status"] == "P" ||
                          data.overviewResponse["status"] == "S"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              content: "Reject",
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    content: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Form(
                                        key: key,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: const Icon(
                                                size: 25,
                                                Icons.close,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Center(
                                              child: DropdownButtonFormField(
                                                  value: selectedvalue,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15))),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  hint: const Text(
                                                      "Example reasons"),
                                                  items: [
                                                    const DropdownMenuItem(
                                                      child: Text(
                                                          "rejection reason 1"),
                                                      value:
                                                          "rejection reason 1",
                                                    ),
                                                    const DropdownMenuItem(
                                                      child: Text(
                                                          "rejection reason 2"),
                                                      value:
                                                          "rejection reason 2",
                                                    )
                                                  ],
                                                  onChanged: (value) {
                                                    rejectnote.text = value!;
                                                    selectedvalue = value;
                                                  }),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            const Text(
                                              "Rejection reason*",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value
                                                          .toString()
                                                          .isEmpty ||
                                                      value.toString() == "") {
                                                    return "field is empty";
                                                  }
                                                },
                                                maxLines: 7,
                                                controller: rejectnote,
                                                decoration: const InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)))),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomButton(
                                                    onPressed: () async {
                                                      if (key.currentState!
                                                          .validate()) {
                                                        loadingAlertBox(
                                                            context);
                                                        try {
                                                          var response = await data.sendapprovalresult(
                                                              approvalid: data
                                                                      .overviewResponse[
                                                                  "approvalID"],
                                                              approvaltype: data
                                                                      .overviewResponse[
                                                                  "approvalType"],
                                                              status: "R",
                                                              comment:
                                                                  rejectnote
                                                                      .text);
                                                          Navigator.pop(
                                                              context);

                                                          Navigator.pop(
                                                              context);
                                                          if (response[
                                                                  "status"] ==
                                                              "S") {
                                                            showSnackbar(
                                                                context,
                                                                response["msg"],
                                                                Colors.green);
                                                            Navigator.pop(
                                                                context, true);
                                                          } else {
                                                            showSnackbar(
                                                                context,
                                                                "somthing went Wrong",
                                                                Colors.red);
                                                          }
                                                        } catch (e) {
                                                          // TODO
                                                          Navigator.pop(
                                                              context);
                                                          showSnackbar(
                                                              context,
                                                              e.toString(),
                                                              Colors.red);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                    content: "Reject",
                                                    color: Colors.red)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            CustomButton(
                                onPressed: () async {
                                  loadingAlertBox(context);
                                  try {
                                    var response =
                                        await data.sendapprovalresult(
                                      approvalid:
                                          data.overviewResponse["approvalID"],
                                      approvaltype:
                                          data.overviewResponse["approvalType"],
                                      status: "A",
                                      comment: "",
                                    );
                                    Navigator.pop(context);
                                    print(
                                        "  approveresponse---------$response");
                                    if (response["status"] == "S") {
                                      showSnackbar(context, response["msg"],
                                          Colors.green);
                                      Navigator.pop(context, true);

                                      return;
                                    } else {
                                      showSnackbar(context,
                                          "somthing went Wrong", Colors.red);
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);

                                    showSnackbar(context, "somthing went Wrong",
                                        Colors.red);
                                  }
                                },
                                content: "Approve",
                                color: maincolor)
                          ],
                        )
                      : const SizedBox(),
                  !(data.overviewResponse["status"] == "P" ||
                          data.overviewResponse["status"] == "S")
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: (data.overviewResponse["status"] == "R")
                                    ? Colors.red
                                    : maincolor
                                // border: Border.all(color: maincolor)
                                ),
                            child: Text(
                              data.overviewResponse["status"] == "AA"
                                  ? "Content already approved"
                                  : (data.overviewResponse["status"] == "A" ||
                                          data.overviewResponse["status"] ==
                                              "C")
                                      ? "Content already been approved"
                                      : "Content already been Rejected",
                              style: const TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

String heading(List data) {
  String a = "";
  data.forEach((e) {
    String key = e.keys.first;
    if (key == "Title") {
      a = e[key];
    }
  });
  return a;
}
