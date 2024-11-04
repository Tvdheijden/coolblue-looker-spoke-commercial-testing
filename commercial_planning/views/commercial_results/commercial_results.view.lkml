# General information on this view
view: commercial_results {
  sql_table_name: `coolblue-operations-prod.category_mgmt.staging_commercial_results_final`
    ;;
  fields_hidden_by_default: yes

#----------- Dimensions --------------#

# First define a primary key so that the view van be joined correctly.
# Concat is used to create a unique value per row in the Commercial Results BigQuery table
  dimension: primary_key {
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.date, '-', ${TABLE}.subsidiaryid, '-', ${TABLE}.region, '-',
      ${TABLE}.customertype, '-', ${TABLE}.outlettype, '-', ${TABLE}.delivery_flow, '-',
      ${TABLE}.is_second_chance, '-', ${TABLE}.delivery_proposition, '-', ${TABLE}.productid) ;;
    primary_key: yes
  }

# Basic properties
  dimension: brand {
    hidden: no
    description: "The brand of the product. Example: Apple"
    label: "Brand"
    group_label: "Brand"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: samsung_brand_group {
    hidden: yes
    description: "Indicates whether the brand is Samsung or not"
    label: "Samsung Brand Group"
    group_label: "Brand"
    view_label: "Product dimensions"
    type: string
    sql: CASE WHEN ${TABLE}.brand = "Samsung" THEN "Samsung" ELSE "Other brands" END ;;
  }

  dimension: apple_brand_group {
    hidden: yes
    description: "Indicates whether the brand is Apple or not"
    label: "Apple Brand Group"
    group_label: "Brand"
    view_label: "Product dimensions"
    type: string
    sql: CASE WHEN ${TABLE}.brand = "Apple" THEN TRUE ELSE FALSE END ;;
  }

  dimension: customertype {
    hidden: no
    description: "Type of customer that placed an order. Example: B2B"
    label: "Customer type"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.customertype ;;
  }

  dimension: is_second_chance {
    hidden: no
    description: "Product was sold as a second chance product or not"
    label: "Second chance"
    view_label: "Product details"
    type: yesno
    sql: ${TABLE}.is_second_chance ;;
  }

  dimension_group: date {
    hidden: no
    description: "Invoice date"
    label: "Invoice"
    view_label: "Invoice date"
    type: time
    timeframes: [
      date,
      week,
      week_of_year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      month,
      month_name,
      month_num,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: isoyear {
    hidden: no
    description: "Invoice date"
    label: "Year ISO"
    view_label: "Invoice date"
    group_label: "ISO Week"
    type: number
    value_format: "####"
    sql: EXTRACT(ISOYEAR FROM ${TABLE}.date) ;;
  }

  dimension: isoweek {
    hidden: no
    description: "Invoice date"
    label: "Week ISO"
    view_label: "Invoice date"
    group_label: "ISO Week"
    type: number
    sql: EXTRACT(ISOWEEK FROM ${TABLE}.date) ;;
  }

  dimension: weeknumber_weekday_combination {
    hidden: no
    description: "Invoice date"
    label: "Weeknumber - weekday"
    view_label: "Invoice date"
    group_label: "Invoice date - Custom"
    type: string
    sql: CONCAT("w",(EXTRACT(ISOWEEK FROM ${TABLE}.date)), ' - ', FORMAT_DATE('%a', ${TABLE}.date)) ;;
  }

  dimension_group: first_day_of_quarter {
    hidden: yes
    type: time
    sql: ${TABLE}.first_day_of_quarter ;;
  }

  dimension: outlettype {
    hidden: no
    description: "Indication whether an order is a store order (including pick-ups) or website order. Example: Store"
    label: "Order type"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.outlettype ;;
  }

  dimension: producttype {
    hidden: no
    description: "Example: laptops"
    label: "Product Type"
    group_label: "Product Type"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.producttype ;;
  }

  dimension: producttypeid {
    hidden: yes
    description: "Example: 17632"
    label: "Product Type ID"
    group_label: "Product Type"
    view_label: "Product dimensions"
    type: number
    value_format_name: id
    sql: ${TABLE}.producttypeid ;;
  }

  dimension: focus_producttype {
    hidden: no
    description: "Indicates whether a target is set on this producttype or not"
    label: "Is Focustype"
    group_label: "Product Type"
    view_label: "Product dimensions"
    type: yesno
    sql: ${TABLE}.focus_producttype ;;
  }

  dimension: product {
    hidden: no
    description: "Example: Apple iPhone 13 mini 128GB Zwart"
    label: "Product Name"
    group_label: "Product"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: productid {
    hidden: no
    description: "Example: 891989"
    label: "Product ID"
    group_label: "Product"
    view_label: "Product dimensions"
    type: number
    value_format_name: id
    sql: ${TABLE}.productid ;;
  }

  dimension: region {
    hidden: no
    description: "The region from the postal code of an order. Example: Flanders"
    label: "Region"
    group_label: "Geography"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: subproducttype {
    hidden: no
    description: "Example: Windows laptops QWERTY"
    label: "Subproduct Type"
    group_label: "Subproduct Type"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.subproducttype ;;
  }

  dimension: subproducttypeid {
    hidden: yes
    description: "Example: 3486"
    label: "Subproduct Type ID"
    group_label: "Subproduct Type"
    view_label: "Product dimensions"
    type: number
    value_format_name: id
    sql: ${TABLE}.subproducttypeid ;;
  }

  dimension: subsidiary {
    hidden: no
    description: "The entity where an order is placed to. Example: Coolblue B.V."
    label: "Subsidiary"
    group_label: "Geography"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.subsidiary ;;
  }

  dimension: subsidiary_country {
    hidden: no
    description: "The country where an order is placed in. Example: Belgium"
    label: "Country"
    group_label: "Geography"
    view_label: "Order details"
    type: string
    sql: CASE WHEN ${subsidiaryid}=1 THEN 'Netherlands' WHEN ${subsidiaryid}=3 THEN 'Belgium' WHEN ${subsidiaryid}=5 THEN 'Germany' END  ;;
  }

  dimension: subsidiary_group {
    hidden: yes
    description: "Groups Netherlands and Belgium together"
    label: "Subsidiary Grouped"
    group_label: "Subsidiary"
    view_label: "Order details"
    type: string
    sql: CASE WHEN ${subsidiaryid}=1 OR ${subsidiaryid}=3 THEN 'Total NL & BE' ELSE 'Other' END ;;
  }

  dimension: subsidiaryid {
    hidden: yes
    description: "Example: 3"
    label: "Subsidiary ID"
    group_label: "Subsidiary"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.subsidiaryid ;;
  }

  dimension: team {
    hidden: no
    description: "Example: Team Laptops, Desktops & Accessoires"
    label: "Team"
    group_label: "Team"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.team ;;
  }

  dimension: team_shortened {
    hidden: no
    description: "Example: Laptops, Desktops & Accessoires"
    label: "Short team name"
    group_label: "Team"
    view_label: "Product dimensions"
    type: string
    sql: REPLACE(${team}, 'Team ', '') ;;
  }

  dimension: teamid {
    hidden: yes
    description: "Example: 2043"
    label: "Team ID"
    group_label: "Team"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.teamid ;;
  }

  dimension: customer_journey {
    hidden: no
    description: "Example: White Goods"
    label: "Customer journey"
    group_label: "Team"
    view_label: "Product dimensions"
    type:  string
    sql:
    CASE
      WHEN ${TABLE}.teamid IN (3043, 1043) THEN 'White Goods'
      WHEN ${TABLE}.teamid = 2044 OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (2027)) THEN 'Televisions'
      WHEN ${TABLE}.teamid = 2043 OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (17631, 2071, 17632, 2621, 2456, 2080, 2694)) THEN 'Laptops'
      WHEN ${TABLE}.teamid IN (43, 10045) OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (2291, 18132, 2340, 13362, 22737, 2292)) THEN 'Home Office'
      WHEN ${TABLE}.teamid IN (4, 5044, 41, 10046) THEN 'Small domestic appliances'
      WHEN ${TABLE}.teamid = 2045 OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (2093, 22845, 2458, 2587, 2094, 14408, 41350, 2101, 2785, 14707, 2430, 24037, 39650, 2341, 2453)) THEN 'Phones & Tablets'
      WHEN ${TABLE}.teamid IN (3, 5) OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (37349, 12216, 2365, 2077, 2069)) THEN 'Audio & Cameras'
      WHEN ${TABLE}.teamid IN (6044, 5043, 2046) OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (2234, 19732, 2415)) THEN 'Other'
      WHEN ${TABLE}.teamid = 4043 OR (${TABLE}.teamid = 8045 AND ${TABLE}.producttypeid IN (24137, 5626)) THEN 'Wearables'
      WHEN ${TABLE}.teamid = 2 THEN 'Solar'
      ELSE 'Non Cat-Teams'
    END ;;
  }

  dimension: delivery_flow {
    hidden: no
    description: "The delivery method with which an order is sent to the customer. Example: CoolblueDelivers"
    label: "Delivery Flow"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.delivery_flow ;;
  }

  dimension: delivery_proposition {
    hidden: yes
    description: "The delivery proposition with which an order is sent to the customer. Example: Store region"
    label: "Delivery proposition"
    view_label: "Order details"
    type: string
    sql: ${TABLE}.delivery_proposition ;;
  }

