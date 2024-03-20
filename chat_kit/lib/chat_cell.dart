

import 'package:chat_kit/cell_item.dart';
import 'package:flutter/material.dart';

const _radius = Radius.circular(4);

class ChatCell extends StatelessWidget {
  final CellItem item;
  const ChatCell({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: item,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: value.side == Side.left ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            CircleAvatar(
              foregroundImage: value.avatar,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(value.name),
                  ),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 460,
                    ),
                    child: Material(
                      elevation: 4,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: _radius,
                        bottomLeft: _radius,
                        bottomRight: _radius,
                      ),
                      color: Colors.tealAccent,
                      child: SelectableText(
                        value.content,
                      ),
                    ),
                  ),
                ],
              )
            )
          ],
        );
      }
    );
  }
}
