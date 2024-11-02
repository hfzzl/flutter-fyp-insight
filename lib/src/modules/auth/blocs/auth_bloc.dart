import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repositories.dart';
import '../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        UserModel? user = await authRepository.getCurrentUser();
        // print(user?.email);
        if (user != null) {
          emit(Authenticated(role: user.role));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(Unauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());
      try {
        UserModel? user = await authRepository.signInWithEmailAndPassword(
            event.email, event.password);
        if (user != null) {
          emit(Authenticated(role: user.role));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<Registered>((event, emit) async {
      emit(AuthLoading());
      try {
        UserModel? user = await authRepository.registerWithEmailAndPassword(
            event.email, event.password, event.role);
        if (user != null) {
          emit(Authenticated(role: user.role));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
