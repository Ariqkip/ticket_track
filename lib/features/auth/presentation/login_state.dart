import 'package:equatable/equatable.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;

  const AuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
    this.isPasswordVisible = false,
  });

  AuthState copyWith({AuthStatus? status, String? errorMessage, bool? isPasswordVisible}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isPasswordVisible];
}