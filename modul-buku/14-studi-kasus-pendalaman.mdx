---
parentBook: 'pemrograman-berorientasi-objek'
chapterNumber: 14
chapterSlug: '14-studi-kasus-pendalaman'
title: 'Studi Kasus & Pendalaman'
description: 'Proyek integrasi komprehensif: transaksi dengan Strategy pattern, stock alert dengan Observer pattern, laporan penjualan dengan collection operations, dan code quality practices'
estimatedReadTime: 100
objectives:
  - 'Mengkonsolidasi seluruh konsep OOP dalam satu proyek terintegrasi'
  - 'Mengimplementasikan transaksi dengan multiple payment method menggunakan Strategy pattern'
  - 'Membangun stock alert system menggunakan Observer pattern'
  - 'Membuat laporan penjualan menggunakan collection operations (filter, group, aggregate)'
  - 'Menerapkan code quality practices: refactoring, naming convention, separation of concerns'
nextChapter: '15-review-persiapan-capstone'
prevChapter: '13-integrasi-gui-database'
status: 'published'
accessLevel: 'free'
---


> **Mata Kuliah:** Pemrograman Berorientasi Objek
> **Minggu:** 14
> **Bagian:** Applied OOP
> **Bahasa:** TypeScript 5.x

---

## Capaian Pembelajaran Modul

Setelah mempelajari modul ini, mahasiswa mampu:
1. Mengkonsolidasi seluruh konsep OOP yang telah dipelajari dalam satu proyek terintegrasi
2. Mengimplementasikan fitur transaksi dengan multiple payment method menggunakan Strategy pattern
3. Mengimplementasikan stock alert system menggunakan Observer pattern
4. Membangun laporan penjualan menggunakan collection operations (filter, group, aggregate)
5. Menerapkan code quality practices: refactoring, naming convention, separation of concerns
6. Membuat manual testing checklist untuk memverifikasi fungsionalitas aplikasi

---

## Prasyarat

- **Modul 01-07:** Fundamental OOP, class, encapsulation, inheritance, polymorphism, abstraction, generics, collections, SOLID principles, design patterns
- **Modul 09:** Database Integration & Error Handling, SQLite, Repository Pattern, custom errors
- **Modul 10:** Service Layer, layered architecture, business logic, dependency injection
- **Modul 11-12:** GUI, HTML/CSS/TS, DOM manipulation, MVC architecture, EventEmitter, Observer
- **Modul 13:** Integrasi GUI + Database, Express API, fetch, async/await, full CRUD end-to-end

---

## Daftar Isi

