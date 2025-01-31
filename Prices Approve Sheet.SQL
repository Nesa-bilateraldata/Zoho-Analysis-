SELECT
		 "Sales Persons"."Name" AS "Sales Person",
		 "Sales Orders"."Order Date" AS "Order Date",
		 "Sales Orders"."Sales Order#" AS "Order Number",
		 "Branch"."Branch Name" AS "Branch Name",
		 "Sales Orders"."Reference Number" AS "PO",
		 "Sales Orders"."Delivery Method" AS "Delivery Method",
		 "Sales Orders"."Payment Terms Label" AS "term",
		 "Customers"."Customer Name" AS "customer name",
		 "Customers"."Claim category" AS "Claim category",
		 "Items"."Item Name" AS "Item Name",
		 "Items"."Product Category" AS "Product Category",
		 "Items"."Category Group" AS "Category Group",
		 "Item MRP"."MRP" AS "MRP-2",
		 "Items"."MRP" AS "MRP",
		 "Item MRP"."MRP_Without_Tax" AS "MRP_Without_Tax",
		 COALESCE("Item MRP"."MRP_Without_Tax", 0) * COALESCE("Sales Order Items"."Quantity", 0) * COALESCE(CASE
				 WHEN "Item MRP"."Category"  = 'MAC' THEN "Customer Claim Excel"."MAC %"


				 ELSE 0
			 END, 0) / 100 AS discount_price,
		 COALESCE(CASE
				 WHEN "Item MRP"."Category"  = 'MAC' THEN "Customer Claim Excel"."MAC %"
				 ELSE NULL
			 END, 0) AS discount_Percentageq,
		 COALESCE("Items"."MRP" * 100 / 118, 0) AS "MRP Without Tax",
		 COALESCE("Items"."MRP" * 100 / 118 * "Sales Order Items"."Quantity", 0) AS "Base Margin-F",
		 COALESCE(CASE
				 WHEN "Items"."Category Group"  = 'Mac' THEN "Customers"."MAC %"
				 ELSE NULL
			 END, 0) AS discount_percentage,
		 (COALESCE("Items"."MRP" * 100 / 118, 0) * COALESCE(CASE
				 WHEN "Items"."Category Group"  = 'Mac' THEN "Customers"."MAC %"
				 ELSE NULL
			 END, 0) / 100) AS discount,
		 COALESCE(CASE
				 WHEN "Item MRP"."Category"  = 'MAC' THEN "Customer Claim Excel"."MAC %"
				 ELSE NULL
			 END, 0) AS discount_percenftae,
		 "Sales Order Items"."Quantity" AS "Quantity",
		 "Sales Order Items"."Sub Total (BCY)" AS "Sales Prices",
		 "Sales Orders"."Sub Total (BCY)" AS "Sales Prices2",
		 COALESCE(CASE
				 WHEN MONTH("Sales Orders"."Order Date")  = 12
				 AND	"Purchase Info"."Price Per Unit DEC"  > 1 THEN "Purchase Info"."Price Per Unit DEC"
				 WHEN MONTH("Sales Orders"."Order Date")  = 12
				 AND	"Purchase Info"."Price Per Unit NOV"  > 1 THEN "Purchase Info"."Price Per Unit NOV"
				 WHEN MONTH("Sales Orders"."Order Date")  = 12
				 AND	"Purchase Info"."Price Per Unit JAN"  > 1 THEN "Purchase Info"."Price Per Unit JAN"
				 WHEN MONTH("Sales Orders"."Order Date")  = 1
				 AND	"Purchase Info"."Price Per Unit DEC"  > 1 THEN "Purchase Info"."Price Per Unit DEC"
				 WHEN MONTH("Sales Orders"."Order Date")  = 1
				 AND	"Purchase Info"."Price Per Unit DEC"  = 1 THEN "Last Purchase Prices"."SubQuery.Unit Price"
				 ELSE "Items"."Purchase Price"
			 END, "Items"."Purchase Price") AS "Purchase Amount",
		 "Price Negotiation"."Back End Amount" AS "Back End Amount",
		 COALESCE("Price Negotiation"."Back End Amount", 0) AS "Bank End",
		 
			CASE
				 WHEN ROW_NUMBER() OVER(PARTITION BY "Sales Orders"."Sales Order#"  ORDER BY "Sales Order Items"."Item Name" )  = 1 THEN COALESCE("Price Negotiation"."Back End Amount", 0)
				 ELSE 0
			 END AS BackEND,
		 COALESCE("Price Negotiation"."Purchase Price  Adjustments", 0) AS "Purchase Price Adjustments",
		 "Price Negotiation"."Other Comment" AS "Purchase Comment",
		 COALESCE("Admin Invoice Approval"."Approval Status", 'Pending') AS "Approval Status",
		 "Admin Invoice Approval"."Comment" AS "Comment",
		 "Sales Orders"."Customer ID" AS "Customer ID"
FROM  "Sales Orders"
LEFT JOIN "Sales Order Items" ON "Sales Order Items"."Sales order ID"  = "Sales Orders"."Sales order ID" 
LEFT JOIN "Branch" ON "Branch"."Branch ID"  = "Sales Orders"."Branch ID" 
LEFT JOIN "Admin Invoice Approval" ON "Admin Invoice Approval"."Sales Order No"  = "Sales Orders"."Sales order ID" 
LEFT JOIN "Price Negotiation" ON "Price Negotiation"."Sales Order No"  = "Sales Orders"."Sales order ID" 
LEFT JOIN "Customers" ON "Customers"."Customer ID"  = "Sales Orders"."Customer ID" 
LEFT JOIN "Sales Persons" ON "Sales Persons"."Sales Person ID"  = "Sales Orders"."Sales Person ID" 
LEFT JOIN "Purchase Info" ON "Purchase Info"."Product ID"  = "Sales Order Items"."Product ID" 
LEFT JOIN "Items" ON "Items"."Item ID"  = "Sales Order Items"."Product ID" 
LEFT JOIN "Last Purchase Prices" ON "Last Purchase Prices"."SubQuery.Item Name"  = "Sales Order Items"."Item Name" 
LEFT JOIN "Item MRP" ON "Items"."SKU"  = "Item MRP"."SKU" 
LEFT JOIN "Customer Claim Excel" ON "Customers"."Company Name"  = "Customer Claim Excel"."Company Name"  
