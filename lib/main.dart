import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                (Container(child: Image.file(imageFile!, fit: BoxFit.cover)))
              else
                (Container(
                  width: 640,
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
                      width: 175,
                      height: 75,
                      child: ElevatedButton(
                        onPressed: () => fetchImage(source: ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 30)),
                        child: const Text('Capture Picture'),
                      )),
                  SizedBox(
                      width: 175,
                      height: 75,
                      child: ElevatedButton(
                        onPressed: () =>
                            fetchImage(source: ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 30)),
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
}
