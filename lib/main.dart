import 'package:flutter/material.dart';
import 'package:gemini_chat_ui/pages/chat.dart';
import 'package:gemini_chat_ui/pages/settings.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var apiKey = Settings.getApiKey();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        )
      ),
      home: apiKey.isEmpty ? const Settings() : Chat(apiKey: apiKey,),
    );
  }
}