# Transaction Margin table - product level information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden
  dimension: product_margin_incl_ssa {
    hidden: yes
    type: number
    sql: ${TABLE}.product_margin_incl_ssa ;;
  }

  dimension: product_margin_excl_media_fee {
    hidden: yes
    type: number
    sql: SAFE_SUBTRACT(${TABLE}.product_margin_incl_ssa,${TABLE}.media_fee) ;;
  }

  dimension: products_sold {
    hidden: yes
    type: number
    sql: ${TABLE}.products_sold ;;
  }

  dimension: sales {
    hidden: yes
    type: number
    sql: ${TABLE}.sales ;;
  }

  dimension: store_products_sold {
    hidden: yes
    type: number
    sql: ${TABLE}.store_products_sold ;;
  }

  dimension: store_sales {
    hidden: yes
    type: number
    sql: ${TABLE}.store_sales ;;
  }

# Transaction Margin table - primary product level information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden

  dimension: attached_margin_incl_ssa {
    hidden: yes
    type: number
    sql: ${TABLE}.attached_margin_incl_ssa ;;
  }

  dimension: attached_margin_incl_ssa_consumer {
    hidden: yes
    type: number
    sql: ${TABLE}.attached_margin_incl_ssa_consumer ;;
  }

  dimension: direct_fixed_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_cost ;;
  }

  dimension: direct_fixed_customer_service_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_customer_service_cost ;;
  }

  dimension: direct_fixed_returns_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_returns_cost ;;
  }

  dimension: direct_fixed_shipment_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_shipment_cost ;;
  }

  dimension: direct_fixed_store_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_store_cost ;;
  }

  dimension: direct_fixed_warehouse_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_warehouse_cost ;;
  }

  dimension: invoice_variable_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.invoice_variable_cost ;;
  }

  dimension: orders {
    hidden: yes
    type: number
    sql: ${TABLE}.orders ;;
  }

  dimension: orders_b2b {
    hidden: yes
    type: number
    sql: ${TABLE}.orders_b2b ;;
  }

  dimension: orders_consumer {
    hidden: yes
    type: number
    sql: ${TABLE}.orders_consumer ;;
  }

  dimension: primary_margin_incl_ssa {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_margin_incl_ssa ;;
  }

  dimension: primary_sales {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_sales ;;
  }

  dimension: attached_sales {
    hidden: yes
    type: number
    sql: ${TABLE}.attached_sales ;;
  }

  dimension: primary_products_sold {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_products_sold ;;
  }

  dimension: attached_products_sold {
    hidden: yes
    type: number
    sql: ${TABLE}.attached_products_sold ;;
  }

  dimension: products_sold_as_attached {
    hidden: yes
    type: number
    sql: ${TABLE}.products_sold_as_attached ;;
  }

  dimension: transaction_margin {
    hidden: yes
    type: number
    sql: ${TABLE}.transaction_margin ;;
  }

  dimension: variable_customer_service_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_customer_service_cost ;;
  }

  dimension: variable_payment_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_payment_cost ;;
  }

  dimension: variable_returns_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_returns_cost ;;
  }

  dimension: variable_shipment_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_shipment_cost ;;
  }

  dimension: variable_store_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_store_cost ;;
  }

  dimension: variable_warehouse_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_warehouse_cost ;;
  }

  dimension: variable_writeoff_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.variable_writeoff_cost ;;
  }

