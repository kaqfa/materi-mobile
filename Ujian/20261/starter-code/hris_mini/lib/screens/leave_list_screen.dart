import 'package:flutter/material.dart';

import '../models/leave_request.dart';
import '../widgets/empty_state.dart';
import '../widgets/leave_card.dart';
import 'leave_detail_screen.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  final List<LeaveRequest> _requests = [...mockLeaveRequests];

  /// Filter aktif; `null` berarti "Semua".
  LeaveStatus? _statusFilter;
  LeaveType? _typeFilter;

  /// Hasil kombinasi filter status dan tipe (logika AND).
  List<LeaveRequest> get _filteredRequests => _requests
      .where((request) => _statusFilter == null || request.status == _statusFilter)
      .where((request) => _typeFilter == null || request.type == _typeFilter)
      .toList();

  bool get _hasActiveFilter => _statusFilter != null || _typeFilter != null;

  /// Membuka detail dan menangkap keputusan (Setujui/Tolak) yang dikirim
  /// balik lewat nilai balik `Navigator.pop`. `null` berarti user hanya back.
  Future<void> _openDetail(LeaveRequest request) async {
    final decision = await Navigator.push<LeaveStatus>(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveDetailScreen(request: request),
      ),
    );
    if (decision != null) {
      _applyDecision(request.id, decision);
    }
  }

  /// Mengganti pengajuan (dicari berdasarkan [id]) dengan instance baru
  /// bermeta status [status] — model immutable, jadi pakai `copyWith`.
  void _applyDecision(String id, LeaveStatus status) {
    final index = _requests.indexWhere((request) => request.id == id);
    if (index == -1) return;
    setState(() {
      _requests[index] = _requests[index].copyWith(status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HRIS Mini',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            const Text('Pengajuan Cuti'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusFilterRow(),
          const SizedBox(height: 8),
          _buildTypeFilterRow(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              _hasActiveFilter
                  ? '${_filteredRequests.length} dari ${_requests.length} pengajuan'
                  : '${_requests.length} pengajuan',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: _filteredRequests.isEmpty
                ? const EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _filteredRequests.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final request = _filteredRequests[index];
                      return LeaveCard(
                        request: request,
                        onTap: () => _openDetail(request),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Baris chip filter status: "Semua" + semua nilai [LeaveStatus].
  Widget _buildStatusFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Row(
        children: [
          _filterChip(
            label: 'Semua',
            selected: _statusFilter == null,
            onSelected: (_) => setState(() => _statusFilter = null),
          ),
          for (final status in LeaveStatus.values)
            _filterChip(
              label: status.label,
              selected: _statusFilter == status,
              onSelected: (_) => setState(() => _statusFilter = status),
            ),
        ],
      ),
    );
  }

  /// Baris chip filter tipe: "Semua" + semua nilai [LeaveType].
  Widget _buildTypeFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      child: Row(
        children: [
          _filterChip(
            label: 'Semua',
            selected: _typeFilter == null,
            onSelected: (_) => setState(() => _typeFilter = null),
          ),
          for (final type in LeaveType.values)
            _filterChip(
              label: type.label,
              selected: _typeFilter == type,
              onSelected: (_) => setState(() => _typeFilter = type),
            ),
        ],
      ),
    );
  }

  /// Satu [ChoiceChip] filter; chip aktif ditandai `selected` sehingga
  /// terlihat jelas berbeda dari yang tidak aktif.
  Widget _filterChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}
