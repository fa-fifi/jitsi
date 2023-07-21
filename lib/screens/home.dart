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
  final roomController = TextEditingController(text: "jitsi-meet-test-room");
  final subjectController = TextEditingController(text: "Test Meeting");
  final usernameController = TextEditingController(text: "Test User");
  final emailController = TextEditingController(text: "fake@email.com");
  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;
  Server server = Server.public;

  void joinMeeting() async {
    final token = await JwtService.rs256(
        name: usernameController.text, email: emailController.text);

    final options = JitsiMeetingOptions(
        roomNameOrUrl: "$jitsiAppID/${roomController.text}",
        serverUrl: server.url,
        subject: subjectController.text,
        token: server.isTokenNeeded ? token : null,
        isAudioMuted: isAudioMuted,
        isAudioOnly: isAudioOnly,
        isVideoMuted: isVideoMuted,
        userDisplayName: usernameController.text,
        userEmail: emailController.text,
        userAvatarUrl:
            'https://api.dicebear.com/6.x/notionists/png?seed=${usernameController.text}&backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf',
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
                  SwitchListTile.adaptive(
                      title: Text("Audio Muted",
                          style: Theme.of(context).textTheme.bodyMedium),
                      value: isAudioMuted,
                      onChanged: (value) =>
                          setState(() => isAudioMuted = value)),
                  SwitchListTile.adaptive(
                      title: Text("Audio Only",
                          style: Theme.of(context).textTheme.bodyMedium),
                      value: isAudioOnly,
                      onChanged: (value) =>
                          setState(() => isAudioOnly = value)),
                  SwitchListTile.adaptive(
                      title: Text("Video Muted",
                          style: Theme.of(context).textTheme.bodyMedium),
                      value: isVideoMuted,
                      onChanged: (value) =>
                          setState(() => isVideoMuted = value)),
                  const SizedBox(height: 10),
                  FlatButton(label: 'Join', onPressed: joinMeeting),
                ]),
          ),
        ),
      );
}