# Staffing cost information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden
  dimension: staffing_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.staffing_cost ;;
  }

# Target setting information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden
  dimension: additional_marketing_income_target {
    hidden: yes
    type: number
    sql: ${TABLE}.additional_marketing_income_target ;;
  }

  dimension: attached_margin_incl_ssa_target {
    hidden: yes
    type: number
    sql: ${TABLE}.attached_margin_incl_ssa_target ;;
  }

  dimension: attached_product_margin_incl_ssa_consumer_target {
    hidden: yes
    type: number
    sql: ${TABLE}.attached_product_margin_incl_ssa_consumer_target ;;
  }

  dimension: category_contribution_target {
    hidden: yes
    type: number
    sql: ${TABLE}.category_contribution_target ;;
  }

  dimension: direct_fixed_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.direct_fixed_cost_target ;;
  }

  dimension: gross_profit_impact_target {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_profit_impact_target ;;
  }

  dimension: invoice_product_margin_incl_ssa_target {
    hidden: yes
    type: number
    sql: ${TABLE}.invoice_product_margin_incl_ssa_target ;;
  }

  dimension: invoice_variable_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.invoice_variable_cost_target ;;
  }

  dimension: orders_consumer_target {
    hidden: yes
    type: number
    sql: ${TABLE}.orders_consumer_target ;;
  }

  dimension: orders_target {
    hidden: yes
    type: number
    sql: ${TABLE}.orders_target ;;
  }

  dimension: percentage_consumer {
    hidden: yes
    type: number
    sql: ${TABLE}.percentage_consumer ;;
  }

  dimension: percentage_wallonia {
    hidden: yes
    type: number
    sql: ${TABLE}.percentage_wallonia ;;
  }

  dimension: primary_product_margin_incl_ssa_target {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_product_margin_incl_ssa_target ;;
  }

  dimension: primary_sales_target {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_sales_target ;;
  }

  dimension: products_sold_target {
    hidden: yes
    type: number
    sql: ${TABLE}.products_sold_target ;;
  }

  dimension: sales_marketing_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.sales_marketing_cost_target ;;
  }

  dimension: sales_target {
    hidden: yes
    type: number
    sql: ${TABLE}.sales_target ;;
  }

  dimension: staffing_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.staffing_cost_target ;;
  }

  dimension: store_products_sold_target {
    hidden: yes
    type: number
    sql: ${TABLE}.store_products_sold_target ;;
  }

  dimension: store_sales_target {
    hidden: yes
    type: number
    sql: ${TABLE}.store_sales_target ;;
  }

  dimension: transaction_margin_target {
    hidden: yes
    type: number
    sql: ${TABLE}.transaction_margin_target ;;
  }

  dimension: visibility_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.visibility_cost_target ;;
  }

# Marketing cost information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden
  dimension: adwords_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.adwords_cost ;;
  }

  dimension: affiliate_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.affiliate_cost ;;
  }

  dimension: display_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.display_cost ;;
  }

  dimension: price_comparison_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.price_comparison_cost ;;
  }

  dimension: retargeting_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.retargeting_cost ;;
  }

  dimension: sales_marketing_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.sales_marketing_cost ;;
  }

  dimension: partner_marketing_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.partner_marketing_cost ;;
  }

  dimension: social_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.social_cost ;;
  }

  dimension: video_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.video_cost ;;
  }

  dimension: visibility_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.visibility_cost ;;
  }

  dimension: visibility_cost_distributed {
    hidden: yes
    type: number
    sql: ${TABLE}.visibility_cost_distributed ;;
  }

# Media income information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden
  dimension: additional_marketing_income_fixed_amount {
    hidden: yes
    type: number
    sql: ${TABLE}.additional_marketing_income_fixed_amount ;;
  }

  dimension: additional_marketing_income_fixed_amount_de {
    hidden: yes
    type: number
    sql: ${TABLE}.additional_marketing_income_fixed_amount_DE ;;
  }

# Impact information - Dimensions needed to create measures
# These columns are measures in the source table, and thus hidden
  dimension: category_contribution {
    hidden: yes
    type: number
    sql: ${TABLE}.category_contribution ;;
  }

  dimension: category_contribution_distributed {
    hidden: yes
    type: number
    sql: ${TABLE}.category_contribution_distributed ;;
  }

  dimension: gross_profit_impact {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_profit_impact ;;
  }

  dimension: gross_profit_impact_distributed {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_profit_impact_distributed ;;
  }

#----------- Measures --------------#

