import 'package:equatable/equatable.dart';

enum EventStatus { notStarted, ongoing, ended }

class Event extends Equatable {
  final String id;
  final String name;
  final DateTime dateTime;
  final String location;
  final EventStatus status;
  final String imageUrl;

  const Event({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.location,
    required this.status,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, dateTime, location, status, imageUrl];
}