- [1. Pendahuluan](#1-pendahuluan)
- [2. Landasan Konsep](#2-landasan-konsep)
- [3. Implementasi dalam TypeScript](#3-implementasi-dalam-typescript)
- [4. Perbandingan Lintas Bahasa](#4-perbandingan-lintas-bahasa)
- [5. Studi Kasus: POS System dengan Fitur Lengkap](#5-studi-kasus-pos-system-dengan-fitur-lengkap)
- [6. Kesalahan Umum & Best Practices](#6-kesalahan-umum--best-practices)
- [7. Ringkasan](#7-ringkasan)
- [8. Latihan Mandiri](#8-latihan-mandiri)

---

## 1. Pendahuluan

Selama 13 minggu perjalanan OOP, kalian telah mempelajari konsep-konsep secara bertahap, dari class dasar hingga full-stack architecture. Sekarang saatnya **menggabungkan semuanya** dalam satu studi kasus yang realistis dan kompleks.

Modul ini berbeda dari modul-modul sebelumnya. Di sini tidak ada konsep baru yang fundamental, yang ada adalah **penerapan mendalam** dan **penggabungan** konsep-konsep yang sudah dipelajari. Bayangkan modul sebelumnya sebagai latihan memainkan not-not musik secara terpisah; modul ini adalah saat kalian memainkan **satu lagu utuh**.

Kita akan membangun fitur-fitur kompleks untuk aplikasi Point of Sale (POS) yang sudah dikembangkan di modul 13:

1. **Transaksi dengan multiple payment method**: menerapkan Strategy pattern
2. **Stock alert system**: menerapkan Observer pattern
3. **Laporan penjualan**: menerapkan collection operations secara intensif
4. **Code quality**: refactoring dan best practices

> 💡 **Insight:** Di dunia industri, jarang sekali kita membangun aplikasi dari nol. Yang lebih sering terjadi adalah **menambahkan fitur ke aplikasi yang sudah ada**. Modul ini mensimulasikan pengalaman tersebut, kalian akan *extend* aplikasi minggu 13, bukan memulai dari awal.

---

## 2. Landasan Konsep

### 2.1 Konsolidasi: Peta Design Patterns dalam Aplikasi

Sebelum mulai coding, mari petakan di mana setiap pattern bekerja dalam arsitektur aplikasi kita:

```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION                       │
│  ProductView, CartView, ReportView                  │
│  ← Observer: subscribe ke perubahan data            │
├─────────────────────────────────────────────────────┤
│                   CONTROLLER                         │
│  ProductController, TransactionController           │
│  ← Orchestrate event → service                      │
├─────────────────────────────────────────────────────┤
│                    SERVICE                           │
│  TransactionService, ReportService                  │
│  ← Strategy: payment method selection               │
│  ← Observer: stock alert notification               │
│  ← Factory: receipt generation                      │
├─────────────────────────────────────────────────────┤
│                   REPOSITORY                         │
│  ProductRepository, TransactionRepository           │
│  ← Repository/DAO: data access abstraction          │
├─────────────────────────────────────────────────────┤
│                    DATABASE                           │
│  SQLite (better-sqlite3)                            │
└─────────────────────────────────────────────────────┘
```

### 2.2 Strategy Pattern: Revisited

Strategy pattern memungkinkan kita **memilih algoritma pada runtime** tanpa mengubah kode yang menggunakannya. Dalam konteks POS:

- **Konteks (Context):** `TransactionService`, perlu memproses pembayaran
- **Strategy Interface:** `PaymentStrategy`, kontrak untuk semua metode pembayaran
- **Concrete Strategies:** `CashPayment`, `QRISPayment`, `TransferPayment`

**Mengapa Strategy, bukan if-else?**

```typescript
// ❌ Tanpa Strategy: fragile, melanggar Open/Closed Principle
function processPayment(method: string, amount: number): PaymentResult {
    if (method === "cash") {
        // logika cash...
    } else if (method === "qris") {
        // logika QRIS...
    } else if (method === "transfer") {
        // logika transfer...
    }
    // Setiap payment method baru = modifikasi fungsi ini
}

// ✅ Dengan Strategy: extensible, setiap method terisolasi
const strategy = PaymentStrategyFactory.create(method);
const result = strategy.pay(amount);
// Payment method baru = class baru, TANPA modifikasi kode existing
```

### 2.3 Observer Pattern: Revisited

Observer pattern memungkinkan sebuah object (**subject**) memberitahu daftar object lain (**observers**) secara otomatis saat terjadi perubahan state. Dalam konteks POS:

- **Subject:** `StockManager`, mengelola perubahan stok
- **Observers:**
  - `LowStockAlertObserver`: tampilkan peringatan jika stok di bawah threshold
  - `StockLogObserver`: catat perubahan stok ke log
  - `StockView`: update tampilan stok di UI

```
   StockManager (Subject)
         │
    stock berubah
         │
    ┌────┼────────────┐
    ▼    ▼            ▼
  Alert  Log        View
```

### 2.4 Collection Operations untuk Reporting

Laporan penjualan membutuhkan operasi data yang kompleks. Ini adalah tempat collection operations (`map`, `filter`, `reduce`, `sort`) bersinar:

| Kebutuhan Laporan | Collection Operations |
|---|---|
| Total revenue hari ini | `filter` (by date) → `reduce` (sum amount) |
| Revenue per payment method | `filter` → `reduce` dengan grouping |
| Top 5 produk terlaris | `reduce` (count per product) → `sort` → `slice(0, 5)` |
| Transaksi di atas nominal tertentu | `filter` (by amount threshold) |
| Rata-rata nilai transaksi | `reduce` (sum) / `length` |

### 2.5 Code Quality: Kapan dan Bagaimana Refactor

Refactoring adalah proses **mengubah struktur internal kode tanpa mengubah perilaku eksternalnya**. Tanda-tanda kode perlu di-refactor:

| Code Smell | Indikasi | Solusi |
|---|---|---|
| **Long Method** | Method > 20 baris | Extract ke method kecil |
| **God Class** | Class punya > 5 tanggung jawab | Split ke beberapa class |
| **Duplicate Code** | Logika yang sama di > 1 tempat | Extract ke shared method/class |
| **Magic Numbers** | Angka tanpa penjelasan (`if (stock < 5)`) | Extract ke constant |
| **Deep Nesting** | if di dalam if di dalam if... | Guard clause / early return |
| **Feature Envy** | Method terlalu banyak akses data class lain | Pindahkan method ke class yang tepat |

---

## 3. Implementasi dalam TypeScript

### 3.1 Payment Strategy Implementation

#### Interface dan Tipe Pendukung

```typescript
// types/payment.ts

interface PaymentResult {
    success: boolean;
    transactionId: string;
    method: PaymentMethod;
    amount: number;
    change?: number;       // untuk cash
    reference?: string;    // untuk QRIS/transfer
    timestamp: Date;
}

type PaymentMethod = "cash" | "qris" | "transfer";

interface PaymentStrategy {
    readonly method: PaymentMethod;
    pay(amount: number, received?: number): PaymentResult;
    validate(amount: number, received?: number): void;
}
```

#### Concrete Strategies

```typescript
// services/payment/CashPayment.ts

class CashPayment implements PaymentStrategy {
    readonly method: PaymentMethod = "cash";

    validate(amount: number, received?: number): void {
        if (amount <= 0) {
            throw new ValidationError("Jumlah pembayaran harus lebih dari 0");
        }
        if (received === undefined) {
            throw new ValidationError("Jumlah uang diterima harus diisi untuk pembayaran cash");
        }
        if (received < amount) {
            throw new ValidationError(
                `Uang tidak cukup: diterima Rp${received.toLocaleString()}, ` +
                `dibutuhkan Rp${amount.toLocaleString()}`
            );
        }
    }

    pay(amount: number, received?: number): PaymentResult {
        this.validate(amount, received);

        return {
            success: true,
            transactionId: this.generateId(),
            method: this.method,
            amount,
            change: (received ?? amount) - amount,
            timestamp: new Date(),
        };
    }

    private generateId(): string {
        return `CASH-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    }
}
```

```typescript
// services/payment/QRISPayment.ts

class QRISPayment implements PaymentStrategy {
    readonly method: PaymentMethod = "qris";

    validate(amount: number): void {
        if (amount <= 0) {
            throw new ValidationError("Jumlah pembayaran harus lebih dari 0");
        }
        if (amount > 5_000_000) {
            throw new ValidationError("Pembayaran QRIS maksimal Rp5.000.000");
        }
    }

    pay(amount: number): PaymentResult {
        this.validate(amount);

        return {
            success: true,
            transactionId: this.generateId(),
            method: this.method,
            amount,
            reference: this.generateQRISReference(),
            timestamp: new Date(),
        };
    }

    private generateId(): string {
        return `QRIS-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    }

    private generateQRISReference(): string {
        return `QR-${Date.now()}`;
    }
}
```

```typescript
// services/payment/TransferPayment.ts

class TransferPayment implements PaymentStrategy {
    readonly method: PaymentMethod = "transfer";

    validate(amount: number): void {
        if (amount <= 0) {
            throw new ValidationError("Jumlah pembayaran harus lebih dari 0");
        }
    }

    pay(amount: number): PaymentResult {
        this.validate(amount);

        return {
            success: true,
            transactionId: this.generateId(),
            method: this.method,
            amount,
            reference: this.generateTransferReference(),
            timestamp: new Date(),
        };
    }

    private generateId(): string {
        return `TRF-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    }

    private generateTransferReference(): string {
        return `TRF-REF-${Date.now()}`;
    }
}
```

#### Factory untuk Strategy Selection

```typescript
// services/payment/PaymentStrategyFactory.ts

class PaymentStrategyFactory {
    private static readonly strategies: Map<PaymentMethod, () => PaymentStrategy> = new Map([
        ["cash", () => new CashPayment()],
        ["qris", () => new QRISPayment()],
        ["transfer", () => new TransferPayment()],
    ]);

    static create(method: PaymentMethod): PaymentStrategy {
        const factory = this.strategies.get(method);
        if (!factory) {
            throw new ValidationError(`Payment method tidak dikenal: ${method}`);
        }
        return factory();
    }

    static getAvailableMethods(): PaymentMethod[] {
        return Array.from(this.strategies.keys());
    }
}
```

### 3.2 Shopping Cart Implementation

```typescript
// models/CartItem.ts

interface CartItem {
    product: Product;
    quantity: number;
}

// services/ShoppingCart.ts

class ShoppingCart {
    private items: CartItem[] = [];

    addItem(product: Product, quantity: number): void {
        if (quantity <= 0) {
            throw new ValidationError("Quantity harus lebih dari 0");
        }

        const existing = this.items.find(item => item.product.id === product.id);
        if (existing) {
            existing.quantity += quantity;
        } else {
            this.items.push({ product, quantity });
        }
    }

    removeItem(productId: number): void {
        const index = this.items.findIndex(item => item.product.id === productId);
        if (index === -1) {
            throw new NotFoundError(`Product dengan ID ${productId} tidak ada di cart`);
        }
        this.items.splice(index, 1);
    }

    updateQuantity(productId: number, quantity: number): void {
        if (quantity <= 0) {
            this.removeItem(productId);
            return;
        }

        const item = this.items.find(item => item.product.id === productId);
        if (!item) {
            throw new NotFoundError(`Product dengan ID ${productId} tidak ada di cart`);
        }
        item.quantity = quantity;
    }

    getItems(): ReadonlyArray<CartItem> {
        return [...this.items];
    }

    getTotal(): number {
        return this.items.reduce(
            (sum, item) => sum + item.product.price * item.quantity,
            0
        );
    }

    getItemCount(): number {
        return this.items.reduce((sum, item) => sum + item.quantity, 0);
    }

    clear(): void {
        this.items = [];
    }

    isEmpty(): boolean {
        return this.items.length === 0;
    }
}
```

### 3.3 Observer Pattern: Stock Alert System

#### Generic EventEmitter (dari Modul 12, diperluas)

```typescript
// utils/EventEmitter.ts

type Listener<T> = (data: T) => void;

class EventEmitter<TEvents extends Record<string, unknown>> {
    private listeners = new Map<keyof TEvents, Set<Listener<any>>>();

    on<K extends keyof TEvents>(event: K, listener: Listener<TEvents[K]>): void {
        if (!this.listeners.has(event)) {
            this.listeners.set(event, new Set());
        }
        this.listeners.get(event)!.add(listener);
    }

    off<K extends keyof TEvents>(event: K, listener: Listener<TEvents[K]>): void {
        this.listeners.get(event)?.delete(listener);
    }

    protected emit<K extends keyof TEvents>(event: K, data: TEvents[K]): void {
        this.listeners.get(event)?.forEach(listener => listener(data));
    }
}
```

#### StockManager dengan Events

```typescript
// services/StockManager.ts

interface StockEvents {
    "stock:updated": { productId: number; productName: string; oldStock: number; newStock: number };
    "stock:low": { productId: number; productName: string; currentStock: number; threshold: number };
    "stock:depleted": { productId: number; productName: string };
}

class StockManager extends EventEmitter<StockEvents> {
    private static readonly LOW_STOCK_THRESHOLD = 5;

    constructor(private readonly productRepository: ProductRepository) {
        super();
    }

    updateStock(productId: number, quantitySold: number): void {
        const product = this.productRepository.findById(productId);
        if (!product) {
            throw new NotFoundError(`Product ID ${productId} tidak ditemukan`);
        }

        if (product.stock < quantitySold) {
            throw new ValidationError(
                `Stok tidak cukup untuk "${product.name}": ` +
                `tersisa ${product.stock}, diminta ${quantitySold}`
            );
        }

        const oldStock = product.stock;
        const newStock = oldStock - quantitySold;

        this.productRepository.updateStock(productId, newStock);

        // Emit stock:updated event
        this.emit("stock:updated", {
            productId,
            productName: product.name,
            oldStock,
            newStock,
        });

        // Check low stock threshold
        if (newStock <= StockManager.LOW_STOCK_THRESHOLD && newStock > 0) {
            this.emit("stock:low", {
                productId,
                productName: product.name,
                currentStock: newStock,
                threshold: StockManager.LOW_STOCK_THRESHOLD,
            });
        }

        // Check depleted stock
        if (newStock === 0) {
            this.emit("stock:depleted", {
                productId,
                productName: product.name,
            });
        }
    }
}
```

#### Concrete Observers

```typescript
// observers/LowStockAlertObserver.ts

class LowStockAlertObserver {
    private alerts: Array<{ productName: string; stock: number; timestamp: Date }> = [];

    register(stockManager: StockManager): void {
        stockManager.on("stock:low", (data) => {
            console.warn(
                `⚠ PERINGATAN: Stok "${data.productName}" rendah! ` +
                `Tersisa: ${data.currentStock} (threshold: ${data.threshold})`
            );
            this.alerts.push({
                productName: data.productName,
                stock: data.currentStock,
                timestamp: new Date(),
            });
        });

        stockManager.on("stock:depleted", (data) => {
            console.error(`🚫 HABIS: Stok "${data.productName}" sudah habis!`);
            this.alerts.push({
                productName: data.productName,
                stock: 0,
                timestamp: new Date(),
            });
        });
    }

    getAlerts(): ReadonlyArray<{ productName: string; stock: number; timestamp: Date }> {
        return [...this.alerts];
    }
}
```

```typescript
// observers/StockLogObserver.ts

class StockLogObserver {
    private logs: Array<{ message: string; timestamp: Date }> = [];

    register(stockManager: StockManager): void {
        stockManager.on("stock:updated", (data) => {
            const message = `Stock update: "${data.productName}" ${data.oldStock} → ${data.newStock}`;
            this.logs.push({ message, timestamp: new Date() });
        });
    }

    getLogs(): ReadonlyArray<{ message: string; timestamp: Date }> {
        return [...this.logs];
    }

    getLogsSince(since: Date): ReadonlyArray<{ message: string; timestamp: Date }> {
        return this.logs.filter(log => log.timestamp >= since);
    }
}
```

### 3.4 TransactionService: Menggabungkan Semua Pattern

```typescript
// models/Transaction.ts

interface Transaction {
    id: string;
    items: ReadonlyArray<CartItem>;
    totalAmount: number;
    paymentMethod: PaymentMethod;
    paymentResult: PaymentResult;
    createdAt: Date;
}

// services/TransactionService.ts

class TransactionService {
    constructor(
        private readonly stockManager: StockManager,
        private readonly transactionRepository: TransactionRepository
    ) {}

    checkout(cart: ShoppingCart, method: PaymentMethod, received?: number): Transaction {
        // 1. Validasi cart
        if (cart.isEmpty()) {
            throw new ValidationError("Cart kosong, tidak bisa checkout");
        }

        // 2. Pilih strategy dan proses pembayaran
        const strategy = PaymentStrategyFactory.create(method);
        const totalAmount = cart.getTotal();
        const paymentResult = strategy.pay(totalAmount, received);

        // 3. Update stock via StockManager (triggers observers)
        for (const item of cart.getItems()) {
            this.stockManager.updateStock(item.product.id, item.quantity);
        }

        // 4. Buat dan simpan transaksi
        const transaction: Transaction = {
            id: paymentResult.transactionId,
            items: cart.getItems(),
            totalAmount,
            paymentMethod: method,
            paymentResult,
            createdAt: new Date(),
        };

        this.transactionRepository.save(transaction);

        // 5. Kosongkan cart
        cart.clear();

        return transaction;
    }
}
```

### 3.5 Collection Operations: Sales Report

```typescript
// services/ReportService.ts

interface DailySummary {
    date: string;
    totalTransactions: number;
    totalRevenue: number;
    averageTransactionValue: number;
}

interface RevenueByMethod {
    method: PaymentMethod;
    totalRevenue: number;
    transactionCount: number;
}

interface TopProduct {
    productName: string;
    totalQuantity: number;
    totalRevenue: number;
}

class ReportService {
    constructor(
        private readonly transactionRepository: TransactionRepository
    ) {}

    // --- Total revenue dalam periode tertentu ---
    getTotalRevenue(from: Date, to: Date): number {
        const transactions = this.transactionRepository.findByDateRange(from, to);

        return transactions.reduce((sum, tx) => sum + tx.totalAmount, 0);
    }

    // --- Revenue per payment method ---
    getRevenueByPaymentMethod(from: Date, to: Date): RevenueByMethod[] {
        const transactions = this.transactionRepository.findByDateRange(from, to);

        // Gunakan Map untuk grouping
        const grouped = new Map<PaymentMethod, { revenue: number; count: number }>();

        for (const tx of transactions) {
            const existing = grouped.get(tx.paymentMethod) ?? { revenue: 0, count: 0 };
            grouped.set(tx.paymentMethod, {
                revenue: existing.revenue + tx.totalAmount,
                count: existing.count + 1,
            });
        }

        // Convert Map ke array dan sort descending by revenue
        return Array.from(grouped.entries())
            .map(([method, data]) => ({
                method,
                totalRevenue: data.revenue,
                transactionCount: data.count,
            }))
            .sort((a, b) => b.totalRevenue - a.totalRevenue);
    }

    // --- Top N produk terlaris ---
    getTopSellingProducts(from: Date, to: Date, limit: number = 5): TopProduct[] {
        const transactions = this.transactionRepository.findByDateRange(from, to);

        // Flatten semua items dari semua transaksi, lalu aggregate per produk
        const productSales = new Map<string, { quantity: number; revenue: number }>();

        for (const tx of transactions) {
            for (const item of tx.items) {
                const key = item.product.name;
                const existing = productSales.get(key) ?? { quantity: 0, revenue: 0 };
                productSales.set(key, {
                    quantity: existing.quantity + item.quantity,
                    revenue: existing.revenue + (item.product.price * item.quantity),
                });
            }
        }

        return Array.from(productSales.entries())
            .map(([productName, data]) => ({
                productName,
                totalQuantity: data.quantity,
                totalRevenue: data.revenue,
            }))
            .sort((a, b) => b.totalQuantity - a.totalQuantity)
            .slice(0, limit);
    }

    // --- Ringkasan harian ---
    getDailySummary(from: Date, to: Date): DailySummary[] {
        const transactions = this.transactionRepository.findByDateRange(from, to);

        // Group by tanggal (YYYY-MM-DD)
        const grouped = new Map<string, Transaction[]>();

        for (const tx of transactions) {
            const dateKey = tx.createdAt.toISOString().split("T")[0];
            const existing = grouped.get(dateKey) ?? [];
            existing.push(tx);
            grouped.set(dateKey, existing);
        }

        return Array.from(grouped.entries())
            .map(([date, txList]) => {
                const totalRevenue = txList.reduce((sum, tx) => sum + tx.totalAmount, 0);
                return {
                    date,
                    totalTransactions: txList.length,
                    totalRevenue,
                    averageTransactionValue: totalRevenue / txList.length,
                };
            })
            .sort((a, b) => a.date.localeCompare(b.date));
    }

    // --- Transaksi di atas nominal tertentu ---
    getLargeTransactions(from: Date, to: Date, minAmount: number): Transaction[] {
        const transactions = this.transactionRepository.findByDateRange(from, to);

        return transactions
            .filter(tx => tx.totalAmount >= minAmount)
            .sort((a, b) => b.totalAmount - a.totalAmount);
    }
}
```

### 3.6 Receipt Generation

```typescript
// services/ReceiptGenerator.ts

class ReceiptGenerator {
    static generate(transaction: Transaction): string {
        const lines: string[] = [];

        lines.push("========================================");
        lines.push("           STRUK PEMBELIAN              ");
        lines.push("========================================");
        lines.push(`ID Transaksi : ${transaction.id}`);
        lines.push(`Tanggal      : ${transaction.createdAt.toLocaleString("id-ID")}`);
        lines.push(`Metode Bayar : ${transaction.paymentMethod.toUpperCase()}`);
        lines.push("----------------------------------------");

        for (const item of transaction.items) {
            const subtotal = item.product.price * item.quantity;
            lines.push(`${item.product.name}`);
            lines.push(
                `  ${item.quantity} x Rp${item.product.price.toLocaleString("id-ID")}` +
                `  = Rp${subtotal.toLocaleString("id-ID")}`
            );
        }

        lines.push("----------------------------------------");
        lines.push(`TOTAL: Rp${transaction.totalAmount.toLocaleString("id-ID")}`);

        if (transaction.paymentResult.change !== undefined && transaction.paymentResult.change > 0) {
            const received = transaction.totalAmount + transaction.paymentResult.change;
            lines.push(`Dibayar: Rp${received.toLocaleString("id-ID")}`);
            lines.push(`Kembalian: Rp${transaction.paymentResult.change.toLocaleString("id-ID")}`);
        }

        if (transaction.paymentResult.reference) {
            lines.push(`Referensi: ${transaction.paymentResult.reference}`);
        }

        lines.push("========================================");
        lines.push("          Terima Kasih!                  ");
        lines.push("========================================");

        return lines.join("\n");
    }
}
```

### 3.7 Wiring: Menghubungkan Semua Komponen

```typescript
// main.ts: Bootstrap & Dependency Injection

import Database from "better-sqlite3";

// --- Database setup ---
const db = new Database("pos.db");

// --- Repository layer ---
const productRepository = new ProductRepository(db);
const transactionRepository = new TransactionRepository(db);

// --- Service layer ---
const stockManager = new StockManager(productRepository);
const transactionService = new TransactionService(stockManager, transactionRepository);
const reportService = new ReportService(transactionRepository);

// --- Register observers ---
const lowStockAlert = new LowStockAlertObserver();
lowStockAlert.register(stockManager);

const stockLog = new StockLogObserver();
stockLog.register(stockManager);

// --- Shopping cart (per session) ---
const cart = new ShoppingCart();

// --- Contoh penggunaan ---

// Tambahkan item ke cart
const laptop = productRepository.findById(1)!;
const mouse = productRepository.findById(2)!;

cart.addItem(laptop, 1);
cart.addItem(mouse, 2);

console.log(`Total: Rp${cart.getTotal().toLocaleString("id-ID")}`);

// Checkout dengan QRIS
const transaction = transactionService.checkout(cart, "qris");

// Cetak struk
console.log(ReceiptGenerator.generate(transaction));

// Laporan
const today = new Date();
const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
const topProducts = reportService.getTopSellingProducts(startOfMonth, today);
console.log("Top produk:", topProducts);
```

---

## 4. Perbandingan Lintas Bahasa

### 4.1 Strategy Pattern

| Aspek | TypeScript | Java | Dart |
|-------|-----------|------|------|
| Interface | `interface PaymentStrategy` | `public interface PaymentStrategy` | `abstract class PaymentStrategy` |
| Implement | `class CashPayment implements PaymentStrategy` | `public class CashPayment implements PaymentStrategy` | `class CashPayment implements PaymentStrategy` |
| Factory | `Map<string, () => Strategy>` | `Map<String, Supplier<Strategy>>` | `Map<String, Strategy Function()>` |
| Type union | `type PaymentMethod = "cash" \| "qris"` | `enum PaymentMethod { CASH, QRIS }` | `enum PaymentMethod { cash, qris }` |

```java
// Java: Strategy Pattern
public interface PaymentStrategy {
    PaymentResult pay(double amount);
}

public class CashPayment implements PaymentStrategy {
    @Override
    public PaymentResult pay(double amount) {
        // ...
    }
}

// Factory
PaymentStrategy strategy = PaymentStrategyFactory.create(PaymentMethod.CASH);
PaymentResult result = strategy.pay(totalAmount);
```

```dart
// Dart: Strategy Pattern
abstract class PaymentStrategy {
  PaymentResult pay(double amount);
}

class CashPayment implements PaymentStrategy {
  @override
  PaymentResult pay(double amount) {
    // ...
  }
}

// Factory
final strategy = PaymentStrategyFactory.create(PaymentMethod.cash);
final result = strategy.pay(totalAmount);
```

### 4.2 Observer Pattern

| Aspek | TypeScript | Java | Dart |
|-------|-----------|------|------|
| Subject | `extends EventEmitter<Events>` | `extends Observable` / custom | `StreamController<T>` |
| Subscribe | `subject.on("event", callback)` | `subject.addObserver(observer)` | `stream.listen(callback)` |
| Emit | `this.emit("event", data)` | `notifyObservers(data)` | `sink.add(data)` |
| Unsubscribe | `subject.off("event", callback)` | `subject.removeObserver(observer)` | `subscription.cancel()` |

```dart
// Dart: Observer via Stream (lebih idiomatic di Flutter)
class StockManager {
  final _stockController = StreamController<StockEvent>.broadcast();

  Stream<StockEvent> get onStockChange => _stockController.stream;

  void updateStock(int productId, int quantitySold) {
    // ... update stock ...
    _stockController.add(StockEvent(productId, oldStock, newStock));
  }

  void dispose() {
    _stockController.close();
  }
}

// Subscribe
stockManager.onStockChange
    .where((e) => e.newStock < threshold)
    .listen((e) => print('Low stock alert: ${e.productId}'));
```

### 4.3 Collection Operations untuk Reporting

```typescript
// TypeScript
const topProducts = transactions
    .flatMap(tx => tx.items)
    .reduce((map, item) => {
        const key = item.product.name;
        const prev = map.get(key) ?? 0;
        map.set(key, prev + item.quantity);
        return map;
    }, new Map<string, number>());
```

```java
// Java Streams
Map<String, Long> topProducts = transactions.stream()
    .flatMap(tx -> tx.getItems().stream())
    .collect(Collectors.groupingBy(
        item -> item.getProduct().getName(),
        Collectors.summingLong(CartItem::getQuantity)
    ));
```

```dart
// Dart
final topProducts = <String, int>{};
for (final tx in transactions) {
  for (final item in tx.items) {
    topProducts.update(
      item.product.name,
      (qty) => qty + item.quantity,
      ifAbsent: () => item.quantity,
    );
  }
}
```

---

## 5. Studi Kasus: POS System dengan Fitur Lengkap

### 5.1 Gambaran Proyek

Kita akan meng-extend aplikasi POS dari minggu 13 dengan fitur-fitur berikut:

```
Fitur Baru:
├── 1. Shopping Cart
│   ├── Add item, update quantity, remove item
│   └── Real-time total calculation
├── 2. Checkout dengan Payment Strategy
│   ├── Cash (dengan kembalian)
│   ├── QRIS (dengan limit 5 juta)
│   └── Transfer (dengan nomor referensi)
├── 3. Stock Alert System
│   ├── Low stock warning (threshold: 5)
│   ├── Stock depleted notification
│   └── Stock change log
├── 4. Receipt Generation
│   └── Struk pembelian formatted
└── 5. Sales Report
    ├── Revenue by date range
    ├── Revenue by payment method
    ├── Top selling products
    └── Daily summary
```

### 5.2 Folder Structure

```
src/
├── models/
│   ├── Product.ts
│   ├── CartItem.ts
│   └── Transaction.ts
├── repositories/
│   ├── ProductRepository.ts
│   └── TransactionRepository.ts
├── services/
│   ├── payment/
│   │   ├── PaymentStrategy.ts          # interface
│   │   ├── CashPayment.ts
│   │   ├── QRISPayment.ts
│   │   ├── TransferPayment.ts
│   │   └── PaymentStrategyFactory.ts
│   ├── ShoppingCart.ts
│   ├── StockManager.ts
│   ├── TransactionService.ts
│   ├── ReportService.ts
│   └── ReceiptGenerator.ts
├── observers/
│   ├── LowStockAlertObserver.ts
│   └── StockLogObserver.ts
├── utils/
│   └── EventEmitter.ts
├── errors/
│   ├── ValidationError.ts
│   └── NotFoundError.ts
└── main.ts
```

### 5.3 Database Schema

```sql
-- Extend schema dari modul 13

CREATE TABLE IF NOT EXISTS transactions (
    id TEXT PRIMARY KEY,
    total_amount REAL NOT NULL,
    payment_method TEXT NOT NULL,
    payment_reference TEXT,
    change_amount REAL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS transaction_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id TEXT NOT NULL,
    product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL,
    price REAL NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Index untuk query laporan
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_transactions_payment_method ON transactions(payment_method);
CREATE INDEX IF NOT EXISTS idx_transaction_items_product_id ON transaction_items(product_id);
```

### 5.4 TransactionRepository Implementation

```typescript
// repositories/TransactionRepository.ts

class TransactionRepository {
    constructor(private readonly db: Database.Database) {}

    save(transaction: Transaction): void {
        const insertTransaction = this.db.prepare(`
            INSERT INTO transactions (id, total_amount, payment_method, payment_reference, change_amount, created_at)
            VALUES (?, ?, ?, ?, ?, ?)
        `);

        const insertItem = this.db.prepare(`
            INSERT INTO transaction_items (transaction_id, product_id, product_name, price, quantity)
            VALUES (?, ?, ?, ?, ?)
        `);

        // Gunakan transaction database untuk atomicity
        const saveAll = this.db.transaction(() => {
            insertTransaction.run(
                transaction.id,
                transaction.totalAmount,
                transaction.paymentMethod,
                transaction.paymentResult.reference ?? null,
                transaction.paymentResult.change ?? 0,
                transaction.createdAt.toISOString()
            );

            for (const item of transaction.items) {
                insertItem.run(
                    transaction.id,
                    item.product.id,
                    item.product.name,
                    item.product.price,
                    item.quantity
                );
            }
        });

        saveAll();
    }

    findByDateRange(from: Date, to: Date): Transaction[] {
        const rows = this.db.prepare(`
            SELECT t.*, ti.product_id, ti.product_name, ti.price, ti.quantity
            FROM transactions t
            JOIN transaction_items ti ON t.id = ti.transaction_id
            WHERE t.created_at BETWEEN ? AND ?
            ORDER BY t.created_at DESC
        `).all(from.toISOString(), to.toISOString()) as any[];

        return this.mapRowsToTransactions(rows);
    }

    private mapRowsToTransactions(rows: any[]): Transaction[] {
        const transactionMap = new Map<string, Transaction>();

        for (const row of rows) {
            if (!transactionMap.has(row.id)) {
                transactionMap.set(row.id, {
                    id: row.id,
                    items: [],
                    totalAmount: row.total_amount,
                    paymentMethod: row.payment_method as PaymentMethod,
                    paymentResult: {
                        success: true,
                        transactionId: row.id,
                        method: row.payment_method as PaymentMethod,
                        amount: row.total_amount,
                        change: row.change_amount,
                        reference: row.payment_reference,
                        timestamp: new Date(row.created_at),
                    },
                    createdAt: new Date(row.created_at),
                });
            }

            const tx = transactionMap.get(row.id)!;
            (tx.items as CartItem[]).push({
                product: {
                    id: row.product_id,
                    name: row.product_name,
                    price: row.price,
                    stock: 0, // stock snapshot not stored
                },
                quantity: row.quantity,
            });
        }

        return Array.from(transactionMap.values());
    }
}
```

### 5.5 End-to-End Flow

Berikut alur lengkap saat user melakukan checkout:

```
1. User menambahkan produk ke cart
   → ShoppingCart.addItem(product, qty)

2. User memilih payment method dan checkout
   → TransactionService.checkout(cart, "qris")

3. TransactionService:
   a. Validasi cart tidak kosong
   b. PaymentStrategyFactory.create("qris") → QRISPayment
   c. QRISPayment.pay(totalAmount) → PaymentResult
   d. StockManager.updateStock() untuk setiap item
      → emit "stock:updated"
      → emit "stock:low" jika stok < 5
      → emit "stock:depleted" jika stok = 0
   e. TransactionRepository.save(transaction)
   f. cart.clear()

4. Observers menerima event:
   → LowStockAlertObserver: tampilkan peringatan
   → StockLogObserver: catat ke log

5. ReceiptGenerator.generate(transaction) → struk

6. ReportService: query kapanpun untuk laporan
```

### 5.6 Refactoring Exercise: Before & After

#### Sebelum Refactoring: "God Function"

```typescript
// ❌ SEBELUM: Semua logika di satu fungsi besar
function processOrder(
    productId: number,
    quantity: number,
    paymentMethod: string,
    received: number,
    db: Database.Database
): string {
    // Validasi
    if (quantity <= 0) throw new Error("Invalid quantity");

    // Ambil produk
    const row = db.prepare("SELECT * FROM products WHERE id = ?").get(productId) as any;
    if (!row) throw new Error("Product not found");
    if (row.stock < quantity) throw new Error("Insufficient stock");

    // Hitung total
    const total = row.price * quantity;

    // Proses payment
    let change = 0;
    let reference = "";
    if (paymentMethod === "cash") {
        if (received < total) throw new Error("Insufficient payment");
        change = received - total;
    } else if (paymentMethod === "qris") {
        if (total > 5000000) throw new Error("QRIS limit exceeded");
        reference = `QR-${Date.now()}`;
    } else if (paymentMethod === "transfer") {
        reference = `TRF-${Date.now()}`;
    }

    // Update stock
    db.prepare("UPDATE products SET stock = stock - ? WHERE id = ?").run(quantity, productId);
    const newStock = row.stock - quantity;

    // Alert
    if (newStock < 5) {
        console.log(`WARNING: Low stock for ${row.name}: ${newStock}`);
    }

    // Save transaction
    const txId = `TX-${Date.now()}`;
    db.prepare("INSERT INTO transactions VALUES (?, ?, ?, ?, ?, datetime('now'))").run(
        txId, total, paymentMethod, reference, change
    );
    db.prepare("INSERT INTO transaction_items VALUES (NULL, ?, ?, ?, ?, ?)").run(
        txId, productId, row.name, row.price, quantity
    );

    // Generate receipt
    return `Receipt: ${txId}\n${row.name} x${quantity}\nTotal: ${total}\nChange: ${change}`;
}
```

#### Sesudah Refactoring: Separation of Concerns

```typescript
// ✅ SESUDAH: Setiap class punya tanggung jawab sendiri

// 1. Cart mengelola item
cart.addItem(product, quantity);

// 2. Strategy menangani payment
const strategy = PaymentStrategyFactory.create("cash");
const paymentResult = strategy.pay(cart.getTotal(), received);

// 3. StockManager mengelola stok + emit event
stockManager.updateStock(product.id, quantity);

// 4. Observer bereaksi pada event
lowStockAlert.register(stockManager); // registered sekali saat startup

// 5. Repository menyimpan data
transactionRepository.save(transaction);

// 6. ReceiptGenerator membuat struk
const receipt = ReceiptGenerator.generate(transaction);
```

**Apa yang berubah?**

| Aspek | Sebelum | Sesudah |
|-------|---------|---------|
| Jumlah tanggung jawab per unit | 7+ di 1 fungsi | 1 per class |
| Menambah payment method | Modifikasi fungsi utama | Tambah class baru |
| Menambah observer | Modifikasi fungsi utama | Tambah observer baru |
| Testing | Sangat sulit (perlu DB) | Mudah (mock dependencies) |
| Reusability | Tidak bisa reuse | ShoppingCart bisa dipakai di mana saja |

---

## 6. Kesalahan Umum & Best Practices

### 6.1 Kesalahan Umum

**❌ Strategy yang sebenarnya hanya if-else yang dipindah**

```typescript
// ❌ Strategy terlalu tipis: cuma wrapper if-else
class CashPayment implements PaymentStrategy {
    pay(amount: number): PaymentResult {
        return { success: true, amount }; // tidak ada logic spesifik
    }
}
```

```typescript
// ✅ Strategy punya logic yang benar-benar berbeda
class CashPayment implements PaymentStrategy {
    validate(amount: number, received?: number): void {
        // validasi spesifik cash: uang diterima harus >= amount
    }
    pay(amount: number, received?: number): PaymentResult {
        this.validate(amount, received);
        // hitung kembalian: logic yang hanya ada di cash
        return { success: true, amount, change: received! - amount };
    }
}
```

**❌ Observer yang mengubah state Subject**

```typescript
// ❌ Observer tidak boleh mengubah state subject: bisa infinite loop
stockManager.on("stock:low", (data) => {
    // JANGAN: ini bisa trigger event lagi
    stockManager.updateStock(data.productId, -10); // restock
});
```

```typescript
// ✅ Observer hanya bereaksi, tidak mengubah source
stockManager.on("stock:low", (data) => {
    notificationService.sendAlert(`Restock needed: ${data.productName}`);
    // Restock dilakukan oleh proses terpisah, bukan dari observer
});
```

**❌ Mutable return dari collection method**

```typescript
// ❌ Mengembalikan reference internal: bisa dimodifikasi dari luar
class ShoppingCart {
    getItems(): CartItem[] {
        return this.items; // reference langsung!
    }
}

// Bahaya:
cart.getItems().push(fakeItem); // memodifikasi internal state!
```

```typescript
// ✅ Kembalikan copy atau ReadonlyArray
class ShoppingCart {
    getItems(): ReadonlyArray<CartItem> {
        return [...this.items]; // spread = shallow copy
    }
}
```

**❌ God Service, semua logic di satu service**

```typescript
// ❌ TransactionService melakukan segalanya
class TransactionService {
    checkout() { /* ... */ }
    getTopProducts() { /* ... */ }     // seharusnya di ReportService
    generateReceipt() { /* ... */ }    // seharusnya di ReceiptGenerator
    sendAlert() { /* ... */ }          // seharusnya di Observer
}
```

### 6.2 Best Practices

| Practice | Penjelasan |
|----------|-----------|
| **Satu class, satu tanggung jawab** | `ShoppingCart` hanya mengelola item. `StockManager` hanya mengelola stok. |
| **Depend on abstraction** | `TransactionService` bergantung pada `PaymentStrategy` interface, bukan concrete class. |
| **Immutable returns** | Selalu kembalikan copy atau `ReadonlyArray` dari getter. |
| **Fail fast** | Validasi di awal method, throw error segera jika invalid. |
| **Meaningful error messages** | `"Stok tidak cukup: tersisa 3, diminta 5"` lebih baik dari `"Invalid stock"`. |
| **Constants, bukan magic numbers** | `LOW_STOCK_THRESHOLD = 5` lebih jelas dari `if (stock < 5)`. |

### 6.3 Manual Testing Checklist

Sebelum menganggap fitur selesai, verifikasi semua skenario berikut:

```
Shopping Cart:
☐ Add item - quantity bertambah, total berubah
☐ Add item yang sudah ada - quantity terakumulasi
☐ Remove item - item hilang dari cart
☐ Update quantity ke 0 - item ter-remove
☐ Cart kosong - total = 0, isEmpty = true

Checkout - Cash:
☐ Bayar tepat - kembalian = 0
☐ Bayar lebih - kembalian sesuai
☐ Bayar kurang - error "uang tidak cukup"
☐ Amount negatif - error validasi

Checkout - QRIS:
☐ Normal payment - sukses dengan reference
☐ Amount > 5 juta - error limit
☐ Amount negatif - error validasi

Checkout - Transfer:
☐ Normal payment - sukses dengan reference
☐ Amount negatif - error validasi

Stock:
☐ Stock berkurang setelah checkout
☐ Stock < 5 → low stock alert
☐ Stock = 0 → depleted alert
☐ Stock tidak cukup → error, transaksi batal

Report:
☐ Total revenue sesuai dengan sum transaksi
☐ Revenue by method - jumlah per method benar
☐ Top products - urutan benar
☐ Daily summary - grouping by date benar
☐ Date range filter - hanya transaksi dalam range
```

---

## 7. Ringkasan

### Konsep yang Diterapkan

| Konsep | Penerapan di Studi Kasus |
|--------|-------------------------|
| **Strategy Pattern** | Payment method selection, CashPayment, QRISPayment, TransferPayment |
| **Observer Pattern** | Stock alert system, StockManager emit events ke observers |
| **Factory Pattern** | PaymentStrategyFactory, create strategy berdasarkan method |
| **Repository Pattern** | TransactionRepository, abstraksi akses data transaksi |
| **Encapsulation** | ShoppingCart, private items, public API yang terkontrol |
| **Interface** | PaymentStrategy, kontrak untuk semua payment method |
| **Generics** | EventEmitter&lt;TEvents&gt;, type-safe event system |
| **Collection Operations** | ReportService, filter, reduce, sort, Map untuk aggregasi |
| **Dependency Injection** | Constructor injection di TransactionService, StockManager |
| **Separation of Concerns** | Setiap class punya satu tanggung jawab spesifik |
| **Error Handling** | ValidationError, NotFoundError dengan pesan yang bermakna |

### Arsitektur Akhir

```
User Action → Controller → Service → Repository → Database
                              ↓
                         StockManager
                              ↓ (events)
                    ┌─────────┼──────────┐
                    ▼         ▼          ▼
                 Alert      Log        View
```

### Checklist Kesiapan Capstone

Setelah menyelesaikan modul ini, pastikan kalian sudah menguasai:

- [ ] Bisa membuat class dengan proper encapsulation
- [ ] Bisa membuat hierarki class dengan inheritance
- [ ] Bisa mendefinisikan dan menggunakan interface
- [ ] Bisa menerapkan minimal 3 design patterns
- [ ] Bisa mengintegrasikan dengan database (SQLite)
- [ ] Bisa membangun GUI dengan HTML/CSS/TS
- [ ] Bisa menerapkan layered architecture
- [ ] Bisa menggunakan collection operations untuk reporting

---

## 8. Latihan Mandiri

### Latihan 1: Discount Strategy (Mudah)

Tambahkan sistem diskon menggunakan Strategy pattern:

```typescript
interface DiscountStrategy {
    readonly name: string;
    calculate(totalAmount: number): number; // return discount amount
}

// Implementasikan:
// - NoDiscount: return 0
// - PercentageDiscount(10): return 10% dari total
// - FixedDiscount(50000): return 50000 (atau total jika total < 50000)
// - BuyNGetDiscount: beli 3 gratis 1 (untuk item termurah)
```

Integrasikan ke `TransactionService.checkout()` sehingga discount dihitung sebelum payment.

### Latihan 2: Notification System (Menengah)

Extend Observer pattern untuk mendukung berbagai jenis notifikasi:

```typescript
// Tambahkan observers baru ke StockManager:
// - EmailNotificationObserver: "kirim email" saat stock depleted
// - RestockSuggestionObserver: generate restock suggestion saat stock low
//   (suggest quantity = 2x threshold)

// Tambahkan event baru:
// - "stock:restocked": saat stok ditambah (implement method addStock di StockManager)

// Implementasikan StockManager.addStock(productId, quantity):
// - Update stock di database
// - Emit "stock:restocked" event
// - Emit "stock:updated" event
```

### Latihan 3: Advanced Report (Menengah)

Tambahkan method-method berikut ke `ReportService`:

```typescript
// 1. Perbandingan revenue 2 periode
comparePeriods(period1From: Date, period1To: Date,
               period2From: Date, period2To: Date): {
    period1Revenue: number;
    period2Revenue: number;
    growthPercentage: number;
}

// 2. Produk yang belum pernah terjual
getUnsoldProducts(): Product[]

// 3. Jam sibuk (peak hours)
getPeakHours(from: Date, to: Date): Array<{
    hour: number;          // 0-23
    transactionCount: number;
    revenue: number;
}>
```

### Latihan 4: Full Refactoring Exercise (Sulit)

Diberikan kode "legacy" berikut. Refactor menggunakan semua pattern yang sudah dipelajari:

```typescript
// ❌ KODE LEGACY: Refactor ini!
const db = new Database("store.db");

function handleOrder(req: any) {
    const { products, payment, customerName } = req;
    let total = 0;
    let receipt = `Order for ${customerName}\n`;

    for (const p of products) {
        const row = db.prepare("SELECT * FROM products WHERE id = ?").get(p.id) as any;
        if (!row) { console.log("not found: " + p.id); continue; }
        if (row.stock < p.qty) { console.log("no stock: " + row.name); continue; }

        total += row.price * p.qty;
        receipt += `${row.name} x${p.qty} = ${row.price * p.qty}\n`;

        db.prepare("UPDATE products SET stock = stock - ? WHERE id = ?").run(p.qty, p.id);
        if (row.stock - p.qty < 5) console.log("LOW STOCK: " + row.name);
    }

    if (payment === "cash") {
        receipt += `\nPaid: cash\n`;
    } else if (payment === "qris") {
        if (total > 5000000) { console.log("qris limit!"); return null; }
        receipt += `\nPaid: QRIS ref-${Date.now()}\n`;
    }

    receipt += `Total: ${total}`;
    db.prepare("INSERT INTO orders VALUES (?, ?, ?, datetime('now'))").run(
        "ORD-" + Date.now(), total, payment
    );

    return receipt;
}
```

**Yang harus di-refactor:**
1. Pisahkan ke Model, Repository, Service, Strategy
2. Ganti `console.log` alert dengan Observer pattern
3. Tambahkan proper error handling (custom Error class)
4. Gunakan ShoppingCart alih-alih loop manual
5. Terapkan ReceiptGenerator alih-alih string concatenation
6. Tambahkan manual testing checklist untuk memverifikasi

---

> **Catatan Dosen:** Modul ini dirancang sebagai "dress rehearsal" untuk capstone project. Pastikan mahasiswa benar-benar mengerjakan latihan refactoring (Latihan 4) karena ini melatih kemampuan yang paling dibutuhkan di dunia kerja: membaca kode orang lain, mengidentifikasi masalah, dan memperbaikinya secara sistematis.
