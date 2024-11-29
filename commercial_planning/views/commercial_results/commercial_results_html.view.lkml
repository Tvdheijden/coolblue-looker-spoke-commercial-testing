# General settings for view
include: "/commercial_planning/views/commercial_results/commercial_results.view.lkml"
include: "/commercial_planning/views/commercial_results/commercial_results_pop.view.lkml"

view: +commercial_results {
  label: "HTML Tiles for Value Tree"

#----------- Date dimensions for HTML Date tiles----------#

  dimension_group: current_date_minus_seven {
    type: time
    timeframes: [
      date,
      week,
      month,
      year,
      day_of_month,
      day_of_week,
      day_of_week_index,
      week_of_year,
      day_of_year,
    ]
    sql: CURRENT_DATE - 7;; #We doen hier -7 zodat er op alle dagen van de week naar de eerst vorige week gekeken wordt
  }

  dimension_group: current_date_minus_fourteen {
    type: time
    timeframes: [
      date,
      week,
      month,
      year,
      day_of_month,
      day_of_week,
      day_of_week_index,
      week_of_year,
      day_of_year,
    ]
    sql: CURRENT_DATE - 14;; #We doen hier -14 zodat er op alle dagen van de week naar 2 weken gekeken wordt
  }

  dimension: ISOWEEK_current_date_minus_seven {
    label: "Week ISO last week"
    type: number
    sql: EXTRACT(ISOWEEK FROM ${current_date_minus_seven_date}) ;;
  }

  dimension: ISOWEEK_current_date_minus_fourteen {
    label: "Week ISO two weeks ago"
    type: number
    sql: EXTRACT(ISOWEEK FROM ${current_date_minus_fourteen_date}) ;;
  }

  dimension: ISOYEAR_current_date_minus_seven {
    label: "Year ISO last week"
    type: number
    value_format_name: id
    sql: EXTRACT(ISOYEAR FROM ${current_date_minus_seven_date}) ;;
  }

  dimension: ISOYEAR_current_date_minus_fourteen {
    label: "Year ISO two weeks ago"
    type: number
    value_format_name: id
    sql: EXTRACT(ISOYEAR FROM ${current_date_minus_fourteen_date}) ;;
  }

  dimension: last_year {
    type: number
    sql: ${ISOYEAR_current_date_minus_seven} -1 ;;
  }

  dimension: last_month_name {
    type: string
    sql: FORMAT_DATETIME("%B", DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) ;;
  }

  dimension: last_month_name_trunc_lower {
    type: string
    sql: LOWER(SUBSTR(FORMAT_DATETIME("%B", DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)), 1, 3)) ;;
  }

  dimension: last_month_last_day {
    type: string
    sql: FORMAT_DATETIME("%d", LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))) ;;
  }

  dimension: two_months_ago_name {
    type: string
    sql: FORMAT_DATETIME("%B", DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)) ;;
  }

  dimension: last_year_number {
    type: number
    value_format_name: id
    sql: EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE()-1, INTERVAL 1 YEAR)) ;;
  }

  dimension: this_year_number {
    type: number
    value_format_name: id
    sql: EXTRACT(YEAR FROM CURRENT_DATE()-1) ;;
  }
  dimension: current_week_to_days {
    type: string
    sql: CONCAT(FORMAT_DATE("%a %b %e", DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), ISOWEEK)), " - ", FORMAT_DATE("%a %b %e %Y", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))) ;;
  }
  dimension: prior_week_to_days {
    type: string
    sql: CONCAT(FORMAT_DATE("%a %b %e", DATE_TRUNC(DATE_SUB(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), INTERVAL 1 WEEK), ISOWEEK)), " - ", FORMAT_DATE("%a %b %e %Y", DATE_SUB(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), INTERVAL 1 WEEK))) ;;
  }
  dimension: last_year_week_to_days {
    type: string
    sql: CONCAT(FORMAT_DATE("%a %b %e", DATE_TRUNC(DATE_SUB(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), INTERVAL 52 WEEK), ISOWEEK)), " - ", FORMAT_DATE("%a %b %e %Y", DATE_SUB(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), INTERVAL 52 WEEK))) ;;
  }
  dimension: yesterday_html {
    type: string
    sql: CONCAT("Results of ", FORMAT_DATE("%d-%m-%Y", CURRENT_DATE()-1)) ;;
  }

#----------- Date Tiles --------------#

  measure: last_week_vs_last_year{
    label: "Last week vs. Last year"
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 18px">W{{ ISOWEEK_current_date_minus_seven._rendered_value  }}-{{ ISOYEAR_current_date_minus_seven._rendered_value  }} vs. W{{ ISOWEEK_current_date_minus_seven._rendered_value  }}-{{ last_year._rendered_value  }}</div>  ;;
  }

  measure: last_week_vs_two_weeks_ago{
    label: "Last week vs. two weeks ago"
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 18px">W{{ ISOWEEK_current_date_minus_seven._rendered_value  }}-{{ ISOYEAR_current_date_minus_seven._rendered_value  }} vs. W{{ ISOWEEK_current_date_minus_fourteen._rendered_value  }}-{{ ISOYEAR_current_date_minus_fourteen._rendered_value  }}</div>  ;;
  }

  measure: last_month_vs_last_year{
    label: "Last month vs. Last year"
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 18px">{{ last_month_name._rendered_value  }} {{ current_date_minus_one_year._rendered_value  }} vs. {{ last_month_name._rendered_value  }} {{ last_year_number._rendered_value  }}</div>   ;;
  }

  measure: last_month_vs_two_months_ago{
    label: "Last month vs. two months ago"
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 18px">{{ last_month_name._rendered_value  }} vs. {{ two_months_ago_name._rendered_value  }}</div>  ;;
  }

  measure: last_month_tile {
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 20px">{{ date_month_name._rendered_value  }} - {{ date_year._rendered_value  }} </div>  ;;
  }

  measure: last_week_tile {
    hidden: no
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 18px">Isoweek {{ isoweek._rendered_value  }} - {{ isoyear._rendered_value  }}</div> ;;
  }

  measure: week_to_date_wow_tile {
    view_label: "Developer metrics"
    type: count
    html: <div style="font-size: 18px">{{ current_week_to_days._rendered_value  }} vs. {{ prior_week_to_days._rendered_value  }}</div> ;;
  }

  measure: week_to_date_yoy_tile {
    view_label: "Developer metrics"
    type: count
    html: <div style="font-size: 18px">{{ current_week_to_days._rendered_value  }} vs. {{ last_year_week_to_days._rendered_value  }}</div> ;;
  }

  measure: running_period_this_year_vs_last_year {
    label: "Running period this year vs. last year"
    view_label: "Developer metrics"
    type: count
    html:
      <div style="font-size: 18px"> 1 jan — {{ last_month_last_day._rendered_value  }} {{ last_month_name_trunc_lower._rendered_value  }} {{ this_year_number._rendered_value  }} vs. 1 jan — {{ last_month_last_day._rendered_value  }} {{ last_month_name_trunc_lower._rendered_value  }} {{ last_year_number._rendered_value  }}</div>   ;;
  }

#----------- Drill Fiels for Value Tree --------------#

#GROSS PROFIT IMPACT
  measure: gross_profit_impact_distributed_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, gross_profit_impact_distributed_wow_abs, gross_profit_impact_distributed_last_week_this_year]
  }

  measure: gross_profit_impact_distributed_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, gross_profit_impact_distributed_wow_abs, gross_profit_impact_distributed_last_week_this_year]
  }

  measure: gross_profit_impact_distributed_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, gross_profit_impact_distributed_mom_abs, gross_profit_impact_distributed_last_month_this_year]
  }

  measure: gross_profit_impact_distributed_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, gross_profit_impact_distributed_mom_abs, gross_profit_impact_distributed_last_month_this_year]
  }

