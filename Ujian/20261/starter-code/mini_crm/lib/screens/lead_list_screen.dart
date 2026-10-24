import 'package:flutter/material.dart';

import '../models/lead.dart';
import '../widgets/lead_card.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final List<Lead> _leads = [...mockLeads];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini CRM — Sales Pipeline')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _leads.length,
        itemBuilder: (context, index) => LeadCard(lead: _leads[index]),
      ),
    );
  }
}
