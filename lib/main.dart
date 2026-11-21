import 'package:flutter/material.dart';
import 'dart:async';

import 'queues/queue_manager.dart';
import 'queues/service_queue.dart';
import 'models/ticket_model.dart';

// ── Constantes ──
const Color kPurple = Color(0xFF6A11CB);
const Color kBlue   = Color(0xFF2575FC);

const LinearGradient kGradient = LinearGradient(
  colors: [kPurple, kBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ── Modèles ──
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
}

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
}

class QueueManager {
  static final Map<String, ServiceQueue> services = {
    "Banque":          ServiceQueue(serviceName: "Banque"),
    "Hôpital":         ServiceQueue(serviceName: "Hôpital"),
    "Restaurant":      ServiceQueue(serviceName: "Restaurant"),
    "Administration":  ServiceQueue(serviceName: "Administration"),
  };

  static ServiceQueue getQueue(String service) => services[service]!;
}

// ── GradientButton ──
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: kGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

// ================= APP =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// ================= SPLASH =================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Ton logo
            Image.asset(
              'assets/image/logo.png',
              width: 140,
            ),
            const SizedBox(height: 20),

            // ✅ Texte
            const Text(
              "SMARTQUEUE",
              style: TextStyle(
                fontSize: 34,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= LOGIN =================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //  BOUTON CRÉER COMPTE
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2575FC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= REGISTER PAGE =================
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: const Color(0xFF6A11CB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Nom complet",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Compte créé !")));
                },
                child: const Text(
                  "Créer le compte",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ================= HOME =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selected;

  final List<Map<String, dynamic>> _services = const [
    {"value": "Banque",         "icon": Icons.account_balance_outlined},
    {"value": "Hôpital",        "icon": Icons.local_hospital_outlined},
    {"value": "Restaurant",     "icon": Icons.restaurant_outlined},
    {"value": "Administration", "icon": Icons.business_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
            decoration: const BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number_outlined,
                    color: Colors.white, size: 28),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SmartQueue",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text("Choisissez votre service",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white70),
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const MyApp())),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: _services.map((s) {
                      final sel = _selected == s["value"];
                      return GestureDetector(
                        onTap: () => setState(() => _selected = s["value"]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: sel ? kGradient : null,
                            color: sel ? null : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: sel ? Colors.transparent : Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(s["icon"] as IconData,
                                  size: 32,
                                  color: sel ? Colors.white : kPurple),
                              const SizedBox(height: 8),
                              Text(s["value"] as String,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: sel ? Colors.white : const Color(0xFF333333))),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  GradientButton(
                    label: "Prendre un ticket",
                    icon: Icons.confirmation_number_outlined,
                    onPressed: _selected == null
                        ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Veuillez choisir un service")),
                      );
                    }
                        : () {
                      final queue = QueueManager.getQueue(_selected!);
                      final ticket = queue.addTicket();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TakeTicketPage(
                              ticket: ticket, queue: queue),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= TAKE TICKET =================
class TakeTicketPage extends StatelessWidget {
  final Ticket ticket;
  final ServiceQueue queue;

  const TakeTicketPage({
    super.key,
    required this.ticket,
    required this.queue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50, left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Text("Ticket généré !",
                          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: kPurple.withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: kGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(ticket.service,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 20),
                        const Text("Votre numéro",
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => kGradient.createShader(bounds),
                          child: Text(
                            "#${ticket.number.toString().padLeft(3, '0')}",
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.orange.shade700),
                              const SizedBox(width: 6),
                              Text("En attente",
                                  style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: "Suivre mon ticket",
                    icon: Icons.track_changes_outlined,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackingPage(ticket: ticket, queue: queue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.home_outlined, color: kPurple),
                      label: const Text("Retour à l'accueil",
                          style: TextStyle(color: kPurple)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kPurple),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () =>
                          Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingPage extends StatefulWidget {
  final Ticket ticket;
  final ServiceQueue queue;

  const TrackingPage({
    super.key,
    required this.ticket,
    required this.queue,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Rafraîchissement toutes les 5 secondes
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int get _myPosition {
    final waiting = widget.queue.tickets
        .where((t) => t.status == TicketStatus.waiting)
        .toList();
    final idx = waiting.indexWhere((t) => t.id == widget.ticket.id);
    return idx == -1 ? 0 : idx;
  }

  int get _totalWaiting =>
      widget.queue.tickets
          .where((t) => t.status == TicketStatus.waiting)
          .length;

  int get _totalServed =>
      widget.queue.tickets
          .where((t) => t.status == TicketStatus.serving ||
          t.status == TicketStatus.done)
          .length;

  int get _estimatedMinutes => _myPosition * 4;

  String get _statusLabel {
    if (widget.ticket.status == TicketStatus.serving) return "C'est votre tour !";
    if (_myPosition == 1) return "Vous êtes prochain";
    if (_myPosition == 0 && widget.ticket.status == TicketStatus.waiting) return "En attente";
    return "En attente";
  }

  Color get _statusColor {
    if (widget.ticket.status == TicketStatus.serving) return Colors.green;
    if (_myPosition <= 1) return Colors.orange;
    return kPurple;
  }

  @override
  Widget build(BuildContext context) {
    final pos = _myPosition;
    final total = widget.queue.tickets.length;
    final progress = total > 0 ? _totalServed / total : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // ── Header dégradé ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Suivi de ticket",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),
                // Carte ticket principal
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      // Numéro
                      Text(
                        "#${widget.ticket.number.toString().padLeft(3, '0')}",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.ticket.service,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _statusLabel,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ETA
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Temps estimé",
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 11)),
                          Text(
                            pos == 0
                                ? "Votre tour !"
                                : "~$_estimatedMinutes min",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Notification ──
                  if (widget.ticket.status != TicketStatus.done)
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEDFE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: kPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              pos == 0
                                  ? "C'est votre tour ! Rendez-vous au guichet."
                                  : pos == 1
                                  ? "Vous êtes prochain — approchez-vous !"
                                  : "$pos personne(s) avant vous — préparez vos documents",
                              style: const TextStyle(
                                  color: Color(0xFF3C3489), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Métriques ──
                  const Text("Vue d'ensemble",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MetricCard(
                        value: "${widget.queue.tickets.length}",
                        label: "Total file",
                        color: kPurple,
                      ),
                      const SizedBox(width: 10),
                      _MetricCard(
                        value: "$pos",
                        label: "Avant moi",
                        color: const Color(0xFFBA7517),
                      ),
                      const SizedBox(width: 10),
                      _MetricCard(
                        value: "$_totalServed",
                        label: "Servis",
                        color: const Color(0xFF1D9E75),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Barre de progression ──
                  const Text("Ma position",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Position ${_totalServed + pos + 1} / $total",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            Text(
                              "Guichet ${widget.queue.tickets.indexWhere((t) => t.status == TicketStatus.serving) % 3 + 1}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                kPurple),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Début",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            Text("Ma position",
                                style: TextStyle(
                                    fontSize: 11, color: kPurple)),
                            Text("Fin",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Liste de la file ──
                  const Text("File d'attente",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: widget.queue.tickets
                          .asMap()
                          .entries
                          .map((entry) {
                        final t = entry.value;
                        final isMe = t.id == widget.ticket.id;
                        return _QueueRow(
                          ticket: t,
                          isMe: isMe,
                          isLast: entry.key ==
                              widget.queue.tickets.length - 1,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Bouton retour accueil ──
                  GradientButton(
                    label: "Retour à l'accueil",
                    icon: Icons.home_outlined,
                    onPressed: () => Navigator.popUntil(
                        context, (route) => route.isFirst),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget carte métrique ──
class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                style:
                const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ── Ligne de la file ──
class _QueueRow extends StatelessWidget {
  final Ticket ticket;
  final bool isMe;
  final bool isLast;

  const _QueueRow({
    required this.ticket,
    required this.isMe,
    required this.isLast,
  });

  Color get _bgColor {
    if (ticket.status == TicketStatus.serving) return const Color(0xFFEEEDFE);
    if (ticket.status == TicketStatus.done) return const Color(0xFFE1F5EE);
    if (isMe) return const Color(0xFFF5F6FA);
    return Colors.white;
  }

  Widget get _badge {
    switch (ticket.status) {
      case TicketStatus.serving:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEDFE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("En cours",
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF534AB7),
                  fontWeight: FontWeight.w500)),
        );
      case TicketStatus.done:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE1F5EE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("Servi",
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF0F6E56),
                  fontWeight: FontWeight.w500)),
        );
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFAEEDA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("Attente",
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF854F0B),
                  fontWeight: FontWeight.w500)),
        );
    }
  }

  Widget get _avatar {
    if (ticket.status == TicketStatus.serving) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          gradient: kGradient,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            "#${ticket.number.toString().padLeft(3, '0')}",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ),
      );
    } else if (ticket.status == TicketStatus.done) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFE1F5EE),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Color(0xFF0F6E56), size: 18),
      );
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          "#${ticket.number.toString().padLeft(3, '0')}",
          style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _bgColor,
        border: isLast
            ? null
            : Border(
            bottom:
            BorderSide(color: Colors.grey.shade200, width: 0.5)),
        borderRadius: isLast
            ? const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16))
            : null,
      ),
      child: Row(
        children: [
          _avatar,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMe ? "Moi — Mon ticket" : "Client #${ticket.number.toString().padLeft(3, '0')}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      isMe ? FontWeight.w600 : FontWeight.normal,
                      color: isMe ? kPurple : Colors.black87),
                ),
                Text(
                  ticket.status == TicketStatus.serving
                      ? "En cours de service"
                      : ticket.status == TicketStatus.done
                      ? "Déjà servi"
                      : isMe
                      ? "Mon ticket"
                      : "En attente",
                  style:
                  const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          _badge,
        ],
      ),
    );
  }
}