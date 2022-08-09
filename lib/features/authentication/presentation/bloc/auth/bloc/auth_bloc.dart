import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:group_chat_fb/core/use_case/usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/get_current_user_id_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/is_signed_in_usecase.dart';
import 'package:group_chat_fb/features/authentication/domain/usecases/sign_out_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IsSignedInUsecase isSignedInUsecase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserIdUsecase getCurrentUserIdUsecase;

  AuthBloc(
      {required this.getCurrentUserIdUsecase,
      required this.isSignedInUsecase,
      required this.signOutUseCase})
      : super(AuthInitial()) {
    on<AppStartedEvent>((event, emit) async {
      try {
        final isSignedIn = await isSignedInUsecase(NoParams());

        isSignedIn.fold((l) {
          emit(UnAuthenticated());
        }, (isSignedIn) async {
          final uid = await getCurrentUserIdUsecase(NoParams());

          uid.fold((l) {
            emit(UnAuthenticated());
          }, (uid) {
            emit(Authenticated(uid: uid));
          });
        });
      } catch (e) {
        emit(UnAuthenticated());
      }
    });
    on<LoggedInEvent>((event, emit) async {
      final uid = await getCurrentUserIdUsecase(NoParams());
      uid.fold((failure) {
        emit(UnAuthenticated());
      }, (uid) => emit(Authenticated(uid: uid)));
    });
    on<SignedOutEvent>((event, emit) async {
      final val = await signOutUseCase(NoParams());
      val.fold(
        (l) {
          emit(const AuthenticationFailure(message: "Please try again"));
        },
        (r) {
          emit(UnAuthenticated());
        },
      );
    });
  }
}
