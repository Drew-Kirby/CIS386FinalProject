<?php
// index.php - Clean Air Corp MySQL Demo (PHP) - FINAL PRODUCTION VERSION (All Bugs Fixed)

// 1) Database Connection Details
$servername = "localhost";
$username = "root"; 
$password = "mysql"; // CHANGE THIS if your local MySQL root password is NOT 'mysql'
$dbname = "clean_air_corp"; 

// 2) Connect to MySQL
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("MySQL connection failed: " . $conn->connect_error);
}

// 3) Helper functions (Defined in the code block below)

// 3) Helper to render a generic MySQL result set (only for Q1-Q5 analysis reports)
function renderGenericResultTable($result) {
    if (!$result) {
        return;
    }
    if ($result->num_rows === 0) {
        echo "<p class='no-records'>No records found.</p>";
        return;
    }

    echo "<table>";

    // Header Row
    echo "<thead><tr>";
    $fields = $result->fetch_fields();
    foreach ($fields as $field) {
        echo "<th>" . htmlspecialchars($field->name) . "</th>";
    }
    echo "</tr></thead>";

    // Data Rows
    echo "<tbody>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        foreach ($row as $key => $value) {
            echo "<td>" . htmlspecialchars((string)$value) . "</td>";
        }
        echo "</tr>";
    }
    echo "</tbody>";
    echo "</table>";
}

// 3b) Helper for Home Tab (SELECT * query logic with sorting)
function renderHomeTableWithSorting($conn, $tableName, $orderBy = null, $sortDir = 'ASC') {
    $sql = "SELECT * FROM {$tableName}";
    
    // Add ORDER BY clause if provided, sanitizing input
    if ($orderBy) {
        $orderBySanitized = $conn->real_escape_string($orderBy);
        $sortDirSanitized = ($sortDir === 'DESC') ? 'DESC' : 'ASC';
        $sql .= " ORDER BY {$orderBySanitized} {$sortDirSanitized}";
    }
    
    $result = $conn->query($sql);
    
    if (!$result) {
        echo "<p class='no-records'>Query failed for table {$tableName}: " . $conn->error . "</p>";
        return;
    }

    if ($result->num_rows === 0) {
        echo "<p class='no-records'>No records found.</p>";
        return;
    }

    echo "<table>";

    // Header Row (Now clickable for sorting)
    echo "<thead><tr>";
    $fields = $result->fetch_fields();
    foreach ($fields as $field) {
        $fieldName = htmlspecialchars($field->name);
        $newSortDir = ($orderBy === $field->name && $sortDir === 'ASC') ? 'DESC' : 'ASC';
        $currentAction = $_GET['action'] ?? 'home';
        
        // Link to trigger sort on this column
        echo "<th><a href='?action={$currentAction}&table_view={$tableName}&order_by={$fieldName}&sort_dir={$newSortDir}'>";
        echo $fieldName;
        
        // Display sort indicator
        if ($orderBy === $field->name) {
            echo ($sortDir === 'ASC') ? ' ▲' : ' ▼';
        }
        echo "</a></th>";
    }
    echo "</tr></thead>";

    // Data Rows
    echo "<tbody>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        foreach ($row as $key => $value) {
            echo "<td>" . htmlspecialchars((string)$value) . "</td>";
        }
        echo "</tr>";
    }
    echo "</tbody>";
    echo "</table>";
}


// 4) Configuration for Tables to Display on Home Tab
$home_page_tables = [
    'Product_Detail' => 'Product Inventory/Status',
    'Product_Sales' => 'Sales Transactions',
    'Maintenance_Service' => 'Maintenance Jobs',
    'Shipment' => 'Shipments & Logistics',
    'Customer' => 'Customer List',
    'Employee' => 'Employee List',
    'Vendor' => 'Vendor List'
];

// 5) Which action to run?
$action = $_GET['action'] ?? 'home';

