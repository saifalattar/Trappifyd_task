import 'package:bloc/bloc.dart';
import 'package:chatting_app/Bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat/stream_chat.dart';

class ChatServiceBloc extends Cubit<States> {
  ChatServiceBloc() : super(InitialState());

  static ChatServiceBloc GET(context) => BlocProvider.of(context);
  final _client = StreamChatClient("mmh3vh9ah6jb", logLevel: Level.INFO);

  Future addChannel(String channelId, Map<String, Object> channelData) async {
    return await _client.createChannel("messaging",
        channelId: channelId, channelData: channelData);
  }

  StreamChatClient get server => _client;

  Future connectUser(String userId, String userName) async {
    await _client.connectUser(
        User(id: userId, name: userName), _client.devToken(userId).rawValue);
  }

  Future<void> signOut() async {
    await _client.disconnectUser();
  }

  Channel connectToChannel(String channelId) =>
      _client.channel("messaging", id: channelId);

  Future<ChannelState> listenToChannel(Channel channel) async =>
      await channel.watch();

  Stream<List<Channel>> getAllChannels(String userName) async* {
    yield* _client.queryChannels(
        filter: Filter.raw(value: {
      "members": {
        "\$in": [userName]
      }
    }));
  }

  Future sendMessage(Channel channel, String message) async {
    await channel.sendMessage(Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(), text: message));
    updateState();
  }

  Future<QueryUsersResponse> getAllUsers() async {
    return await _client.queryUsers(filter: Filter.empty());
  }

  void updateState() {
    emit(UpdateState());
  }
}
