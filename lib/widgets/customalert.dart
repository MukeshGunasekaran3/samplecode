import 'package:flutter/material.dart';
import '../core/constant.dart';

moreOptionsAlert({required BuildContext context, required List data}) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                size: 25,
              ),
            ),
            const Text(
              'More Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("")
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.75,
            child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, i) {
                  String key = data[i].keys.first;
                  String value = data[i][key]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            key,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                            flex: 4,
                            child: Text(
                              value,
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 12),
                            )),
                      ],
                    ),
                  );
                })),
      );
    },
  );
}

historyAlert({required BuildContext context, required List data}) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      print("history alert-----$data");
      return AlertDialog(
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  size: 25,
                )),
            const Text(
              'Approval History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("")
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Container(
            // padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 1,
            child: data.isEmpty
                ? const Center(
                    child: Text("No History"),
                  )
                : ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const SizedBox(),
                    itemBuilder: (context, i) {
                      // String key = data[i].keys.first;
                      // String value = data[i][key]!;
                      return
                          // customtile(
                          //     title: data[i]["approver"].toString().split("@")[0],
                          //     avatartext:
                          //         data[i]["approver"].toString().split("@").first,
                          //     name: "",
                          //     type:
                          //         "${formatDateString(data[i]["date"])}\n${data[i]["comments"]}",
                          //     context: context,
                          //     time: "",
                          //     History: true,
                          //     status: data[i]["status"]);
                          ExpansionTile(
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              textColor: Colors.black,
                              childrenPadding: const EdgeInsets.all(0),
                              expandedAlignment: Alignment.topLeft,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      "${data[i]["approver"]}"
                                          .toString()
                                          .split("@")[0],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    width: 70,
                                    // padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: data[i]["status"] == "A"
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      data[i]["status"] == "A"
                                          ? "Approved"
                                          : "Rejected",
                                      style: TextStyle(
                                          color: data[i]["status"] == "A"
                                              ? Colors.green[700]
                                              : Colors.red[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data[i]["comments"] != "" &&
                                          data[i]["comments"] != null
                                      ? Text(
                                          "Reason : ${data[i]["comments"] ?? "-"}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ))
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    formatDateString(data[i]["date"]),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle( 
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ]);
                    })),
      );
    },
  );
}
