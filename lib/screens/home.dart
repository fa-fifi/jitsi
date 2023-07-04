import 'package:flutter/material.dart';
import 'package:jitsi/widgets/custom_text_field.dart';
import 'package:jitsi/widgets/flat_button.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController serverController = TextEditingController(),
      roomController = TextEditingController(text: "jitsi-meet-test-room"),
      subjectController = TextEditingController(text: "Test Meeting"),
      tokenController = TextEditingController(),
      usernameController = TextEditingController(text: "Test User"),
      emailController = TextEditingController(text: "fake@email.com"),
      avatarController = TextEditingController();

  bool isAudioMuted = true, isAudioOnly = false, isVideoMuted = true;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('Jitsi'),
                const SizedBox(width: 5),
                Image.asset('assets/icon.png', height: 25),
              ])),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                      labelText: "Server URL",
                      controller: serverController,
                      hintText: "Hint: Leave empty for meet.jit.si"),
                  CustomTextField(
                      labelText: "Room", controller: roomController),
                  CustomTextField(
                      labelText: "Subject", controller: subjectController),
                  CustomTextField(
                      labelText: "Token", controller: tokenController),
                  CustomTextField(
                      labelText: "User Display Name",
                      controller: usernameController),
                  CustomTextField(
                      labelText: "User Email", controller: emailController),
                  CustomTextField(
                      labelText: "User Avatar URL",
                      controller: avatarController),
                  CheckboxListTile(
                      dense: true,
                      title: const Text("Audio Muted"),
                      value: isAudioMuted,
                      onChanged: (val) => setState(() => isAudioMuted = val!)),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                      dense: true,
                      title: const Text("Audio Only"),
                      value: isAudioOnly,
                      onChanged: (val) => setState(() => isAudioOnly = val!)),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                      dense: true,
                      title: const Text("Video Muted"),
                      value: isVideoMuted,
                      onChanged: (val) => setState(() => isVideoMuted = val!)),
                  const SizedBox(height: 10),
                  FlatButton(label: 'Join', onPressed: _joinMeeting),
                ]),
          ),
        ),
      );

  _joinMeeting() async {
    final JitsiMeetingOptions options = JitsiMeetingOptions(
        roomNameOrUrl: roomController.text,
        serverUrl:
            serverController.text.trim().isEmpty ? null : serverController.text,
        subject: subjectController.text,
        token: tokenController.text,
        isAudioMuted: isAudioMuted,
        isAudioOnly: isAudioOnly,
        isVideoMuted: isVideoMuted,
        userDisplayName: usernameController.text,
        userEmail: emailController.text,
        featureFlags: {});

    debugPrint("JitsiMeetingOptions: $options");

    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) =>
            debugPrint("onConferenceWillJoin: url: $url"),
        onConferenceJoined: (url) =>
            debugPrint("onConferenceJoined: url: $url"),
        onConferenceTerminated: (url, error) =>
            debugPrint("onConferenceTerminated: url: $url, error: $error"),
        onAudioMutedChanged: (isMuted) =>
            debugPrint("onAudioMutedChanged: isMuted: $isMuted"),
        onVideoMutedChanged: (isMuted) =>
            debugPrint("onVideoMutedChanged: isMuted: $isMuted"),
        onScreenShareToggled: (participantId, isSharing) =>
            debugPrint("onScreenShareToggled: participantId: $participantId, "
                "isSharing: $isSharing"),
        onParticipantJoined: (email, name, role, participantId) => debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
            "participantId: $participantId"),
        onParticipantLeft: (participantId) =>
            debugPrint("onParticipantLeft: participantId: $participantId"),
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId");
        },
        onChatMessageReceived: (senderId, message, isPrivate) => debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate"),
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }
}
