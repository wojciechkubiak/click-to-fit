part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeLoadInit extends HomeEvent {
  final bool isInit;

  HomeLoadInit({this.isInit = false});

  List<Object?> get props => [isInit];
}

class HomeLoadIntro extends HomeEvent {}

class HomeLoadSplash extends HomeEvent {}

class HomeLoadPage extends HomeEvent {
  final User? user;

  HomeLoadPage({this.user});

  List<Object?> get props => [user];
}

class HomeLoadSettings extends HomeEvent {}
