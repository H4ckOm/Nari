import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  // TODO: Modify these dummy URLs
  static const _PrPurl = "https://nari.app/privacy-policy.html";
  static const _ToSurl = "https://nari.app/terms-of-service.html";

  // description text
  final descText =
      '\nWe are NARI – a well-informed community determined to help each other'
      'grow emotionally and economically stronger and more powerful.\n\n';

  // various parameters to control animated widgets
  var _top = -275.0;
  var _shadow = BoxShadow(color: Colors.transparent);
  var _wlcmOpacity = 0.0;
  var _bgcolor = Colors.white;
  var _descOpacity = 0.0;
  var _bttnOpacity = 0.0;

  Widget _bgWidget = Container();

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

      // set state to trigger other animated widgets
      setState(() {
        _bgWidget = FadeInImage(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            placeholder: MemoryImage(kTransparentImage),
            image: AssetImage('assets/bg/bg_1@4x.png'),
            fadeInCurve: Curves.fastOutSlowIn,
            fadeOutDuration: Duration(milliseconds: 1));
        _bgcolor = Color(0xFFF7F7F7);
        _top = -320.0;
        _shadow = BoxShadow(
            color: Color(0x52000000), blurRadius: 12.0, offset: Offset(0, 3));
      });

      // display welcome text when the other widgets have finished loading
      Future.delayed(Duration(seconds: 1), () {
        setState(() => _wlcmOpacity = 1.0);
        Future.delayed(Duration(milliseconds: 700), () {
          setState(() => _descOpacity = 1.0);
          Future.delayed(
              Duration(seconds: 1), () => setState(() => _bttnOpacity = 1.0));
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
      child: Stack(
        children: <Widget>[
          //
          // Background Widget (having image)

          Container(color: Colors.white),
          _bgWidget,

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
                      boxShadow: [_shadow]),
                ),
              ),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn),

          // Logo

          SlideTransition(
            position: _offsetAnimation,
            child: Center(
              child: AnimatedContainer(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo/512x512.png'),
                      radius: 100,
                      backgroundColor: _bgcolor),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: Color(0x29000000),
                        blurRadius: 6.0,
                        offset: Offset(0, 3))
                  ]),
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn),
            ),
          ),

          // Secondary Widgets (Less Animated)

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
                        child: Text(
                          "Welcome!",
                          style: TextStyle(
                              color: Color(0xFF92424F),
                              fontSize: 32,
                              fontWeight: FontWeight.w600),
                        ),
                        curve: Curves.fastOutSlowIn),

                    // Description Text

                    AnimatedOpacity(
                        opacity: _descOpacity,
                        duration: Duration(seconds: 1),
                        child: Text(
                          descText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF8C3048),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        curve: Curves.easeIn),

                    // Join Us Button

                    AnimatedOpacity(
                        opacity: _bttnOpacity,
                        duration: Duration(seconds: 1),
                        child: RaisedButton(
                          onPressed: () =>
                              // TODO: redirect to sign up/login screen
                              print('redirect karo ise'),
                          shape: StadiumBorder(),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                            child: Text(
                              'Join Us',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF92424F)),
                            ),
                          ),
                        ),
                        curve: Curves.fastOutSlowIn),

                    // ToS and Privacy Policy Links

                    AnimatedOpacity(
                      opacity: _bttnOpacity,
                      duration: Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      child: Text.rich(
                          TextSpan(
                            text: '\n\nBy joining, you agree to our\n',
                            style: TextStyle(color: Color(0xFF8C3048)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(_ToSurl)),
                              TextSpan(text: ' and '),
                              TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(_PrPurl)),
                              TextSpan(text: '.')
                            ],
                          ),
                          textAlign: TextAlign.center),
                    ),

                    //
                  ],
                ),
                alignment: Alignment.center),
          )
        ],
      ),
    );
  }
}
