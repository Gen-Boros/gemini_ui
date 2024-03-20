import 'package:chat_kit/chat_kit.dart';
import 'package:chat_kit/data_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ExampleProvider extends DataProvider {
  @override
  Future send(String content) async {
    await Future.delayed(const Duration(seconds: 3));
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ExampleProvider provider = ExampleProvider();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ChatKit(
              dataProvider: provider,
            )
          ),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                  )
                ),
                MaterialButton(
                    child: const Text("Send"),
                    onPressed: () {
                      provider.put(textEditingController.text,
                        name: 'user',
                        avatar: const AssetImage("assets/gemini.png")
                      );
                      textEditingController.text = '';
                    }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
