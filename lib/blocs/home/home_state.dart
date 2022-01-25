part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSplash extends HomeState {}

class HomeLoading extends HomeState {}

class HomeIntro extends HomeState {
  final IntroMode introMode;
  final User? user;

  HomeIntro({
    required this.introMode,
    this.user,
  });

  List<Object> get props => [introMode];
}

class HomeSettings extends HomeState {
  final List<User> users;
  final User currentUser;

  HomeSettings({
    required this.users,
    required this.currentUser,
  });

  List<Object> get props => [users, currentUser];
}

class HomeStars extends HomeState {}

class HomeMeasures extends HomeState {}

class HomePage extends HomeState {
  final User user;
  final Progress progress;

  HomePage({
    required this.user,
    required this.progress,
  });

  List<Object> get props => [user, progress];
}

class HomeError extends HomeState {}
