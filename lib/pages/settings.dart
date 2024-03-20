

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_chat_ui/pages/chat.dart';
import 'package:get_storage/get_storage.dart';

const _apiKey = "apiKey";

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();

  static GetStorage? _storage;
  static GetStorage get storage {
    return _storage ??= GetStorage();
  }
  static String getApiKey() {
    return storage.read(_apiKey) ?? "";
  }
  static void setApiKey(String apiKey) {
    storage.write(_apiKey, apiKey);
  }
}

class _SettingsState extends State<Settings> {

  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
              return Chat(apiKey: Settings.getApiKey());
            }), (route) => false);
          }, child: const Text("Done")),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Text('ApiKey:'),
            title: TextField(
              controller: controller,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: Settings.getApiKey());
    controller.addListener(() {
      Settings.setApiKey(controller.text);
    });
  }
}

