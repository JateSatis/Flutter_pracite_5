import 'package:flutter_bloc/flutter_bloc.dart';

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> cubit, Change<dynamic> change) {
    super.onChange(cubit, change);
    print('🔷 onChange → ${cubit.runtimeType}: $change');
  }
}

