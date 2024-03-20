
import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'fetch.dart';

class FetcherJS extends Fetcher {

  FetcherJS() {
    JsFunction fetch =
    context["fetch"];
  }
  
  @override
  Stream<String> fetch(String url, data) async* {
    JsObject promise = context.callMethod("fetch", [
      url,
      JsObject.jsify({
        "method": "POST",
        "body": jsonEncode(data),
        "headers": {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }
      }),
    ]);

    JsObject r = await _wait(promise);
    JsObject reader = r['body'].callMethod('getReader');

    while (true) {
      var res = await _wait(reader.callMethod('read'));
      var val = res["value"];
      if (val != null) {
        yield utf8.decode(val);
      }
      if (res["done"] == true) {
        break;
      }
    }

  }

  Future _wait(JsObject promise) {
    Completer completer = Completer();
    promise.callMethod("then", [JsFunction.withThis((self, res) {
      completer.complete(res);
    })]);
    promise.callMethod("catch", [JsFunction.withThis((self, err) {
      completer.completeError(err);
    })]);
    return completer.future;
  }
}

Fetcher makeFetcher() => FetcherJS();