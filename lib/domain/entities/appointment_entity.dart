import 'service_entity.dart';
import 'stylist_entity.dart';

class AppointmentEntity {
  final String id;
  final String customerId;
  final ServiceEntity service;
  final StylistEntity stylist;
  final DateTime date;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final double totalPrice;

  AppointmentEntity({
    required this.id,
    required this.customerId,
    required this.service,
    required this.stylist,
    required this.date,
    required this.status,
    required this.totalPrice,
  });
}
