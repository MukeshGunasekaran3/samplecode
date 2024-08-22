import 'package:approver/core/theme.dart';
import 'package:approver/provider/provider.dart';
import 'package:approver/screen/landing.dart';
import 'package:approver/widgets/Navigatorfunc.dart';
import 'package:approver/widgets/custombutton.dart';
import 'package:approver/widgets/customloader.dart';
import 'package:approver/widgets/customsnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  GlobalKey<FormState> validatekey = GlobalKey<FormState>();
  RegExp? regExp;
  TextEditingController otpPinController = TextEditingController();
  TextEditingController userid = TextEditingController();
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  bool formIsValid = false;
  String? errorText;

  @override
  void initState() {
    // TODO: implement initState
    regExp = RegExp(pattern);
  }

  @override
  Widget build(BuildContext context) {
    DashData provider = Provider.of<DashData>(context);
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: validatekey,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(255, 5, 79, 139),
                        maincolor,
                      ],
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Material(
                elevation: 15,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView(
                    children: [
                      Center(
                        child: provider.loginloader
                            ? Lottie.asset(
                                "assets/images/Flow46.json",
                                height: 125,
                                width: 125,
                              )
                            : SizedBox(
                                height: 125,
                                width: 125,
                                child: Image.asset("assets/images/spark.png")),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "User Id",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          userid.value =
                              userid.value.copyWith(text: value.toUpperCase());
                          if (regExp!.hasMatch(value)) {
                            errorText = null;
                            provider.useridvaluechange(data: value);
                          } else {
                            provider.useridvaluechange(data: "");
                            errorText =
                                " Invalid format. Use: example@flattrade.in.";
                            setState(() {});
                          }
                        },
                        validator: (value) {
                          if (value.toString().isEmpty ||
                              value.toString() == "") {
                            return "field is empty";
                          } else if (regExp!.hasMatch(value!) == false) {
                            return "Eg: example@flattrade.in";
                          }
                        },
                        controller: userid,
                        decoration: InputDecoration(
                            errorStyle:
                                TextStyle(fontSize: 12, color: maincolor),
                            errorText: errorText,
                            hintText: "Enter the User Id",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: maincolor,
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: provider.userid == ""
                                ? null
                                : () async {
                                    provider.changesloginloader();
                                    try {
                                      await provider.getuserotp();
                                      provider.changesloginloader();
                                      showSnackbar(
                                          context,
                                          "otp send to your registered mobile number",
                                          maincolor);
                                    } catch (e) {
                                      provider.changesloginloader();
                                      showSnackbar(
                                          context, e.toString(), Colors.red);
                                    }
                                  },
                            child: Text(
                              provider.apiotp == ""
                                  ? "Generate OTP"
                                  : "Regenerate OTP",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: provider.userid == ""
                                      ? Colors.grey
                                      : maincolor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "OTP",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: provider.apiotp == ''
                                ? Colors.grey
                                : Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      PinFieldAutoFill(
                        enabled: provider.apiotp != '',
                        // true,
                        cursor: Cursor(
                            enabled: true,
                            width: 2,
                            height: 20,
                            color: maincolor),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        codeLength: 6,
                        decoration: BoxLooseDecoration(
                            gapSpace: 12,
                            radius: Radius.circular(6.5),
                            strokeWidth: 1.3,
                            textStyle: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 17.0,
                                color: Colors.black),
                            strokeColorBuilder:
                                PinListenColorBuilder(maincolor, Colors.grey),
                            bgColorBuilder: FixedColorBuilder(
                                Color.fromRGBO(255, 255, 255, 1))),
                        enableInteractiveSelection: false,
                        currentCode: otpPinController.text,
                        controller: otpPinController,
                        onCodeChanged: (p0) {
                          if (p0!.length == 6) {
                            provider.useridvaluechange(data: p0, isotp: true);
                          } else {
                            provider.useridvaluechange(data: "", isotp: true);
                          }
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // InkWell(
                          //   onTap: provider.userid == ""
                          //       ? null
                          //       : () async {
                          //           provider.changesloginloader();
                          //           try {
                          //             await provider.getuserotp();
                          //             provider.changesloginloader();
                          //             showSnackbar(
                          //                 context,
                          //                 "otp send to your registered mobile number",
                          //                 maincolor);
                          //           } catch (e) {
                          //             provider.changesloginloader();
                          //             showSnackbar(
                          //                 context, e.toString(), Colors.red);
                          //           }
                          //         },
                          //   child: Text(
                          //     provider.apiotp == ""
                          //         ? "Generate OTP"
                          //         : "Regenerate OTP",
                          //     style: TextStyle(
                          //         fontSize: 12,
                          //         color: provider.userid == ""
                          //             ? Colors.grey
                          //             : maincolor),
                          //   ),
                          // ),
                          // CustomButton(
                          //     onPressed: provider.userid == ""
                          //         ? null
                          //         : () async {
                          //             provider.changesloginloader();
                          //             try {
                          //               await provider.getuserotp();
                          //               provider.changesloginloader();
                          //               showSnackbar(
                          //                   context,
                          //                   "otp send to your registered mobile number",
                          //                   maincolor);
                          //             } catch (e) {
                          //               provider.changesloginloader();
                          //               showSnackbar(
                          //                   context, e.toString(), Colors.red);
                          //             }
                          //           },
                          //     content: provider.apiotp == ""
                          //         ? "Generate OTP"
                          //         : "Regenerate OTP",
                          //     color: maincolor),
                          CustomButton(
                              minwidth: 100,
                              onPressed: provider.userid == "" ||
                                      provider.otp == ""
                                  ? null
                                  : () async {
                                      if (validatekey.currentState!.validate()
                                          // ||provider.otp != ""
                                          ) {
                                        try {
                                          provider.changesloginloader();
                                          await provider.getuserdetails();
                                          provider.changesloginloader();
                                          provider.useridvaluechange(
                                              data: "", isotp: true);
                                          provider.useridvaluechange(data: "");
                                          NavigatorRemoveUntil(
                                              context: context,
                                              page: landing());
                                        } catch (e) {
                                          provider.changesloginloader();
                                          showSnackbar(context, e.toString(),
                                              Colors.red);
                                        }
                                      }
                                    },
                              content: "Submit",
                              color: maincolor),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
