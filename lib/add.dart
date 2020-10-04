//add
import 'package:flutter/material.dart';
import 'package:flutter_basic/models/models.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basic/models/models.dart';

class Addful extends StatefulWidget {
  @override
  _AddfulState createState() => _AddfulState();
}

class _AddfulState extends State<Addful> {

  List<GPSTimes> items = [];
  bool isLoading = false;

  Position _position;
  double _latitude = 0.0;
  double _longtitude = 0.0;
  DateTime _time;
  int _year = 0;
  int _month = 0;
  int _date = 0;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  int _id = 0;

  List<GPSTimes> parseGPSTimes(String responseBody){
    var parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<GPSTimes>((json) => GPSTimes.fromJson(json)).toList();
  }

  _fetchGPSTimes() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get('http://scika.pythonanywhere.com/GPS/');
    if(response.statusCode == 200) {
      setState(() {
        items = parseGPSTimes(utf8.decode(response.bodyBytes));
        isLoading = false;
        print("well parsed.");
      });
    } else {
      throw Exception('failed to load data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset('images/world.png'),
                    Container(

                      height: 200 * (90 - _latitude) / 180,
                      width: MediaQuery.of(context).size.width * (168 + _longtitude) / 360,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Image.asset('images/down_right.png', width:20, height:20)],
                        )],
                      ),
                    )
                  ],
                ),
                Text('$_position'),
                Container(
                  width: 290,
                  height: 290,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 270,
                            height: 270,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                              margin: const EdgeInsets.all(36.0),
                              width: 270,
                              height: 270,
                              child: Center(
                                child: Text(
                                  '${_hour} : ${_minute}',
                                  style: GoogleFonts.bungee(
                                      fontSize: 60.0,
                                      textStyle: TextStyle(color: Colors.blueGrey),
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                        ),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 250.0,
                            lineWidth: 6.0,
                            animation: true,
                            percent: _second / 60,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: hexToColor('#2c3143'),
                            progressColor: hexToColor('#58CBF4'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text('$_time'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(child: Icon(Icons.add_box), onPressed: () => updatevalues(),),
        )
    );
  }
  void updatevalues() async {
    Position newposition = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _fetchGPSTimes().whenComplete(() {
      List<int> idlist = items.map((e) => e.id).toList();
      setState(() {
        _position = newposition;
        _latitude = _position.latitude;
        _longtitude = _position.longitude;

        _time = DateTime.now();
        _hour = _time.hour.toInt();
        _minute = _time.minute.toInt();
        _second = _time.second.toInt();
        _year = _time.year.toInt();
        _month = _time.month.toInt();
        _date = _time.day.toInt();
        if (idlist.length == 0){
          _id = 0;
        } else if (idlist.length == 1) {
          _id = idlist[0] + 1;
        } else {
          _id = idlist.reduce((current, next) => current > next ? current : next) + 1;
        }

        GPSTimes GPSTimer = GPSTimes(
          id: _id,
          lat: _latitude.toString(),
          long: _longtitude.toString(),
          year: _year,
          month: _month,
          date: _date,
          hour: _hour,
          minute: _minute,
          second: _second,
        );

        postGPSTimes(GPSTimer);
        print('Added properties to sever.');

      });
    });

  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<GPSTimes> postGPSTimes(GPSTimes gpstimes) async {
    final http.Response response = await http.post(
        'http://scika.pythonanywhere.com/GPS/',
    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(<String, dynamic>{
      'id' : gpstimes.id.toInt(),
      'lat' : double.parse(gpstimes.lat),
      'long' : double.parse(gpstimes.long),
      'year' : gpstimes.year.toInt(),
      'month' : gpstimes.month.toInt(),
      'date' : gpstimes.date.toInt(),
      'hour' : gpstimes.hour.toInt(),
      'minute' : gpstimes.minute.toInt(),
      'second' : gpstimes.second.toInt(),
    }));
    if (response.statusCode == 200) {
      return GPSTimes.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('failed to post GPSTimes.');
    }
  }
}
