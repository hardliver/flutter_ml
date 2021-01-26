import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedItem = '';

  File pickedImage;
  var imageFile;

  var result = '';

  bool isImageLoaded = false;

  getImageFromGallery() async {
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
    });
  }

  readTextfromanImage() async {
    result = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            result += ' ' + word.text;
          });
        }
      }
    }
  }

  decodeBarCode() async {
    result = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(myImage);

    for (Barcode readableCode in barCodes) {
      setState(() {
        result = readableCode.displayValue;
      });
    }
  }

  Future labelBarCode() async {
    result = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    List labels = await labeler.processImage(myImage);

    for (ImageLabel label in labels) {
      final String text = label.text;
      final double confidence = label.confidence;
      setState(() {
        result += '$text     -     $confidence\n';
      });
    }
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
              : Container(),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(result),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: readTextfromanImage,
        // onPressed: decodeBarCode,
        onPressed: labelBarCode,
        child: Icon(Icons.check),
      ),
    );
  }
}
