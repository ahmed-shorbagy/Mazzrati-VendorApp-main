import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mazzraati_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';

class MessageBubbleShimmerWidget extends StatelessWidget {
  final bool isMe;
  const MessageBubbleShimmerWidget({super.key, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe
          ? const EdgeInsets.fromLTRB(50, 5, 10, 5)
          : const EdgeInsets.fromLTRB(10, 5, 50, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: Provider.of<ChatController>(context).chatList == null,
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    bottomLeft: isMe
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                  color: isMe
                      ? ColorResources.getHintColor(context)
                      : ColorResources.getGrey(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
