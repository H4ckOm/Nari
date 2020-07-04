import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  final descText =
      '\nWe are NARI - a well-informed community determined to help each other grow emotionally and economically stronger and more powerful.\n\n';

  Widget logo({Color backgroundColor: Colors.white}) {
    return Center(
        child: AnimatedContainer(
            child: CircleAvatar(
                backgroundImage: AssetImage('assets/logo/512x512.png'),
                radius: 100,
                backgroundColor: backgroundColor),
            height: 200,
            width: 200,
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3))
            ]),
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn));
  }

  var _color = Colors.white;
  var _top = -275.0;
  var _shadow = new BoxShadow(color: Colors.transparent);
  var _wlcmOpacity = 0.0;
  var _bgcolor = Colors.white;
  var _descOpacity = 0.0;
  var _bttnOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    // setting up base animation
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, -0.25))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward().whenComplete(() {
      // logo has reached its final position

      // change state to trigger other animated widgets
      setState(() {
        _bgcolor = Color(0xFFF7F7F7);
        _color = Color(0xFF70307C);
        _top = -320.0;
        _shadow = new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.32),
            blurRadius: 12.0,
            offset: const Offset(0, 3));
      });

      // display welcome text when the other widgets have finished loading
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _wlcmOpacity = 1.0;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _descOpacity = 1.0;
          });
          Future.delayed(const Duration(milliseconds: 1500), () {
            setState(() {
              _bttnOpacity = 1.0;
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: <Widget>[
      //
      // Background Container (Pink)

      AnimatedContainer(
          decoration: BoxDecoration(color: _color),
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn),
      //
      // Circular Container (White)

      AnimatedPositioned(
          top: _top,
          left: -256 + (MediaQuery.of(context).size.width / 2),
          child: Center(
              child: Container(
                  height: 512,
                  width: 512,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        _shadow,
                      ]))),
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn),
      //
      // Logo

      SlideTransition(
          position: _offsetAnimation, child: logo(backgroundColor: _bgcolor)),
      //
      // Welcome Text

      Positioned(
          top: 280,
          left: 32,
          width: MediaQuery.of(context).size.width - 64,
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //
                    // Welcome Text

                    AnimatedOpacity(
                        opacity: _wlcmOpacity,
                        duration: Duration(seconds: 1),
                        child: Text("Welcome!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w500)),
                        curve: Curves.fastOutSlowIn),

                    // Description Text

                    AnimatedOpacity(
                        opacity: _descOpacity,
                        duration: Duration(seconds: 1),
                        child: Text(descText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        curve: Curves.fastOutSlowIn),

                    // Join Us Button

                    AnimatedOpacity(
                        opacity: _bttnOpacity,
                        duration: Duration(seconds: 1),
                        child: RaisedButton(
                            onPressed: () {
                              // TODO: redirect to sign up/login screen
                              print('redirect karo ise');
                            },
                            shape: StadiumBorder(),
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                                child: const Text('Join Us',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF70307c))))),
                        curve: Curves.fastOutSlowIn),
                    AnimatedOpacity(
                        opacity: _bttnOpacity,
                        duration: Duration(seconds: 2),
                        curve: Curves.easeInOut,
                        child: new InkWell(
                            child: Text('\n\nRead our privacy policy.',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              // TODO: show privacy policy
                              print('chull machi hai');
                            })),
                  ]),
              alignment: Alignment.center)),
    ]));
  }
}
