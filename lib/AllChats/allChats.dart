import 'package:chatting_app/Bloc/cubit.dart';
import 'package:chatting_app/Bloc/states.dart';
import 'package:chatting_app/ChooseNewChat/chooseNewChat.dart';
import 'package:chatting_app/Registeration/registeration.dart';
import 'package:chatting_app/Reuseables/reusableWidgets.dart';
import 'package:chatting_app/Reuseables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';

class AllChats extends StatelessWidget {
  const AllChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatServiceBloc, States>(builder: (context, state) {
      return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                await ChatServiceBloc.GET(context).signOut().then((value) =>
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Registeration())));
              },
              icon: const Icon(
                Icons.logout,
                size: 40,
                color: Colors.red,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChooseNewUser()));
              },
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.message_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        appBar: ScrollAppBar(
          elevation: 1,
          leading: null,
          actions: [
            IconButton(
                onPressed: () {
                  ChatServiceBloc.GET(context).updateState();
                },
                icon: Icon(Icons.refresh))
          ],
          backgroundColor: Colors.white,
          controller: ScrollController(),
          title: Text(
            "WhatsApp",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: StreamBuilder(
            stream: ChatServiceBloc.GET(context).getAllChannels(currenUserId!),
            builder: (_, AsyncSnapshot ss) {
              if (ss.data != null) {
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, index) => Divider(
                    thickness: 0.5,
                  ),
                  itemBuilder: (_, index) {
                    return ChatWidget(
                      channelData: ss.data[index],
                    );
                  },
                  itemCount: ss.data.length,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      );
    });
  }
}
