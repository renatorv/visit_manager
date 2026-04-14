import '../entities/visit.dart';

abstract class VisitRepository {
  Future<List<Visit>> getAllVisits();
  Future<void> addVisit(Visit visit);
  Future<void> updateVisit(Visit visit);
  Future<void> deleteVisit(int id);
}
