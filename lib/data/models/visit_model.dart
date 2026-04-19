import '../../domain/entities/visit.dart';

class VisitModel extends Visit {
  const VisitModel({
    super.id,
    required super.visitedPersonName,
    required super.visitorName,
    required super.visitDate,
    required super.description,
    required super.visitAgain,
    super.nextVisitDate,
    super.nextVisitReason,
  });

  factory VisitModel.fromApi(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] as int?,
      visitedPersonName: json['nome_visitado'] as String,
      visitorName: json['nome_visitante'] as String,
      visitDate: DateTime.parse(json['data_visita'] as String),
      description: json['descricao'] as String,
      visitAgain: json['visitar_novamente'] as bool? ?? false,
      nextVisitDate: json['proxima_visita'] != null
          ? DateTime.parse(json['proxima_visita'] as String)
          : null,
      nextVisitReason: json['motivo_proxima_visita'] as String?,
    );
  }

  Map<String, dynamic> toApiMap() {
    return {
      'nome_visitado': visitedPersonName,
      'nome_visitante': visitorName,
      'data_visita': visitDate.toIso8601String().split('T').first,
      'descricao': description,
      'visitar_novamente': visitAgain,
      'mostrar_app': true,
      if (nextVisitDate != null)
        'proxima_visita': nextVisitDate!.toIso8601String().split('T').first,
      if (nextVisitReason != null && nextVisitReason!.isNotEmpty)
        'motivo_proxima_visita': nextVisitReason,
    };
  }

  Map<String, dynamic> toEditApiMap() {
    return {
      'nome_visitado': visitedPersonName,
      'nome_visitante': visitorName,
      'data_visita': visitDate.toIso8601String().split('T').first,
      'descricao': description,
      'visitar_novamente': visitAgain,
      if (nextVisitDate != null)
        'proxima_visita': nextVisitDate!.toIso8601String().split('T').first,
      if (nextVisitReason != null && nextVisitReason!.isNotEmpty)
        'motivo_proxima_visita': nextVisitReason,
    };
  }

  factory VisitModel.fromEntity(Visit visit) {
    return VisitModel(
      id: visit.id,
      visitedPersonName: visit.visitedPersonName,
      visitorName: visit.visitorName,
      visitDate: visit.visitDate,
      description: visit.description,
      visitAgain: visit.visitAgain,
      nextVisitDate: visit.nextVisitDate,
      nextVisitReason: visit.nextVisitReason,
    );
  }
}
