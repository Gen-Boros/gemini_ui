
import 'dart:async';

import 'package:chat_kit/cell_item.dart';
import 'package:flutter/widgets.dart';

abstract class DataProvider extends ChangeNotifier {
  List<CellItem> list = [];

  final StreamController<int> _onInsert = StreamController();
  Stream<int> get onInsert => _onInsert.stream;

  ValueNotifier<bool> sending = ValueNotifier(false);
  ValueNotifier<bool> receiving = ValueNotifier(false);

  @protected
  Future send(String content);

  Future put(String content, {
    required String name,
    required ImageProvider avatar,
  }) async {
    if (!sending.value) {
      sending.value = true;

      var item = CellItem(ItemData(
        status: ItemStatus.sending,
        name: name,
        content: content,
        avatar: avatar,
        side: Side.right,
      ));
      list.add(item);
      _onInsert.add(list.length - 1);

      await save();
      await send(content);
      item.value = item.value.copy(
        status: ItemStatus.done,
      );
      await save();

      sending.value = false;
    } else {
      throw Exception('data busy');
    }
  }

  Future receive(Stream<String> stream, {
    required String name,
    required ImageProvider avatar,
  }) async {
    if (!receiving.value) {
      receiving.value = true;

      var item = CellItem(ItemData(
        status: ItemStatus.processing,
        name: name,
        content: '',
        avatar: avatar,
        side: Side.left,
      ));
      list.add(item);
      _onInsert.add(list.length - 1);
      await save();
      await for (var word in stream) {
        item.value = item.value.copy(
          content: item.value.content + word,
        );
      }
      item.value = item.value.copy(
        status: ItemStatus.done,
      );
      await save();

      receiving.value = false;
    } else {
      throw Exception('data busy');
    }
  }

  save() async {}

  clear() async {
    list.clear();
    notifyListeners();
    save();
  }
}