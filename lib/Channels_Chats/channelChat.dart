import 'package:chatting_app/Bloc/cubit.dart';
import 'package:chatting_app/Bloc/states.dart';
import 'package:chatting_app/Channels_Chats/components.dart';
import 'package:chatting_app/Reuseables/reusableWidgets.dart';
import 'package:chatting_app/Reuseables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelChat extends StatefulWidget {
  final Channel? channelData;
  const ChannelChat({super.key, this.channelData});

  @override
  State<ChannelChat> createState() => _ChannelChatState();
}

class _ChannelChatState extends State<ChannelChat> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatServiceBloc, States>(builder: (context, state) {
      ChatServiceBloc.GET(context).listenToChannel(widget.channelData!);

      return Scaffold(
          appBar: ChannelAppBar(
            channel: widget.channelData,
            context: context,
          ),
          body: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("chatBackground".jpgAsset()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: widget.channelData!.state == null
                            ? Stream.value([])
                            : widget.channelData!.state!.messagesStream,
                        builder: (_, ss) {
                          if (ss.hasData) {
                            //Scrolling top down when messages are received
                            WidgetsBinding.instance
                                .addPostFrameCallback((callBack) {
                              if (scrollController.hasClients) {
                                scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent);
                              }
                            });
                            return ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                if (ss.data![index].user!.id == currenUserId!) {
                                  return MessageWidget(
                                    message: ss.data![index],
                                    isItMe: true,
                                  );
                                } else {
                                  return MessageWidget(
                                    message: ss.data![index],
                                    isItMe: false,
                                  );
                                }
                              },
                              itemCount: ss.data!.length,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                                controller: message,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 15),
                                    hintMaxLines: 3,
                                    hintText: "Message",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1)))),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await widget.channelData!
                                  .sendMessage(Message(
                                      id: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      text: message.text))
                                  .then((value) {
                                setState(() {
                                  message.text = "";
                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                });
                              });
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.teal,
                            ))
                      ],
                    ),
                  ),
                ],
              )));
    });
  }
}
