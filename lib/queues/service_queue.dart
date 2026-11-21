import '../models/ticket_model.dart';

class ServiceQueue {
  final String serviceName;
  final List<Ticket> tickets = [];

  ServiceQueue({required this.serviceName});

  Ticket addTicket() {
    final ticket = Ticket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      service: serviceName,
      number: tickets.length + 1,
      createdAt: DateTime.now(),
    );
    tickets.add(ticket);
    return ticket;
  }

  Ticket? callNext() {
    for (final ticket in tickets) {
      if (ticket.status == TicketStatus.waiting) {
        ticket.status = TicketStatus.serving;
        return ticket;
      }
    }
    return null;
  }
}