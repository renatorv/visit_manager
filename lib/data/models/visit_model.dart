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

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      id: map['id'] as int?,
      visitedPersonName: map['visited_person_name'] as String,
      visitorName: map['visitor_name'] as String,
      visitDate: DateTime.parse(map['visit_date'] as String),
      description: map['description'] as String,
      visitAgain: (map['visit_again'] as int) == 1,
      nextVisitDate: map['next_visit_date'] != null
          ? DateTime.parse(map['next_visit_date'] as String)
          : null,
      nextVisitReason: map['next_visit_reason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'visited_person_name': visitedPersonName,
      'visitor_name': visitorName,
      'visit_date': visitDate.toIso8601String(),
      'description': description,
      'visit_again': visitAgain ? 1 : 0,
      'next_visit_date': nextVisitDate?.toIso8601String(),
      'next_visit_reason': nextVisitReason,
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
