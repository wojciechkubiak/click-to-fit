import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:star_metter/pages/error_page.dart';
import 'package:star_metter/pages/measures/measures.dart';
import 'package:star_metter/pages/stars.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/services/measures.dart';

import './widgets/widgets.dart';
import './blocs/home/home_bloc.dart';
import './services/services.dart';
import 'blocs/measures/measures_bloc.dart';
import 'blocs/settings/settings_bloc.dart';
import 'blocs/stars/stars_bloc.dart';
import 'config/colors.dart';
import 'lang/translate_preferences.dart';
import 'pages/pages.dart';

enum CurrentPage { INTRO, LOADING, HOME, ARTICLES, ABOUT, SETTINGS }

Future<void> main() async {
  var delegate = await LocalizationDelegate.create(
    basePath: 'assets/i18n/',
    fallbackLocale: 'en_US',
    preferences: TranslatePreferences(),
    supportedLocales: ['en_US', 'pl_PL'],
  );

  WidgetsFlutterBinding.ensureInitialized();
  StorageService storageService = StorageService();

  storageService.getDatabase();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://112f1589f17c4850b93b8a6ffbeeccaf@o1135321.ingest.sentry.io/6184128';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(LocalizedApp(delegate, const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: localizationDelegate.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: localizationDelegate.currentLocale,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ZoomDrawerController zoomController = ZoomDrawerController();
  bool isOpen = false;
  CurrentPage _currentPage = CurrentPage.LOADING;

  @override
  Widget build(BuildContext context) {
    return _repositoryProvider();
  }

  void _setDefaultPage({CurrentPage page = CurrentPage.HOME}) {
    setState(() => _currentPage = page);
  }

  void _menuButtonHandler(CurrentPage page) {
    zoomController.close!();
    setState(() {
      isOpen = false;
      _currentPage = page;
    });
  }

  Widget _repositoryProvider() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeService>(
          create: (context) {
            return HomeService();
          },
        ),
        RepositoryProvider<WeightService>(
          create: (context) {
            return WeightService();
          },
        ),
        RepositoryProvider<StarsService>(
          create: (context) {
            return StarsService();
          },
        ),
        RepositoryProvider<SettingsService>(
          create: (context) {
            return SettingsService();
          },
        ),
        RepositoryProvider<MeasuresService>(
          create: (context) {
            return MeasuresService();
          },
        ),
      ],
      child: _multiBlocProvider(),
    );
  }

  Widget _multiBlocProvider() {
    return MultiBlocProvider(providers: [
      BlocProvider<HomeBloc>(
        create: (context) {
          final homeService = RepositoryProvider.of<HomeService>(context);
          final weightService = RepositoryProvider.of<WeightService>(context);
          final starsService = RepositoryProvider.of<StarsService>(context);
          final measuresService =
              RepositoryProvider.of<MeasuresService>(context);
          return HomeBloc(
            homeService,
            weightService,
            starsService,
            measuresService,
          )..add(HomeLoadInit(isInit: true, handlePage: _setDefaultPage));
        },
      ),
      BlocProvider<SettingsBloc>(
        create: (context) {
          final settingsService =
              RepositoryProvider.of<SettingsService>(context);
          return SettingsBloc(settingsService)..add(SettingsLoadInit());
        },
      ),
      BlocProvider<StarsBloc>(
        create: (context) {
          final settingsService =
              RepositoryProvider.of<SettingsService>(context);
          return StarsBloc(settingsService)..add(StarsLoadInit());
        },
      ),
      BlocProvider<MeasuresBloc>(
        create: (context) {
          final settingsService =
              RepositoryProvider.of<SettingsService>(context);
          final weightService = RepositoryProvider.of<WeightService>(context);
          final measuresService =
              RepositoryProvider.of<MeasuresService>(context);

          return MeasuresBloc(settingsService, weightService, measuresService)
            ..add(const MeasuresLoadInit());
        },
      ),
    ], child: _main());
  }

  Widget _main() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryAccent,
              fontFamily: 'Roboto',
              letterSpacing: 2,
            ),
            headline2: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w100,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
            headline3: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
            headline4: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
            bodyText1: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white70,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        color: CustomColor.primaryAccent,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: CustomColor.primaryAccentLight,
              systemNavigationBarIconBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark,
              systemNavigationBarDividerColor: CustomColor.primaryAccentLight,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.dark : Brightness.light,
              statusBarIconBrightness:
                  Platform.isIOS ? Brightness.dark : Brightness.light,
              statusBarColor: isOpen
                  ? CustomColor.primaryAccentDark
                  : CustomColor.primaryAccent,
            ),
            child: _blocBuilder(),
          ),
        ),
      ),
    );
  }

  Widget _blocBuilder() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomePage) {
          return ZoomDrawer(
            controller: zoomController,
            disableGesture: isOpen,
            style: DrawerStyle.Style5,
            showShadow: true,
            menuScreen: Menu(
              currentPage: _currentPage,
              onClick: _menuButtonHandler,
              user: state.user,
            ),
            mainScreen: GestureDetector(
              onTap: () {
                if (isOpen) {
                  zoomController.close!();
                  setState(() => isOpen = false);
                }
              },
              onPanUpdate: (details) {
                if (details.delta.dx < 0) {
                  zoomController.close!();
                  setState(() => isOpen = false);
                }
              },
              child: AbsorbPointer(
                absorbing: isOpen,
                child: Home(
                  user: state.user,
                  progress: state.progress,
                  showMenu: () {
                    zoomController.open!();
                    setState(() => isOpen = true);
                  },
                ),
              ),
            ),
            borderRadius: 24.0,
            angle: -12.0,
            backgroundColor: CustomColor.primaryAccentDark,
            slideWidth: MediaQuery.of(context).size.width * .45,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.bounceIn,
          );
        }
        if (state is HomeSplash) {
          return const Loading(
            isHeader: true,
          );
        }
        if (state is HomeIntro) {
          return Intro(
            handlePage: _setDefaultPage,
            introMode: state.introMode,
            user: state.user,
          );
        }
        if (state is HomeSettings) {
          return Settings(
            handlePage: _setDefaultPage,
            users: state.users,
            currentUser: state.currentUser,
          );
        }
        if (state is HomeStars) {
          return Stars(
            handlePage: _setDefaultPage,
            stars: state.stars,
          );
        }
        if (state is HomeMeasures) {
          return Measures(
            handlePage: _setDefaultPage,
            weights: state.weights,
            allWeights: state.allWeights,
            allMeasures: state.allMeasures,
            user: state.user,
          );
        }
        if (state is HomeError) {
          return ErrorPage(
            handlePage: _setDefaultPage,
          );
        }
        return const Loading();
      },
    );
  }
}
