import '../entities/visit.dart';
import '../repositories/visit_repository.dart';

class GetAllVisitsUseCase {
  final VisitRepository repository;

  GetAllVisitsUseCase(this.repository);

  Future<List<Visit>> call() => repository.getAllVisits();
}