# Transaction Margin table - product level information
  measure: total_products_sold {
    hidden: no
    description: "Number of sold products, based on all products in orders"
    label: "Sold Product Quantity"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${products_sold} ;;
  }

  measure: total_store_products_sold {
    hidden: yes
    description: "Number of sold products in store, based on all products in orders"
    label: "Store Sold Product Quantity"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${store_products_sold} ;;
  }

  measure: total_sales {
    hidden: no
    description: "Sales in euros, based on all products in orders, excluding VAT"
    label: "Sales"
    group_label: "Sales metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    type: sum
    sql: ${sales} ;;
  }

  measure: total_store_sales {
    hidden: yes
    description: "Sales in store in euros, based on all products in orders, excluding VAT"
    label: "Store Sales"
    group_label: "Sales metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${store_sales} ;;
  }

  measure: average_sales_price {
    hidden: no
    description: "Sales divided by sold product quantity"
    view_label: "Metrics - Sales & Transaction Margin"
    label: "Average Sales Price"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${total_sales},${total_products_sold}) ;;
  }

  measure: total_product_margin {
    hidden: no
    description: "Product Margin including all subsequent agreements."
    label: "Product Margin incl. SAs"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: product_margin_per_order {
    hidden: no
    description: "Product Margin including all subsequent agreements divided by the number of orders."
    label: "Product Margin incl. SAs per Order"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_product_margin}, ${total_orders}) ;;
  }

  measure: product_margin_perc {
    hidden: no
    label: "Product Margin incl. SAs as % of Sales"
    description: "Product margin divided by the amount of sales"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_product_margin},${total_sales}) ;;
  }

  measure: total_product_margin_excl_media_fee {
    hidden: no
    description: "Product Margin excluding media fee."
    label: "Product Margin excl. media fee"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${product_margin_excl_media_fee} ;;
  }

  measure: product_margin_excl_media_fee_perc {
    hidden: no
    label: "Product Margin excl. media fee as % of Sales"
    description: "Product margin excl. media fee divided by the amount of sales"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_product_margin_excl_media_fee},${total_sales}) ;;
  }

