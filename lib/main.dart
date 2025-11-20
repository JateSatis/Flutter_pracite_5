import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_5_project/app_observer.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'app.dart';

void main() {
  Bloc.observer = AppObserver();

  runApp(
    BlocProvider(
      create: (context) => EstateCubit(),
      child: const App(),
    ),
  );
}

