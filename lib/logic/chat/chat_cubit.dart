import 'package:bloc/bloc.dart';
import 'package:dsync_meetup_app/data/models/message_model.dart';
import 'package:dsync_meetup_app/data/services/chat_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService;

  ChatCubit(this.chatService) : super(ChatInitial());

  Future<void> loadMessages(String chatId) async {
    emit(ChatLoading());
    try {
      final messages = await chatService.getMessages(chatId).first;
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(String chatId, String text, String senderId) async {
    try {
      await chatService.sendMessage(chatId, text, senderId);
    } catch (e) {
      emit(ChatError('Failed to send message'));
    }
  }
}