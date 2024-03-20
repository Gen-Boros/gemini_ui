
import 'dart:convert';

import 'package:chat_kit/cell_item.dart';
import 'package:chat_kit/chat_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import '../json_events/json_events.dart';
import '../fetch/fetch.dart';
import '../fetch/factory.dart'
  if (dart.library.io) '../fetch/fetch_io.dart'
  if (dart.library.html) '../fetch/fetch_js.dart';

const geminiProUri = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:streamGenerateContent?key=";
const geminiVisionUri = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=";

const _saveKey = "saved";

class GeminiProvider extends DataProvider {

  final String apiKey;
  final Fetcher fetcher = makeFetcher();
  late GetStorage _storage;

  GeminiProvider(this.apiKey) {
    _storage = GetStorage();
    var data = _storage.read(_saveKey);
    if (data is List) {
      for (var d in data) {
        list.add(CellItem(ItemData.fromData(d, const AssetImage("assets/gemini.png"))));
      }
    }
  }

  @override
  save() async {
    var arr = [];
    for (var item in list) {
      arr.add(item.value.toData());
    }
    await _storage.write(_saveKey, arr);
  }

  _makeContents() {
    return list.map((e) {
      return {
        "role": e.value.name,
        "parts": [
          {
            "text": e.value.content
          }
        ]
      };
    }).toList();
  }

  @override
  Future send(String content) async {

    var stream = fetcher.fetch(geminiProUri + apiKey, {
      "contents": _makeContents(),
      "safetySettings": [
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_NONE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_NONE"
        },
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_NONE"
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_NONE"
        }
      ],
    });

    // var req = http.Request("POST", Uri.parse(geminiProUri + apiKey));
    // req.headers["Content-Type"] = Headers.jsonContentType;
    // req.body = jsonEncode({
    //   "contents": _makeContents(),
    // });

    // var res = await req.send();

    receive(
        _transStream(stream),
        name: 'model',
        avatar: const AssetImage("assets/gemini.png")
    );

  }

  Stream<String> _transStream(Stream<String> stream) async* {
    var events = stream.transform(const JsonEventDecoder()).flatten();
    var nextExport = false;
    await for (var event in events) {
      try {
        if (event.type == JsonEventType.propertyName && event.value == "text") {
          nextExport = true;
        } else if (nextExport) {
          nextExport = false;
          if (event.type == JsonEventType.propertyValue) {
            yield event.value as String;
          }
        }
      } catch (_) {
      }
    }
  }

}