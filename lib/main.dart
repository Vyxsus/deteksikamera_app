import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(OcrApp());
}

class OcrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OcrHomePage(),
    );
  }
}

class OcrHomePage extends StatefulWidget {
  @override
  _OcrHomePageState createState() => _OcrHomePageState();
}

class _OcrHomePageState extends State<OcrHomePage> {
  File? _image;
  String _recognizedText = '';

  Future<void> _getImageAndRecognizeText() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _recognizedText = recognizedText.text;
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OCR Camera')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImageAndRecognizeText,
              child: Text('Ambil Gambar & Baca Teks'),
            ),
            SizedBox(height: 24),
            Text(
              _recognizedText,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
