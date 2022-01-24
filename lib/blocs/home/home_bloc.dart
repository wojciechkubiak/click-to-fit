import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:star_metter/models/intro.dart';
import '../../models/progress.dart';
import '../../models/star.dart';
import '../../models/user.dart';
import '../../models/weight.dart';
import '../../services/weight.dart';
import './../../services/services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService;
  final WeightService _weightService;
  final StarsService _starsService;

  HomeBloc(
    HomeService homeService,
    WeightService weightService,
    StarsService starsService,
  )   : _homeService = homeService,
        _weightService = weightService,
        _starsService = starsService,
        super(HomeInitial()) {
    on<HomeLoadInit>(_mapHomeInit);
    on<HomeLoadSplash>(_mapHomeLoadSplash);
    on<HomeLoadIntro>(_mapHomeLoadIntro);
    on<HomeLoadPage>(_mapHomeLoadHomePage);
    on<HomeLoadSettings>(_mapHomeLoadSettings);
  }

  void _mapHomeInit(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeLoadInit) {
      event.isInit ? emit(HomeSplash()) : emit(HomeLoading());

      if (event.isInit) await Future.delayed(const Duration(seconds: 5));

      User? user = await _homeService.getUser(event.userId);

      if (user is User) {
        Weight? weight = await _weightService.getTodayWeight(
            initialWeight: user.initWeight, id: user.id!);
        Weight? previousWeight =
            await _weightService.getPreviousWeight(id: user.id!);
        List<Weight>? weightHistory =
            await _weightService.getWeights(id: user.id!);

        Star? star = await _starsService.getTodayStars(
          id: user.id!,
          progressLimit: user.stars,
        );
        List<Star> starProgress = await _starsService.getStars(id: user.id!);

        Progress? progress = await _homeService.getProgress(
          user: user,
          starProgress: starProgress,
          star: star!,
          weight: weight,
          prevWeight: previousWeight,
          weightProgress: weightHistory,
        );
        if (progress is Progress) {
          event.handlePage();
          emit(HomePage(user: user, progress: progress));
        }
      } else {
        emit(HomeIntro(introMode: IntroMode.init));
      }
    } else {
      emit(HomeSplash());
    }
  }

  void _mapHomeLoadSplash(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
  }

  void _mapHomeLoadIntro(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeLoadIntro) {
      emit(HomeIntro(introMode: event.introMode, user: event.user));
    }
  }

  void _mapHomeLoadHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    if (event is HomeLoadPage) {
      if (event.user is User) {
        User user = event.user!;
        int? userId = await _homeService.insertUser(event.user!);
        user.id = userId;

        if (userId is int) {
          Weight? weight = await _weightService.insertNewRecord(
            id: userId,
            weight: user.initWeight,
          );
          Weight? previousWeight =
              await _weightService.getPreviousWeight(id: user.id!);
          List<Weight>? weightHistory =
              await _weightService.getWeights(id: user.id!);

          Star? star = await _starsService.getTodayStars(
            id: user.id!,
            progressLimit: user.stars,
          );
          List<Star> starProgress = await _starsService.getStars(id: user.id!);

          Progress? progress = await _homeService.getProgress(
            user: user,
            starProgress: starProgress,
            star: star!,
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

  void _mapHomeLoadSettings(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    List<User> users = await _homeService.getUsers();
    User? currentUser = await _homeService.getUser(null);

    if (currentUser is User) {
      emit(HomeSettings(
        users: users,
        currentUser: currentUser,
      ));
    }
  }
}
