part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSplash extends HomeState {}

class HomeLoading extends HomeState {}

class HomeIntro extends HomeState {}

class HomePage extends HomeState {
  final User user;

  HomePage({required this.user});

  List<Object> get props => [user];
}

class HomeError extends HomeState {}
