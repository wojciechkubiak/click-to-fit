import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:star_metter/models/user.dart';
import './../../services/services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService? _homeService;

  HomeBloc(HomeService homeService)
      : _homeService = homeService,
        super(HomeInitial()) {
    on<HomeLoadInit>(_mapHomeInit);
    on<HomeLoadSplash>(_mapHomeLoadSplash);
    on<HomeLoadIntro>(_mapHomeLoadIntro);
    on<HomeLoadPage>(_mapHomeLoadHomePage);
  }

  void _mapHomeInit(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());

    await Future.delayed(const Duration(seconds: 5));
    User? user = await _homeService!.getUser(null);

    if (user is User) {
      emit(HomePage(user: user));
    } else {
      emit(HomeIntro());
    }
  }

  void _mapHomeLoadSplash(HomeEvent event, Emitter<HomeState> emit) {
    emit(HomeSplash());
  }

  void _mapHomeLoadIntro(HomeEvent event, Emitter<HomeState> emit) {
    emit(HomeIntro());
  }

  void _mapHomeLoadHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeLoadPage) {
      if (_homeService != null && event.user is User) {
        int? userId = await _homeService!.insertUser(event.user!);

        if (userId is int) {
          User? user = await _homeService!.getUser(userId);

          if (user is User) {
            emit(HomePage(user: user));
          }
        }
      }
    }
  }
}
