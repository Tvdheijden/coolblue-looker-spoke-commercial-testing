# The database connection used for this model
connection: "ops_commercial_planning_testing"
label: "Commercial Planning"

# Include all the view files
include: "/commercial_planning/views/commercial_results/commercial_results.view.lkml"
include: "/commercial_planning/views/commercial_results/commercial_results_pop.view.lkml"
include: "/commercial_planning/views/commercial_results/commercial_results_html.view.lkml"
include: "/commercial_planning/views/commercial_results/additional_target_metrics.view.lkml"
include: "/commercial_planning/views/products.view.lkml"
include: "/commercial_planning/views/product_lines_info.view.lkml"
include: "/commercial_planning/views/v_dim_product.view.lkml"

# Include the value_tree_dashboard file
include: "../value_tree_week.dashboard"

# Create the explore
explore: commercial_results {
  label: "Commercial Results per Product"
  group_label: "Commercial Planning"
  description: "Explore with commercial data and targets on product level"
  from:  commercial_results

  #Always where so that there is only data from 2018+. This CANNOT be adjusted by the end users
  # sql_always_where: EXTRACT(YEAR FROM invoice_date) >= 2018 ;;
  #Always exclude teams that are not part of the category teams, like zonnepanelen and zz.opruimen
  sql_always_where: commercial_results.teamid NOT IN (0, 7045, 21, 6045, 2, 42, 4044) ;;

  #Always filter on B2B and Consumer sales only and teams in category teams. This CAN be adjusted by the end users
  always_filter: {
    filters: [commercial_results.customertype: "B2B, Consumer, Business Consumer"]
  }
  case_sensitive: no

  join: products {
    view_label: "Product dimensions"
    fields: [products.product_line,
      products.product_segment_name,
      products.size_category_name,
      products.pref_stock_location,
      products.product_group_name,
    ]
    type: left_outer
    sql_on: ${commercial_results.productid} = ${products.product_id} ;;
    relationship: many_to_one
  }

  join: v_dim_product {
    view_label: "Product dimensions"
    fields: [v_dim_product.product_type_en, v_dim_product.bk_product]
    type: left_outer
    sql_on: ${products.product_id} = ${v_dim_product.bk_product} ;;
    relationship: one_to_one
  }

  join: product_lines_info {
    view_label: "Product dimensions"
    type: left_outer
    sql_on: ${commercial_results.productid} = ${product_lines_info.product_id} ;;
    relationship: many_to_one
  }

  join: additional_target_metrics {
    type: left_outer
    sql_on: DATE_TRUNC(${commercial_results.date_date}, MONTH) = ${additional_target_metrics.date_date}
          AND ${commercial_results.teamid} = ${additional_target_metrics.teamid}
          AND ${commercial_results.subsidiaryid} = ${additional_target_metrics.subsidiaryid};;
    relationship: many_to_one
  }

}
