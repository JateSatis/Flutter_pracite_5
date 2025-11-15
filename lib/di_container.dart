// lib/di_container.dart
import 'package:get_it/get_it.dart';
import 'package:practice_5_project/estate_repository.dart';
import 'package:practice_5_project/profile_repository.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<EstateRepository>(() => EstateRepository());
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
}