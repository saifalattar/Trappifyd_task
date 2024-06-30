import 'package:chatting_app/Bloc/cubit.dart';
import 'package:chatting_app/Bloc/states.dart';
import 'package:chatting_app/Channels_Chats/channelChat.dart';
import 'package:chatting_app/Reuseables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelAppBar extends AppBar {
  final Channel? channel;
  final BuildContext? context;
  ChannelAppBar({super.key, this.channel, this.context})
      : super(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context!);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              FutureBuilder(
                  future: channel!.queryMembers(),
                  builder: (_, ss) {
                    String name = "";
                    bool? isOnline;
                    String? lastActive;
                    if (ss.hasData) {
                      for (var i in ss.data!.members) {
                        if (i.userId != currenUserId!) {
                          name = i.user!.name;
                          isOnline = i.user!.online;
                          if (!isOnline) {
                            lastActive =
                                "${i.user!.lastActive!.year}-${i.user!.lastActive!.month}-${i.user!.lastActive!.day} ${i.user!.lastActive!.hour}:${i.user!.lastActive!.minute}";
                          }
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\t$name",
                            style: Theme.of(context!).textTheme.headlineLarge,
                          ),
                          Text(
                            isOnline!
                                ? "  Online"
                                : "  Last seen at $lastActive",
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          ),
        );
}

class ChatWidget extends StatelessWidget {
  Channel? channelData;
  final bool isNewChannel;
  String? member;
  ChatWidget(
      {super.key, this.channelData, this.isNewChannel = false, this.member});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatServiceBloc, States>(builder: (context, state) {
      return InkWell(
        onTap: () async {
          if (isNewChannel) {
            String channelID = "$currenUserId$member";
            await ChatServiceBloc.GET(context).addChannel(channelID, {
              "members": [currenUserId, member]
            }).then((value) {
              channelData =
                  ChatServiceBloc.GET(context).connectToChannel(channelID);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChannelChat(
                            channelData: channelData,
                          )));
            }).catchError((onError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Can't chat with yourself")));
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelChat(
                          channelData: channelData,
                        )));
          }
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isNewChannel
                      ? Text(
                          "\t$member",
                          style: Theme.of(context).textTheme.headlineLarge,
                        )
                      : FutureBuilder(
                          future: channelData!.queryMembers(),
                          builder: (_, ss) {
                            String name = "";
                            if (ss.hasData) {
                              for (var i in ss.data!.members) {
                                if (i.userId != currenUserId!) {
                                  name = i.user!.name;
                                }
                              }
                              return Text(
                                "\t\t$name",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                  Text(
                    isNewChannel
                        ? "\t\tStart Conversation Now"
                        : channelData!.lastMessageAt == null
                            ? "\t\tStart Conversation Now"
                            : "\t\t Last Message On ${channelData!.lastMessageAt!.hour}:${channelData!.lastMessageAt!.minute}",
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

class MessageWidget extends StatelessWidget {
  final Message? message;
  final bool? isItMe;
  const MessageWidget({super.key, required this.message, required this.isItMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isItMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            minWidth: 50, maxWidth: MediaQuery.sizeOf(context).width * 0.80),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                isItMe! ? const Color.fromARGB(255, 1, 107, 97) : Colors.white),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${message!.text}",
              style: TextStyle(
                  fontSize: 15, color: isItMe! ? Colors.white : Colors.black),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    "${message!.createdAt.hour}:${message!.createdAt.minute}  ",
                    style: Theme.of(context).textTheme.titleSmall),
                Icon(
                  message!.state.isSent ? Icons.done_all : Icons.done,
                  color: Colors.grey,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
