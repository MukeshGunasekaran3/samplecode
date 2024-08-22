import 'dart:io';
import 'dart:math';
import 'package:approver/core/constant.dart';
import 'package:intl/intl.dart';
import 'package:approver/core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customtile extends StatelessWidget {
  final String avatartext;
  final String title;
  final String name;
  final String type;
  final BuildContext context;
  final String time;
  final String status;
  // final bool History;
  final void Function()? onTap;

  const customtile(
      {super.key,
      required this.avatartext,
      required this.name,
      required this.type,
      required this.context,
      this.onTap,
      required this.time,
      required this.status,
      // this.History = false,
      required this.title});

  @override
  Widget build(context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: double.infinity,
          decoration: BoxDecoration(
              // color: status == "Process"
              //     ? Colors.white
              //     : status == "Approved"
              //         ? Colors.green.withOpacity(0.1)
              //         : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Row(
                children: [
                  // SizedBox(
                  //   width: 5,
                  // ),

                  CircleAvatar(
                    backgroundColor: getRandomPastelColor(),
                    minRadius: 22,
                    child: Text(
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        avatartext != ""
                            ? "${avatartext[0].toUpperCase()}${avatartext[avatartext.length - 1].toUpperCase()}"
                            : "TE"),
                  ),

                  //  status == "Approved"
                  //     ? Icon(
                  //         Icons.verified,
                  //         size: 40,
                  //         color: Colors.green,
                  //       )
                  //     : Icon(
                  //         Icons.warning,
                  //         size: 40,
                  //         color: Colors.red,
                  //       ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          type,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        // SizedBox(
                        //   height: 2,
                        // ),
                        Text(
                          "Requested from $name on ${formatDateString(time)}",
                          overflow: TextOverflow.visible,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: Text(
                  //     time.substring(0, 10),
                  //     style: TextStyle(
                  //         color: Colors.green,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // SizedBox(
                  // //   width: 5,
                  // // ),
                  status == "P" || status == "S"
                      ? SizedBox()
                      : Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 70,
                          // padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: status == "A"
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            status == "A" ? "Approved" : "Rejected",
                            style: TextStyle(
                                color: status == "A"
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }
}
