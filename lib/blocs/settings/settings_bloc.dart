import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/progress.dart';
import '../../models/star.dart';
import '../../models/user.dart';
import '../../models/weight.dart';
import '../../services/settings.dart';
import '../../services/weight.dart';
import './../../services/services.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService;

  SettingsBloc(
    SettingsService settingsService,
  )   : _settingsService = settingsService,
        super(SettingsInitial()) {
    on<SettingsLoadInit>(_mapHomeInit);
  }

  void _mapHomeInit(SettingsEvent event, Emitter<SettingsState> emit) async {}
}
