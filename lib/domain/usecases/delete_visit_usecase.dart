import '../repositories/visit_repository.dart';

class DeleteVisitUseCase {
  final VisitRepository repository;

  DeleteVisitUseCase(this.repository);

  Future<void> call(int id) => repository.deleteVisit(id);
}
