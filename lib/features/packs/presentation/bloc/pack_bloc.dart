import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

part 'pack_event.dart';
part 'pack_state.dart';

/// Bloc for managing Pack events and states.
class PackBloc extends Bloc<PackEvent, PackState> {
  /// Creates a new instance of [PackBloc].
  PackBloc() : super(PackInitialState()) {
    on<FetchPackEvent>(_onFetchPack);
    on<FetchPackLoopEvent>(_onFetchPackLoop);
  }

  Timer? _fetchLoopTimer;

  Future<void> _onFetchPackLoop(FetchPackLoopEvent event, Emitter<PackState> emit) async {
    _fetchLoopTimer?.cancel();
    _fetchLoopTimer = Timer.periodic(event.delay, (_) {
      add(FetchPackEvent(event.packId));
    });
    // Initial fetch
    add(FetchPackEvent(event.packId));
  }

  Future<void> _onFetchPack(FetchPackEvent event, Emitter<PackState> emit) async {
    if (state is! PackLoadedState) {
      emit(PackLoadingState());
    }

    try {
      final result = await getIt<PackRepository>().getPackById(event.packId);
      result.fold(
        (failure) {
          emit(PackFailureState(failure));
        },
        (pack) {
          emit(PackLoadedState(pack));
        },
      );
    } catch (e, st) {
      getIt<Talker>().error('[OnFetchPack] Error: $e', e, st);
      emit(
        PackFailureState(
          ApiException.unknownError(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _fetchLoopTimer?.cancel();
    _fetchLoopTimer = null;
    return super.close();
  }
}
