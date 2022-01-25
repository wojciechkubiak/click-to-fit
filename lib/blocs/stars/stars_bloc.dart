import 'package:bloc/bloc.dart';
import '../../services/settings.dart';
import './../../services/services.dart';

part 'stars_event.dart';
part 'stars_state.dart';

class StarsBloc extends Bloc<StarsEvent, StarsState> {
  final SettingsService _settingsService;

  StarsBloc(
    SettingsService settingsService,
  )   : _settingsService = settingsService,
        super(StarsInitial()) {
    on<StarsLoadInit>(_mapHomeInit);
  }

  void _mapHomeInit(StarsEvent event, Emitter<StarsState> emit) async {}
}
