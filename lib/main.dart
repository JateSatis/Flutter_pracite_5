import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_5_project/app_observer.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import 'package:practice_5_project/shared/cubits/chat_cubit.dart';
import 'package:practice_5_project/shared/cubits/message_cubit.dart';
import 'package:practice_5_project/shared/cubits/review_cubit.dart';
import 'app.dart';

void main() {
  Bloc.observer = AppObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EstateCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => MessageCubit()),
        BlocProvider(create: (context) => ReviewCubit()),
      ],
      child: const App(),
    ),
  );
}

