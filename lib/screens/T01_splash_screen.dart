import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward().whenComplete(() {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            //backgroundColor: Colors.yellow,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            width:Get.width,
            height:Get.height ,
            decoration:const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splashscreen.png'),
                fit: BoxFit.cover)
            ),
          ),
        ),
      ),
    );
  }
}

      
