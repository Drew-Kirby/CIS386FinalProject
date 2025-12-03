USE clean_air_corp;

-- Q1: For each customer, how many sales has Clean Air Corp completed?
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(ps.sale_id) AS total_sales
FROM Customer c, Product_Sales ps
WHERE c.customer_id = ps.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_sales DESC, c.customer_name;

-- Q2: For each product, how many times has it been sold?
SELECT
    pd.product_num,
    pd.unit_info,
    COUNT(ps.sale_id) AS times_sold
FROM Product_Detail pd, Product_Sales ps
WHERE pd.product_num = ps.product_num
GROUP BY pd.product_num, pd.unit_info
ORDER BY times_sold DESC, pd.product_num;

-- Q3: For each employee, how many sales have they completed?
SELECT
    e.ssn,
    e.name,
    COUNT(ps.sale_id) AS sales_count
FROM Employee e, Product_Sales ps
WHERE e.ssn = ps.eSSN
GROUP BY e.ssn, e.name
ORDER BY sales_count DESC, e.name;

-- Q4: For each employee, how many maintenance jobs have they handled?
SELECT
    e.ssn,
    e.name,
    COUNT(ms.job_num) AS maintenance_jobs
FROM Employee e, Maintenance_Service ms
WHERE e.ssn = ms.eSSN
GROUP BY e.ssn, e.name
ORDER BY maintenance_jobs DESC, e.name;

-- Q5: For each vendor, how many different products has Clean Air Corp purchased?
SELECT
    v.vendor_id,
    v.vendor_name,
    COUNT(DISTINCT p.product_number) AS product_count
FROM Vendor v, Purchasing p
WHERE v.vendor_id = p.vendor_id
GROUP BY v.vendor_id, v.vendor_name
ORDER BY product_count DESC, v.vendor_name;

-- Q6: For each department, how many employees are in that department?
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.ssn) AS employee_count
FROM Department d, Employee e
WHERE d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC, d.dept_id;

-- Q7: For each product, what is the date of its most recent maintenance job?
SELECT
    pd.product_num,
    pd.unit_info,
    (
        SELECT MAX(ms.date)
        FROM Maintenance_Service ms
        WHERE ms.product_num = pd.product_num
    ) AS last_maintenance_date
FROM Product_Detail pd
ORDER BY last_maintenance_date DESC, pd.product_num;

-- Q8: List all shipments in February 2025 with order id, customer name, shipping address, and ETA.
SELECT
    s.order_id,
    s.customer,
    s.address,
    s.ETA
FROM Shipment s
WHERE s.ETA BETWEEN '2025-02-01' AND '2025-02-28'
ORDER BY s.ETA, s.order_id;

-- Q9: List all sales together with their shipment order id and ETA.
SELECT
    ps.sale_id,
    ps.date       AS sale_date,
    s.order_id,
    s.ETA         AS shipment_eta
FROM Product_Sales ps, Shipment s
WHERE ps.sale_id = s.sale_id
ORDER BY ps.sale_id;

-- Q10: For each customer, what is the date of their most recent sale?
SELECT
    c.customer_id,
    c.customer_name,
    (
        SELECT MAX(ps.date)
        FROM Product_Sales ps
        WHERE ps.customer_id = c.customer_id
    ) AS last_sale_date
FROM Customer c
ORDER BY last_sale_date DESC, c.customer_name;