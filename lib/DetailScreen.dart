import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedItem = '';

  File pickedImage;
  var imageFile;

  bool isImageLoaded = false;

  getImageFromGallery() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedItem = ModalRoute.of(context).settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem),
        centerTitle: true,
        actions: [
          RaisedButton(
            onPressed: getImageFromGallery,
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            color: Colors.blue,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          isImageLoaded
              ? Center(
                  child: Container(
                    height: 250.0,
                    width: 250.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: FileImage(pickedImage),
                      fit: BoxFit.cover,
                    )),
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.check),
      ),
    );
  }
}
