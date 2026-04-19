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
    try {
      final response = await dio.get('/visits/ativas');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => VisitModel.fromApi(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<void> insertVisit(VisitModel visit) async {
    try {
      await dio.post('/visits/criar_visita', queryParameters: visit.toApiMap());
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<void> updateVisit(VisitModel visit) async {
    try {
      await dio.put('/visits/editar/${visit.id}', queryParameters: visit.toEditApiMap());
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout || e.toString().contains('Connection refused')) {
      return 'Falha ao comunicar com o servidor, por favor tente mais tarde.';
    }
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          final first = detail[0];
          if (first is Map && first.containsKey('msg')) {
            return first['msg'].toString();
          }
        }
        return detail.toString();
      }
    }
    return 'Erro de comunicação com o servidor';
  }
}
