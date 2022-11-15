import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:convert';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppBarMain(),
    );
  }
}

class AppBarMain extends StatefulWidget {
  const AppBarMain({super.key});

  @override
  State<AppBarMain> createState() => _AppBarMainState();
}

class _AppBarMainState extends State<AppBarMain> {
  State<AppBarMain> createState() => _AppBarMainState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Park Translater'),
      ),
      body: Center(
          child: IconButton(
        icon: const Icon(Icons.camera_alt_rounded),
        iconSize: 75,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ParkCamera()),
          );
        },
      )),
    );
  }
}

class ParkCamera extends StatefulWidget {
  const ParkCamera({super.key});

  @override
  State<ParkCamera> createState() => _ParkCameraState();
}

class _ParkCameraState extends State<ParkCamera> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Park Scanner'),
        ),
        body: Center(
          child: Column(
            children: [
              if (imageFile != null)
                (Image.file(imageFile!,
                    fit: BoxFit.contain, height: 580, width: 1080))
              else
                (Container(
                  width: 300,
                  height: 480,
                  alignment: Alignment.center,
                  child: const Text('Image will appear here'),
                )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => fetchImage(source: ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        child: const Text('Capture Picture'),
                      )),
                  SizedBox(
                      width: 150,
                      height: 50,
                      child: IconButton(
                        icon: const Icon(Icons.navigate_next_rounded),
                        iconSize: 75,
                        onPressed: () {
                          if (imageFile != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignTranslater(imageFile: imageFile!)),
                            );
                          } else {
                            setState(() {
                              _showMyDialog();
                            });
                            debugPrint("No Image");
                          }
                        },
                      )),
                  SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () =>
                            fetchImage(source: ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        child: const Text('Select Picture'),
                      )),
                ],
              )
            ],
          ),
        ));
  }

  void fetchImage({required ImageSource source}) async {
    debugPrint("entering fetchimage");
    final imageFile = await ImagePicker().pickImage(source: source);

    if (imageFile == null) return;
    final imageTemp = File(imageFile.path);
    setState(() => this.imageFile = imageTemp);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('There is no image selected or captured'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class SignTranslater extends StatefulWidget {
  File imageFile;
  SignTranslater({super.key, required this.imageFile});

  @override
  State<SignTranslater> createState() =>
      // ignore: no_logic_in_create_state
      _SignTranslaterState(imageFile: imageFile);
}

class _SignTranslaterState extends State<SignTranslater> {
  File imageFile;
  _SignTranslaterState({required this.imageFile});
  String imageText = ('');

  @override
  Widget build(Object context) {
    if (imageText == ('')) {
      translateMethod(imageFile, imageText);
      return const Center(
        child: SizedBox(
          height: 200.0,
          width: 200.0,
          child: CircularProgressIndicator(
            strokeWidth: 5,
          ),
        ),
      );
    } else {
      int numberOfLines = 0;
      final imageTextLines = interpretText(imageText);
      for (var i = 0; i < imageTextLines.length; i++) {
        numberOfLines = i;
        debugPrint("Line: $numberOfLines ${imageTextLines[i]}");
      }
      return Scaffold(
          appBar: AppBar(title: const Text('Translated')),
          body: Center(
              child: Column(children: [
            SizedBox(
                child: Text(
              ("Du får parkera mellan: $imageTextLines[0]"),
              style: const TextStyle(fontSize: 30),
            )),
          ])));
    }
  }

  void translateMethod(imageFile, String imageText) async {
    debugPrint('entering translateMethod');
    imageText = await FlutterTesseractOcr.extractText(imageFile.path);
    debugPrint(imageText);
    setState(() => this.imageText = imageText);
  }

  List<String> interpretText(String imageText) {
    const splitter = LineSplitter();
    int numberOfLines = 0;
    final imageTextLines = splitter.convert(imageText);
    /*
    for (var i = 0; i < imageTextLines.length; i++) {
      numberOfLines = i;
      debugPrint("Line: $numberOfLines ${imageTextLines[i]}");
    }
    */
    //when = imageTextLines[0];
    //weekday = imageTextLines[1];
    //weekend = imageTextLines[2];
    //redday = imageTextLines[3];
    return imageTextLines;
  }
}
