import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:leanware_test/component/example_actions_widget.dart';
import 'package:leanware_test/config/agora.config.dart' as config;
import 'package:leanware_test/core/utils/app_colors.dart';
import 'package:leanware_test/core/utils/snackbar_utils.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:leanware_test/presentation/cubits/timer_cubit/timer_cubit.dart';
import 'package:leanware_test/presentation/screens/join_channel_audio_and_video_screen.dart/widgets/control_button.dart';
import 'package:leanware_test/presentation/screens/join_to_call_screen/join_to_call_screen.dart';
import 'package:leanware_test/presentation/screens/waiting_room/waiting_room_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// MultiChannel Example
class JoinChannelAudioAndVideoScreen extends StatefulWidget {
  /// Construct the [JoinChannelAudioAndVideoScreen]
  const JoinChannelAudioAndVideoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudioAndVideoScreen> {
  late final RtcEngine _engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      isEnabledVirtualBackgroundImage = false,
      openMicrophone = true,
      muteMicrophone = false,
      muteAllRemoteAudio = false,
      enableSpeakerphone = true,
      playEffect = false,
      muteAllRemoteVideo = false;

  Set<int> remoteUid = {};

  final ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler _rtcEngineEventHandler;
  int id = 2;
  bool _isLoading = false;
  int? localUid = config.uid;
  Map<String, dynamic> data = {};

  bool _isEngineInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await getUserIdHost();

      // 2. Inicializar el engine
      await _initEngine();

      if (_isEngineInitialized) {
        await _joinChannel();
      }
    } catch (e) {
      log('Error in initialization: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposeEngine();
  }

  Future<void> getUserIdHost() async {
    final result = await context.read<CallCubit>().setAndCheckIfItsHost();
    data = result;
  }

  Future<void> _disposeEngine() async {
    if (_isEngineInitialized) {
      try {
        _engine.unregisterEventHandler(_rtcEngineEventHandler);
        await _engine.leaveChannel();
        await _engine.release();
        _isEngineInitialized = false;
      } catch (e) {
        log('Error disposing engine: $e');
      }
    }
  }

  Future<void> _initEngine() async {
    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(
        appId: config.appId,
      ));

      _rtcEngineEventHandler = RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {},
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
          setState(() {
            isJoined = true;
          });

          if (data['isHost'] as bool) {
            context.read<CallCubit>().setWaitingRoom();
          }
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          log('[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
          setState(() {
            remoteUid.add(rUid);
          });
          log(remoteUid.toString());
          _playUserJoinedSound();
        },
        onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          log('[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
          setState(() {
            remoteUid.removeWhere((element) => element == rUid);
          });
          if (remoteUid.isEmpty) {
            context.read<CallCubit>().setToInitial();
            context.pop();
          }
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
          setState(() {
            isJoined = false;
            remoteUid.clear();
          });
        },
        onRemoteVideoStateChanged: (RtcConnection connection,
            int remoteUid,
            RemoteVideoState state,
            RemoteVideoStateReason reason,
            int elapsed) {
          log('[onRemoteVideoStateChanged] connection: ${connection.toJson()} remoteUid: $remoteUid state: $state reason: $reason elapsed: $elapsed');
          if (state == RemoteVideoState.remoteVideoStateStarting) {
            context.read<CallCubit>().startCall();
          }
        },
      );
      _engine.registerEventHandler(_rtcEngineEventHandler);
      await _engine.enableVideo();
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      _isEngineInitialized = true; // Marcar como inicializado
    } catch (e) {
      log('Error initializing engine: $e');
      _isEngineInitialized = false;
      rethrow;
    }
  }

  Future<void> _joinChannel() async {
    if (!_isEngineInitialized) {
      log('Cannot join channel: Engine not initialized');
      return;
    }

    try {
      await _engine.joinChannel(
        token: config.token,
        channelId: config.channelId,
        uid: int.parse(data['uid']),
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      log('Error joining channel: $e');
      rethrow;
    }
  }

  Future<void> _playUserJoinedSound() async {
    if (_engine == null) {
      log("🚨 _engine is null, cannot play sound!");
      return;
    }

    final response = await _engine.playEffect(
      soundId: 1,
      filePath: 'assets/sounds/ding.mp3',
      loopCount: 1,
      pitch: 1.0,
      pan: 0.0,
      gain: 100,
      publish: true, // 🔊 Asegura que el sonido se reproduzca en local
    );

    log("🔊 playEffect response:");
  }

  Future<void> _enableVirtualBackground() async {
    await _engine.enableVirtualBackground(
        enabled: !isEnabledVirtualBackgroundImage,
        backgroundSource: const VirtualBackgroundSource(
          backgroundSourceType: BackgroundSourceType.backgroundBlur,
          blurDegree: BackgroundBlurDegree.blurDegreeHigh,
        ),
        segproperty:
            const SegmentationProperty(modelType: SegModelType.segModelAi));
    setState(() {
      isEnabledVirtualBackgroundImage = !isEnabledVirtualBackgroundImage;
    });
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      openCamera = true;
      muteCamera = false;
      muteAllRemoteVideo = false;
    });
  }

  Future<void> _switchMicrophone() async {
    // await await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone);
    setState(() {
      openMicrophone = !openMicrophone;
    });
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  _openCamera() async {
    await _engine.enableLocalVideo(!openCamera);
    setState(() {
      openCamera = !openCamera;
    });
  }

  _muteLocalVideoStream() async {
    await _engine.muteLocalVideoStream(!muteCamera);
    setState(() {
      muteCamera = !muteCamera;
    });
  }

  _muteAllRemoteVideoStreams() async {
    await _engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo);
    setState(() {
      muteAllRemoteVideo = !muteAllRemoteVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _isLoading
        ? Container(
            height: size.height,
            width: size.width,
            color: AppColors.background,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          )
        : BlocConsumer<CallCubit, CallState>(
            listener: (context, callState) {
              if (callState is StartCall) {
                context.read<TimerCubit>().stopTimer();
              }
            },
            builder: (context, callState) {
              if (callState is CallWaiting) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<TimerCubit>().startTimer();
                });
                return BlocListener<TimerCubit, TimerState>(
                  listener: (context, state) async {
                    if (state is TimerFinished) {
                      SnackBarUtils.showTimeoutSnackBar(context);
                      await context.read<CallCubit>().clearRoom();
                      context.pop();
                    }
                  },
                  child: WaitingRoom(),
                );
              }
              if (callState == StartCall()) {
                WidgetsBinding.instance.addPostFrameCallback((_) {});
                return ExampleActionsWidget(
                  displayContentBuilder: (context, isLayoutHorizontal) {
                    return Stack(
                      children: [
                        remoteUid.length == 1
                            ? AgoraVideoView(
                                controller: VideoViewController.remote(
                                  rtcEngine: _engine,
                                  canvas: VideoCanvas(uid: remoteUid.first),
                                  connection: RtcConnection(
                                      channelId: config.channelId),
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: remoteUid.length,
                                itemBuilder: (context, index) {
                                  return AgoraVideoView(
                                    controller: VideoViewController.remote(
                                      rtcEngine: _engine,
                                      canvas: VideoCanvas(
                                          uid: remoteUid.elementAt(index)),
                                      connection: RtcConnection(
                                          channelId: config.channelId),
                                    ),
                                  );
                                },
                              ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 200,
                            width: 200,
                            child: AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: _engine,
                                canvas: const VideoCanvas(uid: 0),
                              ),
                              onAgoraVideoViewCreated: (viewId) {
                                _engine.startPreview();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: AppColors.secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (!kIsWeb &&
                                    (defaultTargetPlatform ==
                                            TargetPlatform.android ||
                                        defaultTargetPlatform ==
                                            TargetPlatform.iOS)) ...[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.white24,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: _switchCamera,
                                      icon: Icon(
                                        switchCamera
                                            ? Icons.camera_front
                                            : Icons.camera_rear,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  ControlButton(
                                    onPressed: _openCamera,
                                    icon: Icons.videocam,
                                    iconDisabled: Icons.videocam_off,
                                    isEnabled: openCamera,
                                  ),
                                  ControlButton(
                                    onPressed: _switchMicrophone,
                                    icon: Icons.mic,
                                    iconDisabled: Icons.mic_off,
                                    isEnabled: openMicrophone,
                                  ),
                                  ControlButton(
                                    onPressed: _enableVirtualBackground,
                                    icon: Icons.blur_on,
                                    iconDisabled: Icons.blur_off,
                                    isEnabled: isEnabledVirtualBackgroundImage,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        context.pop();
                                        await context
                                            .read<CallCubit>()
                                            .clearRoom();
                                      },
                                      icon: Icon(
                                        Icons.call_end,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                                if (kIsWeb) ...[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: _muteLocalVideoStream,
                                    child: Text(
                                        'Camera ${muteCamera ? 'muted' : 'unmute'}'),
                                  ),
                                  ElevatedButton(
                                    onPressed: _muteAllRemoteVideoStreams,
                                    child: Text(
                                        'All Remote Camera ${muteAllRemoteVideo ? 'muted' : 'unmute'}'),
                                  ),
                                  ElevatedButton(
                                    onPressed: _openCamera,
                                    child: Text(
                                        'Camera ${openCamera ? 'on' : 'off'}'),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        context.pop();
                                        await context
                                            .read<CallCubit>()
                                            .clearRoom();
                                      },
                                      icon: Icon(
                                        Icons.call_end,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  // actionsBuilder: (context, isLayoutHorizontal) {
                  //   final channelProfileType = [
                  //     ChannelProfileType.channelProfileLiveBroadcasting,
                  //     ChannelProfileType.channelProfileCommunication,
                  //   ];
                  //   final items = channelProfileType
                  //       .map((e) => DropdownMenuItem(
                  //             child: Text(
                  //               e.toString().split('.')[1],
                  //             ),
                  //             value: e,
                  //           ))
                  //       .toList();

                  //   return Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       if (!kIsWeb &&
                  //           (defaultTargetPlatform == TargetPlatform.android ||
                  //               defaultTargetPlatform == TargetPlatform.iOS))
                  //         Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Column(
                  //                 mainAxisAlignment: MainAxisAlignment.start,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   const Text('Rendered by Flutter texture: '),
                  //                   Switch(
                  //                     value: _isUseFlutterTexture,
                  //                     onChanged: isJoined
                  //                         ? null
                  //                         : (changed) {
                  //                             setState(() {
                  //                               _isUseFlutterTexture = changed;
                  //                             });
                  //                           },
                  //                   )
                  //                 ]),
                  //           ],
                  //         ),
                  //       const SizedBox(
                  //         height: 20,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             flex: 1,
                  //             child: ElevatedButton(
                  //               onPressed:
                  //                   isJoined ? _leaveChannel : _joinChannel,
                  //               child: Text(
                  //                   '${isJoined ? 'Leave' : 'Join'} channel'),
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       if (!kIsWeb &&
                  //           (defaultTargetPlatform == TargetPlatform.android ||
                  //               defaultTargetPlatform ==
                  //                   TargetPlatform.iOS)) ...[
                  //         const SizedBox(
                  //           height: 20,
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: _switchCamera,
                  //           child: Text(
                  //               'Camera ${switchCamera ? 'front' : 'rear'}'),
                  //         ),
                  //       ],
                  //       if (kIsWeb) ...[
                  //         const SizedBox(
                  //           height: 20,
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: _muteLocalVideoStream,
                  //           child: Text(
                  //               'Camera ${muteCamera ? 'muted' : 'unmute'}'),
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: _muteAllRemoteVideoStreams,
                  //           child: Text(
                  //               'All Remote Camera ${muteAllRemoteVideo ? 'muted' : 'unmute'}'),
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: _openCamera,
                  //           child: Text('Camera ${openCamera ? 'on' : 'off'}'),
                  //         ),
                  //       ],
                  //     ],
                  //   );
                  // },
                );
              }
              return const SizedBox.shrink(); // Returns an empty widget
            },
          );
    // if (!_isInit) return Container();
  }
}
