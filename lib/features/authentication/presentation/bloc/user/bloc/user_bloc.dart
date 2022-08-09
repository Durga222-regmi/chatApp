import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/enitity/user_entity.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_all_user_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_update_user_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAllUserUsecase getAllUserUsecase;
  final GetUpdateUserUsecase getUpdateUserUsecase;

  UserBloc(
      {required this.getAllUserUsecase, required this.getUpdateUserUsecase})
      : super(UserInitial()) {
    on<GetUserEvent>((event, emit) async {
      emit(UserLoading());

      final userOrFailure = await getAllUserUsecase(NoParams());

      userOrFailure.fold((failure) {
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

      resultOfFailure.fold(
        (l) {
          emit(UserFailure());
        },
        (r) {
          emit(UserUpdated());
        },
      );
    });
  }
}
