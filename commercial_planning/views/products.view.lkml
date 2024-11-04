view: products {
  sql_table_name: `coolblue-bi-platform-prod.product.products`
    ;;

  dimension: pref_outbound_address_product_id {
    primary_key: yes
    label: "Preferred Outbound Address Product ID."
    description: "The Preferred Outbound Address for the Product ID."
    type: number
    sql: ${TABLE}.pref_outbound_address_product_id ;;
  }

  dimension: active {
    label: "Is Active"
    description: "Is TRUE when a product is active in Vanessa. Indicates if the product is actively maintained (true) or historic (false)."
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: product_id {
    label: "Product ID"
    description: "Unique product identifier of the product."
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    label: "Product"
    description: "Name of the product."
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_type_id {
    label: "Product Type ID"
    description: "Product type ID of the product."
    type: number
    sql: ${TABLE}.product_type_id ;;
  }

  dimension: product_type_name {
    label: "Product Type"
    description: "Product type of the product."
    type: string
    sql: ${TABLE}.product_type_name ;;
  }

  dimension: product_group_id {
    label: "Product Group ID"
    description: "Product group ID of the product."
    type: number
    sql: ${TABLE}.product_group_id ;;
  }

  dimension: product_group_name {
    label: "Product Group"
    description: "Product group of the product."
    type: string
    sql: ${TABLE}.product_group_name ;;
  }

  dimension: product_group_group_type_id {
    label: "Product Group Group Type ID"
    description: "Product group group type ID of the product."
    type: number
    sql: ${TABLE}.product_group_group_type_id ;;
  }

  dimension: product_line {
    label: "Product Line"
    description: "Product line of the product."
    type: string
    sql: ${TABLE}.product_line ;;
  }

  dimension: product_line_id {
    label: "Product Line ID"
    description: "Product line ID of the product."
    type: number
    sql: ${TABLE}.product_line_id ;;
  }

  dimension: product_segment_id {
    label: "Product Segment ID"
    description: "Product segment ID of the product."
    type: number
    sql: ${TABLE}.product_segment_id ;;
  }

  dimension: product_segment_name {
    label: "Product Segment"
    description: "Product segment of the product."
    type: string
    sql: ${TABLE}.product_segment_name ;;
  }

  dimension: product_class_id {
    label: "Product Class ID"
    description: "Class ID of the product (e.g. standard product, service plan, combination)."
    type: number
    sql: ${TABLE}.product_class_id ;;
  }

  dimension: product_class_name {
    label: "Product Class"
    description: "Class of the product (e.g. standard product, service plan, combination)."
    type: string
    sql: ${TABLE}.product_class_name ;;
  }

  dimension: sub_product_type_norm {
    label: "Subproduct Type Norm"
    description: "Subproduct type norm of the product."
    type: number
    sql: ${TABLE}.sub_product_type_norm ;;
  }

  dimension: subproduct_type_id {
    label: "Subproduct Type ID"
    description: "Subproduct type ID of the product."
    type: number
    sql: ${TABLE}.subproduct_type_id ;;
  }

  dimension: subproduct_type_name {
    label: "Subproduct Type"
    description: "Subproduct type of the product."
    type: string
    sql: ${TABLE}.subproduct_type_name ;;
  }

  dimension: team_id {
    label: "Team ID"
    description: "Team ID of the product."
    type: number
    sql: ${TABLE}.team_id ;;
  }

  dimension: team_name {
    label: "Team"
    description: "Team of the product."
    type: string
    sql: ${TABLE}.team_name ;;
  }

  dimension: team_id_apple {
    label: "Team ID (Incl. Apple)"
    description: "Team ID of the product including team Apple based on brand Apple."
    type: number
    sql: CASE WHEN ${TABLE}.brand_id = 32
              THEN 8045
              ELSE ${TABLE}.team_id
         END ;;
  }

  dimension: team_name_apple  {
    label: "Team (Incl. Apple)"
    description: "Team of the product including team Apple based on brand Apple."
    type: string
    sql: CASE WHEN ${TABLE}.brand_id = 32
              THEN "Team Apple"
              ELSE ${TABLE}.team_name
         END ;;
  }

  dimension: brand_id {
    label: "Brand ID"
    description: "Brand ID of the product."
    type: number
    sql: ${TABLE}.brand_id ;;
  }

  dimension: brand_name {
    label: "Brand"
    type: string
    description: "Brand of the product."
    sql: ${TABLE}.brand_name ;;
  }

  dimension: end_of_life {
    label: "Is End Of Life"
    description: "Indicates whether or not a product is End of Life."
    type: yesno
    sql: ${TABLE}.end_of_life ;;
  }

  dimension: product_combination_id {
    label: "Product Combination ID"
    description: "Combination ID of the product."
    type: number
    sql: ${TABLE}.product_combination_id ;;
  }

  dimension: product_data_carrier {
    label: "Is Product Data Carrier"
    description: "Data Carrier of the product."
    type: yesno
    sql: ${TABLE}.product_data_carrier ;;
  }

  dimension: purchase {
    label: "Is Purchase"
    description: "Indicates if a products is (still) purchased by the company."
    type: yesno
    sql: ${TABLE}.purchase ;;
  }

  dimension: box_quantity {
    label: "Box Quantity"
    description: "The box quantity of this product. Purchases are preferred to be a multiplace of this amount."
    type: number
    sql: ${TABLE}.box_quantity ;;
  }

  dimension: pallet_quantity {
    label: "Pallet Quantity"
    description: "Maximum pallet quantity of the product."
    type: number
    sql: ${TABLE}.pallet_quantity ;;
  }

  dimension: identification_codes {
    label: "Identification Codes"
    description: "Identification codes of the product."
    hidden: yes
    sql: ${TABLE}.identification_codes ;;
  }

  dimension: manufacturer_id {
    label: "Manufacturer ID"
    description: "Manufacturer ID of the product."
    type: number
    sql: ${TABLE}.manufacturer_id ;;
  }

  dimension: manufacturer_name {
    label: "Manufacturer"
    description: "Manufacturer of the product."
    type: string
    sql: ${TABLE}.manufacturer_name ;;
  }

  dimension: manufacturer_product_code {
    label: "Manufacturer Product Code"
    description: "Code the manufacturer gave to the product."
    type: string
    sql: ${TABLE}.manufacturer_product_code ;;
  }

  dimension: size_category_id {
    label: "Size Category ID"
    description: "Size Category ID of the product (relative to the storage space on a picktrolley)."
    type: number
    sql: ${TABLE}.size_category_id ;;
  }

  dimension: size_category_name {
    label: "Size Category"
    description: "Size Category of the product."
    type: string
    sql: ${TABLE}.size_category_name ;;
  }

  dimension: size_height {
    label: "Size Height"
    description: "Height of the product in cm."
    type: number
    sql: ${TABLE}.size_height ;;
  }

  dimension: size_length {
    label: "Size Length"
    description: "Length of the product in cm."
    type: number
    sql: ${TABLE}.size_length ;;
  }

  dimension: size_width {
    label: "Size Width"
    description: "Width of the product in cm."
    type: number
    sql: ${TABLE}.size_width ;;
  }

  dimension: weight {
    label: "Weight"
    description: "Weight of the product in kg."
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension_group: last_modification {
    label: "Last Modification"
    description: "Last modification date of the product."
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modification_date ;;
  }

  dimension: delivery_service_id {
    label: "Delivery Service ID"
    description: "Delivery service ID of the product."
    type: number
    sql: ${TABLE}.delivery_service_id ;;
  }

  dimension: distribution_stock_location_address_id {
    label: "Distribution Stock Location Address ID"
    description: "Distribution stock location address id of the product."
    type: string
    sql: ${TABLE}.distribution_stock_location_address_id ;;
  }

  dimension: pref_inbound_address_product_id {
    label: "Preferred Inbound Address Product ID"
    description: "Preferred inbound address ID of the product."
    type: number
    sql: ${TABLE}.pref_inbound_address_product_id ;;
  }

  dimension: pref_inbound_address_product_name {
    label: "Preferred Inbound Address Product"
    description: "Preferred inbound address of the product."
    type: string
    sql: ${TABLE}.pref_inbound_address_product_name ;;
  }

  dimension: pref_inbound_address_product_type_id {
    label: "Preferred Inbound Address Product Type ID"
    description: "Preferred inbound address ID of the product type."
    type: number
    sql: ${TABLE}.pref_inbound_address_product_type_id ;;
  }

  dimension: pref_inbound_address_product_type_name {
    label: "Preferred Inbound Address Product Type"
    description: "Preferred inbound address of the product type."
    type: string
    sql: ${TABLE}.pref_inbound_address_product_type_name ;;
  }

  dimension: pref_outbound_address_product_name {
    label: "Preferred Outbound Address Product"
    description: "Preferred outbound address of the product."
    type: string
    sql: ${TABLE}.pref_outbound_address_product_name ;;
  }

  dimension: pref_outbound_address_product_type_id {
    label: "Preferred Outbound Address Product Type ID"
    description: "Preferred outbound address ID of the product type."
    type: number
    sql: ${TABLE}.pref_outbound_address_product_type_id ;;
  }

  dimension: pref_outbound_address_product_type_name {
    label: "Preferred Outbound Address Product Type"
    description: "Preferred outbound address of the product type."
    type: string
    sql: ${TABLE}.pref_outbound_address_product_type_name ;;
  }

  dimension: pref_stock_loc_product {
    label: "Preferred Stock Location Product"
    description: "Preferred stock location of the product."
    type: string
    sql: ${TABLE}.pref_stock_loc_product ;;
  }

  dimension: pref_stock_loc_product_id {
    label: "Preferred Stock Location Product ID"
    description: "Preferred stock location ID of the product."
    type: number
    sql: ${TABLE}.pref_stock_loc_product_id ;;
  }

  dimension: pref_stock_loc_product_type {
    label: "Preferred Stock Location Product Type"
    description: "Preferred stock location of the product type."
    type: string
    sql: ${TABLE}.pref_stock_loc_product_type ;;
  }

  dimension: pref_stock_loc_product_type_id {
    label: "Preferred Stock Location Product Type ID"
    description: "Preferred stock location ID of the product type."
    type: number
    sql: ${TABLE}.pref_stock_loc_product_type_id ;;
  }

  dimension: pref_stock_location {
    label: "Stock location"
    description: "The physical locations where we store stock"
    type: string
    sql: COALESCE(${TABLE}.pref_stock_loc_product_type, ${TABLE}.pref_stock_loc_product)  ;;
  }

  dimension_group: street {
    label: "Street"
    description: "Street date of the product."
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.street_date ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      pref_outbound_address_product_id,
      pref_outbound_address_product_name,
      size_category_name,
      brand_name,
      product_name,
      team_name,
      product_segment_name,
      subproduct_type_name,
      product_class_name,
      pref_outbound_address_product_type_name,
      pref_inbound_address_product_name,
      product_type_name,
      product_group_name,
      pref_inbound_address_product_type_name,
      manufacturer_name,
      products.pref_outbound_address_product_name,
      products.size_category_name,
      products.brand_name,
      products.product_name,
      products.team_name,
      products.product_segment_name,
      products.subproduct_type_name,
      products.product_class_name,
      products.pref_outbound_address_product_id,
      products.pref_outbound_address_product_type_name,
      products.pref_inbound_address_product_name,
      products.product_type_name,
      products.product_group_name,
      products.pref_inbound_address_product_type_name,
      products.manufacturer_name,
    ]
  }
}

view: products__identification_codes {
  dimension: products__identification_codes {
    label: "Product Identification Codes"
    description: "Identification codes of the product."
    type: string
    sql: products__identification_codes ;;
  }
}
