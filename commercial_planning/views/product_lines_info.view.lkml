view: product_lines_info {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `coolblue-webandapp-prod.product_management.product_lines_info`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Brand ID" in Explore.

  dimension: brand_id {
    type: number
    label: "Brand ID"
    description: "ID of the Brand"
    sql: ${TABLE}.brand_id ;;
  }

  dimension: brand_name {
    type: string
    label: "Brand name"
    description: "name of the Brand"
    sql: ${TABLE}.brand_name ;;
  }

  dimension: family_value {
    type: string
    label: "Family name"
    description: "Name of the family in which the product(s) is(are)"
    sql: ${TABLE}.family_value ;;
  }

  dimension: generation_value {
    type: string
    label: "Generation name"
    description: "Name of the Generation in which the product(s) is(are)"
    sql: ${TABLE}.generation_value ;;
  }

  dimension: line_value {
    type: string
    label: "Line name"
    description: "Name of the Line in which the product(s) is(are)"
    sql: ${TABLE}.line_value ;;
  }

  dimension: product_id {
    type: number
    primary_key: yes
    label: "Product ID"
    description: "ID of the Product"
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    label: "Product name"
    description: "Name of the Product"
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_type_id {
    type: number
    label: "Producttype ID"
    description: "ID of the Producttype"
    sql: ${TABLE}.product_type_id ;;
  }

  dimension: product_type_name {
    type: string
    label: "Product type name"
    description: "Name of the product type"
    sql: ${TABLE}.product_type_name ;;
  }

  dimension: subproduct_type_id {
    type: number
    label: "Subproducttype ID"
    description: "ID of the subproducttype"
    sql: ${TABLE}.subproduct_type_id ;;
  }

  dimension: subproduct_type_name {
    type: string
    label: "Subproducttype name"
    description: "Name of the Subproducttype"
    sql: ${TABLE}.subproduct_type_name ;;
  }

}