# Transaction Margin table - primary product level information
  measure: total_transaction_margin {
    hidden: no
    description: "Total transaction margin, based on the primary products in orders"
    label: "Transaction Margin"
    group_label: "Transaction Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_per_order {
    hidden: no
    description: "Transaction margin divided by the number of orders"
    label: "Transaction Margin per Order"
    group_label: "Transaction Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_transaction_margin}, ${total_orders}) ;;
  }

  measure: transaction_margin_percentage_of_sales {
    hidden: no
    description: "Transaction margin divided by the total amount of sales on order-level (excluding VAT)"
    label: "Transaction Margin as % of Sales"
    group_label: "Transaction Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_transaction_margin}, ${total_orderlevel_sales}) ;;
  }

  measure: total_primary_sales {
    hidden: no
    description: "Sales in euros, based on the primary products in orders, excluding VAT"
    label: "Primary Sales"
    group_label: "Sales metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${primary_sales} ;;
  }

  measure: total_attached_sales {
    hidden: no
    description: "Sales in euros, based on the attached products in orders, excluding VAT"
    label: "Attached Sales"
    group_label: "Sales metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${attached_sales} ;;
  }

  measure: total_orderlevel_sales {
    hidden: no
    description: "Sales in euros, based on the primary + attached products in orders, excluding VAT"
    label: "Order-level Sales"
    group_label: "Sales metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: IFNULL(${primary_sales},0) + IFNULL(${attached_sales},0) ;;
  }

  measure: total_primary_margin_incl_ssa {
    hidden: no
    description: "Margin for the primary products of orders, including all subsequent agreements"
    label: "Primary Margin"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_per_order {
    hidden: no
    description: "Margin for the primary products of orders divided by the number of orders"
    label: "Primary Margin per Order"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_primary_margin_incl_ssa}, ${total_orders}) ;;
  }

  measure: primary_margin_percentage_of_sales {
    hidden: no
    description: "Margin for the primary products of orders divided by the amount of primary sales"
    label: "Primary Margin as % of Sales"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_primary_margin_incl_ssa}, ${total_primary_sales}) ;;
  }

  measure: total_attached_margin_incl_ssa {
    hidden: no
    description: "Margin for the attached products of orders, including all subsequent agreements"
    label: "Attached Margin"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_per_order {
    hidden: no
    description: "Margin for the attached products of orders divided by the number of orders"
    label: "Attached Margin per Order"
    group_label: "Margin metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_attached_margin_incl_ssa}, ${total_orders}) ;;
  }

  measure: total_invoice_variable_cost {
    hidden: no
    description: "Sum of all types of variable costs"
    label: "Variable Costs"
    group_label: "Variable Costs metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_costs_per_order {
    hidden: no
    description: "Sum of all variable costs divided by the number of orders"
    label: "Variable Costs per Order"
    group_label: "Variable Costs metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_invoice_variable_cost}, ${total_orders}) ;;
  }

  measure: total_orders {
    description: "Number of orders based on the first invoice data of an order"
    view_label: "Metrics - Sales & Transaction Margin"
    hidden: no
    type: sum
    value_format: "#,##0"
    sql: ${orders} ;;
  }

  measure: total_primary_products_sold {
    hidden: no
    description: "Number of products sold, based on the primary products in orders."
    label: "Primary Products Sold"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${primary_products_sold} ;;
  }

  measure: total_attached_products_sold {
    hidden: no
    description: "Number of products sold, based on the attached products in orders."
    label: "Attached Products Sold"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${attached_products_sold} ;;
  }

  measure: total_products_sold_as_attached {
    hidden: no
    description: "Number of times the products is sold as attached."
    label: "Products Sold as Attached"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Sales & Transaction Margin"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${products_sold_as_attached} ;;
  }

# Staffing cost information
  measure: total_staffing_cost {
    hidden: no
    description: "Total staffing cost for P&L creation"
    label: "Staffing Cost"
    group_label: "Category Contribution metrics"
    view_label: "Metrics - Profitability"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${staffing_cost} ;;
  }

# Target setting information
  measure: total_products_sold_target {
    hidden: no
    description: "Target number of sold products, based on all products in orders"
    label: "Sold Product Quantity Target"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${products_sold_target} ;;
  }

  measure: total_store_products_sold_target {
    hidden: no
    description: "Target number of sold products in store, based on all products in orders"
    label: "Store Sold Product Quantity Target"
    group_label: "Sold Product Quantity metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${store_products_sold_target} ;;
  }

  measure: total_sales_target {
    hidden: no
    description: "Target sales in euros, based on all products in orders, excluding VAT"
    label: "Sales Target"
    group_label: "Sales metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${sales_target} ;;
  }

  measure: target_average_sales_price {
    hidden: no
    description: "Target sales excl. VAT divided by the number of sold products"
    label: "Average Sales Price Target"
    group_label: "Sales metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_sales_target},${total_products_sold_target}) ;;
  }

  measure: total_store_sales_target {
    hidden: no
    description: "Target sales in store in euros, based on all products in orders, excluding VAT"
    label: "Store Sales Target"
    group_label: "Sales metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${store_sales_target} ;;
  }

  measure: total_transaction_margin_target {
    hidden: no
    description: "Target transaction margin, based on the primary products in orders"
    label: "Transaction Margin Target"
    group_label: "Transaction Margin metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${transaction_margin_target} ;;
  }

  measure: target_transaction_margin_per_order {
    hidden: no
    description: "Target transaction margin divided by the target number of orders"
    label: "Transaction Margin per Order Target"
    group_label: "Transaction Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_transaction_margin_target}, ${total_orders_target}) ;;
  }

  measure: target_transaction_margin_percentage_of_sales {
    hidden: no
    description: "Target transaction margin divided by the target amount of sales (excluding VAT)"
    label: "Transaction Margin as % of Sales Target"
    group_label: "Transaction Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_transaction_margin_target}, ${total_sales_target}) ;;
  }

  measure: total_primary_sales_target {
    hidden: no
    description: "Target sales in euros, based on the primary products in orders, excluding VAT"
    label: "Primary Sales Target"
    group_label: "Sales metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${primary_sales_target} ;;
  }

  measure: total_primary_margin_incl_ssa_target {
    hidden: no
    description: "Target margin for the primary products of orders, including all subsequent agreements"
    label: "Primary Margin Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${primary_product_margin_incl_ssa_target} ;;
  }

  measure: total_invoice_product_margin_incl_ssa_target {
    hidden: no
    description: "Target margin for the products of orders, including all subsequent agreements"
    label: "Product Margin Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: target_product_margin_incl_ssa_per_order {
    hidden: no
    description: "Target margin for the products of orders, including all subsequent agreements, divided by the target number of orders"
    label: "Product Margin per Order Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_invoice_product_margin_incl_ssa_target}, ${total_orders_target}) ;;
  }

  measure: target_primary_margin_per_order {
    hidden: no
    description: "Target margin for the primary products of orders divided by the target number of orders"
    label: "Primary Margin per Order Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_primary_margin_incl_ssa_target}, ${total_orders_target}) ;;
  }

  measure: target_product_margin_percentage_of_sales {
    hidden: no
    description: "Target margin for the products divided by the target amount of sales"
    label: "Product Margin as % of Sales Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_invoice_product_margin_incl_ssa_target}, ${total_sales_target}) ;;
  }

  measure: target_primary_margin_percentage_of_sales {
    hidden: no
    description: "Target margin for the primary products of orders divided by the target amount of primary sales"
    label: "Primary Margin as % of Sales Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_primary_margin_incl_ssa_target}, ${total_primary_sales_target}) ;;
  }

  measure: total_attached_margin_incl_ssa_target {
    hidden: no
    description: "Target margin for the attached products of orders, including all subsequent agreements"
    label: "Attached Margin Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${attached_margin_incl_ssa_target} ;;
  }

  measure: target_attached_margin_per_order {
    hidden: no
    description: "Target margin for the attached products of orders divided by the target number of orders"
    label: "Attached Margin per Order Target"
    group_label: "Margin metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_attached_margin_incl_ssa_target}, ${total_orders_target}) ;;
  }

  measure: total_invoice_variable_cost_target {
    hidden: no
    description: "Target sum of all types of variable costs"
    label: "Variable Costs Target"
    group_label: "Variable Costs metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${invoice_variable_cost_target} ;;
  }

  measure: target_variable_costs_per_order {
    hidden: no
    description: "Target sum of all variable costs divided by the target number of orders"
    label: "Variable Costs per Order Target"
    group_label: "Variable Costs metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_invoice_variable_cost_target}, ${total_orders_target}) ;;
  }

  measure: total_orders_target {
    description: "Target number of orders"
    label: "Orders Target"
    view_label: "Metrics - Targets"
    hidden: no
    type: sum
    value_format: "[>=1000000]0.00,,\"M\";[>=10000]0,\"K\";0"
    sql: ${orders_target} ;;
  }

  measure: total_sales_marketing_cost_target {
    hidden: no
    description: "Target sum of sales marketing cost, excluding visibility goals and offline channels"
    label: "Sales Marketing Costs Target"
    group_label: "Marketing metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${sales_marketing_cost_target} ;;
  }

  measure: target_sales_marketing_cost_per_order {
    hidden: no
    description: "Target sum of sales marketing cost, excluding visibility goals and offline channels divided by the target number of orders"
    label: "Sales Marketing Costs per Order Target"
    group_label: "Marketing metrics"
    view_label: "Metrics - Targets"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_sales_marketing_cost_target}, ${total_orders_target}) ;;
  }

  measure: total_additional_marketing_income_fixed_amount_target {
    hidden: no
    description: "Target sum of fixed media income Target"
    label: "Additional Marketing Income"
    group_label: "Marketing metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${additional_marketing_income_target} ;;
  }

  measure: total_category_contribution_target {
    hidden: no
    description: "Target transaction margin minus target marketing costs, plus target marketing income, minus expected staffing costs"
    label: "Category Contribution Target"
    group_label: "Profitability metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${category_contribution_target} ;;
  }

  measure: total_gross_profit_impact_target {
    hidden: no
    description: "Target transaction margin minus target marketing costs, plus target marketing income, minus target direct fixed costs"
    label: "Gross Profit Impact Target"
    group_label: "Profitability metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${gross_profit_impact_target} ;;
  }

  measure: sales_end_of_year_target {
    hidden: no
    description: "A combination of actual sales for passed quarters plus sales targets for upcoming quarters, can be used to estimate end of year results"
    label: "Sales End of Year Target"
    group_label: "End of Year Targets"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: CASE
          WHEN DATE_TRUNC(date, MONTH) < DATE_TRUNC(CURRENT_DATE(), MONTH) THEN ${sales}
          ELSE ${sales_target}
         END ;;
  }

  measure: product_margin_incl_ssa_end_of_year_target {
    hidden: no
    description: "A combination of actuals for passed quarters plus targets for upcoming quarters, can be used to estimate end of year results"
    label: "Product Margin incl. SAs End of Year Target"
    group_label: "End of Year Targets"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: CASE
          WHEN DATE_TRUNC(date, MONTH) < DATE_TRUNC(CURRENT_DATE(), MONTH) THEN ${product_margin_incl_ssa}
          ELSE ${invoice_product_margin_incl_ssa_target}
         END ;;
  }

  measure: total_visibility_cost_target {
    hidden: no
    description: "Target sum of brand marketing costs"
    label: "Brand Marketing Cost Target"
    group_label: "Marketing metrics"
    view_label: "Metrics - Targets"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${visibility_cost_target} ;;
  }