#VISIBILITY COST/BRAND MARKETING COST
  measure: visibility_cost_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, visibility_cost_distributed_wow_abs, visibility_cost_distributed_last_week_this_year]
  }

  measure: visibility_cost_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, visibility_cost_distributed_wow_abs, visibility_cost_distributed_last_week_this_year]
  }

  measure: visibility_cost_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, visibility_cost_distributed_mom_abs, visibility_cost_distributed_last_month_this_year]
  }

  measure: visibility_cost_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, visibility_cost_distributed_mom_abs, visibility_cost_distributed_last_month_this_year]
  }

#PARTNER MARKETING COST
  measure: partner_marketing_cost_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, partner_marketing_cost_wow_abs, partner_marketing_cost_last_week_this_year]
  }

  measure: partner_marketing_cost_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, partner_marketing_cost_wow_abs, partner_marketing_cost_last_week_this_year]
  }

  measure: partner_marketing_cost_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, partner_marketing_cost_mom_abs, partner_marketing_cost_last_month_this_year]
  }

  measure: partner_marketing_cost_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, partner_marketing_cost_mom_abs, partner_marketing_cost_last_month_this_year]
  }

#SALES MARKETING COST
  measure: sales_marketing_cost_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, sales_marketing_cost_wow_abs, sales_marketing_cost_last_week_this_year]
  }

  measure: sales_marketing_cost_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, sales_marketing_cost_wow_abs, sales_marketing_cost_last_week_this_year]
  }

  measure: sales_marketing_cost_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, sales_marketing_cost_mom_abs, sales_marketing_cost_last_month_this_year]
  }

  measure: sales_marketing_cost_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, sales_marketing_cost_mom_abs, sales_marketing_cost_last_month_this_year]
  }

#ADDITIONAL MARKETING INCOME
  measure: additional_marketing_income_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, additional_marketing_income_wow_abs, additional_marketing_income_last_week_this_year]
  }

  measure: additional_marketing_income_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, additional_marketing_income_wow_abs, additional_marketing_income_last_week_this_year]
  }

  measure: additional_marketing_income_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, additional_marketing_income_mom_abs, additional_marketing_income_last_month_this_year]
  }

  measure: additional_marketing_income_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, additional_marketing_income_mom_abs, additional_marketing_income_last_month_this_year]
  }
  measure: variable_cost_per_order_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, variable_cost_per_order_wow_abs, variable_cost_per_order_last_week_this_year]
  }

#VARIABLE COST PER ORDER
  measure: variable_cost_per_order_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, variable_cost_per_order_wow_abs, variable_cost_per_order_last_week_this_year]
  }

  measure: variable_cost_per_order_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, variable_cost_per_order_mom_abs, variable_cost_per_order_last_month_this_year]
  }

  measure: variable_cost_per_order_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, variable_cost_per_order_mom_abs, variable_cost_per_order_last_month_this_year]
  }

#AVERAGE SALES PRICE
  measure: average_sales_price_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, average_sales_price_wow_abs, average_sales_price_last_week_this_year]
  }

  measure: average_sales_price_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, average_sales_price_wow_abs, average_sales_price_last_week_this_year]
  }

  measure: average_sales_price_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, average_sales_price_mom_abs, average_sales_price_last_month_this_year]
  }

  measure: average_sales_price_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, average_sales_price_mom_abs, average_sales_price_last_month_this_year]
  }

#PRIMARY MARGIN PER ORDER
  measure: primary_margin_per_order_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, primary_margin_per_order_wow_abs, primary_margin_per_order_last_week_this_year]
  }

  measure: primary_margin_per_order_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, primary_margin_per_order_wow_abs, primary_margin_per_order_last_week_this_year]
  }

  measure: primary_margin_per_order_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, primary_margin_per_order_mom_abs, primary_margin_per_order_last_month_this_year]
  }

  measure: primary_margin_per_order_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, primary_margin_per_order_mom_abs, primary_margin_per_order_last_month_this_year]
  }

#MARGIN
  measure: margin_drill_week_subproducttype {
    type: sum
    sql: 0 ;;
    drill_fields: [subproducttype, margin_wow, margin_last_week_this_year]
  }

  measure: margin_drill_week_product {
    type: sum
    sql: 0 ;;
    drill_fields: [product, margin_wow, margin_last_week_this_year]
  }

  measure: margin_drill_month_subproducttype {
    type: sum
    sql: 0 ;;
    drill_fields: [subproducttype, margin_mom, margin_last_month_this_year]
  }

  measure: margin_drill_month_product {
    type: sum
    sql: 0 ;;
    drill_fields: [product, margin_mom, margin_last_month_this_year]
  }

#MARGIN AS PERCENTAGE OF SALES
  measure: margin_perc_drill_week_subproducttype {
    type: sum
    sql: 0 ;;
    drill_fields: [subproducttype, margin_perc_wow_abs, margin_perc_last_week_this_year]
  }

  measure: margin_perc_drill_week_product {
    type: sum
    sql: 0 ;;
    drill_fields: [product, margin_perc_wow_abs, margin_perc_last_week_this_year]
  }

  measure: margin_perc_drill_month_subproducttype {
    type: sum
    sql: 0 ;;
    drill_fields: [subproducttype, margin_perc_mom_abs, margin_perc_last_month_this_year]
  }

  measure: margin_perc_drill_month_product {
    type: sum
    sql: 0 ;;
    drill_fields: [product, margin_perc_mom_abs, margin_perc_last_month_this_year]
  }

#ATTACHED MARGIN PER ORDER
  measure: attached_margin_per_order_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, attached_margin_per_order_wow_abs, attached_margin_per_order_last_week_this_year]
  }

  measure: attached_margin_per_order_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, attached_margin_per_order_wow_abs, attached_margin_per_order_last_week_this_year]
  }

  measure: attached_margin_per_order_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, attached_margin_per_order_mom_abs, attached_margin_per_order_last_month_this_year]
  }

  measure: attached_margin_per_order_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, attached_margin_per_order_mom_abs, attached_margin_per_order_last_month_this_year]
  }

#SALES
  measure: sales_drill_week_team{
    type:  sum
    sql: 0 ;;
    drill_fields: [team, sales_wow_abs, sales_last_week_this_year]
  }

  measure: sales_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, sales_wow_abs, sales_last_week_this_year]
  }

  measure: sales_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, sales_wow_abs, sales_last_week_this_year]
  }

  measure: sales_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, sales_mom_abs, sales_last_month_this_year]
  }

  measure: sales_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, sales_mom_abs, sales_last_month_this_year]
  }

  measure: sort_producttype_by_total_sales {
    type: number
    value_format_name: decimal_0
    sql: SUM(${sales_last_week_this_year}) OVER(PARTITION BY ${producttype}) ;;
  }

#ORDERS
  measure: orders_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, orders_wow_abs, orders_last_week_this_year]
  }

  measure: orders_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, orders_wow_abs, orders_last_week_this_year]
  }

  measure: orders_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, orders_mom_abs, orders_last_month_this_year]
  }

  measure: orders_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, orders_mom_abs, orders_last_month_this_year]
  }

#TRANSACTION MARGIN
  measure: transaction_margin_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, transaction_margin_wow_abs, transaction_margin_last_week_this_year]
  }

  measure: transaction_margin_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, transaction_margin_wow_abs, transaction_margin_last_week_this_year]
  }

  measure: transaction_margin_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, transaction_margin_mom_abs, transaction_margin_last_month_this_year]
  }

  measure: transaction_margin_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, transaction_margin_mom_abs, transaction_margin_last_month_this_year]
  }

