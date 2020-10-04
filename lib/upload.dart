//upload
import 'package:flutter/material.dart';
import 'package:flutter_basic/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_basic/models/models.dart';

class Uploadful extends StatefulWidget {
  @override
  _UploadfulState createState() => _UploadfulState();
}

class _UploadfulState extends State<Uploadful> {

  List<GPSTimes> items = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('upload page initialized.');

    _fetchGPSTimes();
    print(items);
  }

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
      });
    } else {
      throw Exception('failed to load data.');
    }
  }
  Future<GPSTimes> deletedata(String id) async {
    final http.Response response = await http.delete(
      'http://scika.pythonanywhere.com/GPS/$id/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 204) {
      return GPSTimes.fromJson(json.decode((response.body)));
    } else {
      print(response.statusCode);
      throw Exception('Failed to delete data.');
    }

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body:ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(color:Colors.amber),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    setState(() {
                    items.removeAt(index);
                  });
                    deletedata(items[index-1].id.toString());
                    },
                  key: Key(items[index].lat + items[index].second.toString() + items[index].month.toString()),
                  child: ListTile(
                    title: Text('(id:${items[index].id})\n ${items[index].lat} : ${items[index].long}\n${items[index].year} / ${items[index].month} / ${items[index].date} / ${items[index].hour} : ${items[index].minute} : ${items[index].second}')
                  ),
                );
                },
            ),
            floatingActionButton: FloatingActionButton(child: Icon(Icons.add_box), onPressed: printing),
        )
    );
  }
  void printing()
  {
    print(items);
  }


}
