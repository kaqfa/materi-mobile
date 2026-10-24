/// Model domain HRIS mini (Pengajuan Cuti) — starter UTS 20261.
library;

enum LeaveType {
  annual('Cuti Tahunan'),
  sick('Sakit'),
  unpaid('Tanpa Gaji');

  const LeaveType(this.label);
  final String label;
}

enum LeaveStatus {
  pending('Menunggu'),
  approved('Disetujui'),
  rejected('Ditolak');

  const LeaveStatus(this.label);
  final String label;
}

class LeaveRequest {
  final String id;
  final String employee;
  final LeaveType type;
  final LeaveStatus status;
  final DateTime startDate;
  final DateTime endDate;

  const LeaveRequest({
    required this.id,
    required this.employee,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  LeaveRequest copyWith({LeaveStatus? status}) => LeaveRequest(
        id: id,
        employee: employee,
        type: type,
        status: status ?? this.status,
        startDate: startDate,
        endDate: endDate,
      );
}

final mockLeaveRequests = [
  LeaveRequest(
    id: 'r1',
    employee: 'Budi Santoso',
    type: LeaveType.annual,
    status: LeaveStatus.pending,
    startDate: DateTime(2026, 11, 10),
    endDate: DateTime(2026, 11, 14),
  ),
  LeaveRequest(
    id: 'r2',
    employee: 'Siti Aminah',
    type: LeaveType.sick,
    status: LeaveStatus.approved,
    startDate: DateTime(2026, 10, 20),
    endDate: DateTime(2026, 10, 21),
  ),
  LeaveRequest(
    id: 'r3',
    employee: 'Andi Wijaya',
    type: LeaveType.unpaid,
    status: LeaveStatus.rejected,
    startDate: DateTime(2026, 12, 1),
    endDate: DateTime(2026, 12, 5),
  ),
  LeaveRequest(
    id: 'r4',
    employee: 'Dewi Lestari',
    type: LeaveType.annual,
    status: LeaveStatus.pending,
    startDate: DateTime(2026, 11, 25),
    endDate: DateTime(2026, 11, 28),
  ),
  LeaveRequest(
    id: 'r5',
    employee: 'Rudi Hartono',
    type: LeaveType.annual,
    status: LeaveStatus.approved,
    startDate: DateTime(2026, 12, 15),
    endDate: DateTime(2026, 12, 22),
  ),
  LeaveRequest(
    id: 'r6',
    employee: 'Eko Prasetyo',
    type: LeaveType.sick,
    status: LeaveStatus.pending,
    startDate: DateTime(2026, 11, 5),
    endDate: DateTime(2026, 11, 6),
  ),
  LeaveRequest(
    id: 'r7',
    employee: 'Lina Marlina',
    type: LeaveType.annual,
    status: LeaveStatus.rejected,
    startDate: DateTime(2026, 10, 30),
    endDate: DateTime(2026, 11, 2),
  ),
  LeaveRequest(
    id: 'r8',
    employee: 'Tono',
    type: LeaveType.unpaid,
    status: LeaveStatus.pending,
    startDate: DateTime(2026, 11, 18),
    endDate: DateTime(2026, 11, 20),
  ),
];