#TRANSACTION MARGIN PER ORDER
  measure: transaction_margin_per_order_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, transaction_margin_per_order_wow_abs, transaction_margin_per_order_last_week_this_year]
  }

  measure: transaction_margin_per_order_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, transaction_margin_per_order_wow_abs, transaction_margin_per_order_last_week_this_year]
  }

  measure: transaction_margin_per_order_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, transaction_margin_per_order_mom_abs, transaction_margin_per_order_last_month_this_year]
  }

  measure: transaction_margin_per_order_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, transaction_margin_per_order_mom_abs, transaction_margin_per_order_last_month_this_year]
  }

#PRODUCTS SOLD
  measure: products_sold_drill_week_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, products_sold_wow_abs, products_sold_last_week_this_year]
  }

  measure: products_sold_drill_week_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, products_sold_wow_abs, products_sold_last_week_this_year]
  }

  measure: products_sold_drill_month_subproducttype{
    type:  sum
    sql: 0 ;;
    drill_fields: [subproducttype, products_sold_mom_abs, products_sold_last_month_this_year]
  }

  measure: products_sold_drill_month_product{
    type:  sum
    sql: 0 ;;
    drill_fields: [product, products_sold_mom_abs, products_sold_last_month_this_year]
  }

#----------- HTML Tiles --------------#

