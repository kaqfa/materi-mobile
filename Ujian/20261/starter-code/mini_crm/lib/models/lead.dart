/// Model domain Mini CRM (Sales Pipeline) — starter UTS 20261.
library;

/// Tahapan pipeline penjualan, dari prospek baru sampai closing.
enum LeadStage {
  newLead('Baru'),
  contacted('Dihubungi'),
  qualified('Qualified'),
  closed('Closing');

  const LeadStage(this.label);
  final String label;
}

enum LeadPriority {
  low('Rendah'),
  medium('Sedang'),
  high('Tinggi');

  const LeadPriority(this.label);
  final String label;
}

class Lead {
  final String id;
  final String company;
  final String contact;
  final LeadStage stage;
  final int value; // estimasi nilai kontrak, dalam juta rupiah
  final LeadPriority priority;

  const Lead({
    required this.id,
    required this.company,
    required this.contact,
    this.stage = LeadStage.newLead,
    this.value = 0,
    this.priority = LeadPriority.medium,
  });

  Lead copyWith({LeadStage? stage, LeadPriority? priority}) => Lead(
        id: id,
        company: company,
        contact: contact,
        stage: stage ?? this.stage,
        value: value,
        priority: priority ?? this.priority,
      );
}

const mockLeads = [
  Lead(
    id: 'l1',
    company: 'PT Nusantara Logistik',
    contact: 'Budi Santoso',
    stage: LeadStage.newLead,
    value: 120,
    priority: LeadPriority.high,
  ),
  Lead(
    id: 'l2',
    company: 'CV Mitra Karya',
    contact: 'Siti Aminah',
    stage: LeadStage.contacted,
    value: 45,
    priority: LeadPriority.medium,
  ),
  Lead(
    id: 'l3',
    company: 'PT Global Retail',
    contact: 'Andi Wijaya',
    stage: LeadStage.qualified,
    value: 300,
    priority: LeadPriority.high,
  ),
  Lead(
    id: 'l4',
    company: 'Koperasi Sejahtera',
    contact: 'Dewi Lestari',
    stage: LeadStage.closed,
    value: 80,
    priority: LeadPriority.low,
  ),
  Lead(
    id: 'l5',
    company: 'PT Prima Teknologi',
    contact: 'Rudi Hartono',
    stage: LeadStage.newLead,
    value: 60,
    priority: LeadPriority.low,
  ),
  Lead(
    id: 'l6',
    company: 'CV Karya Bangun',
    contact: 'Eko Prasetyo',
    stage: LeadStage.contacted,
    value: 150,
    priority: LeadPriority.high,
  ),
  Lead(
    id: 'l7',
    company: 'PT Sinar Abadi',
    contact: 'Lina Marlina',
    stage: LeadStage.qualified,
    value: 210,
    priority: LeadPriority.medium,
  ),
  Lead(
    id: 'l8',
    company: 'PT Agro Makmur',
    contact: 'Tono',
    stage: LeadStage.closed,
    value: 95,
    priority: LeadPriority.medium,
  ),
];