# Sales Marketing cost information
  measure: total_sales_marketing_cost {
    hidden: no
    description: "Sum of sales marketing cost, excluding brand & partner marketing goals and offline channels"
    label: "Sales Marketing Costs"
    group_label: "Costs metrics"
    view_label: "Metrics - Marketing"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_per_order {
    hidden: no
    description: "Sum of sales marketing cost, excluding brand & partner marketing goals and offline channels divided by the number of orders"
    label: "Sales Marketing Costs per Order"
    group_label: "Costs metrics"
    view_label: "Metrics - Marketing"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_sales_marketing_cost}, ${total_orders}) ;;
  }

  measure: total_visibility_cost_distributed {
    hidden: no
    description: "Sum of brand marketing cost distributed equally over the days in a quarter"
    label: "Brand Marketing Costs"
    group_label: "Costs metrics"
    view_label: "Metrics - Marketing"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${visibility_cost_distributed} ;;
  }

# Partner Marketing cost information
  measure: total_partner_marketing_cost {
    hidden: no
    description: "Sum of partner marketing cost"
    label: "Partner Marketing Costs"
    group_label: "Costs metrics"
    view_label: "Metrics - Marketing"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_per_order {
    hidden: no
    description: "Sum of sales marketing cost"
    label: "Partner Marketing Costs per Order"
    group_label: "Costs metrics"
    view_label: "Metrics - Marketing"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${total_partner_marketing_cost}, ${total_orders}) ;;
  }

# Media income information
  measure: total_additional_marketing_income_fixed_amount {
    hidden: no
    description: "Sum of fixed media income"
    label: "Additional Marketing Income"
    group_label: "Income metrics"
    view_label: "Metrics - Marketing"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

# Impact information
  measure: total_category_contribution {
    hidden: yes
    description: "Transaction margin minus marketing costs, plus marketing income, minus direct fixed costs and minus staffing costs"
    label: "Category Contribution - not distributed"
    group_label: "Category Contribution metrics"
    view_label: "Metrics - Profitability"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${category_contribution} ;;
  }

  measure: total_category_contribution_distributed {
    hidden: no
    description: "Transaction margin minus marketing costs, plus marketing income, minus staffing costs, corrected for duration of marketing visibility campaigns"
    label: "Category Contribution"
    group_label: "Category Contribution metrics"
    view_label: "Metrics - Profitability"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${category_contribution_distributed} ;;
  }

  measure: total_category_contribution_distributed_excl_direct_fixed_cost {
    hidden: yes
    description: "Transaction margin minus marketing costs, plus marketing income, minus staffing costs, corrected for duration of marketing visibility campaigns"
    label: "Category Contribution (excl. direct fixed cost)"
    group_label: "Category Contribution metrics"
    view_label: "Metrics - Profitability"
    type: number
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${total_gross_profit_impact_distributed} - ${total_staffing_cost} ;;
  }

  measure: total_category_contribution_distributed_excl_direct_fixed_cost_as_percentage_of_sales {
    hidden: yes
    description: "Transaction margin minus marketing costs, plus marketing income, minus staffing costs, corrected for duration of marketing visibility campaigns, as percentage of sales"
    label: "Category Contribution (excl. direct fixed cost) as % of Sales"
    group_label: "Category Contribution metrics"
    view_label: "Metrics - Profitability"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${total_category_contribution_distributed_excl_direct_fixed_cost}, ${total_orderlevel_sales}) ;;
  }

  measure: total_gross_profit_impact {
    hidden: yes
    description: "Transaction margin minus marketing costs, plus marketing income, minus direct fixed costs"
    label: "Gross Profit Impact - not distributed"
    group_label: "Gross Profit Impact metrics"
    view_label: "Metrics - Profitability"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${gross_profit_impact} ;;
  }

  measure: total_gross_profit_impact_distributed {
    hidden: no
    description: "Transaction margin minus marketing costs, plus marketing income, minus direct fixed costs, corrected for duration of marketing visibility campaigns"
    label: "Gross Profit Impact"
    group_label: "Gross Profit Impact metrics"
    view_label: "Metrics - Profitability"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    sql: ${gross_profit_impact_distributed} ;;
  }

