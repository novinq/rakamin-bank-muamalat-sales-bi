# validasi dataset
SELECT 'customers' AS nama_tabel, COUNT(*) AS jumlah_baris
FROM `novi-project-513109.sales_muamalat.customers`
UNION ALL
SELECT 'orders', COUNT(*)
FROM `novi-project-513109.sales_muamalat.orders`
UNION ALL
SELECT 'products', COUNT(*)
FROM `novi-project-513109.sales_muamalat.products`
UNION ALL
SELECT 'product_category', COUNT(*)
FROM `novi-project-513109.sales_muamalat.product_category`;

# uji query tabel master
SELECT
    o.Date                                   AS order_date,
    pc.CategoryName                          AS category_name,
    p.ProdName                               AS product_name,
    p.Price                                  AS product_price,
    o.Quantity                               AS order_qty,
    o.Quantity * p.Price                     AS total_sales,
    SUBSTR(c.CustomerEmail, 1, STRPOS(c.CustomerEmail, '#') - 1) AS cust_email,
    c.CustomerCity                           AS cust_city
FROM `novi-project-513109.sales_muamalat.orders` o
JOIN `novi-project-513109.sales_muamalat.customers` c
    ON o.CustomerID = c.CustomerID
JOIN `novi-project-513109.sales_muamalat.products` p
    ON o.ProdNumber = p.ProdNumber
JOIN `novi-project-513109.sales_muamalat.product_category` pc
    ON p.Category = pc.CategoryID
ORDER BY o.Date ASC, o.Quantity ASC, o.OrderID ASC
LIMIT 10;

# menyimpan sebagai master_table
--- membuat table 
CREATE OR REPLACE TABLE `novi-project-513109.sales_muamalat.master_table` AS
SELECT
    o.Date                                   AS order_date,
    pc.CategoryName                          AS category_name,
    p.ProdName                               AS product_name,
    p.Price                                  AS product_price,
    o.Quantity                               AS order_qty,
    o.Quantity * p.Price                     AS total_sales,
    SUBSTR(c.CustomerEmail, 1, STRPOS(c.CustomerEmail, '#') - 1) AS cust_email,
    c.CustomerCity                           AS cust_city
FROM `novi-project-513109.sales_muamalat.orders` o
JOIN `novi-project-513109.sales_muamalat.customers` c
    ON o.CustomerID = c.CustomerID
JOIN `novi-project-513109.sales_muamalat.products` p
    ON o.ProdNumber = p.ProdNumber
JOIN `novi-project-513109.sales_muamalat.product_category` pc
    ON p.Category = pc.CategoryID
ORDER BY o.Date ASC, o.Quantity ASC, o.OrderID ASC;

--- validasi angka
SELECT
    COUNT(*)                   AS total_transaksi,
    SUM(total_sales)           AS total_sales,
    SUM(order_qty)             AS total_unit,
    COUNT(DISTINCT cust_email) AS pelanggan_unik,
    MIN(order_date)            AS tanggal_awal,
    MAX(order_date)            AS tanggal_akhir
FROM `novi-project-513109.sales_muamalat.master_table`;

--- validasi email bersih
SELECT COUNT(*) AS email_masih_kotor
FROM `novi-project-513109.sales_muamalat.master_table`
WHERE STRPOS(cust_email, '#') > 0;

# ekspor master_table ke format CSV
SELECT *
FROM `novi-project-513109.sales_muamalat.master_table`
ORDER BY order_date ASC, order_qty ASC;

# membuat map chart 
CREATE OR REPLACE TABLE `novi-project-513109.sales_muamalat.master_table_geo` AS
SELECT
  m.*,
  c.CustomerState AS cust_state
FROM `novi-project-513109.sales_muamalat.master_table` AS m
LEFT JOIN `novi-project-513109.sales_muamalat.customers` AS c
  ON m.cust_email = SUBSTR(c.CustomerEmail, 1, STRPOS(c.CustomerEmail, '#') - 1)
ORDER BY m.order_date;

#melihat tampilan tabel
SELECT *
FROM `novi-project-513109.sales_muamalat.master_table_geo`
ORDER BY order_date;