import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';

class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(null);

  void login(User user) {
    emit(user);
  }

  void logout() {
    emit(null);
  }

  User? get currentUser => state;
}