# ---------------------------- Date filters --------------------------#

  dimension: cost_reducing_filter_effect_metrics{
    hidden: yes
    label: "Keeps query costs low filter"
    description: "This filter limits the date range to keep the query costs low."
    view_label: "Date filters"
    type: yesno
    sql: (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), ISOWEEK),INTERVAL 2 WEEK)
        AND ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), ISOWEEK)
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), ISOWEEK), INTERVAL 54 WEEK)
        AND ${date_date} < DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), ISOWEEK), INTERVAL 52 WEEK)
        );;
  }

  dimension: cost_reducing_filter_monthly_effect_metrics{
    hidden: yes
    label: "Keeps query costs low filter (month)"
    description: "This filter limits the date range to keep the query costs low."
    view_label: "Date filters"
    type: yesno
    sql: (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH),INTERVAL 2 MONTH)
        AND ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH)
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH), INTERVAL 13 MONTH)
        AND ${date_date} < DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH), INTERVAL 12 MONTH)
        );;
  }

  dimension: cost_reducing_filter_wtd_dashboard {
    hidden: yes
    label: "Reduces query costs filter"
    description: "This filter limits the date range to keep the query costs low."
    view_label: "Date filters"
    type: yesno
    sql: (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, ISOWEEK),INTERVAL 1 WEEK)
        AND ${date_date} <= CURRENT_DATE('Europe/Amsterdam')-1)
        OR (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, ISOWEEK), INTERVAL 52 WEEK)
        AND ${date_date} < DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, ISOWEEK), INTERVAL 51 WEEK)
        );;
  }

  dimension: cost_reducing_filter_mtd {
    hidden: yes
    label: "MTD filter"
    description: "This filter limits the date range to keep the query costs low."
    view_label: "Date filters"
    type: yesno
    sql: (${date_date} >= DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, MONTH)
        AND ${date_date} <= CURRENT_DATE('Europe/Amsterdam')-1)
        OR (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, MONTH), INTERVAL 1 YEAR)
        AND ${date_date} <= DATE_SUB(CURRENT_DATE('Europe/Amsterdam')-1, INTERVAL 1 YEAR)
        );;
  }

  dimension: cost_reducing_filter_qtd {
    hidden: yes
    label: "QTD filter"
    description: "This filter limits the date range to keep the query costs low."
    view_label: "Date filters"
    type: yesno
    sql: (${date_date} >= DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, QUARTER)
        AND ${date_date} <= CURRENT_DATE('Europe/Amsterdam')-1)
        OR (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, QUARTER), INTERVAL 1 YEAR)
        AND ${date_date} <= DATE_SUB(CURRENT_DATE('Europe/Amsterdam')-1, INTERVAL 1 YEAR)
        );;
  }

  dimension: cost_reducing_filter_ytd {
    hidden: yes
    label: "YTD filter"
    description: "This filter limits the date range to keep the query costs low."
    view_label: "Date filters"
    type: yesno
    sql: (${date_date} >= DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 MONTH), YEAR)
        AND ${date_date} <= LAST_DAY(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 MONTH), MONTH))
        OR (${date_date} >= DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 13 MONTH), YEAR)
        AND ${date_date} <= LAST_DAY(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 13 MONTH), MONTH));;
  }

  dimension: last_10_weeks {
    hidden: no
    label: "Is last 10 weeks"
    view_label: "Date filters"
    description: "Use as a filter to see only data for the last 10 weeks in a YoY graph"
    type: yesno
    sql: (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL 10 WEEK)
        AND ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK)
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL +62 WEEK)
        AND ${date_date} < DATE_ADD(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL -52 WEEK)
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL +114 WEEK)
        AND ${date_date} < DATE_ADD(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL -104 WEEK)
        );;
  }

  dimension: last_12_weeks {
    hidden: no
    label: "Is last 12 weeks"
    view_label: "Date filters"
    description: "Use as a filter to see only data for the last 12 weeks in a YoY graph"
    type: yesno
    sql: (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL 12 WEEK)
        AND ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK)
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL +64 WEEK)
        AND ${date_date} < DATE_ADD(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL -52 WEEK)
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL +116 WEEK)
        AND ${date_date} < DATE_ADD(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL -104 WEEK)
        );;
  }

  dimension: last_12_weeks_incl_current_week {
    label: "Is last 12 weeks incl. current week"
    view_label: "Date filters"
    description: "Use as a filter to see only data for the last 12 weeks in a YoY graph, including the current week"
    type: yesno
    sql:  (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL 12 WEEK)
        AND ${date_date} < CURRENT_DATE('Europe/Amsterdam')
        )
        OR
        (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK),INTERVAL +64 WEEK)
        AND ${date_date} < DATE_ADD(CURRENT_DATE('Europe/Amsterdam'),INTERVAL -52 WEEK)
        );;
  }

  dimension: week_filter {
    hidden: no
    label: "Is Week Filter -10|+3"
    description: "Use this filter to show the last 10 weeks and next 3 weeks in YoY graphs"
    view_label: "Date filters"
    type: yesno
    sql: CASE WHEN EXTRACT(ISOWEEK FROM DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 10 WEEK)) <= EXTRACT(ISOWEEK FROM DATE_ADD(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 3 WEEK))
          THEN ${date_week_of_year} >= EXTRACT(ISOWEEK FROM DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 10 WEEK)) AND ${date_week_of_year} <= EXTRACT(ISOWEEK FROM DATE_ADD(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 3 WEEK)) AND ${date_year} >= EXTRACT(ISOYEAR FROM CURRENT_DATE('Europe/Amsterdam'))-2
          ELSE ${date_week_of_year} >= EXTRACT(ISOWEEK FROM DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 10 WEEK)) OR ${date_week_of_year} <= EXTRACT(ISOWEEK FROM DATE_ADD(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 3 WEEK)) AND ${date_year} >= EXTRACT(ISOYEAR FROM CURRENT_DATE('Europe/Amsterdam'))-2
          END;;
  }

  dimension: last_3_months {
    label: "Is last 3 months"
    view_label: "Date filters"
    description: "Use as a filter to see only data for the last 3 months in a YoY graph"
    type: yesno
    sql: (${date_date} >= DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH), INTERVAL 3 MONTH)
      AND ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH)
      )
      OR
      (${date_date} >= DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 YEAR), MONTH), INTERVAL 3 MONTH)
      AND ${date_date} < DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 YEAR), MONTH)
      )
      OR
      (${date_date} >= DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 2 YEAR), MONTH), INTERVAL 3 MONTH)
      AND ${date_date} < DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 2 YEAR), MONTH)
      );;
  }

  dimension: last_3_iso_years {
    label: "Is last 3 ISO years"
    view_label: "Date filters"
    description: "Use as a filter to see only data for the last 3 ISO years in a YoY graph"
    type: yesno
    sql: DATE_TRUNC(${date_date}, ISOYEAR) >= DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 2 YEAR), ISOYEAR)
      AND DATE_TRUNC(${date_date}, ISOYEAR) <= DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), ISOYEAR);;
  }

  dimension: hide_current_week {
    hidden: no
    description: "Filter out the current week"
    label: "Has not current week"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),ISOWEEK);;
  }

  dimension: hide_current_month {
    hidden: no
    description: "Filter out the current month"
    label: "Has not current month"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_date} < DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'),MONTH);;
  }

  dimension: only_qtd {
    hidden: no
    description: "Shows only data for the first day of the quarter until yesterday"
    label: "Is QtD"
    view_label: "Date filters"
    group_label: "To-Date Filters"
    type: yesno
    sql: ${date_day_of_year} < EXTRACT(DAYOFYEAR FROM CURRENT_DATE('Europe/Amsterdam')) AND EXTRACT(QUARTER FROM ${date_date}) = EXTRACT(QUARTER FROM CURRENT_DATE('Europe/Amsterdam')) ;;
  }

