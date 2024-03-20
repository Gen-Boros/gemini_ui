library chat_kit;

import 'dart:async';

import 'package:chat_kit/chat_cell.dart';
import 'package:flutter/material.dart';

import 'cell_item.dart';
import 'data_provider.dart';

export 'data_provider.dart';

typedef ItemBuilder = Widget Function(BuildContext, CellItem);

ItemBuilder _defaultBuilder = (context, item) {
  return ChatCell(item: item);
};

class ChatKit extends StatefulWidget {
  final ItemBuilder? itemBuilder;
  final DataProvider dataProvider;

  const ChatKit({
    super.key,
    this.itemBuilder,
    required this.dataProvider,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatKitState();
  }
}

class _ChatKitState extends State<ChatKit> {

  GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: widget.dataProvider.list.length,
      itemBuilder: (context, index, animation) {
        var item = widget.dataProvider.list[index];
        return SizeTransition(
          sizeFactor: animation,
          child: (widget.itemBuilder??_defaultBuilder)(context, item),
        );
      },
    );
  }

  _reload() {
    setState(() {
      _listKey = GlobalKey();
    });
  }
  late StreamSubscription<int> _insertSub;

  @override
  void initState() {
    super.initState();
    widget.dataProvider.addListener(_reload);
    _insertSub = widget.dataProvider.onInsert.listen((index) {
      _listKey.currentState?.insertItem(index, duration: const Duration(milliseconds: 300));
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.dataProvider.removeListener(_reload);
    _insertSub.cancel();
  }
}