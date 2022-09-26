import 'package:flutter/material.dart';

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

class AppBarMain extends StatelessWidget {
  const AppBarMain({super.key});
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

class ParkCamera extends StatelessWidget {
  const ParkCamera({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Park Scanner'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 175,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 40)),
                    child: const Text('knapp'),
                  )),
              SizedBox(
                  width: 175,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 40)),
                    child: const Text('knopp'),
                  )),
            ],
          ),
        ));
  }
}
