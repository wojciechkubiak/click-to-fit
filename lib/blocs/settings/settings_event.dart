part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsLoadInit extends SettingsEvent {}
