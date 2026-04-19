import '../../domain/entities/visit.dart';
import '../../domain/repositories/visit_repository.dart';
import '../datasources/visit_remote_datasource.dart';
import '../models/visit_model.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitRemoteDataSource dataSource;

  VisitRepositoryImpl(this.dataSource);

  @override
  Future<List<Visit>> getAllVisits() async {
    return dataSource.getAllVisits();
  }

  @override
  Future<void> addVisit(Visit visit) async {
    final model = VisitModel.fromEntity(visit);
    await dataSource.insertVisit(model);
  }

  @override
  Future<void> updateVisit(Visit visit) async {
    final model = VisitModel.fromEntity(visit);
    await dataSource.updateVisit(model);
  }

}
