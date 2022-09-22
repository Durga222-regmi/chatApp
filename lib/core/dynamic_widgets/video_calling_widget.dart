import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/core/enum/enums.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallingWidget extends StatefulWidget {
  static const routeName = "/video_calling_widget";
  String channelId;
  MessageType messageType;

  ClientRole clientRole;

  VideoCallingWidget(
      {Key? key,
      required this.channelId,
      required this.messageType,
      required this.clientRole})
      : super(key: key);

  @override
  State<VideoCallingWidget> createState() => _VideoCallingWidgetState();
}

class _VideoCallingWidgetState extends State<VideoCallingWidget> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool _muted = false;
  bool _viewPanel = false;
  late RtcEngine _rtcEngine;
  bool _localUserJoined = false;

  Bloc? chatBloc;

  @override
  void initState() {
    super.initState();
    initPlatFormState();
  }

  @override
  void dispose() {
    _users.clear();
    _rtcEngine.leaveChannel();
    _rtcEngine.destroy();
    // _joined = false;
    // _switched = false;
    // _remoteUid = 0;
    disposePlatForm();

    super.dispose();
  }

  Future<void> disposePlatForm() async {
    RtcEngineContext context = RtcEngineContext(AppConstant.APP_ID);
    var engine = await RtcEngine.createWithContext(context);
    engine.leaveChannel();
  }

  Future<void> initPlatFormState() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    // create RTC Client Instance
    _rtcEngine = await RtcEngine.create(AppConstant.APP_ID);
    await _rtcEngine.enableVideo();
    // join channel with channel name as 123
    await _rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _rtcEngine.setClientRole(widget.clientRole);

    // Define event handling logic
    _addAgoraEventHandler();

    // enable videoa

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    await _rtcEngine.setVideoEncoderConfiguration(configuration);
    await _rtcEngine.joinChannel(
        AppConstant.TOKEN, AppConstant.CHANNEL_NAME, null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        actionWidgets: [
          IconButton(
              onPressed: () {
                setState(() {
                  _viewPanel = !_viewPanel;
                });
              },
              icon: const Icon(Icons.info_outline))
        ],
      ),
      body: Center(
        child: Stack(
          children: [_viewRoles(), _pannel(), _toolBar()],
        ),
      ),
    );
  }

  void _addAgoraEventHandler() {
    _rtcEngine.setEventHandler(RtcEngineEventHandler(error: (errr) {
      setState(() {
        var error = "Error $errr";
        log(error.toString());
        _infoStrings.add(error);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'Join channel $channel uid $uid';
        _localUserJoined = true;
        _infoStrings.add(info);
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        var info = "User joined $uid";
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add("Leave channel");
        _users.clear();
      });
    }, userOffline: (uid, reason) {
      setState(() {
        var info = "Offline User $uid Reason:$reason";
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }));
  }

  Widget _toolBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 49),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
              shape: const CircleBorder(),
              elevation: 2.0,
              padding: const EdgeInsets.all(12),
              fillColor: _muted ? Colors.blueAccent : Colors.white,
              child: Icon(_muted ? Icons.mic_off : Icons.mic),
              onPressed: () async {
                setState(() {
                  _muted = !_muted;
                });
                await _rtcEngine.muteLocalAudioStream(_muted);
              }),
          RawMaterialButton(
              shape: const CircleBorder(),
              elevation: 2.0,
              padding: const EdgeInsets.all(15),
              fillColor: Colors.redAccent,
              child: const Icon(
                Icons.call_end,
                size: 35,
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
          RawMaterialButton(
              shape: const CircleBorder(),
              elevation: 2.0,
              padding: const EdgeInsets.all(12),
              fillColor: Colors.white,
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 35,
              ),
              onPressed: () async {
                await _rtcEngine.switchCamera();
              })
        ],
      ),
    );
  }

  Widget _pannel() {
    return Visibility(
        visible: _viewPanel,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: ListView.builder(
                      itemCount: _infoStrings.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        if (_infoStrings.isEmpty) {
                          return const Text("......");
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                  child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Text(
                                  _infoStrings[index],
                                  style:
                                      const TextStyle(color: Colors.blueGrey),
                                ),
                              ))
                            ],
                          ),
                        );
                      }))),
        ));
  }

  Widget _viewRoles() {
    final List<StatefulWidget> list = [];

    if (widget.clientRole == ClientRole.Broadcaster) {
      if (_localUserJoined) {
        list.add(const rtc_local_view.SurfaceView());
      }
    }

    log("user joinded+:${_users.length}");
    for (var i in _users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: i,
        channelId: AppConstant.CHANNEL_NAME,
      ));
    }
    final views = list;
    setState(() {});
    return Column(
      children:
          List.generate(views.length, (index) => Expanded(child: views[index])),
    );
  }
}
