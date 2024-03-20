
import 'package:chat_kit/chat_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini_chat_ui/pages/settings.dart';
import 'package:image/image.dart' as img;

import '../data/gemini_provider.dart';

class ExampleProvider extends DataProvider {
  @override
  Future send(String content) async {
    await Future.delayed(const Duration(seconds: 3));
  }

}

class Chat extends StatefulWidget {

  final String apiKey;

  const Chat({super.key, required this.apiKey});

  @override
  State<StatefulWidget> createState() => _ChatState();
  
}

class _ChatState extends State<Chat> {
  late GeminiProvider provider;
  TextEditingController textEditingController = TextEditingController();

  ValueNotifier<img.Image?> attachImage = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
              return const Settings();
            }), (route) => false);
          }, icon: const Icon(Icons.settings)),
          IconButton(onPressed: () {
            provider.clear();
          }, icon: const Icon(Icons.playlist_remove_outlined)),
        ],
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
                      maxLines: null,
                    )
                ),
                MaterialButton(
                  child: const Icon(Icons.attach_file),
                  onPressed: () async {
                    var result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.image,
                    );
                    if (result != null) {
                      var image = img.decodeImage(result.files.first.bytes!)!;
                      image = img.copyResize(
                        image,
                        width: 512,
                        height: 512 * image.height ~/ image.width,
                      );
                      attachImage.value = image;
                    }
                  }
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

  @override
  void initState() {
    super.initState();
    provider = GeminiProvider(widget.apiKey);
  }
}