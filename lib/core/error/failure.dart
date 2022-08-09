import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List<dynamic> props = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}
