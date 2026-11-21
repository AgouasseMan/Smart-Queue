import '../queues/service_queue.dart';

class QueueManager {
  static final Map<String, ServiceQueue> services = {
    "Banque": ServiceQueue(serviceName: "Banque"),
    "Hôpital": ServiceQueue(serviceName: "Hôpital"),
    "Restaurant": ServiceQueue(serviceName: "Restaurant"),
    "Administration": ServiceQueue(serviceName: "Administration"),
  };

  static ServiceQueue getQueue(String service) {
    return services[service]!;
  }
}