import '../entities/visit.dart';
import '../repositories/visit_repository.dart';

class AddVisitUseCase {
  final VisitRepository repository;

  AddVisitUseCase(this.repository);

  Future<void> call(Visit visit) => repository.addVisit(visit);
}
