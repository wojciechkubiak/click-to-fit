part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeLoadInit extends HomeEvent {
  final bool isInit;
  final Function() handlePage;

  HomeLoadInit({this.isInit = false, required this.handlePage});

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
