import 'package:approver/provider/provider.dart';
import 'package:approver/screen/landing.dart';
import 'package:approver/screen/login.dart';
import 'package:approver/widgets/Navigatorfunc.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController? anime;
  @override
  void initState() {
    super.initState();
    anime = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DashData>(context, listen: false).checkConnectivity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: Text("")),
            Center(
                child: Lottie.asset(
              controller: anime,
              "assets/images/Flow46.json",
              height: 150,
              width: 375,
              onLoaded: (value) async {
                anime!
                  ..duration = value.duration
                  ..forward();
                await Future.delayed(const Duration(milliseconds: 1800));
                SharedPreferences s = await SharedPreferences.getInstance();
                String user = s.getString("user") ?? "";
                print("splash screen-----$user");
                NavigatorRemoveUntil(
                    context: context,
                    page: user != "" ? const landing() : const login());
              },
            )),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/images/pngwing.com.png",
                    fit: BoxFit.fitHeight,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
