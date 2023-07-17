import 'package:flutter/material.dart';
import 'package:jitsi/services/jwt.dart';
import 'package:jitsi/utils/constants.dart';
import 'package:jitsi/utils/enums.dart';
import 'package:jitsi/widgets/custom_text_field.dart';
import 'package:jitsi/widgets/flat_button.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController roomController =
          TextEditingController(text: "jitsi-meet-test-room"),
      subjectController = TextEditingController(text: "Test Meeting"),
      usernameController = TextEditingController(text: "Test User"),
      emailController = TextEditingController(text: "fake@email.com"),
      avatarController = TextEditingController();
  Server server = Server.public;
  bool isAudioMuted = true, isAudioOnly = false, isVideoMuted = true;

  SwitchListTile buildSwitchTile(BuildContext context,
          {required String label, required bool value}) =>
      SwitchListTile.adaptive(
          title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          value: value,
          onChanged: (value) => setState(() => isVideoMuted = value));

  void _joinMeeting() async {
    final String token = await JwtService.rs256(
        name: usernameController.text, email: emailController.text);

    final JitsiMeetingOptions options = JitsiMeetingOptions(
        roomNameOrUrl: "$jitsiAppID/${roomController.text}",
        serverUrl: server.url,
        subject: subjectController.text,
        token: server.isTokenNeeded ? token : null,
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
        onParticipantsInfoRetrieved: (participantsInfo, requestId) => debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
            "requestId: $requestId"),
        onChatMessageReceived: (senderId, message, isPrivate) => debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate"),
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }

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
                  const Padding(
                      padding: EdgeInsets.all(5), child: Text('Server URL')),
                  DropdownButtonFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1)),
                      value: server,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: Server.values
                          .map((server) => DropdownMenuItem(
                              value: server, child: Text(server.url)))
                          .toList(),
                      onChanged: (newServer) =>
                          setState(() => server = newServer!)),
                  const SizedBox(height: 10),
                  CustomTextField(
                      labelText: "Room",
                      controller: roomController,
                      maxLength: 20),
                  CustomTextField(
                      labelText: "Subject",
                      controller: subjectController,
                      maxLength: 20),
                  CustomTextField(
                      labelText: "User Display Name",
                      controller: usernameController,
                      maxLength: 20),
                  CustomTextField(
                      labelText: "User Email", controller: emailController),
                  CustomTextField(
                      labelText: "User Avatar URL",
                      controller: avatarController),
                  buildSwitchTile(context,
                      label: "Audio Muted", value: isAudioMuted),
                  buildSwitchTile(context,
                      label: "Audio Only", value: isAudioOnly),
                  buildSwitchTile(context,
                      label: "Video Muted", value: isVideoMuted),
                  FlatButton(label: 'Join', onPressed: _joinMeeting),
                ]),
          ),
        ),
      );
}
