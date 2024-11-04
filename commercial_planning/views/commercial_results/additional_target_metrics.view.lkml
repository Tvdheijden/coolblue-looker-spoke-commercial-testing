view: additional_target_metrics {
  sql_table_name: `coolblue-operations-prod.category_mgmt.additional_target_metrics_last_month`
    ;;
  fields_hidden_by_default: yes   #in Production fields are always hidden by default

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: CONCAT(${TABLE}.month, "-", ${TABLE}.subsidiaryid, "-", ${TABLE}.teamid) ;;
  }

#----------------- Dimensions ------------------#

  dimension_group: date {
    hidden: yes
    description: "Date Target Set"
    label: ""
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
    sql: ${TABLE}.month ;;
  }

  dimension: is_last_month {
    label: "Is Last Month"
    group_label: "Month Filters"
    view_label: "Date filters"
    type: yesno
    hidden: yes
    sql: DATE_TRUNC(${date_date}, MONTH) = DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 MONTH), MONTH) ;;
  }

  dimension: subsidiary_country {
    hidden: yes
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
    hidden: yes
    description: "Example: Team Laptops, Desktops & Accessoires"
    label: "Team"
    group_label: "Team"
    view_label: "Product dimensions"
    type: string
    sql: ${TABLE}.team ;;
  }

  dimension: team_shortened {
    hidden: yes
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

  #------------------ Dimensions Targets ---------------#

  dimension: gross_profit_impact_target {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_profit_impact_target ;;
  }

  dimension: visibility_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.brand_marketing_cost_target ;;
  }

  dimension: additional_marketing_income_target {
    hidden: yes
    type: number
    sql: ${TABLE}.additional_marketing_income_target ;;
  }

  dimension: partner_marketing_cost_target {
    hidden: yes
    type: number
    sql: ${TABLE}.partner_marketing_cost_target ;;
  }

  #-------------- Measures -------------------#

  measure: gross_profit_impact_last_month_target {
    label: "Last month target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    hidden: yes
    sql: SUM (DISTINCT ${gross_profit_impact_target}) ;;
  }

  measure: additional_marketing_income_last_month_target {
    label: "Last month target additional marketing income"
    group_label: "Additional Marketing Income Target"
    view_label: "Period on period calculations"
    type: sum_distinct
    value_format: "€#,##0"
    hidden: yes
    sql: ${additional_marketing_income_target} ;;
  }

  measure: partner_marketing_cost_last_month_target {
    label: "Last month target partner marketing cost"
    group_label: "Partner Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum_distinct
    value_format: "€#,##0"
    hidden: yes
    sql: ${partner_marketing_cost_target} ;;
  }

  measure: visibility_cost_last_month_target {
    label: "Last month target Brand marketing cost"
    group_label: "Brand Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum_distinct
    value_format: "€#,##0"
    hidden: yes
    sql: ${visibility_cost_target} ;;
  }

}
