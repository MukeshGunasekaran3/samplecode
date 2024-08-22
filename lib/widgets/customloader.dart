import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

loadingAlertBox(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
              alignment: Alignment.center,
              child: Lottie.asset(
                "assets/images/Flow46.json",
                height: 100,
                width: 250,
              )),
        ),
      );
    },
  );
}
