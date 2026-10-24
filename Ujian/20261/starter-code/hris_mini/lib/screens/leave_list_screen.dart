import 'package:flutter/material.dart';

import '../models/leave_request.dart';
import '../widgets/leave_card.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  final List<LeaveRequest> _requests = [...mockLeaveRequests];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HRIS — Pengajuan Cuti')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _requests.length,
        itemBuilder: (context, index) => LeaveCard(request: _requests[index]),
      ),
    );
  }
}
