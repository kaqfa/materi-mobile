# API Contract, Remedial Task Tracker (P05)

> **Status:** Kontrak v1.0, 2026-08-08
> **Berlaku untuk:** `06-Starter-Code/p05-api/`
> **Tujuan:** Menetapkan bentuk request/response REST, kode status, dan kebijakan konfigurasi agar mahasiswa, mock fallback, dan server dosen (jika ada) berbicara bahasa yang sama.

## 1. Konfigurasi

| Item | Sumber | Catatan |
|-------------|-----------------------------------------|----------------------------------------------------|
| Base URL | `--dart-define=API_BASE_URL=...` | Kosong -> aplikasi otomatis pakai **mock/fixture**. |
| Token (opt) | `--dart-define=API_TOKEN=...` | Dikirim sebagai header `Authorization: Bearer <token>` saat nilai tersedia. |
| Timeout | `ApiConfig.timeout` (10 dtk default) | Melebihi timeout -> `NetworkError`. |

- **Jangan hardcode** base URL, host, atau token di source maupun dokumentasi.
- `.env.example` hanya placeholder; Flutter membaca nilai lewat `String.fromEnvironment` (compile-time define), bukan file `.env` langsung (lihat catatan di file tersebut).
- Tidak ada credential default. Server/akun menjadi input dosen.

## 2. Endpoint

| Method | Path | Body | Sukses (2xx) | Gagal umum |
|----------|-----------------|---------------------|----------------------|------------------------------|
| `GET` | `/tasks` |, | `200` + array task | `500`/`503` `NetworkError` |
| `POST` | `/tasks` | task object | `201` + task object | `400`/`422` `409` |
| `PATCH` | `/tasks/:id` | task object | `200` + task object | `404` `400`/`422` |
| `DELETE` | `/tasks/:id` |, | `204` (no content) | `404` `403` |

## 3. Bentuk objek `task`

### 3.1 Task (single)

```json
{
 "id": "t01",
 "title": "Complete Math Assignment",
 "description": "Finish calculus homework chapter 4.",
 "due_date": "2026-09-01T00:00:00.000Z",
 "priority": "high",
 "is_completed": false
}
```

| Field | Tipe | Wajib | Catatan |
|-----------------|---------|-------|------------------------------------------------------|
| `id` | string | ya | Client-generated (`task-<epoch>`) bila POST. |
| `title` | string | ya | Minimal 3 karakter (aturan validasi UI). |
| `description` | string | ya | Boleh `""`; tidak null. |
| `due_date` | string | ya | ISO-8601 UTC. |
| `priority` | string | ya | Salah satu: `"low"`, `"medium"`, `"high"`. |
| `is_completed` | boolean | ya | Default `false`. |

### 3.2 List response

Server boleh mengembalikan:

**Bentuk A, array langsung (disarankan):**

```json
[
 { "id": "t01", "...": "..." },
 { "id": "t02", "...": "..." }
]
```

**Bentuk B, dibungkus `data`:**

```json
{ "data": [ { "id": "t01", "...": "..." } ] }
```

`HttpTaskApiClient` mendukung keduanya. Mock memakai Bentuk A.

## 4. Error response

Body error tidak dijamin konsisten lintas server; **klien memetakan dari HTTP status**, bukan mem-parsing body error:

| Status | Subtype `ApiError` | Pesan singkat UI |
|------------|--------------------|----------------------------------------|
| `4xx ≠404` | `ClientError` | Permintaan ditolak server. |
| `404` | `NotFoundError` | Task tidak ditemukan. |
| `5xx` | `ServerError` | Server bermasalah, coba lagi nanti. |
| timeout/socket | `NetworkError` | Tidak ada koneksi. |
| JSON invalid | `ParseError` | Data server tidak terbaca. |

## 5. Mock / fixture fallback

- Lokasi fixture: `p05-api/lib/features/tasks/data/remote/fixtures/task_fixtures.dart`.
- `MockTaskApiClient` mengimplementasikan seluruh method `TaskApiClient` terhadap fixture (in-memory store + `simulateNetworkError`).
- Default (`API_BASE_URL` kosong) -> `main.dart` memilih `MockTaskApiClient`. Ini memenuhi acceptance "bisa diuji tanpa server eksternal".
- Mock **tidak** persisten lintas restart (itu domain P04/SQLite). Jangan dianggap bug.

## 6. Catatan keamanan

- Tidak ada token/key/default nyata di repo ini.
- `.env.example` hanya placeholder dokumentasi; jangan mengisinya dengan rahasia lalu commit.
- Token hanya dikirim lewat header saat `API_BASE_URL` terdefinisi.

## 7. Ekstensi di luar scope wajib (opsional, setelah gate lulus)

- `PUT /tasks/:id` vs `PATCH` (saat ini pakai PATCH).
- Pagination, filter server-side, sorting.
- Soft delete (`DELETE` menandai `deleted_at`).
- `POST /tasks/:id/sync` untuk antrian sync offline (dikecualikan dari scope wajib; lihat planning §2).
