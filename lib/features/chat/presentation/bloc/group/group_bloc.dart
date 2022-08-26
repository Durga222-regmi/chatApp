import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/get_create_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/get_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/get_single_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/join_group_usecase.dart';
import 'package:group_chat_fb/features/chat/domain/usecases/group/update_group_usecase.dart';

import '../../../data/datasources/remote_data_source/chat_storage_provider.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GetCreateGroupUsecase getCreateGroupUsecase;
  GetGroupUsecase getGroupUsecase;
  JoinGroupUsecase joinGroupUsecase;
  UpdateGroupUsecase updateGroupUsecase;
  GetSingleGroupUsecase getSingleGroupUsecase;

  GroupBloc(
      {required this.getCreateGroupUsecase,
      required this.getGroupUsecase,
      required this.joinGroupUsecase,
      required this.updateGroupUsecase,
      required this.getSingleGroupUsecase})
      : super((GroupInitial())) {
    on<GetCreateGroupEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        final imageUrl =
            await ChatStorageProviderRemoteDataSource.uploadImage(event.file);

        final groupEntity = GroupEntity(
            creationTime: event.groupEntity.creationTime,
            admin: event.groupEntity.admin,
            groupName: event.groupEntity.groupName,
            groupProfileImage: imageUrl,
            joinUsers: event.groupEntity.joinUsers,
            limitUsers: event.groupEntity.limitUsers,
            lastMessage: event.groupEntity.lastMessage);

        await getCreateGroupUsecase(
            GetCreateGroupUsecasePrams(groupEntity: groupEntity));
        emit(const GroupCreated(successMessage: "Group created successfully"));
      } catch (e) {
        emit(const GroupFailure(failureMessage: "Cannot create group"));
      }
    });
    on<GetGroupEvent>((event, emit) async {
      emit(GroupLoading());

      final groupsOrFailure = await getGroupUsecase(NoParams());
      await groupsOrFailure.fold(
        (failure) async {
          log("cannot create group");
          emit(const GroupFailure(failureMessage: "Cannot create group"));
        },
        (groups) async {
          await emit.forEach<List<GroupEntity>>(groups,
              onData: (List<GroupEntity> groupList) {
            return GroupLoaded(groupEntities: groupList);
          });
        },
      );
    });
    on<JoinGroupEvent>((event, emit) async {
      try {
        await joinGroupUsecase(JoinGroupUsecasePrams(
            groupEntity: event.groupEntity, uid: event.uid));
      } catch (e) {
        emit(const GroupJoinFailure(joinFailureMsg: "cannot join group"));
      }
    });
    on<UpdateGroupEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        await updateGroupUsecase(
            UpdateGroupUsecasePrams(groupEntity: event.groupEntity));
      } catch (e) {
        emit(const GroupFailure(failureMessage: "cannot update group"));
      }
    });

    on<GetSingleGroupEvent>((event, emit) async {
      emit(GroupLoading());
      try {
        final groupEntity = await getSingleGroupUsecase(
            GetSingleGroupUsecaseParams(uid: event.uid));

        await groupEntity.fold((failure) async {
          emit(const GroupFailure(failureMessage: "Can't load this group"));
        }, (groupEntity) {
          emit(GetSingleGroupStateLoaded(groupEntity: groupEntity));
        });
      } catch (e) {
        emit(const GroupFailure(failureMessage: "Can't load this group"));
      }
    });
  }

  void dispose() {}
}
