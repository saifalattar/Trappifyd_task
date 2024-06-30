import 'package:chatting_app/AllChats/allChats.dart';
import 'package:chatting_app/Bloc/cubit.dart';
import 'package:chatting_app/Bloc/states.dart';
import 'package:chatting_app/Registeration/components.dart';
import 'package:chatting_app/Reuseables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registeration extends StatelessWidget {
  const Registeration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text("\n\nPlease choose an ID, or Write yours if exists"),
          TextField(
            controller: userId,
            decoration: InputDecoration(
                labelText: "User ID",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.teal, width: 4))),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: userName,
            decoration: InputDecoration(
                labelText: "Display Name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: Colors.teal, width: 4))),
          ),
          SizedBox(
            height: 40,
          ),
          BlocBuilder<ChatServiceBloc, States>(builder: (context, state) {
            return ElevatedButton(
                onPressed: () async {
                  await ChatServiceBloc.GET(context)
                      .connectUser(userId.text, userName.text)
                      .then((value) {
                    currenUserId = userId.text;
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => AllChats()));
                  }).catchError((onError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("$onError")));
                  });
                },
                child: const Text("Enter"));
          })
        ],
      ),
    ));
  }
}
