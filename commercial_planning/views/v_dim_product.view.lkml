view: v_dim_product {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `coolblue-bi-platform-prod.dimensions.v_dim_product`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Active" in Explore.

  dimension: active {
    hidden: yes
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: bk_product {
    hidden: yes
    type: number
    primary_key: yes
    sql: SAFE_CAST(${TABLE}.bk_product AS INT64) ;;
  }

  dimension: brand {
    hidden: yes
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: end_of_life {
    hidden: yes
    type: yesno
    sql: ${TABLE}.end_of_life ;;
  }

  dimension: manufacturer {
    hidden: yes
    type: string
    sql: ${TABLE}.manufacturer ;;
  }

  dimension: product {
    hidden: yes
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: product_group {
    hidden: no
    type: string
    sql: ${TABLE}.product_group ;;
  }

  dimension: product_type {
    hidden: yes
    type: string
    sql: ${TABLE}.product_type ;;
  }

  dimension: product_type_de {
    hidden: yes
    type: string
    sql: ${TABLE}.product_type_de ;;
  }

  dimension: product_type_en {
    label: "4b. Product type name (English)"
    type: string
    suggest_explore: transactions_suggestions
    suggest_dimension: transactions_suggestions.product_type_name
    sql: ${TABLE}.product_type_en ;;
  }

  dimension: product_type_fr {
    hidden: yes
    type: string
    sql: ${TABLE}.product_type_fr ;;
  }

  dimension: purchase {
    hidden: yes
    type: yesno
    sql: ${TABLE}.purchase ;;
  }

  dimension: size_category {
    hidden: yes
    type: string
    sql: ${TABLE}.size_category ;;
  }

  dimension: subproduct_type {
    hidden: yes
    type: string
    sql: ${TABLE}.subproduct_type ;;
  }

  dimension: team {
    hidden: yes
    type: string
    sql: ${TABLE}.team ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }

}
