import 'package:dio/dio.dart';

import '../models/visit_model.dart';

abstract class VisitRemoteDataSource {
  Future<List<VisitModel>> getAllVisits();
  Future<void> insertVisit(VisitModel visit);
  Future<void> updateVisit(VisitModel visit);
}

class VisitRemoteDataSourceImpl implements VisitRemoteDataSource {
  final Dio dio;

  VisitRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VisitModel>> getAllVisits() async {
    final response = await dio.get('/visits/ativas');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => VisitModel.fromApi(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> insertVisit(VisitModel visit) async {
    await dio.post('/visits/criar_visita', queryParameters: visit.toApiMap());
  }

  @override
  Future<void> updateVisit(VisitModel visit) async {
    await dio.put('/visits/editar/${visit.id}', queryParameters: visit.toEditApiMap());
  }
}
