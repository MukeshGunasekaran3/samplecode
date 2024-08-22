import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String content;
  final Color color;
  double minwidth;

  CustomButton(
      {super.key,
      this.minwidth = 0,
      required this.onPressed,
      required this.content,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        content,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
          minimumSize: MaterialStatePropertyAll(Size(
              minwidth == 0
                  ? MediaQuery.of(context).size.width * 0.4
                  : minwidth,
              MediaQuery.of(context).size.height * 0.05)),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          backgroundColor: MaterialStatePropertyAll(
              onPressed == null ? Colors.grey[350] : color)),
    );
  }
}
