
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:page_transition_animation/pages/dashboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController _pageController;

  AnimationController _rippleController;
  AnimationController _scaleController;

  Animation<double> _rippleAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    _rippleController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _scaleController = AnimationController(vsync: this, duration: Duration(seconds: 1))
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(context, PageTransition(child: Dashboard(), type: PageTransitionType.fade));
      }
    });

    _rippleAnimation = Tween<double>(begin: 80.0, end: 90.0).animate(_rippleController)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rippleController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _rippleController.forward();
      }
    });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 30.0).animate(_scaleController);

    _rippleController.forward();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _scaleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          makePage(image: 'assets/images/one.jpg'),
          makePage(image: 'assets/images/two.jpg'),
          makePage(image: 'assets/images/three.jpg'),
        ],
      ),
    );
  }

  Widget makePage({@required image}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(.3),
              Colors.black.withOpacity(.3),
            ]
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Text('Exercise 1', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('15', style: TextStyle(color: Colors.yellow[400], fontSize: 40, fontWeight: FontWeight.bold),),
                  Text('Minutes', style: TextStyle(color: Colors.white, fontSize: 30),)
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('3', style: TextStyle(color: Colors.yellow[400], fontSize: 40, fontWeight: FontWeight.bold),),
                  Text('Exercises', style: TextStyle(color: Colors.white, fontSize: 30),)
                ],
              ),
              SizedBox(height: 180),
              Text('Start the ornign with your health', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w100)),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) => Container(
                    width: _rippleAnimation.value,
                    height: _rippleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(.4)
                      ),
                      child: InkWell(
                        onTap: () => _scaleController.forward(),
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) => Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue
                              ),
                            ),
                          )
                        ),
                      ),
                    ),
                  )
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}