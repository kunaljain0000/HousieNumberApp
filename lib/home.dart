import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

//packages

import 'package:flutter_tts/flutter_tts.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

//toast

import 'package:fluttertoast/fluttertoast.dart';

// main code of homepage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime backbuttonpressedTime;
  // disables the button after each click for 1 second --starts
  double _autospeed = 2;

  bool _isgeneratebuttondisabled = false;
  bool _isswitchedauto = false;

  // disables the button after each click for 1 second --ends

  // some variables and code for generating random number and checking that the number is not repeating again --starts
  var buttontext = "Start";
  final FlutterTts flutterTts = FlutterTts();
  var number = '0';
  var previous = '0';
  var currNumber = "";

  // generating the random number --starts

  Future _generatenumber() async {
    setState(() {
      buttontext = "Next";
    });

    if (this.numberdone.length >= 90) {
      return;
    }

    int randomnumber = Random().nextInt(90) + 1;
    while (this.numberdone.indexOf(randomnumber) >= 0) {
      randomnumber = Random().nextInt(90) + 1;
    }

    setState(() {
      if (numberdone.length == 90) {
        number = 'Game Over';
      } else {
        previous = '$number';
        number = '$randomnumber';
        this.numberdone.insert(0, randomnumber);
      }
    });

    // checking if the number is single digit

    setState(() {
      if (number.length == 1) {
        currNumber = "Single number ";
      } else {
        for (int i = 0; i < number.length; i++) {
          currNumber += number[i];
          currNumber += " ";
        }
      }
    });

    // checking if the number is single digit

    // generating the random number --ends

    // Some code for speaking the random number --starts --package used = flutter_tts

    await flutterTts.setLanguage('en-IN');
    print(await flutterTts.getVoices);
    await flutterTts.setPitch(1);
    await flutterTts.speak(currNumber + '($number)');
    await flutterTts.setVolume(3.0);

    setState(() {
      currNumber = "";
    });

    // Some code for speaking the random number --ends --package used = flutter_tts

    // the timing logic for disabling and enabling the button --starts

    Timer(Duration(microseconds: 400), () {
      setState(() {
        _isgeneratebuttondisabled = true;
      });
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isgeneratebuttondisabled = false;
      });
    });

    // the timing logic for disabling and enabling the button --end
  }

  // exit app logic -- ends

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }

  Future autoplay() async {
    if (_isswitchedauto == true) {
      _isgeneratebuttondisabled = true;
    } else {
      _isgeneratebuttondisabled = false;
    }
    while (numberdone.length < 90) {
      if (_isswitchedauto) {
        await new Future.delayed(Duration(seconds: (_autospeed).ceil()), () {
//        print("hello");
        });
        _generatenumber();
        setState(() {
          if (numberdone.length == 90) {
            number = 'Game Over';
          }
        });

//      print('length= ${numberdone.length}');
      } else {
        break;
      }
    }
  }
  // exit app logic -- starts

  // some variables and code for generating random number and checking that the number is not repeating again --ends

  // reseting for new game --starts

  void _reset() {
    setState(() {
      if (_isswitchedauto) {
        Fluttertoast.showToast(
            msg: 'Please off the Auto button first',
            backgroundColor: Colors.black,
            textColor: Colors.white);
      } else {
        previous = '0';
        this.numberdone = List();
        number = '0';
        _isgeneratebuttondisabled = false;
        buttontext = "Start";
      }
    });
  }

  // reseting for new game --ends

  // list to store random numbers --starts

  List<int> numberdone = List();

  // list to store random numbers --ends

  // simple design for the number display --starts

  Widget generatecell(int number) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            (this.numberdone.indexOf(number) >= 0) ? Colors.red : Colors.blue,
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: (this.numberdone.indexOf(number) >= 0)
                  ? Colors.white
                  : Colors.white),
        ),
      ),
    );
  }
  // simple design for the number display --ends

  // main code --starts

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          title: Text('Housie Number Generator'),
          backgroundColorStart: Colors.blueAccent[900],
          backgroundColorEnd: Colors.indigo,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: onWillPop,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40)),
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Center(
                            child: Text(
                              ' Previous : $previous',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        height: 40,
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Center(
                              child: Text(
                            'Reset',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          )),
                          onPressed: _reset,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 10,
                      childAspectRatio: 10 / 10,
                      children: List.generate(90, (number) {
                        return generatecell(number + 1);
                      })),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 250,
                        child: RaisedButton(
                            color: Colors.blue,
                            child: Center(
                                child: Text(
                              _isswitchedauto ? 'Auto' : buttontext,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            )),
                            onPressed: _isswitchedauto
                                ? null
                                : _isgeneratebuttondisabled
                                    ? null
                                    : _generatenumber),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Manual',
                          style: TextStyle(
                            color: _isswitchedauto ? Colors.black : Colors.blue,
                            fontSize: 20,
                            fontWeight: _isswitchedauto
                                ? FontWeight.normal
                                : FontWeight.bold,
                          )),
                      Switch(
                        value: _isswitchedauto,
                        onChanged: (value) {
                          setState(() {
                            _isswitchedauto = value;
                            _isgeneratebuttondisabled = true;
                          });
                          if (_isswitchedauto) {
                            autoplay();
                          }
                        },
                        activeTrackColor: Colors.blue,
                        activeColor: Colors.white,
                      ),
                      Text('Auto',
                          style: TextStyle(
                            color: _isswitchedauto ? Colors.blue : Colors.black,
                            fontSize: 20,
                            fontWeight: _isswitchedauto
                                ? FontWeight.bold
                                : FontWeight.normal,
                          )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: _isswitchedauto
                          ? PopupMenuButton(
                              icon: InkWell(
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text("2x"),
                                  value: 2,
                                ),
                                PopupMenuItem(
                                  child: Text("3x"),
                                  value: 3,
                                ),
                                PopupMenuItem(
                                  child: Text("4x"),
                                  value: 4,
                                ),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  _autospeed = _autospeed;
                                  _autospeed = value + _autospeed;
                                });
                              },
                            )
                          : null,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// main code --ends
