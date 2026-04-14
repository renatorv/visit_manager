import '../entities/visit.dart';
import '../repositories/visit_repository.dart';

class UpdateVisitUseCase {
  final VisitRepository repository;

  UpdateVisitUseCase(this.repository);

  Future<void> call(Visit visit) => repository.updateVisit(visit);
}
