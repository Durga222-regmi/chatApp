import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_all_user_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_update_user_usecase.dart';

import '../../../../domain/usecases/update_chatting_with_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAllUserUsecase getAllUserUsecase;
  final GetUpdateUserUsecase getUpdateUserUsecase;
  final UpdateChattingWithUsecase updateChattingWithUsecase;

  UserBloc(
      {required this.getAllUserUsecase,
      required this.getUpdateUserUsecase,
      required this.updateChattingWithUsecase})
      : super(UserInitial()) {
    on<GetUserEvent>((event, emit) async {
      emit(UserLoading());

      final userOrFailure = await getAllUserUsecase(NoParams());

      await userOrFailure.fold((failure) async {
        emit(UserFailure());
      }, (user) async {
        await emit.forEach<List<UserEntity>>(user,
            onData: (List<UserEntity> userList) {
          log(userList.length.toString());
          return UserLoaded(users: userList);
        });
      });
    });
    on<GetUpdatedUser>((event, emit) async {
      emit(UserUpdating());

      final resultOfFailure = await getUpdateUserUsecase(
          GetUpdateUserUsecasePrams(entity: event.entity));

      await resultOfFailure.fold(
        (l) async {
          emit(UserFailure());
        },
        (r) async {
          emit(UserUpdated());
        },
      );
    });

    // on<GetUpdatedUser>((event, emit) async {
    //   emit(UserUpdating());

    //   final resultOfFailure = await getUpdateUserUsecase(
    //       GetUpdateUserUsecasePrams(entity: event.entity));

    //   await resultOfFailure.fold(
    //     (l) async {
    //       emit(UserFailure());
    //     },
    //     (r) async {
    //       emit(UserUpdated());
    //     },
    //   );
    // });
    on<UpdateChattingWithEvent>((event, emit) async {
      final val = await updateChattingWithUsecase(
          UpdateChattingWithUsecaseParams(uid: event.uid, users: event.users));
      await val.fold(
        (l) async {
          emit(UserFailure());
        },
        (r) async {
          
        },
      );
    });
  }
}