#GROSS PROFIT IMPACT
  measure: gross_profit_impact_distributed_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Gross profit impact distributed"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ gross_profit_impact_distributed_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ gross_profit_impact_distributed_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/936?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Gross profit impact </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{gross_profit_impact_distributed_last_week_this_year._rendered_value}} </div>
      {% if gross_profit_impact_distributed_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ gross_profit_impact_distributed_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ gross_profit_impact_distributed_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if gross_profit_impact_distributed_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{ gross_profit_impact_distributed_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{ gross_profit_impact_distributed_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if gross_profit_impact_distributed_week_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ gross_profit_impact_distributed_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_week_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ gross_profit_impact_distributed_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: gross_profit_impact_distributed_html_week_target_wow_yoy_abs {
    view_label: "Html combinations"
    group_label: "Gross profit impact distributed"
    label: "Last week - delta target/wow/yoy with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{gross_profit_impact_distributed_last_week_this_year._rendered_value}} </div>
      {% if gross_profit_impact_distributed_week_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{gross_profit_impact_distributed_week_yoy_abs._rendered_value}} ({{gross_profit_impact_distributed_week_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_week_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{gross_profit_impact_distributed_week_yoy_abs._rendered_value}} ({{gross_profit_impact_distributed_week_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if gross_profit_impact_distributed_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{gross_profit_impact_distributed_wow_abs._rendered_value}} ({{ gross_profit_impact_distributed_wow._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{gross_profit_impact_distributed_wow_abs._rendered_value}} ({{ gross_profit_impact_distributed_wow._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: gross_profit_impact_distributed_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Gross profit impact distributed"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ gross_profit_impact_distributed_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ gross_profit_impact_distributed_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/983?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Gross profit impact </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{gross_profit_impact_distributed_last_month_this_year._rendered_value}} </div>
      {% if subsidiary_country._is_filtered or producttype._is_filtered or brand._is_filtered or region._is_filtered or subproducttype._is_filtered%}
      {% else %}
      {% if gross_profit_impact_distributed_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ gross_profit_impact_distributed_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ gross_profit_impact_distributed_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% endif %}
      {% if gross_profit_impact_distributed_mom._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{ gross_profit_impact_distributed_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_mom._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{ gross_profit_impact_distributed_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if gross_profit_impact_distributed_month_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ gross_profit_impact_distributed_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_month_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ gross_profit_impact_distributed_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: gross_profit_impact_distributed_html_month_target_mom_yoy_abs {
    view_label: "Html combinations"
    group_label: "Gross profit impact distributed"
    label: "Last month - delta target/mom/yoy with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{gross_profit_impact_distributed_last_month_this_year._rendered_value}} </div>
      {% if gross_profit_impact_distributed_month_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{gross_profit_impact_distributed_month_yoy_abs._rendered_value}} ({{gross_profit_impact_distributed_month_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_month_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{gross_profit_impact_distributed_month_yoy_abs._rendered_value}} ({{gross_profit_impact_distributed_month_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
         {% if gross_profit_impact_distributed_mom._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{gross_profit_impact_distributed_mom_abs._rendered_value}} ({{ gross_profit_impact_distributed_mom._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif gross_profit_impact_distributed_mom._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{gross_profit_impact_distributed_mom_abs._rendered_value}} ({{ gross_profit_impact_distributed_mom._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#VISIBILITY COST/BRAND MARKETING COST
  measure: visibility_cost_distributed_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Brand Marketing cost distributed"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ visibility_cost_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ visibility_cost_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/942?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Brand marketing cost </div>
      <div style="font-size: 20px; padding : 0; margin : 15px ; line-height : 20px;"> {{visibility_cost_distributed_last_week_this_year._rendered_value}} </div>
      {% if visibility_cost_distributed_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ visibility_cost_distributed_week_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif visibility_cost_distributed_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ visibility_cost_distributed_week_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if visibility_cost_distributed_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ visibility_cost_distributed_wow._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif visibility_cost_distributed_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ visibility_cost_distributed_wow._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if visibility_cost_distributed_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ visibility_cost_distributed_week_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif visibility_cost_distributed_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ visibility_cost_distributed_week_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      </div>  ;;
  }


  measure: visibility_cost_distributed_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Brand Marketing cost distributed"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ visibility_cost_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ visibility_cost_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1013?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Brand marketing cost </div>
      <div style="font-size: 20px; padding : 0; margin : 15px ; line-height : 20px;"> {{visibility_cost_distributed_last_month_this_year._rendered_value}} </div>
      {% if producttype._is_filtered or brand._is_filtered or region._is_filtered or subproducttype._is_filtered%}
      {% else %}
      {% if visibility_cost_distributed_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ visibility_cost_distributed_month_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif visibility_cost_distributed_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ visibility_cost_distributed_month_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% endif %}
      {% if visibility_cost_distributed_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ visibility_cost_distributed_mom._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif visibility_cost_distributed_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ visibility_cost_distributed_mom._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if visibility_cost_distributed_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ visibility_cost_distributed_month_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif visibility_cost_distributed_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ visibility_cost_distributed_month_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#SALES MARKETING COST
  measure: sales_marketing_cost_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Sales marketing cost"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ sales_marketing_cost_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ sales_marketing_cost_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/941?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Sales marketing cost </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{sales_marketing_cost_last_week_this_year._rendered_value}} </div>
      {% if sales_marketing_cost_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_marketing_cost_week_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif sales_marketing_cost_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_marketing_cost_week_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if sales_marketing_cost_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ sales_marketing_cost_wow._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif sales_marketing_cost_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ sales_marketing_cost_wow._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if sales_marketing_cost_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_marketing_cost_week_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif sales_marketing_cost_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_marketing_cost_week_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: sales_marketing_cost_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Sales marketing cost"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ sales_marketing_cost_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ sales_marketing_cost_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1009?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Sales marketing cost </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{sales_marketing_cost_last_month_this_year._rendered_value}} </div>
      {% if sales_marketing_cost_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_marketing_cost_month_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif sales_marketing_cost_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_marketing_cost_month_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if sales_marketing_cost_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ sales_marketing_cost_mom._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif sales_marketing_cost_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ sales_marketing_cost_mom._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if sales_marketing_cost_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_marketing_cost_month_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif sales_marketing_cost_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_marketing_cost_month_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#PARTNER MARKETING COST
  measure: partner_marketing_cost_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Partner marketing cost"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ partner_marketing_cost_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ partner_marketing_cost_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/5973?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Partner marketing cost </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{ partner_marketing_cost_last_week_this_year._rendered_value }} </div>
      {% if partner_marketing_cost_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ partner_marketing_cost_wow._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif partner_marketing_cost_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ partner_marketing_cost_wow._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if partner_marketing_cost_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ partner_marketing_cost_week_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif partner_marketing_cost_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ partner_marketing_cost_week_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: partner_marketing_cost_html_month_target_mom_yoy {

    view_label: "Html combinations"
    group_label: "Partner marketing cost"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ partner_marketing_cost_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ partner_marketing_cost_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/5978?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Partner marketing cost </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{ partner_marketing_cost_last_month_this_year._rendered_value }} </div>
      {% if producttype._is_filtered or brand._is_filtered or region._is_filtered or subproducttype._is_filtered%}
      {% else %}
      {% if partner_marketing_cost_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ partner_marketing_cost_month_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif partner_marketing_cost_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ partner_marketing_cost_month_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% endif %}
      {% if partner_marketing_cost_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ partner_marketing_cost_mom._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif partner_marketing_cost_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ partner_marketing_cost_mom._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if partner_marketing_cost_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ partner_marketing_cost_month_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif partner_marketing_cost_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ partner_marketing_cost_month_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#ADDITIONAL MARKETING INCOME
  measure: additional_marketing_income_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Additional marketing income"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ additional_marketing_income_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ additional_marketing_income_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/940?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Additional marketing income </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{additional_marketing_income_last_week_this_year._rendered_value}} </div>
      {% if additional_marketing_income_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ additional_marketing_income_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif additional_marketing_income_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ additional_marketing_income_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if additional_marketing_income_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ additional_marketing_income_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif additional_marketing_income_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ additional_marketing_income_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if additional_marketing_income_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ additional_marketing_income_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif additional_marketing_income_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ additional_marketing_income_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: additional_marketing_income_html_month_target_mom_yoy {

    view_label: "Html combinations"
    group_label: "Additional marketing income"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ additional_marketing_income_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ additional_marketing_income_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/988?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Additional marketing income </div>
      <div style="font-size: 20px; padding : 0; margin : 15px; line-height : 20px;"> {{additional_marketing_income_last_month_this_year._rendered_value}} </div>
      {% if producttype._is_filtered or brand._is_filtered or region._is_filtered or subproducttype._is_filtered%}
      {% else %}
      {% if additional_marketing_income_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ additional_marketing_income_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif additional_marketing_income_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ additional_marketing_income_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% endif %}
      {% if additional_marketing_income_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ additional_marketing_income_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif additional_marketing_income_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ additional_marketing_income_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if additional_marketing_income_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ additional_marketing_income_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif additional_marketing_income_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ additional_marketing_income_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
     </div>;;
  }

#VARIABLE COST PER ORDER
  measure: variable_cost_per_order_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Variable cost per order"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ variable_cost_per_order_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ variable_cost_per_order_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/946?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Variable cost per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{variable_cost_per_order_last_week_this_year._rendered_value}} </div>
      {% if variable_cost_per_order_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ variable_cost_per_order_week_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif variable_cost_per_order_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ variable_cost_per_order_week_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if variable_cost_per_order_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ variable_cost_per_order_wow._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif variable_cost_per_order_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ variable_cost_per_order_wow._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if variable_cost_per_order_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ variable_cost_per_order_week_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif variable_cost_per_order_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ variable_cost_per_order_week_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: variable_cost_per_order_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Variable cost per order"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ variable_cost_per_order_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ variable_cost_per_order_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1012?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Variable cost per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{variable_cost_per_order_last_month_this_year._rendered_value}} </div>
      {% if variable_cost_per_order_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ variable_cost_per_order_month_delta_target._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif variable_cost_per_order_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ variable_cost_per_order_month_delta_target._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if variable_cost_per_order_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ variable_cost_per_order_mom._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif variable_cost_per_order_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ variable_cost_per_order_mom._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
      {% if variable_cost_per_order_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ variable_cost_per_order_month_yoy._rendered_value  }} <font color="#E50000"> ▲ </font> </div>
      {% elsif variable_cost_per_order_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ variable_cost_per_order_month_yoy._rendered_value  }} <font color="#00B900"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#AVERAGE SALES PRICE
  measure: average_sales_price_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Average sales price"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ average_sales_price_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ average_sales_price_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/949?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Average sales price </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{average_sales_price_last_week_this_year._rendered_value}} </div>
      {% if average_sales_price_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ average_sales_price_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ average_sales_price_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if average_sales_price_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{ average_sales_price_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{ average_sales_price_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if average_sales_price_week_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ average_sales_price_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_week_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ average_sales_price_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: average_sales_price_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Average sales price"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ average_sales_price_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ average_sales_price_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/997?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Average sales price </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{average_sales_price_last_month_this_year._rendered_value}} </div>
      {% if average_sales_price_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ average_sales_price_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{ average_sales_price_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if average_sales_price_mom._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{ average_sales_price_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_mom._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{ average_sales_price_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if average_sales_price_month_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ average_sales_price_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_month_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{ average_sales_price_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: average_sales_price_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "ASP"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> ASP </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{average_sales_price_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{average_sales_price_wtd_this_year._rendered_value}} </div>
      {% if average_sales_price_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ average_sales_price_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ average_sales_price_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if average_sales_price_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ average_sales_price_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif average_sales_price_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ average_sales_price_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#PRIMARY MARGIN
  measure: primary_margin_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Primary margin"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> Primary margin </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{primary_margin_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{primary_margin_wtd_this_year._rendered_value}} </div>
      {% if primary_margin_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ primary_margin_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ primary_margin_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if primary_margin_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#PRIMARY MARGIN PER ORDER
  measure: primary_margin_per_order_html_week_target_wow_yoy{
    hidden: no
    view_label: "Html combinations"
    group_label: "Primary margin per order"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ primary_margin_per_order_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ primary_margin_per_order_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/943?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Primary margin per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{primary_margin_per_order_last_week_this_year._rendered_value}} </div>
      {% if primary_margin_per_order_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ primary_margin_per_order_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_per_order_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ primary_margin_per_order_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if primary_margin_per_order_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ primary_margin_per_order_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_per_order_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ primary_margin_per_order_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if primary_margin_per_order_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_per_order_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_per_order_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_per_order_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: primary_margin_per_order_html_month_target_mom_yoy{
    view_label: "Html combinations"
    group_label: "Primary margin per order"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ primary_margin_per_order_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ primary_margin_per_order_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1007?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Primary margin per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{primary_margin_per_order_last_month_this_year._rendered_value}} </div>
      {% if primary_margin_per_order_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ primary_margin_per_order_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_per_order_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ primary_margin_per_order_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if primary_margin_per_order_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ primary_margin_per_order_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_per_order_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ primary_margin_per_order_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if primary_margin_per_order_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_per_order_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif primary_margin_per_order_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_per_order_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#PRIMARY MARGIN AS PERCENT OF SALES
  measure: primary_margin_perc_sales_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Primary margin % sales"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> Primary margin % sales </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{primary_margin_perc_sales_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{primary_margin_perc_sales_wtd_this_year._rendered_value}} </div>
        {% if primary_margin_perc_sales_wtd_wow_abs._value > 0 %}
      <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ primary_margin_perc_sales_wtd_wow_abs._rendered_value  }}p <font color="#00B900"> ▲ </font> </div>
        {% elsif primary_margin_perc_sales_wtd_wow_abs._value <= 0 %}
      <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ primary_margin_perc_sales_wtd_wow_abs._rendered_value  }}p <font color="#E50000"> ▼ </font> </div>
        {% endif %}
        {% if primary_margin_perc_sales_wtd_yoy_abs._value > 0 %}
      <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_perc_sales_wtd_yoy_abs._rendered_value  }}p <font color="#00B900"> ▲ </font> </div>
        {% elsif primary_margin_perc_sales_wtd_yoy_abs._value <= 0 %}
      <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ primary_margin_perc_sales_wtd_yoy_abs._rendered_value  }}p <font color="#E50000"> ▼ </font> </div>
        {% endif %}
    </div>  ;;
  }

#MARGIN
  measure: margin_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Margin"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ margin_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ margin_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/3954?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Product margin incl all SA's </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{margin_last_week_this_year._rendered_value}} </div>
      {% if margin_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: margin_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Margin"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ margin_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ margin_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/3962?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Product margin incl all SA's </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{margin_last_month_this_year._rendered_value}} </div>
      {% if margin_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ margin_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ margin_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: margin_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Margin"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 30px;"> Product margin </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 20px; line-height : 20px;"> {{margin_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{margin_wtd_this_year._rendered_value}} </div>
      {% if margin_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#MARGIN AS PERCENT OF SALES
  measure: margin_perc_html_week_target_wow_yoy_abs {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Last week - delta yoy/wow/target absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{margin_perc_last_week_this_year._rendered_value}} </div>
      {% if margin_perc_yoy_week._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{margin_perc_yoy_week._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_yoy_week._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{margin_perc_yoy_week._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_wow_abs._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_perc_wow_abs._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_wow_abs._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_perc_wow_abs._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_delta_target._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_delta_target._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: margin_perc_html_week_target {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Last week margin - delta target"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{margin_perc_last_week_this_year._rendered_value}} </div>
      {% if margin_perc_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_delta_target._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_delta_target._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: margin_perc_html_wtd {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Week to date - deltas with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{margin_perc_wtd_this_year._rendered_value}} </div>
      {% if margin_perc_wtd_yoy_abs._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{margin_perc_wtd_yoy_abs._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_wtd_yoy_abs._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{margin_perc_wtd_yoy_abs._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_wtd_wow_abs._value > 0 %}
      <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{margin_perc_wtd_wow_abs._rendered_value}} <font color="#00B900"> ▲ </font> </div>
        {% elsif margin_perc_wtd_wow_abs._value <= 0 %}
      <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{margin_perc_wtd_wow_abs._rendered_value}} <font color="#E50000"> ▼ </font> </div>
        {% endif %}
    </div>;;
  }

  measure: margin_perc_html_month_target_mom_yoy_abs {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Last month - delta yoy/mom/target absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{margin_perc_last_month_this_year._rendered_value}} </div>
      {% if margin_perc_yoy_month._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{margin_perc_yoy_month._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_yoy_month._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{margin_perc_yoy_month._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_mom_abs._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{ margin_perc_mom_abs._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_mom_abs._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{ margin_perc_mom_abs._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_month_delta_target._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_month_delta_target._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: margin_perc_html_month_target {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Last month margin - delta target"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{margin_perc_last_month_this_year._rendered_value}} </div>
      {% if margin_perc_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_month_delta_target._rendered_value}} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{margin_perc_month_delta_target._rendered_value}} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: margin_perc_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 30px;"> Product margin % sales </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{margin_perc_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{margin_perc_wtd_this_year._rendered_value}} </div>
      {% if margin_perc_wtd_wow_abs._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_perc_wtd_wow_abs._rendered_value  }}p <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_wtd_wow_abs._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_perc_wtd_wow_abs._rendered_value  }}p <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_wtd_yoy_abs._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_perc_wtd_yoy_abs._rendered_value  }}p <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_wtd_yoy_abs._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_perc_wtd_yoy_abs._rendered_value  }}p <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: margin_perc_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ margin_perc_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ margin_perc_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/3957?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Product margin % sales </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{margin_perc_last_week_this_year._rendered_value}} </div>
      {% if margin_perc_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_perc_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_perc_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_wow_abs._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_perc_wow_abs._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_wow_abs._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ margin_perc_wow_abs._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_yoy_week._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_perc_yoy_week._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_yoy_week._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_perc_yoy_week._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: margin_perc_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Margin %"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ margin_perc_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ margin_perc_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/3963?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Product margin % sales </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{margin_perc_last_month_this_year._rendered_value}} </div>
      {% if margin_perc_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_perc_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ margin_perc_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_mom_abs._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ margin_perc_mom_abs._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_mom_abs._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ margin_perc_mom_abs._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if margin_perc_yoy_month._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_perc_yoy_month._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif margin_perc_yoy_month._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ margin_perc_yoy_month._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#ATTACHED MARGIN PER ORDER
  measure: attached_margin_per_order_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Attached margin per order"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> Attached margin per order </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{attached_margin_per_order_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{attached_margin_per_order_wtd_this_year._rendered_value}} </div>
      {% if attached_margin_per_order_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ attached_margin_per_order_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ attached_margin_per_order_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if attached_margin_per_order_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ attached_margin_per_order_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ attached_margin_per_order_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: attached_margin_per_order_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Attached margin per order"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ attached_margin_per_order_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ attached_margin_per_order_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/944?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Attached margin per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{attached_margin_per_order_last_week_this_year._rendered_value}} </div>
      {% if attached_margin_per_order_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ attached_margin_per_order_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ attached_margin_per_order_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if attached_margin_per_order_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ attached_margin_per_order_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ attached_margin_per_order_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if attached_margin_per_order_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ attached_margin_per_order_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ attached_margin_per_order_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: attached_margin_per_order_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Attached margin per order"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ attached_margin_per_order_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ attached_margin_per_order_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/989?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Attached margin per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{attached_margin_per_order_last_month_this_year._rendered_value}} </div>
      {% if attached_margin_per_order_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ attached_margin_per_order_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ attached_margin_per_order_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if attached_margin_per_order_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ attached_margin_per_order_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ attached_margin_per_order_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if attached_margin_per_order_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ attached_margin_per_order_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif attached_margin_per_order_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ attached_margin_per_order_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#SALES
  measure: sales_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ sales_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ sales_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/947?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Sales </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{sales_last_week_this_year._rendered_value}} </div>
      {% if sales_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ sales_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ sales_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: sales_html_week_target_wow_yoy_abs {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Last week - delta target/wow/yoy with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{sales_last_week_this_year._rendered_value}} </div>
      {% if sales_week_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{sales_week_yoy_abs._rendered_value}} ({{sales_week_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_week_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{sales_week_yoy_abs._rendered_value}} ({{sales_week_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{sales_wow_abs._rendered_value}} ({{ sales_wow._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{sales_wow_abs._rendered_value}} ({{ sales_wow._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_week_deviation_target._rendered_value}} ({{sales_week_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_week_deviation_target._rendered_value}} ({{sales_week_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: sales_html_week_target_abs {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Last week sales - delta target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{sales_last_week_this_year._rendered_value}} </div>
      {% if sales_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_week_deviation_target._rendered_value}} ({{sales_week_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_week_deviation_target._rendered_value}} ({{sales_week_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: sales_html_wtd {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Week to date - deltas with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{sales_wtd_this_year._rendered_value}} </div>
      {% if sales_wtd_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{sales_wtd_yoy_abs._rendered_value}} ({{sales_wtd_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{sales_wtd_yoy_abs._rendered_value}} ({{sales_wtd_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_wtd_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{sales_wtd_wow_abs._rendered_value}} ({{ sales_wtd_wow._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_wtd_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{sales_wtd_wow_abs._rendered_value}} ({{ sales_wtd_wow._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: sales_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ sales_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ sales_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1008?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Sales </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{sales_last_month_this_year._rendered_value}} </div>
      {% if sales_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ sales_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ sales_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ sales_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: sales_html_month_target_wow_yoy_abs {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Last month - delta target/mom/yoy with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{sales_last_month_this_year._rendered_value}} </div>
      {% if sales_month_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{sales_month_yoy_abs._rendered_value}} ({{sales_month_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_month_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{sales_month_yoy_abs._rendered_value}} ({{sales_month_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_mom._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{sales_mom_abs._rendered_value}} ({{ sales_mom._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_mom._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{sales_mom_abs._rendered_value}} ({{ sales_mom._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_month_deviation_target._rendered_value}} ({{sales_month_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_month_deviation_target._rendered_value}} ({{sales_month_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: sales_html_month_target_abs {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Last month sales - delta target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{sales_last_month_this_year._rendered_value}} </div>
      {% if sales_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_month_deviation_target._rendered_value}} ({{sales_month_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{sales_month_deviation_target._rendered_value}} ({{sales_month_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: sales_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Sales"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 30px;"> Sales </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 20px; line-height : 20px;"> {{sales_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{sales_wtd_this_year._rendered_value}} </div>
      {% if sales_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ sales_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ sales_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if sales_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif sales_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ sales_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#ORDERS
  measure: orders_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Orders"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ orders_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ orders_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/945?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Orders </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{orders_last_week_this_year._rendered_value}} </div>
      {% if orders_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ orders_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ orders_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if orders_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ orders_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ orders_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if orders_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ orders_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ orders_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: orders_html_week_target_yoy_abs {
    view_label: "Html combinations"
    group_label: "Orders"
    label: "Last week - delta yoy"
    type: count
    html:
    <div style="font-weight: 400; line-height : 40px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 5px; line-height : 25px;"> {{orders_last_week_this_year._rendered_value}} </div>
      {% if orders_week_yoy._value > 0 %}
        <div style="font-size: 15px; padding : 0;  line-height : 25px;"> YoY {{orders_week_yoy_abs._rendered_value}} ({{orders_week_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_week_yoy._value <= 0 %}
        <div style="font-size: 15px; padding : 0;  line-height : 25px;"> YoY {{orders_week_yoy_abs._rendered_value}} ({{orders_week_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: orders_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Orders"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ orders_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ orders_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1006?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Orders </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{orders_last_month_this_year._rendered_value}} </div>
      {% if orders_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ orders_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ orders_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if orders_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ orders_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ orders_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if orders_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ orders_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ orders_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: orders_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Orders"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 30px;"> Orders </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 20px; line-height : 20px;"> {{orders_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{orders_wtd_this_year._rendered_value}} </div>
      {% if orders_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ orders_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ orders_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if orders_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ orders_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif orders_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ orders_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#TRANSACTION MARGIN
  measure: transaction_margin_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> Transaction margin </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 20px; line-height : 20px;"> {{transaction_margin_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{transaction_margin_wtd_this_year._rendered_value}} </div>
      {% if transaction_margin_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_html_week_yoy_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Last week - delta yoy"
    type: count
    html:
    <div style="font-weight: 400; line-height : 40px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 5px; line-height : 25px;"> {{transaction_margin_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_last_week_yoy._value > 0 %}
        <div style="font-size: 15px; padding : 0;  line-height : 25px;"> YoY {{transaction_margin_last_week_yoy_abs._rendered_value}} ({{transaction_margin_last_week_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_last_week_yoy._value <= 0 %}
        <div style="font-size: 15px; padding : 0;  line-height : 25px;"> YoY {{transaction_margin_last_week_yoy_abs._rendered_value}} ({{transaction_margin_last_week_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: transaction_margin_html_week_target_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Last week tm - delta target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_week_deviation_target._rendered_value}} ({{transaction_margin_week_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_week_deviation_target._rendered_value}} ({{transaction_margin_week_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_html_wtd {
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Week to date - deltas with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_wtd_this_year._rendered_value}} </div>
      {% if transaction_margin_wtd_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_wtd_yoy_abs._rendered_value}} ({{transaction_margin_wtd_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_wtd_yoy_abs._rendered_value}} ({{transaction_margin_wtd_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
       {% if transaction_margin_wtd_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{transaction_margin_wtd_wow_abs._rendered_value}} ({{ transaction_margin_wtd_wow._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_wtd_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{transaction_margin_wtd_wow_abs._rendered_value}} ({{ transaction_margin_wtd_wow._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

  measure: transaction_margin_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ transaction_margin_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ transaction_margin_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1379?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Transaction margin </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{transaction_margin_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_last_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_last_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_last_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_last_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ transaction_margin_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ transaction_margin_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1387?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Transaction margin </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{transaction_margin_last_month_this_year._rendered_value}} </div>
      {% if transaction_margin_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ transaction_margin_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ transaction_margin_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_last_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_last_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_last_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_last_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_html_month_target_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin"
    label: "Last month tm - delta target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_last_month_this_year._rendered_value}} </div>
      {% if transaction_margin_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_month_deviation_target._rendered_value}} ({{transaction_margin_month_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_month_deviation_target._rendered_value}} ({{transaction_margin_month_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#TRANSACTION MARGIN PER ORDER
  measure: transaction_margin_per_order_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last week - delta target/wow/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ transaction_margin_per_order_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ transaction_margin_per_order_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/939?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Transaction margin per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{transaction_margin_per_order_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_per_order_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_per_order_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_per_order_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_per_order_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_per_order_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_per_order_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_week_target_yoy_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last week - delta yoy"
    type: count
    html:
    <div style="font-weight: 400; line-height : 40px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 5px; line-height : 25px;"> {{transaction_margin_per_order_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_week_yoy._value > 0 %}
        <div style="font-size: 15px; padding : 0;  line-height : 25px;"> YoY {{transaction_margin_per_order_week_yoy_abs._rendered_value}} ({{transaction_margin_per_order_week_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_week_yoy._value <= 0 %}
        <div style="font-size: 15px; padding : 0;  line-height : 25px;"> YoY {{transaction_margin_per_order_week_yoy_abs._rendered_value}} ({{transaction_margin_per_order_week_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_week_target_wow_yoy_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last week - delta yoy/wow/target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_per_order_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_week_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_per_order_week_yoy_abs._rendered_value}} ({{transaction_margin_per_order_week_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_week_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_per_order_week_yoy_abs._rendered_value}} ({{transaction_margin_per_order_week_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{transaction_margin_per_order_wow_abs._rendered_value}} ({{ transaction_margin_per_order_wow._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{transaction_margin_per_order_wow_abs._rendered_value}} ({{ transaction_margin_per_order_wow._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_week_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_week_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_week_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_week_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_week_target_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last week tmpo - delta target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_per_order_last_week_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_week_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_week_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_week_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_week_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_week_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_week_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last month - delta target/mom/yoy"
    type: count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ transaction_margin_per_order_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ transaction_margin_per_order_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1011?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Transaction margin per order </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{transaction_margin_per_order_last_month_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_per_order_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ transaction_margin_per_order_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ transaction_margin_per_order_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ transaction_margin_per_order_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_per_order_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_per_order_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_month_target_mom_yoy_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last month - delta yoy/mom/target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_per_order_last_month_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_month_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_per_order_month_yoy_abs._rendered_value}} ({{transaction_margin_per_order_month_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_month_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_per_order_month_yoy_abs._rendered_value}} ({{transaction_margin_per_order_month_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_mom._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{transaction_margin_per_order_mom_abs._rendered_value}} ({{ transaction_margin_per_order_mom._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_mom._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> MoM {{transaction_margin_per_order_mom_abs._rendered_value}} ({{ transaction_margin_per_order_mom._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_month_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_month_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_month_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_month_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_month_target_abs {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Last month tmpo - delta target with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_per_order_last_month_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_month_delta_target._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_month_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_month_delta_target._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_month_delta_target._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> Target {{transaction_margin_per_order_month_delta_target_abs._rendered_value}} ({{transaction_margin_per_order_month_delta_target._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> Transaction margin per order </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_per_order_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;">{{transaction_margin_per_order_wtd_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_per_order_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ transaction_margin_per_order_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if transaction_margin_per_order_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_per_order_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ transaction_margin_per_order_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: transaction_margin_per_order_html_wtd {
    view_label: "Html combinations"
    group_label: "Transaction margin per order"
    label: "Week to date - deltas with absolute numbers"
    type: count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; padding : 0; margin-bottom : 10px; line-height : 20px;"> {{transaction_margin_per_order_wtd_this_year._rendered_value}} </div>
      {% if transaction_margin_per_order_wtd_yoy._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_per_order_wtd_yoy_abs._rendered_value}} ({{transaction_margin_per_order_wtd_yoy._rendered_value}}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> YoY {{transaction_margin_per_order_wtd_yoy_abs._rendered_value}} ({{transaction_margin_per_order_wtd_yoy._rendered_value}}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
       {% if transaction_margin_per_order_wtd_wow._value > 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{transaction_margin_per_order_wtd_wow_abs._rendered_value}} ({{ transaction_margin_per_order_wtd_wow._rendered_value  }}) <font color="#00B900"> ▲ </font> </div>
      {% elsif transaction_margin_per_order_wtd_wow._value <= 0 %}
        <div style="font-size: 13px; padding : 0; margin : 0; line-height : 20px;"> WoW {{transaction_margin_per_order_wtd_wow_abs._rendered_value}} ({{ transaction_margin_per_order_wtd_wow._rendered_value  }}) <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>;;
  }

#PRODUCTS SOLD
  measure: products_sold_html_week_target_wow_yoy {
    hidden: no
    view_label: "Html combinations"
    group_label: "Products sold"
    label: "Last week - delta target/wow/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ products_sold_drill_week_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ products_sold_drill_week_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/948?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Sold product quantity </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{products_sold_last_week_this_year._rendered_value}} </div>
      {% if products_sold_week_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ products_sold_week_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_week_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ products_sold_week_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if products_sold_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ products_sold_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ products_sold_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if products_sold_week_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ products_sold_week_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_week_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ products_sold_week_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: products_sold_html_month_target_mom_yoy {
    view_label: "Html combinations"
    group_label: "Products sold"
    label: "Last month - delta target/mom/yoy"
    type:  count
    link:{
      label: "Drill to Subproduct-type"
      url: "{{ products_sold_drill_month_subproducttype._link }}"
    }
    link:{
      label: "Drill to Product"
      url: "{{ products_sold_drill_month_product._link }}"
    }
    link: {
      url: "https://coolblue.cloud.looker.com/dashboards/1010?&Product+Type={{ _filters['producttype'] | url_encode }}&Subproduct+Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Subsidiary={{ _filters['subsidiary'] | url_encode }}&Customer+Type={{ _filters['customertype'] | url_encode }}&Team={{ _filters['team'] | url_encode }}&Focustype+(Yes+/+No)={{ _filters['focus_producttype'] | url_encode }}"
      label: "Go to the developments over time"
    }
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 16px; color:#0090e3; padding : 0; margin : 0; line-height : 20px;"> Sold product quantity </div>
      <div style="font-size: 20px;padding : 0; margin : 15px; line-height : 20px;"> {{products_sold_last_month_this_year._rendered_value}} </div>
      {% if products_sold_month_delta_target._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ products_sold_month_delta_target._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_month_delta_target._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> Target {{ products_sold_month_delta_target._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if products_sold_mom._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ products_sold_mom._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_mom._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> MoM {{ products_sold_mom._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if products_sold_month_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ products_sold_month_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_month_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ products_sold_month_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

  measure: products_sold_html_yesterday_wtd_wow_yoy {
    view_label: "Html combinations"
    group_label: "Products sold"
    label: "Yesterday - wtd wow/yoy"
    type:  count
    html:
    <div style="font-weight: 400; line-height : 150px;">
      <div style="font-size: 20px; color:#0090e3; padding : 0; margin-bottom : 10px; line-height : 25px;"> SPQ </div>
      <div style="font-weight: 300; font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> Yesterday </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 10px; line-height : 20px;"> {{products_sold_yesterday_this_year._rendered_value}} </div>
      <div style="font-size: 16px; color:#DDDDDD; padding : 0; margin-bottom : 5px; line-height : 16px;"> WtD Week total </div>
      <div style="font-size: 20px;padding : 0; margin-bottom : 5px; line-height : 20px;">{{products_sold_wtd_this_year._rendered_value}} </div>
      {% if products_sold_wtd_wow._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ products_sold_wtd_wow._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_wtd_wow._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> WoW {{ products_sold_wtd_wow._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
      {% if products_sold_wtd_yoy._value > 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ products_sold_wtd_yoy._rendered_value  }} <font color="#00B900"> ▲ </font> </div>
      {% elsif products_sold_wtd_yoy._value <= 0 %}
        <div style="font-size: 13px;padding : 0; margin : 0; line-height : 20px;"> YoY {{ products_sold_wtd_yoy._rendered_value  }} <font color="#E50000"> ▼ </font> </div>
      {% endif %}
    </div>  ;;
  }

#----------- Filter buttons --------------#

  dimension: weekly_results_navigation_buttons {
    label: "Navigation for weekly results dashboard"
    view_label: "Navigation"
    can_filter: no
    type: string
    sql: "" ;;
    html: <div style=" padding: 2px">
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/2619?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Main overview YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/2002?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Sales deepdive YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/2196?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Margin deepdive YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/7409?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>TMpO deepdive YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/4084?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Main overview WoW</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/2042?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Sales deepdive WoW</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/2375?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Margin deepdive WoW</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/8143?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>TMpO deepdive WoW</b>
          </a>
          <a style="
            color: #FFFFFF; background-color:  #0090E3; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.atlassian.net/wiki/spaces/CMGT/pages/42351637/Looker+Data+and+Dashboards">
            <b>Confluence</b>
          </a></div>;;
  }

  dimension: monthly_results_navigation_buttons {
    label: "Navigation for monthly results dashboard"
    view_label: "Navigation"
    can_filter: no
    type: string
    sql: "" ;;
    html: <div style=" padding: 2px">
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/3820?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet+type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Main overview YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/8782?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet+type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Main overview YtD</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/3881?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Sales deepdive YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/3951?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Margin deepdive YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/8157?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>TMpO deepdive YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/4072?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Main overview MoM</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/3994?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Sales deepdive MoM</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/4037?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>Margin deepdive MoM</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/8160?Team={{ _filters['commercial_results.team'] | url_encode }}&Customer%20type={{ _filters['commercial_results.customertype'] | url_encode }}&Product%20Type={{ _filters['commercial_results.producttype'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Outlet%20type={{ _filters['commercial_results.outlettype'] | url_encode }}&Subproduct%20Type={{ _filters['commercial_results.subproducttype'] | url_encode }}">
            <b>TMpO deepdive MoM</b>
          </a>
          <a style="
            color: #FFFFFF; background-color:  #0090E3; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.atlassian.net/wiki/spaces/CMGT/pages/42351637/Looker+Data+and+Dashboards">
            <b>Confluence</b>
          </a></div>;;
  }

  dimension: daily_results_navigation_buttons {
    label: "Navigation for daily results dashboard"
    view_label: "Navigation"
    can_filter: no
    type: string
    sql: "" ;;
    html: <div style=" padding: 2px">
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/7602?Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Team={{ _filters['commercial_results.team'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}">
            <b>Week to date overview YoY</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/7601?Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Team={{ _filters['commercial_results.team'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}">
            <b>Week to date overview WoW</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/1122?Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Team={{ _filters['commercial_results.team'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}">
            <b>Key metrics overview</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/1213?Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Team={{ _filters['commercial_results.team'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}">
            <b>Sales deepdive</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/1239?Product+Type={{ _filters['commercial_results.producttype'] | url_encode }}&Customer+type={{ _filters['commercial_results.customertype'] | url_encode }}&Team={{ _filters['commercial_results.team'] | url_encode }}&Subproduct+Type={{ _filters['commercial_results.subproducttype'] | url_encode }}&Brand={{ _filters['commercial_results.brand'] | url_encode }}&Subsidiary={{ _filters['commercial_results.subsidiary'] | url_encode }}">
            <b>Margin deepdive</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/1364">
            <b>Bleeders deepdive</b>
          </a>
            <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="/dashboards/4174">
            <b>Stock insights</b>
          </a>
          <a style="
            color: #FFFFFF; background-color:  #0090E3; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.atlassian.net/wiki/spaces/CMGT/pages/42351637/Looker+Data+and+Dashboards">
            <b>Confluence</b>
          </a></div>;;
  }

  dimension: commercial_targets_navigation_buttons {
    #Does not work if used in the gfk_commercial_targets_explore
    label: "Navigation for Aimy"
    view_label: "Navigation"
    can_filter: no
    type: string
    sql: "" ;;
    html: <div style=" padding: 2px">
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.cloud.looker.com/dashboards/7392?Team={{ _filters['team'] | url_encode }}&Product%20Type={{ _filters['producttype'] | url_encode }}&Subproduct%20Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Country={{ _filters['subsidiary_country'] | url_encode }}">
            <b>Commercial Targets Overview</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.cloud.looker.com/dashboards/7430?Team={{ _filters['team'] | url_encode }}&Product%20Type={{ _filters['producttype'] | url_encode }}&Subproduct%20Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Country={{ _filters['subsidiary_country'] | url_encode }}">
            <b>Year to Date Team Results</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.cloud.looker.com/dashboards/6932?Team={{ _filters['team'] | url_encode }}&Product%20Type={{ _filters['producttype'] | url_encode }}&Subproduct%20Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Country={{ _filters['subsidiary_country'] | url_encode }}">
            <b>Trend lines: Weekly Trends</b>
          </a>
          <a style="
            color: #0090E3; background-color:  #FFFFFF; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.cloud.looker.com/dashboards/6937?Team={{ _filters['team'] | url_encode }}&Product%20Type={{ _filters['producttype'] | url_encode }}&Subproduct%20Type={{ _filters['subproducttype'] | url_encode }}&Brand={{ _filters['brand'] | url_encode }}&Country={{ _filters['subsidiary_country'] | url_encode }}">
            <b>Trend lines: Monthly Trends</b>
          </a>
          <a style="
            color: #FFFFFF; background-color:  #0090E3; border: solid 1px #C1C6CC;
            font-weight: 400; font-size: 2ex;
            float: left; text-align: center; vertical-align: middle;
            padding: 10px; margin: 5px; line-height: 1.2; border-radius: 5px;
            cursor: pointer; user-select: none;"
            href="https://coolblue.atlassian.net/wiki/spaces/CMGT/pages/42351637/Looker+Data+and+Dashboards">
            <b>Confluence</b>
          </a></div>;;
  }

#----------- Custom Dimensions --------------#
#Fit into model because custom dimensions ignore aggregate tables
  dimension: custom_header_actual {
    label: "Custom Header: Actuals"
    view_label: "Headers"
    type: string
    sql: "Actual" ;;
  }
  dimension: custom_header_yoy {
    label: "Custom Header: YoY"
    view_label: "Headers"
    type: string
    sql: "YoY-%" ;;
  }
  dimension: custom_header_tgt {
    label: "Custom Header: Target"
    view_label: "Headers"
    type: string
    sql: "TGT-%" ;;
  }

# ---------------------------- Sets for aggregate tables --------------------------#

  set: agg_html_week_set {
    fields: [
      sales_last_week_and_wow,
      products_sold_last_week_and_wow,
      gross_profit_impact_distributed_html_week_target_wow_yoy,
      gross_profit_impact_distributed_html_week_target_wow_yoy_abs,
      visibility_cost_distributed_html_week_target_wow_yoy,
      sales_marketing_cost_html_week_target_wow_yoy,
      partner_marketing_cost_html_week_target_wow_yoy,
      additional_marketing_income_html_week_target_wow_yoy,
      variable_cost_per_order_html_week_target_wow_yoy,
      average_sales_price_html_week_target_wow_yoy,
      margin_html_week_target_wow_yoy,
      margin_perc_html_week_target_wow_yoy,
      margin_perc_html_week_target_wow_yoy_abs,
      primary_margin_per_order_html_week_target_wow_yoy,
      attached_margin_per_order_html_week_target_wow_yoy,
      sales_html_week_target_wow_yoy_abs,
      sales_html_week_target_wow_yoy,
      transaction_margin_per_order_html_week_target_wow_yoy,
      transaction_margin_per_order_html_week_target_wow_yoy_abs,
      transaction_margin_per_order_html_week_target_yoy_abs,
      transaction_margin_html_week_yoy_abs,
      transaction_margin_html_week_target_wow_yoy,
      orders_html_week_target_wow_yoy,
      orders_html_week_target_yoy_abs,
      products_sold_html_week_target_wow_yoy,
      last_week_tile,
      last_week_vs_last_year,
      last_week_vs_two_weeks_ago,
    ]
  }

  set: agg_html_month_set {
    fields: [
      gross_profit_impact_distributed_html_month_target_mom_yoy,
      gross_profit_impact_distributed_html_month_target_mom_yoy_abs,
      visibility_cost_distributed_html_month_target_mom_yoy,
      sales_marketing_cost_html_month_target_mom_yoy,
      partner_marketing_cost_html_month_target_mom_yoy,
      additional_marketing_income_html_month_target_mom_yoy,
      variable_cost_per_order_html_month_target_mom_yoy,
      average_sales_price_html_month_target_mom_yoy,
      primary_margin_per_order_html_month_target_mom_yoy,
      attached_margin_per_order_html_month_target_mom_yoy,
      sales_html_month_target_mom_yoy,
      sales_html_month_target_wow_yoy_abs,
      transaction_margin_html_month_target_mom_yoy,
      transaction_margin_per_order_html_month_target_mom_yoy,
      transaction_margin_per_order_html_month_target_mom_yoy_abs,
      orders_html_month_target_mom_yoy,
      products_sold_html_month_target_mom_yoy,
      margin_html_month_target_mom_yoy,
      margin_perc_html_month_target_mom_yoy,
      margin_perc_html_month_target_mom_yoy_abs,
      last_month_tile,
      last_month_vs_last_year,
      last_month_vs_two_months_ago,
    ]
  }

  set: agg_html_yesterday_set {
    fields: [
      average_sales_price_html_yesterday_wtd_wow_yoy,
      primary_margin_perc_sales_html_yesterday_wtd_wow_yoy,
      attached_margin_per_order_html_yesterday_wtd_wow_yoy,
      sales_html_yesterday_wtd_wow_yoy,
      transaction_margin_html_yesterday_wtd_wow_yoy,
      products_sold_html_yesterday_wtd_wow_yoy,
    ]
  }

  set: agg_html_effect_metric_set {
    fields: [
      sales_html_week_target_abs,
      margin_perc_html_week_target,
      transaction_margin_per_order_html_week_target_abs,
      transaction_margin_html_week_target_abs,
      sales_html_month_target_abs,
      margin_perc_html_month_target,
      transaction_margin_per_order_html_month_target_abs,
      transaction_margin_html_month_target_abs
    ]
  }

  set: agg_html_wtd_comparison_set {
    fields: [
      sales_html_yesterday_wtd_wow_yoy,
      sales_html_wtd,
      products_sold_html_yesterday_wtd_wow_yoy,
      average_sales_price_html_yesterday_wtd_wow_yoy,
      margin_perc_html_yesterday_wtd_wow_yoy,
      margin_perc_html_wtd,
      transaction_margin_per_order_html_yesterday_wtd_wow_yoy,
      transaction_margin_per_order_html_wtd,
      transaction_margin_html_yesterday_wtd_wow_yoy,
      transaction_margin_html_wtd,
    ]
  }

  set: set_custom_headers {
    fields: [
      custom_header_actual,
      custom_header_yoy,
      custom_header_tgt
    ]
  }
}
