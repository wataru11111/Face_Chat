import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/agora_config.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String friendName;

  const CallScreen({
    Key? key,
    required this.channelName,
    required this.friendName,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // マイクとカメラの権限をリクエスト
    await [Permission.microphone, Permission.camera].request();

    // Agoraエンジンの作成
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: AgoraConfig.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("ローカルユーザーがチャンネルに参加: ${connection.localUid}");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("リモートユーザーがチャンネルに参加: $remoteUid");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("リモートユーザーが退出: $remoteUid");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    // ビデオを有効化
    await _engine.enableVideo();
    await _engine.startPreview();

    // チャンネルに参加
    await _engine.joinChannel(
      token: AgoraConfig.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // マイクのミュート切り替え
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  // ビデオのON/OFF切り替え
  void _toggleVideo() {
    setState(() {
      _isVideoOff = !_isVideoOff;
    });
    _engine.muteLocalVideoStream(_isVideoOff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通話中: ${widget.friendName}'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          // リモートビデオ（相手の映像）
          Center(
            child: _remoteVideo(),
          ),
          // ローカルビデオ（自分の映像）を右上に小さく表示
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 120,
              height: 160,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          // 通話コントロールボタン
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // マイクミュートボタン
                  FloatingActionButton(
                    onPressed: _toggleMute,
                    backgroundColor: _isMuted ? Colors.red : Colors.white,
                    child: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.white : Colors.black,
                    ),
                  ),
                  // 通話終了ボタン
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.red,
                    child: Icon(Icons.call_end, color: Colors.white),
                  ),
                  // ビデオON/OFFボタン
                  FloatingActionButton(
                    onPressed: _toggleVideo,
                    backgroundColor: _isVideoOff ? Colors.red : Colors.white,
                    child: Icon(
                      _isVideoOff ? Icons.videocam_off : Icons.videocam,
                      color: _isVideoOff ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // リモートビデオ表示
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                '${widget.friendName}の参加を待っています...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }
  }
}
