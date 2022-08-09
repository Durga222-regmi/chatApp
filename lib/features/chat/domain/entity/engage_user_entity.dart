import 'package:equatable/equatable.dart';

class EngageUserEntity extends Equatable {
  final String? uid;
  final String? otherUid;

  const EngageUserEntity({this.otherUid, this.uid});

  @override
  // TODO: implement props
  List<Object?> get props => [uid, otherUid];
}
