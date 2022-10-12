import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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

  late Future<String> translated = imageTranslaterMethod(imageFile);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translated')),
      body: (Image.file(imageFile,
          fit: BoxFit.contain, height: 580, width: 1080)),
    );
  }

  static Future<String> imageTranslaterMethod(File imageFile) async {
    debugPrint('metod');
    late final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.rect;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }

    return ('hej');
  }
}
