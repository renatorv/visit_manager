import 'package:equatable/equatable.dart';

class Visit extends Equatable {
  final int? id;
  final String visitedPersonName;
  final String visitorName;
  final DateTime visitDate;
  final String description;
  final bool visitAgain;
  final DateTime? nextVisitDate;
  final String? nextVisitReason;
  final String phone;
  final String address;

  const Visit({
    this.id,
    required this.visitedPersonName,
    required this.visitorName,
    required this.visitDate,
    required this.description,
    required this.visitAgain,
    this.nextVisitDate,
    this.nextVisitReason,
    required this.phone,
    required this.address,
  });

  Visit copyWith({
    int? id,
    String? visitedPersonName,
    String? visitorName,
    DateTime? visitDate,
    String? description,
    bool? visitAgain,
    DateTime? nextVisitDate,
    String? nextVisitReason,
    String? phone,
    String? address,
    bool clearNextVisitDate = false,
    bool clearNextVisitReason = false,
  }) {
    return Visit(
      id: id ?? this.id,
      visitedPersonName: visitedPersonName ?? this.visitedPersonName,
      visitorName: visitorName ?? this.visitorName,
      visitDate: visitDate ?? this.visitDate,
      description: description ?? this.description,
      visitAgain: visitAgain ?? this.visitAgain,
      nextVisitDate:
          clearNextVisitDate ? null : (nextVisitDate ?? this.nextVisitDate),
      nextVisitReason:
          clearNextVisitReason ? null : (nextVisitReason ?? this.nextVisitReason),
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        id,
        visitedPersonName,
        visitorName,
        visitDate,
        description,
        visitAgain,
        nextVisitDate,
        nextVisitReason,
        phone,
        address,
      ];
}
