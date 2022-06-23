import 'package:flutter/material.dart';
import 'package:flutter_snack_message/flutter_snack_message.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Pretty snack message',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const MyHomePage(title: 'Pretty snack message'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  List<PrettySnackMessage> messages = [
    PrettySnackMessage(
      title: 'Success',
      subTitle: 'Your changes are saved successfully.',
      type: SnackMessageType.success,
      duration: SnackMessageDuration.short,
    ),
    PrettySnackMessage(
      title: 'Error',
      subTitle: 'Error has occured while saving changes.',
      type: SnackMessageType.error,
      duration: SnackMessageDuration.short,
    ),
    PrettySnackMessage(
      title: 'Info',
      subTitle: 'New settings available on your account.',
      type: SnackMessageType.info,
      duration: SnackMessageDuration.short,
    ),
    PrettySnackMessage(
      title: 'Warning',
      subTitle: 'Data you have entered is invalid.',
      type: SnackMessageType.warning,
      duration: SnackMessageDuration.short,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            messages[(index++ % 4)].show();
          },
          child: const Text('SHOW SNACK'),
        ),
      ),
    );
  }
}
