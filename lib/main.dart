import 'package:flutter/material.dart';
import 'package:gui_desktop/mdi/mdi_controller.dart';
import 'package:gui_desktop/mdi/mdi_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDI Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MdiController controller;

  @override
  void initState() {
    super.initState();
    controller = MdiController(onUpdate: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => controller.addWindow(),
        child: const Center(
          child: Icon(Icons.add, size: 40),
        ),
      ),
      body: MdiManager(mdiController: controller),
    );
  }
}
