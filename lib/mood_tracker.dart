import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class FeelingGoal extends StatefulWidget {
  FeelingGoal({Key key, this.title, this.icon}) : super(key: key);

  final String title;
  final Icon icon;

  @override
  _FeelingGoalState createState() => _FeelingGoalState(this.title, this.icon);
}

class _FeelingGoalState extends State<FeelingGoal> {
  _FeelingGoalState(this.title, this.icon);

  final String title;
  final Icon icon;

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => setState(() => checked = !checked),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: 100,
          child: Column(
            children: <Widget>[
              Container(height: 40),
              Icon(
                icon.icon,
                color: (checked) ? Colors.white : Color(0xFF92424F),
                size: 32,
              ),
              Container(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: (checked) ? Colors.white : Color(0xFF92424F),
                ),
              ),
            ],
          ),
          decoration: (checked)
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                      colors: [Color(0xFFF9886C), Color(0xFFF7B42C)],
                      begin: Alignment.topLeft),
                  boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey[700],
                          offset: Offset(2, 2))
                    ])
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
        ),
      ),
    );
  }
}

class FeelingSlider extends StatefulWidget {
  FeelingSlider({Key key}) : super(key: key);

  @override
  _FeelingSliderState createState() => _FeelingSliderState();
}

class _FeelingSliderState extends State<FeelingSlider> {
  final feelingIndicators = [
    'assets/emojis/crying_face.gif',
    'assets/emojis/pouting_face.gif',
    'assets/emojis/weary_face.gif',
    'assets/emojis/frowning_face.gif',
    'assets/emojis/yawning_face.gif',
    'assets/emojis/relieved_face.gif',
    'assets/emojis/upside_down_face.gif',
    'assets/emojis/grinning_face_with_smiling_eyes.gif',
    'assets/emojis/smiling_face_with_sunglasses.gif'
  ];

  double feeling = 4;
  List<FeelingGoal> goals = [
    FeelingGoal(title: 'Friends', icon: Icon(Icons.people)),
    FeelingGoal(title: 'Music', icon: Icon(Icons.music_note)),
    FeelingGoal(title: 'Travel', icon: Icon(Icons.near_me)),
    FeelingGoal(title: 'Gifts', icon: Icon(Icons.card_giftcard)),
    FeelingGoal(title: 'Health', icon: Icon(Icons.healing)),
    FeelingGoal(
        title: 'Sleep', icon: Icon(Icons.airline_seat_individual_suite)),
    FeelingGoal(title: 'Shopping', icon: Icon(Icons.shopping_cart)),
    FeelingGoal(title: 'Weather', icon: Icon(Icons.wb_cloudy)),
    FeelingGoal(title: 'Relaxing', icon: Icon(Icons.weekend))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Row(
          children: [
            Text(
              'Next ',
              style: TextStyle(fontSize: 19),
            ),
            Icon(
              Icons.arrow_forward,
              size: 18,
            ),
          ],
        ),
        backgroundColor: Color(0xFFF7B42C),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/bg/bg_1@4x.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.white.withOpacity(0.2),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Color(0xFFE58C8A), Color(0xFFEEC0C6)],
            //     begin: Alignment.centerLeft,
            //   ),
            // ),
            padding: EdgeInsets.only(top: 50.0, bottom: 70.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'How are you, Akshra?',
                    style: GoogleFonts.quicksand(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8C3048)),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Image.asset(
                      feelingIndicators[feeling.round()],
                      height: 128,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Slider(
                      value: feeling,
                      onChanged: (dat) {
                        setState(() {
                          feeling = dat;
                        });
                      },
                      min: -0.49,
                      max: 8.49,
                      activeColor: Color(0xFF92424F),
                      inactiveColor: Color(0x8892424F),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 45, 30, 30),
                    child: Text(
                      'Would you like to share what\'s making you feel that way?',
                      style: GoogleFonts.quicksand(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8C3048)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(width: 10),
                        for (var goal in goals) goal,
                        Container(width: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
