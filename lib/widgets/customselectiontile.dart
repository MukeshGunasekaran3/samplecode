// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:approver/core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionTile extends StatelessWidget {
  final void Function()? onTap;
  final String heading;
  final int count;
  final bool shadow;
  const SelectionTile({
    Key? key,
    required this.onTap,
    required this.heading,
    required this.count,
    required this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              height: 100,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                // boxShadow: [
                //   shadow
                //       ? BoxShadow(
                //           color:
                //               Colors.black.withOpacity(0.2), // Shadow color
                //           spreadRadius: 5, // Spread radius
                //           blurRadius: 5, // Blur radius
                //           offset: Offset(0, 3), // Shadow position (x, y)
                //         )
                //       : BoxShadow()
                // ],
                borderRadius: BorderRadius.circular(20),
                boxShadow: shadow
                    ? [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          spreadRadius: 3, // The spread radius
                          blurRadius: 5, // The blur radius
                          offset: Offset(0, 3), // Shadow position (x, y)
                        ),
                      ]
                    : [],
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: shadow
                      ? [
                          Colors.blue,
                          maincolor,
                          const Color.fromARGB(255, 3, 44, 104),
                        ]
                      : [
                          Color.fromARGB(255, 207, 203, 203),
                          Colors.grey,
                        ],
                ),
              ),
              child: Text(
                heading,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )),
            count == 0
                ? const Text("")
                : Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.red,
                      child: Text(
                        count.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
