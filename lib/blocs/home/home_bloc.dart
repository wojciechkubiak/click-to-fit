import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:star_metter/models/progress.dart';
import 'package:star_metter/models/user.dart';
import 'package:star_metter/models/weight.dart';
import 'package:star_metter/services/weight.dart';
import './../../services/services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService;
  final WeightService _weightService;

  HomeBloc(HomeService homeService, WeightService weightService)
      : _homeService = homeService,
        _weightService = weightService,
        super(HomeInitial()) {
    on<HomeLoadInit>(_mapHomeInit);
    on<HomeLoadSplash>(_mapHomeLoadSplash);
    on<HomeLoadIntro>(_mapHomeLoadIntro);
    on<HomeLoadPage>(_mapHomeLoadHomePage);
  }

  void _mapHomeInit(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());

    await Future.delayed(const Duration(seconds: 5));
    User? user = await _homeService.getUser(null);
    if (user is User) {
      Weight? weight =
          await _weightService.getTodayWeight(initialWeight: user.initWeight);
      Weight? previousWeight = await _weightService.getPreviousWeight();
      List<Weight>? weightHistory = await _weightService.getWeights();

      Progress? progress = await _homeService.getProgress(
        user: user,
        starProgress: [],
        weight: weight,
        prevWeight: previousWeight,
        weightProgress: weightHistory,
      );
      if (progress is Progress) {
        emit(HomePage(user: user, progress: progress));
      }
    } else {
      emit(HomeIntro());
    }
  }

  void _mapHomeLoadSplash(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
  }

  void _mapHomeLoadIntro(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeIntro());
  }

  void _mapHomeLoadHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());

    if (event is HomeLoadPage) {
      if (event.user is User) {
        int? userId = await _homeService.insertUser(event.user!);

        if (userId is int) {
          User? user = await _homeService.getUser(userId);

          if (user is User) {
            Weight? weight = await _weightService.getTodayWeight(
                initialWeight: user.initWeight);
            Weight? previousWeight = await _weightService.getPreviousWeight();
            List<Weight>? weightHistory = await _weightService.getWeights();

            Progress? progress = await _homeService.getProgress(
              user: user,
              starProgress: [],
              weight: weight,
              prevWeight: previousWeight,
              weightProgress: weightHistory,
            );
            if (progress is Progress) {
              emit(HomePage(user: user, progress: progress));
            }
          }
        }
      }
    }
  }
}
