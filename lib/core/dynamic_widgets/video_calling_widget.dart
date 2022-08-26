import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallingWidget extends StatefulWidget {
  String channelId;

  VideoCallingWidget({Key? key, required this.channelId}) : super(key: key);

  @override
  State<VideoCallingWidget> createState() => _VideoCallingWidgetState();
}

class _VideoCallingWidgetState extends State<VideoCallingWidget> {
  bool _joined = false;
  int _remoteUid = 0;
  final bool _switched = false;

  @override
  void initState() {
    super.initState();
    initPlatFormState();
  }

  Future<void> initPlatFormState() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    // create RTC Client Instance
    RtcEngineContext context = RtcEngineContext(AppConstant.APP_ID);
    var engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        _joined = true;
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (uid, reason) {
      setState(() {
        _remoteUid = 0;
      });
    }));
    // enable video
    await engine.enableVideo();
    // join channel with channel name as 123
    await engine.joinChannel(AppConstant.TOKEN, widget.channelId, null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _switched ? _renderRemoteVideo() : _renderLocalPreview(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _switched != _switched;
                  });
                },
                child: Center(
                  child:
                      _switched ? _renderLocalPreview() : _renderRemoteVideo(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

// local video rendering
  _renderLocalPreview() {
    if (_remoteUid != 0 && defaultTargetPlatform == TargetPlatform.android ||
        _remoteUid != 0 && defaultTargetPlatform == TargetPlatform.iOS) {
      return RtcRemoteView.SurfaceView(
          uid: _remoteUid, channelId: widget.channelId);
    }
    if (_remoteUid != 0 && defaultTargetPlatform == TargetPlatform.windows ||
        _remoteUid != 0 && defaultTargetPlatform == TargetPlatform.macOS) {
      return RtcRemoteView.TextureView(
        uid: _remoteUid,
        channelId: widget.channelId,
      );
    } else {
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }

  // remote video rendering

  _renderRemoteVideo() {}
}
