part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSplash extends HomeState {}

class HomeLoading extends HomeState {}

class HomeIntro extends HomeState {}

class HomeSettings extends HomeState {}

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
