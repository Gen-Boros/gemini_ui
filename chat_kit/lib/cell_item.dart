
import 'package:flutter/widgets.dart';

enum ItemStatus {
  sending,
  processing,
  done,
}

enum Side {
  left,
  right,
}

class ItemData {
  final ItemStatus status;
  final String name;
  final String content;
  final ImageProvider avatar;
  final Side side;

  const ItemData({
    required this.status,
    required this.name,
    required this.content,
    required this.avatar,
    required this.side,
  });

  factory ItemData.fromData(Map data, ImageProvider avatar) {
    var name = data["name"];
    return ItemData(
        status: ItemStatus.done,
        name: name,
        content: data["content"],
        avatar: avatar,
        side: name == "model" ? Side.left : Side.right);
  }

  Map toData() {
    return {
      "name": name,
      "content": content,
    };
}

  ItemData copy({
    ItemStatus? status,
    String? name,
    String? content,
    ImageProvider? avatar,
    Side? side,
  }) {
    return ItemData(
      status: status??this.status,
      name: name??this.name,
      content: content??this.content,
      avatar: avatar??this.avatar,
      side: side??this.side,
    );
  }
}

class CellItem extends ValueNotifier<ItemData> {
  CellItem(super.value);

}