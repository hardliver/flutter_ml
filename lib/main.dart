import 'package:flutter/material.dart';
import 'package:flutter_ml/DetailScreen.dart';

void main() => runApp(MaterialApp(
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> itemList = [
    'Text Scanner',
    'Barcode Scanner',
    'Label Scanner',
    'Face Detection'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ML Kit Demo'), centerTitle: true),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (content, index) {
          return Card(
            child: ListTile(
              title: Text(itemList[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => DetailScreen(),
                    settings: RouteSettings(arguments: itemList[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
