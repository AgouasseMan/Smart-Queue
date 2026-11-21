enum TicketStatus { waiting, serving, done }

class Ticket {
  final String id;
  final String service;
  final int number;
  final DateTime createdAt;
  TicketStatus status;

  Ticket({
    required this.id,
    required this.service,
    required this.number,
    required this.createdAt,
    this.status = TicketStatus.waiting,
  });

  @override
  String toString() => 'Ticket #$number — $service';
}