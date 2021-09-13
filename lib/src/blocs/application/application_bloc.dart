import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloudmate/src/blocs/app_bloc.dart';
import 'package:cloudmate/src/blocs/bloc.dart';
import 'package:cloudmate/src/configs/application.dart';
import 'package:cloudmate/src/themes/theme_service.dart';
import 'bloc.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(InitialApplicationState());

  @override
  Stream<ApplicationState> mapEventToState(event) async* {
    if (event is OnSetupApplication) {
      // Get themeMode
      await Application().initialAppLication();
      AppBloc.themeBloc.add(
        OnChangeTheme(
          themeMode: ThemeService().isSavedDarkMode()
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );
      yield ApplicationCompleted();
    }
  }
}
