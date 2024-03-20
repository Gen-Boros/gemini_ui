
import 'dart:convert';

import 'package:dio/dio.dart';
import 'fetch.dart';

class FetcherIO extends Fetcher {
  final Dio dio = Dio();

  @override
  Stream<String> fetch(String url, data) async * {
    var res = await dio.request<ResponseBody>(
        url,
        options: Options(
          method: "POST",
          contentType: Headers.jsonContentType,
          responseType: ResponseType.stream,
        ),
        data: data
    );

    await for (var chunk in res.data!.stream) {
      yield utf8.decode(chunk);
    }
  }

}

Fetcher makeFetcher() => FetcherIO();