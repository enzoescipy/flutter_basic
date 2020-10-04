//login
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basic/models/models.dart';

class Loginful extends StatefulWidget {
  @override
  _LoginfulState createState() => _LoginfulState();
}

class _LoginfulState extends State<Loginful> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body:Text('hello1')
        )
    );
  }
}