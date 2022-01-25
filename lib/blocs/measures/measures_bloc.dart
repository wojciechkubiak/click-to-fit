import 'package:bloc/bloc.dart';
import '../../services/settings.dart';
import './../../services/services.dart';

part 'measures_event.dart';
part 'measures_state.dart';

class MeasuresBloc extends Bloc<MeasuresEvent, MeasuresState> {
  final SettingsService _settingsService;

  MeasuresBloc(
    SettingsService settingsService,
  )   : _settingsService = settingsService,
        super(MeasuresInitial()) {
    on<MeasuresLoadInit>(_mapHomeInit);
  }

  void _mapHomeInit(MeasuresEvent event, Emitter<MeasuresState> emit) async {}
}
