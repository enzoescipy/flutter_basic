//main
import 'package:flutter/material.dart';
import 'package:flutter_basic/add.dart';
import 'package:flutter_basic/upload.dart';
import 'package:flutter_basic/login.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GPSloader(),
    );
  }
}


class GPSloader extends StatefulWidget {
  @override
  _GPSloaderState createState() => _GPSloaderState();
}

class _GPSloaderState extends State<GPSloader> {
  int _currentindex = 0;
  final _children = [Loginful(), Addful(), Uploadful()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title: Text('GPS'),),
        body: _children[_currentindex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          currentIndex: _currentindex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.vpn_key), title: Text('Login'),),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Add'),),
            BottomNavigationBarItem(icon: Icon(Icons.update), title: Text('Upload'),),
      ],
      ),
    ));
  }

  void onTap(int index){
    setState(() {
      _currentindex = index;
    });
  }
}






