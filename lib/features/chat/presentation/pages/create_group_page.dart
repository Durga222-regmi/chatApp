import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_fb/app_constant.dart';
import 'package:group_chat_fb/core/dynamic_widgets/custom_app_bar.dart';
import 'package:group_chat_fb/features/chat/domain/entity/group_entity.dart';
import 'package:group_chat_fb/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupPage extends StatefulWidget {
  String uid;
  static const routeName = "/create_group_page";
  CreateGroupPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _numberOfPeopleController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? profileUrl;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      builder: (context, groupState) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "Create Group",
          ),
          body: _bodyWidget(groupState),
        );
      },
      listener: (context, groupState) {
        if (groupState is GroupCreated) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(groupState.successMessage)));
        } else if (groupState is GroupFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(groupState.failureMessage)));
        }
      },
    );
  }

  _bodyWidget(GroupState groupState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: groupState is GroupLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    backgroundColor: AppConstant.PRIMARY_COLOR,
                  ),
                  Text("Creating group...")
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          GestureDetector(
                            onTap: () {
                              _getImage();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5,
                                      color: AppConstant.BORDER_COLOR)),
                              child: _image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : const Icon(Icons.photo_outlined),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            cursorColor: AppConstant.PRIMARY_COLOR,
                            cursorHeight: 25,
                            controller: _groupNameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                hintText: "Enter group name",
                                hintStyle: TextStyle(fontSize: 16),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: AppConstant.BORDER_COLOR)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: AppConstant.BORDER_COLOR))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            cursorColor: AppConstant.PRIMARY_COLOR,
                            cursorHeight: 25,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            controller: _numberOfPeopleController,
                            validator: (val) {
                              try {
                                int.parse(val.toString());
                              } on FormatException {
                                return "invalid number";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: "Number of people",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: AppConstant.BORDER_COLOR)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: AppConstant.BORDER_COLOR))),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppConstant.PRIMARY_COLOR)),
                        onPressed: () {
                          _submit();
                        },
                        child: const Text("Create group")),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(color: AppConstant.PRIMARY_COLOR),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
    );
  }

  void _getImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        log("no image selected");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        _createGroup();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _clear() {
    _groupNameController.clear();
    _numberOfPeopleController.clear();
    profileUrl = "";
    _image = null;
  }

  void disposeFiled() {
    _groupNameController.dispose();
    _numberOfPeopleController.dispose();
  }

  @override
  void dispose() {
    _clear();
    disposeFiled();

    super.dispose();
  }

  void _createGroup() {
    BlocProvider.of<GroupBloc>(context).add(GetCreateGroupEvent(
        groupEntity: GroupEntity(
            creationTime: Timestamp.now(),
            admin: GroupAdminEntity(uid: widget.uid),
            groupName: _groupNameController.text,
            groupProfileImage: profileUrl,
            joinUsers: "1",
            limitUsers: _numberOfPeopleController.text,
            lastMessage: ""),
        file: _image!));
  }
}
