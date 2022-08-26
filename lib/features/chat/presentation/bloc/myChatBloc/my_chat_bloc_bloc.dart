import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/add_to_my_chat_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/chat/get_my_chat_usecase.dart';

import '../../../domain/entity/my_chat_entity.dart';

part 'my_chat_bloc_event.dart';
part 'my_chat_bloc_state.dart';

class MyChatBloc extends Bloc<MyChatBlocEvent, MyChatBlocState> {
  AddToMyChatUseCase addToMyChatUseCase;
  GetMyChatUsecase getMyChatUsecase;

  MyChatBloc({required this.addToMyChatUseCase, required this.getMyChatUsecase})
      : super(MyChatBlocInitial()) {
    on<AddToMyChatEvent>((event, emit) async {
      final resultOrFailure = await addToMyChatUseCase(
          AddToMyChatUseCasePrams(myChatEntity: event.myChatEntity));

      await resultOrFailure.fold((failure) async {
        MyChatLoadFailure(failureMessage: "Can't add to chat list");
      }, (result) async {
        log("Added to chatList");
      });
    });
    on<GetMyChatEvent>((event, emit) async {
      emit(MyChatLoading());
      final resultOrFailure =
          await getMyChatUsecase(GetMyChatUsecaseParams(uid: event.uid));

      await resultOrFailure.fold((failure) async {
        MyChatLoadFailure(failureMessage: "Can't load chats");
      }, (result) async {
        await emit.forEach(result, onData: (List<MyChatEntity> myChatList) {
          return MyChatLoaded(myChatEntities: myChatList);
        });
      });
    });
  }
}