# ---------------------------- Sets to define for aggregate tables --------------------------#
# Standard measures that we want to aggregate in the aggregate table

  set: agg_measure_set {
    fields: [
      total_sales,
      total_primary_sales,
      total_attached_sales,
      total_products_sold,
      average_sales_price,
      total_transaction_margin,
      total_orders,
      total_product_margin,
      total_primary_margin_incl_ssa,
      total_attached_margin_incl_ssa,
      primary_margin_per_order,
      transaction_margin_per_order,
      attached_margin_per_order,
      total_gross_profit_impact,
      total_gross_profit_impact_distributed,
      total_sales_marketing_cost,
      total_additional_marketing_income_fixed_amount,
      primary_margin_percentage_of_sales,
      product_margin_perc,
      product_margin_excl_media_fee_perc,
      total_invoice_variable_cost,
      variable_costs_per_order,
      total_visibility_cost_distributed,
      total_primary_products_sold,
      total_products_sold_as_attached,
      total_partner_marketing_cost,
      partner_marketing_cost_per_order,
    ]
  }

  set: agg_target_set {
    fields: [
      total_sales_target,
      total_products_sold_target,
      total_transaction_margin_target,
      total_orders_target,
      total_invoice_product_margin_incl_ssa_target,
      total_primary_margin_incl_ssa_target,
      total_attached_margin_incl_ssa_target,
      total_gross_profit_impact_target,
      total_sales_marketing_cost_target,
      total_invoice_variable_cost_target,
      target_variable_costs_per_order,
      target_product_margin_percentage_of_sales,
      target_primary_margin_percentage_of_sales,
      target_average_sales_price,
      target_transaction_margin_per_order,
      target_transaction_margin_percentage_of_sales,
      target_attached_margin_per_order,
      target_sales_marketing_cost_per_order,
      total_visibility_cost_target,
      total_additional_marketing_income_fixed_amount_target,
    ]
  }

# The standard dimensions that we want to aggregate in the aggregate table
  set: standard_dimension_set {
    fields: [
      subsidiary,
      subsidiary_country,
      customertype,
      outlettype,
      region,
      delivery_flow,
    ]
  }

  set: product_id_set {
    fields: [
      productid,
      product,
    ]
  }

  set: producttype_set {
    fields: [
      subproducttype,
      producttype,
      focus_producttype,
      v_dim_product.product_type_en,
    ]
  }

  set: producttype_brand_set {
    fields: [
      subproducttype,
      producttype,
      focus_producttype,
      brand,
      samsung_brand_group,
      apple_brand_group,
      v_dim_product.product_type_en,
      is_second_chance,
    ]
  }

  set: team_set {
    fields: [
      team,
      teamid,
    ]
  }

#Time dimensions to aggregate on daily level
  set: daily_dimension_set {
    fields: [
      date_date,
      date_day_of_week,
      date_day_of_week_index,
      date_week_of_year,
      isoweek,
      date_year,
      isoyear,
      weeknumber_weekday_combination,
    ]
  }

#Time dimensions to aggregate on weekly level
  set: weekly_dimension_set {
    fields: [
      date_week_of_year,
      date_week,
      date_quarter_of_year,
      date_year,
      isoyear,
      isoweek,
      last_10_weeks,
      last_12_weeks,
      last_3_iso_years,
      hide_current_week,
    ]
  }

#Time dimensions to aggregate on monthly/year level
  set: monthly_dimension_set {
    fields: [
      date_month,
      date_month_name,
      date_quarter_of_year,
      date_year,
      hide_current_month,
      only_qtd,
    ]
  }

  set: join_measure_set {
    fields: [
      total_sales,
      total_products_sold,
      average_sales_price,
      total_orders,
      total_product_margin,
      total_transaction_margin,
      transaction_margin_percentage_of_sales
    ]
  }

  set: join_dimension_set {
    fields: [
      subsidiary,
      customertype,
      team,
      producttype,
      subproducttype,
      brand,
      product,
      productid
    ]
  }

############ Parameters ##################################
  parameter: price_bucket_size {
    hidden: yes
    description: "Set the size steps for the price buckets"
    view_label: "Price buckets"
    label: "Price bucket size"
    default_value: "500"
    type: number
  }

  dimension: dynamic_price_buckets {
    hidden: yes
    description: "Price buckets based on bucket size. Default: 500"
    view_label: "Price buckets"
    label: "Price buckets"
    type: number
    sql: TRUNC(SAFE_DIVIDE(${TABLE}.sales,${TABLE}.products_sold) *1.21 / {% parameter price_bucket_size %}, 0)
      * {% parameter price_bucket_size %} ;;
  }

}
