part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeLoadInit extends HomeEvent {
  final bool isInit;
  final Function() handlePage;
  final int? userId;

  HomeLoadInit({
    this.isInit = false,
    required this.handlePage,
    this.userId,
  });

  List<Object?> get props => [isInit];
}

class HomeLoadIntro extends HomeEvent {
  final IntroMode introMode;
  final User? user;

  HomeLoadIntro({
    this.introMode = IntroMode.init,
    this.user,
  });

  List<Object?> get props => [introMode, user];
}

class HomeLoadSplash extends HomeEvent {}

class HomeLoadPage extends HomeEvent {
  final IntroMode introMode;
  final User? user;

  HomeLoadPage({this.introMode = IntroMode.init, this.user});

  List<Object?> get props => [user];
}

class HomeLoadSettings extends HomeEvent {}

class HomeLoadStars extends HomeEvent {}

class HomeLoadMeasures extends HomeEvent {}
