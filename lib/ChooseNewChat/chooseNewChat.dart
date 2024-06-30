import 'package:chatting_app/Bloc/cubit.dart';
import 'package:chatting_app/Bloc/states.dart';
import 'package:chatting_app/Reuseables/reusableWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseNewUser extends StatelessWidget {
  const ChooseNewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatServiceBloc, States>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Choose New Chat",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
            future: ChatServiceBloc.GET(context).getAllUsers(),
            builder: (_, ss) {
              if (ss.hasData) {
                return ListView.separated(
                    itemBuilder: (_, index) {
                      return ChatWidget(
                        isNewChannel: true,
                        member: ss.data!.users[index].name,
                      );
                    },
                    separatorBuilder: (_, index) => const Divider(
                          thickness: 0.5,
                        ),
                    itemCount: ss.data!.users.length);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      );
    });
  }
}
