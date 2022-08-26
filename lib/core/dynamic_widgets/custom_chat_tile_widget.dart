import 'package:flutter/material.dart';
import 'package:group_chat_fb/core/enum/enums.dart';

class CustomChatTile extends StatelessWidget {
  MessageType? messageType;
  List<String>? profileUrls;
  String? profileUrl;
  String? name;
  String? lastMessage;
  Function()? onTap;

  CustomChatTile({
    Key? key,
    this.messageType,
    this.profileUrl,
    this.lastMessage,
    this.name,
    this.onTap,
    this.profileUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0.5, color: Colors.grey[500]!)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        profileUrl ??
                            "https://cdn.vectorstock.com/i/1000x1000/45/79/male-avatar-profile-picture-silhouette-light-vector-4684579.webp",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? "",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          if (lastMessage != null) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              lastMessage ?? "",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
                Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
