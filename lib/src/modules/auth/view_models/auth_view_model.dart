import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repositories.dart';
import '../models/user_model.dart';
import '../blocs/auth_state.dart';

class AuthViewModel extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(AuthInitial()) {
    _init();
  }

  void _init() async {
    emit(AuthInitial());
    UserModel? user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(role: user.role));
    } else {
      emit(Unauthenticated());
    }
  }

  void signIn(String email, String password) async {
    emit(AuthLoading());
    UserModel? user =
        await _authRepository.signInWithEmailAndPassword(email, password);
    if (user != null) {
      emit(Authenticated(role: user.role));
    } else {
      emit(const AuthError(message: 'Login failed'));
    }
  }

  void register(String email, String password, String role) async {
    emit(AuthLoading());
    UserModel? user = await _authRepository.registerWithEmailAndPassword(
        email, password, role);
    if (user != null) {
      emit(Authenticated(role: user.role));
    } else {
      emit(const AuthError(message: 'Registration failed'));
    }
  }

  void signOut() async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }
}
