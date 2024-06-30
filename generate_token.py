import stream_chat

server_client = stream_chat.StreamChat(
    api_key="mmh3vh9ah6jb", api_secret="5qrkwhr3bvdjz8rjb3zyhz3ptcvr4vg3ek2y9bwsv3d4t6997nn6fub5shvvak6m"
)
token = server_client.create_token("SaifAlattar")
print(token)