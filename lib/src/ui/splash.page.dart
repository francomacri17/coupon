import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shimmer/shimmer.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(70, 0, 0, 0), BlendMode.darken),
                image: new NetworkImage(
                    'https://i.etsystatic.com/10951470/r/il/0e9685/869999991/il_fullxfull.869999991_4ubt.jpg'),
              )),
            ),
            Shimmer.fromColors(
              baseColor: Colors.deepPurple,
              highlightColor: Colors.purple,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Coupon',
                      style: TextStyle(
                          fontSize: 90.0,
                          fontStyle: FontStyle.italic,
                          shadows: <Shadow>[
                            Shadow(
                                blurRadius: 18.0,
                                color: Colors.black87,
                                offset: Offset.fromDirection(120, 12))
                          ]))),
            ),
          ],
        ),
      ),
    );
  }
}
