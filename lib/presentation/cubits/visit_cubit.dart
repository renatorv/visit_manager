import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/visit.dart';
import '../../domain/usecases/add_visit_usecase.dart';
import '../../domain/usecases/delete_visit_usecase.dart';
import '../../domain/usecases/get_all_visits_usecase.dart';
import '../../domain/usecases/update_visit_usecase.dart';
import 'visit_state.dart';

class VisitCubit extends Cubit<VisitState> {
  final GetAllVisitsUseCase getAllVisitsUseCase;
  final AddVisitUseCase addVisitUseCase;
  final UpdateVisitUseCase updateVisitUseCase;
  final DeleteVisitUseCase deleteVisitUseCase;

  VisitCubit({
    required this.getAllVisitsUseCase,
    required this.addVisitUseCase,
    required this.updateVisitUseCase,
    required this.deleteVisitUseCase,
  }) : super(VisitInitial());

  Future<void> loadVisits() async {
    emit(VisitLoading());
    try {
      final visits = await getAllVisitsUseCase();
      emit(VisitLoaded(visits));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }

  Future<void> addVisit(Visit visit) async {
    try {
      await addVisitUseCase(visit);
      final visits = await getAllVisitsUseCase();
      emit(VisitOperationSuccess('Visita cadastrada com sucesso!', visits));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }

  Future<void> updateVisit(Visit visit) async {
    try {
      await updateVisitUseCase(visit);
      final visits = await getAllVisitsUseCase();
      emit(VisitOperationSuccess('Visita atualizada com sucesso!', visits));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }

  Future<void> deleteVisit(int id) async {
    try {
      await deleteVisitUseCase(id);
      final visits = await getAllVisitsUseCase();
      emit(VisitOperationSuccess('Visita excluída com sucesso!', visits));
    } catch (e) {
      emit(VisitError(e.toString()));
    }
  }
}
