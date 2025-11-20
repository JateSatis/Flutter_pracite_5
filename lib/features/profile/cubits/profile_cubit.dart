// lib/bloc/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/profile/models/profile.dart';

class ProfileCubit extends Cubit<Profile> {
  ProfileCubit() : super(
    Profile(
      name: 'Максим Данилов',
      imageUrl: 'https://avatars.githubusercontent.com/u/77029208?v=4',
    ),
  );

  Profile get profile => state;
}