# Analisis Penjualan PT Sejahtera Bersama 2020-2021

Proyek Rakamin Virtual Internship Experience x Bank Muamalat (Business Intelligence).

## Isi
- `Rakamin_Intern.sql`: query BigQuery untuk validasi 4 tabel, master table, dan tabel `master_table_geo` untuk peta.

## Alur
1. Validasi jumlah baris tabel customers, orders, products, product_category.
2. Gabungkan keempat tabel menjadi `master_table` (3.339 baris).
3. Tambahkan `cust_state` untuk peta per negara bagian (`master_table_geo`).
4. Visualisasi di Looker Studio.

Dataset: BigQuery `sales_muamalat`.
