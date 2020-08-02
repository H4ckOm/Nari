import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeelingGoal extends StatefulWidget {
  final String title;
  final Icon icon;

  FeelingGoal(this.title, this.icon);

  @override
  _FeelingGoalState createState() => _FeelingGoalState(this.title, this.icon);
}

class _FeelingGoalState extends State<FeelingGoal> {
  final String title;
  final Icon icon;

  bool checked = false;

  _FeelingGoalState(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          IconButton(
            icon: icon,
            color: (checked) ? Colors.white : Colors.black,
            onPressed: () {
              setState(() {
                checked = !checked;
              });
            },
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: (checked) ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      decoration: (checked)
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                  colors: [Color(0xFF8f94fb), Color(0xFF4e54c8)],
                  begin: Alignment.topLeft),
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.blueGrey)])
          : BoxDecoration(),
    );
  }
}

class FeelingSlider extends StatefulWidget {
  @override
  _FeelingSliderState createState() => _FeelingSliderState();
}

class _FeelingSliderState extends State<FeelingSlider> {
  final feelingIndicators = [
    '😣', //
    '😔', //
    '☹', //
    '😞', //
    '😶', //
    '🙂', //
    '😀', //
    '😁', //
    '😎', //
  ];
  double feeling = 4;
  List<FeelingGoal> goals = [
    FeelingGoal('Freinds', Icon(Icons.person)),
    FeelingGoal('Music', Icon(Icons.music_note)),
    FeelingGoal('Travel', Icon(Icons.near_me)),
    FeelingGoal('Gifts', Icon(Icons.card_giftcard)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100.0, bottom: 75.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hey Ayush,',
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold),
          ),
          Text(
            'How are you feeling today?',
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          Container(
            height: 30,
          ),
          Text(
            feelingIndicators[feeling.round()],
            style: TextStyle(fontSize: 68.0),
          ),
          Container(
            height: 30,
          ),
          Transform.scale(
            scale: 1.4,
            child: CupertinoSlider(
              value: feeling,
              onChanged: (dat) {
                setState(() {
                  feeling = dat;
                });
              },
              min: 0,
              max: 8,
              activeColor: Colors.grey[100],
            ),
          ),
          Container(
            height: 20,
          ),
          Text(
            'How do you feel that way?',
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                for (var goal in goals) goal,
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFD3CCE3), Color(0xFFE9E4F0)],
              begin: Alignment.topCenter)),
    );
  }
}