// Get current sorting parameters
$table_to_view = $_GET['table_view'] ?? null;
$order_by = $_GET['order_by'] ?? null;
$sort_dir = $_GET['sort_dir'] ?? 'ASC';

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clean Air Corp - CACMS Portal</title>
    <style>
        /* --- CORE STYLES --- */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa; 
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* --- HEADER / BRANDING (Tri-Mer Style) --- */
        .header {
            background-color: #003366; 
            color: #fff;
            /* FIX: Reduced vertical padding to visually shrink the header */
            padding: 20px 0; 
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            /* Min-height ensures content fits without excessive empty space */
            min-height: 80px; 
            margin-bottom: 20px;
        }
        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo-section {
            display: flex;
            align-items: center;
        }
        .logo-link {
            display: block;
            line-height: 0; 
            margin-right: 15px;
        }
        .app-logo {
            /* FIXED: Logo size to properly fill the header height */
            height: 100px; 
            width: auto;
            vertical-align: middle;
        }
        .tagline {
            font-size: 14px;
            opacity: 0.8;
            font-style: italic;
            margin-left: 20px;
            padding-left: 20px;
            border-left: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        /* --- NAVIGATION --- */
        .portal-nav {
            margin-bottom: 20px;
            background-color: #fff;
            border-bottom: 1px solid #ccc;
        }
        .nav-links {
            display: flex;
            /* FIXED: Allow wrapping and ensure space */
            flex-wrap: wrap; 
            padding-left: 0;
            list-style: none;
            border-radius: 4px;
        }
        .nav-links a {
            display: block;
            padding: 12px 10px; /* FIXED: Reduced horizontal padding slightly */
            margin-right: 5px;  /* FIXED: Added explicit margin-right for separation */
            text-decoration: none;
            background: #fff;
            color: #333;
            border: 1px solid transparent;
            border-radius: 0;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s;
        }
        /* FIXED: Removed the border-right on all but last child as it was confusing layout */
        .nav-links a:hover {
            background: #f0f0f0;
            color: #003366;
        }
        .nav-links a.active {
            color: #003366;
            background-color: #e9ecef; 
            border-bottom: 3px solid #007bff; 
            margin-bottom: -1px; 
        }
        
        /* --- MAIN CONTENT CARD --- */
        .content-card {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-top: 20px;
        }
        h2 {
            color: #003366;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
            margin-top: 0;
        }
        /* --- COLLAPSIBLE / TABLE STYLING --- */
        .collapsible-header {
            background-color: #f0f0f0; 
            color: #333;
            cursor: pointer;
            padding: 15px;
            width: 100%;
            border: 1px solid #ddd;
            text-align: left;
            font-size: 16px;
            transition: background-color 0.3s;
            border-radius: 4px;
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
        }
        .collapsible-header:hover {
            background-color: #e5e5e5;
        }
        .active-collapsible {
            background-color: #e9ecef;
            border-bottom: none;
            border-bottom-left-radius: 0;
            border-bottom-right-radius: 0;
        }
        .table-content {
            padding: 0 18px;
            overflow: hidden;
            background-color: #fff;
            max-height: 0; 
            transition: max-height 0.3s ease-in-out;
            border: 1px solid #ddd;
            border-top: none;
            border-bottom-left-radius: 4px;
            border-bottom-right-radius: 4px;
        }
        
        table {
            border-collapse: collapse;
            margin: 15px 0;
            width: 100%;
            border: 1px solid #ccc;  /* outer border */
        }
        th, td {
            border: 1px solid #ccc;  /* inner grid lines */
        }

        th {
            background: #007bff; 
            color: #fff;
            font-weight: 600;
        }
        td {
            font-size: 13px;
        }

        th a {
            color: #fff;
            text-decoration: none;
            display: block;
        }
        
        .code {
            font-family: Consolas, monospace;
            background: #212529; 
            color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            font-size: 13px;
        }
        .no-records {
            color: #dc3545;
            font-style: italic;
            font-weight: 600;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo-section">
            <a href="?action=home" class="logo-link">
                <img src="logo.png" alt="Clean Air Corp Logo" class="app-logo">
            </a>
            <span class="tagline">Pioneering Industrial Emission Control Systems</span>
        </div>
        <div>
            <span class="tagline">CACMS Portal | User: System Admin</span>
        </div>
    </div>
</header>

<div class="portal-nav">
    <div class="container">
        <nav class="nav-links">
            <a href="?action=home" class="<?php echo $action === 'home' ? 'active' : ''; ?>">Data Hub</a>
            <a href="?action=products_in_stock" class="<?php echo $action === 'products_in_stock' ? 'active' : ''; ?>">In Stock Report</a>
            <a href="?action=sales_per_customer" class="<?php echo $action === 'sales_per_customer' ? 'active' : ''; ?>">Sales by Customer</a>
            <a href="?action=sales_by_employee" class="<?php echo $action === 'sales_by_employee' ? 'active' : ''; ?>">Sales by Employee</a>
            <a href="?action=maintenance_by_employee" class="<?php echo $action === 'maintenance_by_employee' ? 'active' : ''; ?>">Maintenance by Employee</a>
            <a href="?action=shipments_feb_range" class="<?php echo $action === 'shipments_feb_range' ? 'active' : ''; ?>">Feb Shipments</a>
        </nav>
    </div>
</div>

<div class="container">
    <div class="content-card">
        <?php

        // --- HOME PAGE (DATA HUB) ---
        if ($action === 'home') {
            ?>
            <h2>🏠 CACMS Data Hub: View Core Tables</h2>
            <p>Select a table below to view its raw data. Click on any column header to sort the data based on that column. Note: Only one table can be expanded at a time to keep the view clean.</p>
            
            <?php
            // Loop through all tables and create a collapsible section for each
            foreach ($home_page_tables as $tableName => $description) {
                // Determine if this is the currently expanded table (for sorting)
                $is_expanded = ($table_to_view === $tableName);
                
                // If it's the expanded table, determine the sorting parameters
                $current_order_by = $is_expanded ? $order_by : null;
                $current_sort_dir = $is_expanded ? $sort_dir : 'ASC';

                echo "<button type='button' class='collapsible-header' onclick='toggleCollapse(\"content-{$tableName}\", \"{$tableName}\")'>";
                echo "<span>📊 {$tableName} — {$description}</span>";
                echo "<span>" . ($is_expanded ? '▼ Hide' : '▲ Show') . "</span>";
                echo "</button>";
                
                // The max-height is always 0 here; JS handles the initial expansion
                echo "<div id='content-{$tableName}' class='table-content'>"; 
                
                // Render the table data (with sorting links integrated into headers)
                renderHomeTableWithSorting($conn, $tableName, $current_order_by, $current_sort_dir);

                echo "</div>";
            }
        }

        // --- Q1: Products In Stock ---
        if ($action === 'products_in_stock') {
            echo "<h2>Q1: Products Currently In Stock</h2>";
            $sql = "SELECT product_num, unit_info, unit_status FROM Product_Detail WHERE unit_status = 'In Stock' ORDER BY product_num ASC";
            echo "<div class='code'>" . htmlspecialchars($sql) . "</div>";
            
            $result = $conn->query($sql);
            if ($result) {
                renderGenericResultTable($result);
            } else {
                echo "<p class='no-records'>Query failed: " . $conn->error . "</p>";
            }
        }

        // --- Q2: Sales Per Customer (aggregation/GROUP BY) ---
        if ($action === 'sales_per_customer') {
            echo "<h2>Q2: Number of Sales Per Customer</h2>";
            $sql = "SELECT customer_id, COUNT(*) AS total_sales FROM Product_Sales GROUP BY customer_id ORDER BY total_sales DESC";
            echo "<div class='code'>" . htmlspecialchars($sql) . "</div>";
            
            $result = $conn->query($sql);
            if ($result) {
                renderGenericResultTable($result);
            } else {
                echo "<p class='no-records'>Query failed: " . $conn->error . "</p>";
            }
        }

        // --- Q3: Sales by specific employee ---
        if ($action === 'sales_by_employee') {
            echo "<h2>Q3: Sales by Employee SSN 100000005</h2>";
            $sql = "SELECT sale_id, product_num, customer_id, date FROM Product_Sales WHERE eSSN = '100000005' ORDER BY date ASC";
            echo "<div class='code'>" . htmlspecialchars($sql) . "</div>";
            
            $result = $conn->query($sql);
            if ($result) {
                renderGenericResultTable($result);
            } else {
                echo "<p class='no-records'>Query failed: " . $conn->error . "</p>";
            }
        }

        // --- Q4: Maintenance jobs by specific employee ---
        if ($action === 'maintenance_by_employee') {
            echo "<h2>Q4: Maintenance Jobs by Employee SSN 100000016</h2>";
            $sql = "SELECT job_num, date, job_type, product_num FROM Maintenance_Service WHERE eSSN = '100000016' ORDER BY date ASC";
            echo "<div class='code'>" . htmlspecialchars($sql) . "</div>";
            
            $result = $conn->query($sql);
            if ($result) {
                renderGenericResultTable($result);
            } else {
                echo "<p class='no-records'>Query failed: " . $conn->error . "</p>";
            }
        }

        // --- Q5: Shipments in a date range ---
        if ($action === 'shipments_feb_range') {
            echo "<h2>Q5: Shipments with ETA Between 2025-02-15 and 2025-02-28</h2>";
            $sql = "SELECT order_id, customer, address, ETA FROM Shipment WHERE ETA >= '2025-02-15' AND ETA <= '2025-02-28' ORDER BY ETA ASC";
            echo "<div class='code'>" . htmlspecialchars($sql) . "</div>";
            
            $result = $conn->query($sql);
            if ($result) {
                renderGenericResultTable($result);
            } else {
                echo "<p class='no-records'>Query failed: " . $conn->error . "</p>";
            }
        }

        // Close connection before end of script
        $conn->close();
        ?>
    </div>
</div>

<script>
    // JavaScript for Collapsible Functionality
    function toggleCollapse(contentId, tableName) {
        let content = document.getElementById(contentId);
        let button = content.previousElementSibling;
        
        // --- 1. Collapse all others ---
        document.querySelectorAll('.table-content').forEach(otherContent => {
            if (otherContent.id !== contentId) {
                otherContent.style.maxHeight = null;
                otherContent.previousElementSibling.classList.remove('active-collapsible');
                otherContent.previousElementSibling.querySelector('span:last-child').innerHTML = '▲ Show';
            }
        });

        // --- 2. Toggle current section ---
        if (content.style.maxHeight && content.style.maxHeight !== '0px') {
            // Collapse
            content.style.maxHeight = null;
            button.classList.remove('active-collapsible');
            button.querySelector('span:last-child').innerHTML = '▲ Show';
            
            // Clear the table_view query parameter when collapsing
            let url = new URL(window.location.href);
            url.searchParams.delete('table_view');
            url.searchParams.delete('order_by');
            url.searchParams.delete('sort_dir');
            window.history.pushState({}, '', url);

        } else {
            // Expand
            // Must calculate the scroll height dynamically
            // FIX: Recalculate scrollHeight right before setting max-height
            // NOTE: We MUST ensure the content is fully rendered first, which is why the timeout is essential for expansion.
            
            // Temporarily set height to auto to measure actual scrollHeight
            content.style.maxHeight = 'auto'; 
            const scrollHeight = content.scrollHeight;
            
            // Set back to 0 before setting final height (needed for CSS transition)
            content.style.maxHeight = '0px'; 
            
            // Forced repaint to ensure transition works from 0
            void content.offsetHeight; 

            content.style.maxHeight = scrollHeight + 50 + "px"; // Add buffer
            
            button.classList.add('active-collapsible');
            button.querySelector('span:last-child').innerHTML = '▼ Hide';

            // Add the table_view query parameter when expanding
            let url = new URL(window.location.href);
            url.searchParams.set('table_view', tableName);
            
            // We only need to set the URL parameter if it was a manual click, not if it was triggered by sorting (which already has the parameters).
        }
    }
    
    // Auto-expand the correct table on load and after sorting
    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const tableView = urlParams.get('table_view');
        
        // FIX: Ensure all tables start collapsed by explicitly setting max-height to 0
        document.querySelectorAll('.table-content').forEach(content => {
            content.style.maxHeight = '0';
        });

        if (tableView) {
            const contentId = `content-${tableView}`;
            const content = document.getElementById(contentId);
            
            if (content) {
                // The delay is mandatory for sorting to work, allowing PHP-rendered table data to populate before measuring.
                setTimeout(() => {
                    // FIX: Ensure the max-height is calculated based on scrollHeight, and add buffer
                    if (content.scrollHeight > 0) {
                         // Add a buffer (50px) to ensure no scroll bars appear inside the collapsible section
                         content.style.maxHeight = content.scrollHeight + 50 + "px"; 
                    } else {
                         // Fallback for tables with tiny content
                         content.style.maxHeight = "500px"; 
                    }
                    
                    content.previousElementSibling.classList.add('active-collapsible');
                    content.previousElementSibling.querySelector('span:last-child').innerHTML = '▼ Hide';
                }, 50); // 50ms delay is sufficient to fix render calculation errors
            }
        }
    });
</script>

</body>
</html>