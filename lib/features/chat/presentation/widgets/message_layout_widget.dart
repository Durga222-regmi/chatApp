import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_fb/core/enum/enums.dart';

import '../../../../app_constant.dart';
import '../../../../page_constant.dart';

class MessageLayoutWidget extends StatelessWidget {
  String? name;
  TextAlign? alignName;
  Color? nibColor;
  String? senderUid;
  String? channelId;
  String? type;
  String? status;
  String? time;
  MessageType? messageType;
  TextAlign? align;
  String? text;
  CrossAxisAlignment? boxAlign;
  CrossAxisAlignment? crossAlign;
  BubbleNip? nip;

  MessageLayoutWidget({
    Key? key,
    this.name,
    this.alignName,
    this.nibColor,
    this.type,
    this.channelId,
    this.senderUid,
    this.status,
    this.time,
    this.messageType,
    this.align,
    this.boxAlign,
    this.text,
    this.crossAlign,
    this.nip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAlign!,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: type == "VID_CALL"
              ? GestureDetector(
                  onTap: () {
                    if (status == "CALLED") {
                      Navigator.pushNamed(
                          context, PageConstant.videoCallingWidget, arguments: [
                        channelId,
                        messageType,
                        ClientRole.Broadcaster
                      ]);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 0.5, color: AppConstant.BORDER_COLOR)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(status == "CALLED"
                                ? "Incoming video call"
                                : "Video chat ended"),
                            Icon(
                              status == "CALLED" ? Icons.call : Icons.call_end,
                              color: status == "CALLED"
                                  ? Colors.green
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(3),
                  child: Bubble(
                    color: nibColor,
                    nip: nip,
                    child: Column(
                      crossAxisAlignment: crossAlign!,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          text!,
                          textAlign: align,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
