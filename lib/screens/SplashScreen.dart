import 'package:flutter/material.dart';
import 'package:shopping_list/screens/Home.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDelay();
  }

  getDelay() async {
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          this.context, CustomPageRoutes(child: Home(title: widget.title)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome To",
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 15),
              Image.asset(
                "assets/images/app_icon.png",
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              const SizedBox(height: 15),
              const Text(
                "List Check",
                style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 15),
              Text(
                "Develop By @sanaulla-shaikh",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
        )));
  }
}

class CustomPageRoutes extends PageRouteBuilder {
  final Widget child;

  CustomPageRoutes({required this.child})
      : super(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) => child,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // const begin = Offset(0, -1);
              // const end = Offset.zero;
              // final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
              // final offsetAnimation = animation.drive(tween);

              return FadeTransition(
                opacity:animation,
                child: child,
              );
            });
}
