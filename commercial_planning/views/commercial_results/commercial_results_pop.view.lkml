# General settings for view
include: "/commercial_planning/views/commercial_results/commercial_results.view.lkml"
include: "/commercial_planning/views/commercial_results/additional_target_metrics.view.lkml"

view: +commercial_results {
  label: "Period over Period Calculations"

#----------- Date dimensions for period on period calculations --------------#

  dimension_group: current_date_minus_one {
    label: "Current date"
    view_label: "Date filters"
    description: "The date that is used for period over period comparisons"
    type: time
    convert_tz: no
    timeframes: [
      date,
      month,
      day_of_month,
      day_of_week,
      day_of_week_index,
      week,
      week_of_year,
      day_of_year,
      quarter,
      year,
    ]
    sql: DATE_ADD(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, ISOYEAR), INTERVAL DATE_DIFF(CURRENT_DATE('Europe/Amsterdam')-1, DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam')-1, ISOYEAR), DAY) DAY);; #We doen hier -1 zodat er op maandag nog gekeken wordt naar de vorige volledige week/maand
  }

# Yesterday
  dimension: is_yesterday {
    label: "Is Yesterday"
    group_label: "Day Filters"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_date} = ${current_date_minus_one_date};;
  }

  dimension: is_yesterday_previous_year {
    label: "Is Yesterday Previous Year"
    group_label: "Day Filters"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_date} = DATE_ADD(DATE_TRUNC(DATE_SUB(${current_date_minus_one_date}, INTERVAL 52 WEEK), ISOYEAR), INTERVAL DATE_DIFF(${current_date_minus_one_date}, DATE_TRUNC(${current_date_minus_one_date}, ISOYEAR), DAY) DAY);;
  }

# Week
  dimension: is_last_isoweek {
    label: "Is Last Week"
    group_label: "Week Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, ISOWEEK) = DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 7 DAY), ISOWEEK);;
  }

  dimension: is_last_week { #Get a line for the previous completed week compared to last week to date
    label: "Is Last Week"
    group_label: "Week Filters"
    view_label: "Date Filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, ISOWEEK) = DATE_TRUNC(DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY), INTERVAL 1 WEEK), ISOWEEK) ;;
  }

  dimension: is_last_week_last_year { #Get a line for the same week last year compared to last week to date
    label: "Is Last Week Last Year"
    group_label: "Week Filters"
    view_label: "Date Filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, ISOWEEK) = DATE_TRUNC(DATE_SUB(${current_date_minus_one_date}, INTERVAL 52 WEEK), ISOWEEK) ;;
  }

  dimension: is_two_isoweeks_ago {
    label: "Is Two Weeks Ago"
    group_label: "Week Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, ISOWEEK) = DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 14 DAY), ISOWEEK) ;;
  }

  dimension: is_last_isoweek_last_year {
    label: "Is Last Week Last Year"
    group_label: "Week Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date},ISOWEEK) = DATE_TRUNC(DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 7 DAY), INTERVAL 52 WEEK), ISOWEEK) ;;
  }

  dimension: is_current_isoweek_last_year {
    label: "Is Current Week Last Year"
    group_label: "Week Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, ISOWEEK) = DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 YEAR), ISOWEEK);;
  }

  dimension: isoweek_sort_last_10_weeks {
    label: "Last 10 weeks"
    group_label: "Week sorting"
    view_label: "Sorting measures"
    type:  number
    sql:  case when ${isoweek} > EXTRACT(ISOWEEK FROM date_add(${current_date_minus_one_date}, INTERVAL 10 week)) then ${isoweek} - 100 else ${isoweek} end  ;;
  }

  dimension: isoweek_sort_last_20_weeks {
    label: "Last 20 weeks"
    group_label: "Week sorting"
    view_label: "Sorting measures"
    type:  number
    sql:  case when ${isoweek} > EXTRACT(ISOWEEK FROM date_add(${current_date_minus_one_date}, INTERVAL 20 week)) then ${isoweek} - 100 else ${isoweek} end  ;;
  }

# WtD
  dimension: is_wtd {
    label: "Is Week to Date"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_date} <= ${current_date_minus_one_date} AND ${date_week} = ${current_date_minus_one_week};;
  }

  dimension: is_wtd_last_week {
    label: "Is Week to Date Previous Week"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_day_of_week_index} <= ${current_date_minus_one_day_of_week_index} AND DATE_TRUNC(${date_date},ISOWEEK) = DATE_TRUNC(DATE_SUB(${current_date_minus_one_date}, INTERVAL 1 WEEK), ISOWEEK) ;;
  }

  dimension: is_wtd_previous_year {
    label: "Is Week to Date Previous Year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql:  ${date_day_of_week_index} <= ${current_date_minus_one_day_of_week_index}
      AND DATE_TRUNC(${date_date},ISOWEEK) = DATE_TRUNC(DATE_SUB(${current_date_minus_one_date}, INTERVAL 52 WEEK), ISOWEEK);;
  }

# Month
  dimension: is_last_month {
    label: "Is Last Month"
    group_label: "Month Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, MONTH) = DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 MONTH), MONTH) ;;
  }

  dimension: is_last_month_previous_year {
    label: "Is Last Month Previous Year"
    group_label: "Month Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, MONTH) = DATE_TRUNC(DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 MONTH), INTERVAL 1 YEAR), MONTH) ;;
  }

  dimension: is_two_months_ago {
    label: "Is Two Months Ago"
    group_label: "Month Filters"
    view_label: "Date filters"
    type: yesno
    sql: DATE_TRUNC(${date_date}, MONTH) = DATE_TRUNC(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 2 MONTH), MONTH) ;;
  }

# MtD
  dimension: is_mtd {
    label: "MTD this year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: ${date_date} <= ${current_date_minus_one_date} AND DATE_TRUNC(${date_date}, MONTH) = DATE_TRUNC(${current_date_minus_one_date}, MONTH) ;;
  }

  dimension: is_mtd_previous_year {
    label: "MTD last year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: ${date_date} <= DATE_SUB(${current_date_minus_one_date}, INTERVAL 1 YEAR) AND ${date_date} >= DATE_TRUNC(DATE_SUB(${current_date_minus_one_date}, INTERVAL 1 YEAR), MONTH) ;;
  }

# Quarter
  dimension: is_qtd {
    label: "QTD this year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: ${date_date} <= ${current_date_minus_one_date} AND ${date_date} >= DATE_TRUNC(${current_date_minus_one_date}, QUARTER) ;;
  }

  dimension: is_qtd_previous_year {
    label: "QTD last year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: ${date_date} <= DATE_SUB(${current_date_minus_one_date}, INTERVAL 1 YEAR) AND ${date_date} >= DATE_TRUNC(DATE_SUB(${current_date_minus_one_date}, INTERVAL 1 YEAR), QUARTER) ;;
  }

# Year
  dimension: is_current_year {
    label: "Is Current Year"
    group_label: "Year Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(ISOYEAR FROM ${date_date}) = EXTRACT(ISOYEAR FROM DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY));;  #in week 1 omzetten naar 7 DAY om nog laatste week van dec te zien
  }

  dimension: is_current_year_not_iso {
    label: "Is Current (non iso) Year"
    group_label: "Year Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(YEAR FROM ${date_date}) = EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY));; #in week 1 omzetten naar 7 DAY om nog laatste week van dec te zien
  }

  dimension: is_last_year {
    label: "Is Last Year"
    group_label: "Year Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(ISOYEAR FROM ${date_date}) = EXTRACT(ISOYEAR FROM DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY),INTERVAL 52 WEEK));; #in week 1 omzetten naar 7 DAY om nog laatste week van dec te zien
  }

  dimension: is_last_year_not_iso {
    label: "Is Last (non iso) Year"
    group_label: "Year Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(YEAR FROM ${date_date}) = EXTRACT(YEAR FROM DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY),INTERVAL 52 WEEK));; #in week 1 omzetten naar 7 DAY om nog laatste week van dec te zien
  }

  dimension: is_two_years_ago {
    label: "Is two years ago"
    group_label: "Year Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(ISOYEAR FROM ${date_date}) = EXTRACT(ISOYEAR FROM DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY),INTERVAL 104 WEEK));; #in week 1 omzetten naar 7 DAY om nog laatste week van dec te zien
  }

  dimension: is_two_years_ago_not_iso {
    label: "Is two (non iso) years ago"
    group_label: "Year Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(YEAR FROM ${date_date}) = EXTRACT(YEAR FROM DATE_SUB(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'),INTERVAL 1 DAY),INTERVAL 104 WEEK));; #in week 1 omzetten naar 7 DAY om nog laatste week van dec te zien
  }

#YTD
  dimension: is_ytd {
    label: "YTD this year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: ${date_day_of_year} <= ${current_date_minus_one_day_of_year} AND ${date_year} = ${current_date_minus_one_year} ;;
  }

  dimension: is_ytd_previous_year {
    label: "YTD last year"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: ${date_day_of_year} <= ${current_date_minus_one_day_of_year} AND EXTRACT(YEAR FROM ${date_date}) = EXTRACT(YEAR FROM DATE_SUB(${current_date_minus_one_date}, INTERVAL 1 YEAR)) ;;
  }

  dimension: is_ytd_last_month {
    label: "YTD this year last month"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(DAYOFYEAR FROM ${date_date}) <= EXTRACT(DAYOFYEAR FROM LAST_DAY(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 MONTH), MONTH)) AND EXTRACT(YEAR FROM ${date_date}) = EXTRACT(YEAR FROM DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH), INTERVAL 1 MONTH)) ;;
  }

  dimension: is_ytd_last_month_previous_year {
    label: "YTD last year last month"
    group_label: "To-Date Filters"
    view_label: "Date filters"
    type: yesno
    sql: EXTRACT(DAYOFYEAR FROM ${date_date}) <= EXTRACT(DAYOFYEAR FROM LAST_DAY(DATE_SUB(CURRENT_DATE('Europe/Amsterdam'), INTERVAL 1 MONTH), MONTH)) AND EXTRACT(YEAR FROM ${date_date}) = EXTRACT(YEAR FROM DATE_SUB(DATE_SUB(DATE_TRUNC(CURRENT_DATE('Europe/Amsterdam'), MONTH), INTERVAL 1 MONTH), INTERVAL 1 YEAR)) ;;
  }

  dimension: week_filter_yesterdays_results {
    label: "Week filter for yesterday's results report"
    view_label: "Date filters"
    type: yesno
    sql: CASE
            WHEN EXTRACT (ISOWEEK FROM ${current_date_minus_one_date}) = 52 THEN (${date_week_of_year} >= 49 AND ${date_week_of_year} <= 52) AND ${isoyear} >= EXTRACT(ISOYEAR FROM ${current_date_minus_one_date})-2
            WHEN EXTRACT (ISOWEEK FROM ${current_date_minus_one_date}) = 53 THEN (${date_week_of_year} >= 50 AND ${date_week_of_year} <= 53) AND ${isoyear} >= EXTRACT(ISOYEAR FROM ${current_date_minus_one_date})-2
            WHEN EXTRACT (ISOWEEK FROM DATE_SUB(${current_date_minus_one_date}, INTERVAL 3 WEEK)) <= 0 THEN (${date_week_of_year} >= 1 AND ${date_week_of_year} <= 4) AND ${isoyear} >= EXTRACT(ISOYEAR FROM ${current_date_minus_one_date})-2
            ELSE (${date_week_of_year} >= EXTRACT(ISOWEEK FROM DATE_SUB(${current_date_minus_one_date}, INTERVAL 2 WEEK)) AND ${date_week_of_year} <= EXTRACT(ISOWEEK FROM DATE_ADD(${current_date_minus_one_date}, INTERVAL 1 WEEK))) AND ${isoyear} >= EXTRACT(ISOYEAR FROM ${current_date_minus_one_date})-2
            END;;
  }

#----------------------------- Period on period calculations --------------------------------#

#GROSS PROFIT IMPACT - WEEK
  measure: gross_profit_impact_distributed_last_week_this_year {
    label: "Last week gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_last_week_last_year {
    label: "Last week last year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_last_week_target {
    label: "Last week target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${gross_profit_impact_target} ;;
  }

  measure: gross_profit_impact_distributed_two_weeks_this_year {
    label: "Two weeks ago gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_wow {
    label: "Last week WoW growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_last_week_this_year}-${gross_profit_impact_distributed_two_weeks_this_year}), ABS(${gross_profit_impact_distributed_two_weeks_this_year})) ;;
  }

  measure: gross_profit_impact_distributed_wow_abs {
    label: "Absolute WoW growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${gross_profit_impact_distributed_last_week_this_year}-${gross_profit_impact_distributed_two_weeks_this_year};;
  }

  measure: gross_profit_impact_distributed_week_yoy {
    label: "Last week YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_last_week_this_year}-${gross_profit_impact_distributed_last_week_last_year}), ABS(${gross_profit_impact_distributed_last_week_last_year})) ;;
  }

  measure: gross_profit_impact_distributed_week_yoy_abs {
    label: "Absolute growth Last week YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${gross_profit_impact_distributed_last_week_this_year}-${gross_profit_impact_distributed_last_week_last_year} ;;
  }

#GROSS PROFIT IMPACT - MONTH
  measure: gross_profit_impact_distributed_last_month_this_year {
    label: "Last month gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_last_month_last_year {
    label: "Last month last year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_last_month_target {
    label: "Last month target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${gross_profit_impact_target} ;;
  }

  measure: gross_profit_impact_distributed_two_months_this_year {
    label: "Two months ago gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_mom {
    label: "Last month MoM growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_last_month_this_year}-${gross_profit_impact_distributed_two_months_this_year}), ABS(${gross_profit_impact_distributed_two_months_this_year})) ;;
  }

  measure: gross_profit_impact_distributed_mom_abs {
    label: "Absolute MoM growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${gross_profit_impact_distributed_last_month_this_year}-${gross_profit_impact_distributed_two_months_this_year};;
  }

  measure: gross_profit_impact_distributed_month_yoy {
    label: "Last month YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_last_month_this_year}-${gross_profit_impact_distributed_last_month_last_year}), ABS(${gross_profit_impact_distributed_last_month_last_year})) ;;
  }

  measure: gross_profit_impact_distributed_month_yoy_abs {
    label: "Absolute growth last month YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${gross_profit_impact_distributed_last_month_this_year}-${gross_profit_impact_distributed_last_month_last_year} ;;
  }

  measure: gross_profit_impact_distributed_week_delta_target {
    label: "Last week delta target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_last_week_this_year}-${gross_profit_impact_last_week_target}), ABS(${gross_profit_impact_last_week_target})) ;;
  }

  measure: gross_profit_impact_distributed_week_delta_target_abs {
    label: "Last week absolute delta target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${gross_profit_impact_distributed_last_week_this_year}-${gross_profit_impact_last_week_target} ;;
  }

  measure: gross_profit_impact_distributed_month_delta_target {
    label: "Last month delta target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_last_month_this_year}-${additional_target_metrics.gross_profit_impact_last_month_target}), ABS(${additional_target_metrics.gross_profit_impact_last_month_target})) ;;
  }

  measure: gross_profit_impact_distributed_month_delta_target_abs {
    label: "Last month absolute delta target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${gross_profit_impact_distributed_last_month_this_year}-${additional_target_metrics.gross_profit_impact_last_month_target} ;;
  }

#GROSS PROFIT IMPACT - MTD
  measure: gross_profit_impact_distributed_mtd_this_year {
    label: "MTD gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_mtd_last_year {
    label: "MTD last year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_mtd_yoy {
    label: "MTD YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_mtd_this_year}-${gross_profit_impact_distributed_mtd_last_year}), ABS(${gross_profit_impact_distributed_mtd_last_year})) ;;
  }

#GROSS PROFIT IMPACT - YEAR
  measure: gross_profit_impact_distributed_this_year {
    label: "Current year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year:"yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_this_year_not_iso {
    label: "Current (non iso) year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso:"yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_last_year {
    label: "Last year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year:"yes"]
    sql:  ${gross_profit_impact_distributed};;
  }

  measure: gross_profit_impact_distributed_last_year_not_iso {
    label: "Last (non iso) year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso:"yes"]
    sql:  ${gross_profit_impact_distributed};;
  }

  measure: gross_profit_impact_distributed_this_year_target {
    label: "Current year target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year:"yes"]
    sql: ${gross_profit_impact_target} ;;
  }

  measure: gross_profit_impact_distributed_this_year_target_not_iso{
    label: "Current (non iso) year target gross profit impact"
    group_label: "Gross Profit Impact Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso:"yes"]
    sql: ${gross_profit_impact_target} ;;
  }

#GROSS PROFIT IMPACT - QTD
  measure: gross_profit_impact_distributed_qtd_this_year {
    label: "QTD gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_qtd: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_qtd_last_year {
    label: "QTD last year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_qtd_yoy {
    label: "QTD YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_qtd_this_year}-${gross_profit_impact_distributed_qtd_last_year}), ABS(${gross_profit_impact_distributed_qtd_last_year})) ;;
  }

#GROSS PROFIT IMPACT - YTD
  measure: gross_profit_impact_distributed_ytd_this_year {
    label: "YTD gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_ytd_last_year {
    label: "YTD last year gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_ytd_yoy {
    label: "YTD YoY growth gross profit impact"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_ytd_this_year}-${gross_profit_impact_distributed_ytd_last_year}), ABS(${gross_profit_impact_distributed_ytd_last_year})) ;;
  }

  measure: gross_profit_impact_distributed_ytd_yoy_abs {
    label: "YTD YoY growth gross profit impact absolute"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${gross_profit_impact_distributed_ytd_this_year}-${gross_profit_impact_distributed_ytd_last_year} ;;
  }

  measure: gross_profit_impact_distributed_ytd_this_year_last_month {
    label: "YTD gross profit impact last month"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_ytd_last_year_last_month {
    label: "YTD last year gross profit impact last month"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month_previous_year: "yes"]
    sql:  ${gross_profit_impact_distributed} ;;
  }

  measure: gross_profit_impact_distributed_ytd_yoy_last_month {
    label: "YTD YoY growth gross profit impact last month"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${gross_profit_impact_distributed_ytd_this_year_last_month}-${gross_profit_impact_distributed_ytd_last_year_last_month}), ABS(${gross_profit_impact_distributed_ytd_last_year_last_month})) ;;
  }

  measure: gross_profit_impact_distributed_ytd_yoy_abs_last_month {
    label: "YTD YoY growth gross profit impact absolute last month"
    group_label: "Gross Profit Impact"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${gross_profit_impact_distributed_ytd_this_year_last_month}-${gross_profit_impact_distributed_ytd_last_year_last_month} ;;
  }

#VISIBILITY / BRAND MARKETING COST - WEEK
  measure: visibility_cost_distributed_last_week_this_year {
    label: "Last week brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${visibility_cost_distributed} ;;
  }

  measure: visibility_cost_distributed_last_week_last_year {
    label: "Last week last year brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${visibility_cost_distributed} ;;
  }

  measure: visibility_cost_last_week_target {
    label: "Last week target brand marketing cost"
    group_label: "Brand Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${visibility_cost_target} ;;
  }

  measure: visibility_cost_distributed_two_weeks_this_year {
    label: "Two weeks ago brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${visibility_cost_distributed} ;;
  }

  measure: visibility_cost_distributed_wow_abs {
    label: "Absolute WoW growth brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${visibility_cost_distributed_last_week_this_year}-${visibility_cost_distributed_two_weeks_this_year} ;;
  }

  measure: visibility_cost_distributed_wow {
    label: "Last week WoW growth brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${visibility_cost_distributed_last_week_this_year}-${visibility_cost_distributed_two_weeks_this_year}), ABS(${visibility_cost_distributed_two_weeks_this_year})) ;;
  }

  measure: visibility_cost_distributed_mom {
    label: "Last month MoM grwoth brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${visibility_cost_distributed_last_month_this_year}-${visibility_cost_distributed_two_months_this_year}), ABS(${visibility_cost_distributed_two_months_this_year})) ;;
  }

  measure: visibility_cost_distributed_week_yoy {
    label: "Last week YoY growth brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${visibility_cost_distributed_last_week_this_year}-${visibility_cost_distributed_last_week_last_year}), ABS(${visibility_cost_distributed_last_week_last_year})) ;;
  }

#VISIBILITY / BRAND MARKETING COST - MONTH
  measure: visibility_cost_distributed_last_month_this_year {
    label: "Last month brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${visibility_cost_distributed} ;;
  }

  measure: visibility_cost_distributed_last_month_last_year {
    label: "Last month last year brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${visibility_cost_distributed} ;;
  }

  measure: visibility_cost_last_month_target {
    label: "Last month target brand marketing cost"
    group_label: "Brand Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${visibility_cost_target} ;;
  }

  measure: visibility_cost_distributed_two_months_this_year {
    label: "Two months ago brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${visibility_cost_distributed} ;;
  }

  measure: visibility_cost_distributed_mom_abs {
    label: "Absolute MoM growth brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${visibility_cost_distributed_last_month_this_year}-${visibility_cost_distributed_two_months_this_year} ;;
  }

  measure: visibility_cost_distributed_month_yoy {
    label: "Last month YoY growth brand marketing cost"
    group_label: "Brand Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${visibility_cost_distributed_last_month_this_year}-${visibility_cost_distributed_last_month_last_year}), ABS(${visibility_cost_distributed_last_month_last_year})) ;;
  }

  measure: visibility_cost_distributed_week_delta_target {
    label: "Last week delta target brand marketing cost"
    group_label: "Brand Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${visibility_cost_distributed_last_week_this_year}-${visibility_cost_last_week_target}), ABS(${visibility_cost_last_week_target})) ;;
  }

  measure: visibility_cost_distributed_month_delta_target {
    label: "Last month delta target brand marketing cost"
    group_label: "Brand Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${visibility_cost_distributed_last_month_this_year}-${additional_target_metrics.visibility_cost_last_month_target}), ABS(${additional_target_metrics.visibility_cost_last_month_target})) ;;
  }

#SALES MARKETING COST - WEEK
  measure: sales_marketing_cost_last_week_this_year {
    label: "Last week sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_last_week_last_year {
    label: "Last week last year sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_last_week_target {
    label: "Last week target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${sales_marketing_cost_target} ;;
  }

  measure: sales_marketing_cost_two_weeks_this_year {
    label: "Two weeks ago sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_wow_abs {
    label: "Absolute WoW growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql:${sales_marketing_cost_last_week_this_year}-${sales_marketing_cost_two_weeks_this_year} ;;
  }

  measure: sales_marketing_cost_wow {
    label: "Last week WoW growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_marketing_cost_last_week_this_year}-${sales_marketing_cost_two_weeks_this_year}), ABS(${sales_marketing_cost_two_weeks_this_year})) ;;
  }

  measure: sales_marketing_cost_week_yoy {
    label: "Last week YoY growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_marketing_cost_last_week_this_year}-${sales_marketing_cost_last_week_last_year}), ABS(${sales_marketing_cost_last_week_last_year})) ;;
  }

  measure: sales_marketing_cost_week_delta_target {
    label: "Last week delta target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_marketing_cost_last_week_this_year}-${sales_marketing_cost_last_week_target}), ABS(${sales_marketing_cost_last_week_target})) ;;
  }

#SALES MARKETING COST - MONTH
  measure: sales_marketing_cost_last_month_this_year {
    label: "Last month sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_last_month_last_year {
    label: "Last month last year sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_last_month_target {
    label: "Last month target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${sales_marketing_cost_target} ;;
  }

  measure: sales_marketing_cost_two_months_this_year {
    label: "Two months ago sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_mom_abs {
    label: "Absolute MoM growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${sales_marketing_cost_last_month_this_year}-${sales_marketing_cost_two_months_this_year} ;;
  }

  measure: sales_marketing_cost_mom {
    label: "Last month MoM growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_marketing_cost_last_month_this_year}-${sales_marketing_cost_two_months_this_year}), ABS(${sales_marketing_cost_two_months_this_year})) ;;
  }

  measure: sales_marketing_cost_month_yoy {
    label: "Last month YoY growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_marketing_cost_last_month_this_year}-${sales_marketing_cost_last_month_last_year}), ABS(${sales_marketing_cost_last_month_last_year})) ;;
  }

  measure: sales_marketing_cost_month_delta_target {
    label: "Last month delta target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_marketing_cost_last_month_this_year}-${sales_marketing_cost_last_month_target}), ABS(${sales_marketing_cost_last_month_target})) ;;
  }

#SALES MARKETING COST - MTD
  measure: sales_marketing_cost_mtd_this_year {
    label: "MTD sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_mtd_last_year {
    label: "MTD last year sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_mtd_this_year_target {
    label: "MTD sales marketing cost target"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes"]
    sql: ${sales_marketing_cost_target} ;;
  }

  measure: sales_marketing_cost_mtd_yoy {
    label: "MTD YoY sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_mtd_this_year}-${sales_marketing_cost_mtd_last_year}), ABS(${sales_marketing_cost_mtd_last_year})) ;;
  }

  measure: sales_marketing_cost_mtd_delta_target {
    label: "MTD delta target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_mtd_this_year}-${sales_marketing_cost_mtd_this_year_target}), ABS(${sales_marketing_cost_mtd_this_year_target})) ;;
  }

#SALES MARKETING COST - QTD
  measure: sales_marketing_cost_qtd_this_year {
    label: "QTD sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_qtd: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_qtd_last_year {
    label: "QTD last year sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_qtd_yoy {
    label: "QTD YoY growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_qtd_this_year}-${sales_marketing_cost_qtd_last_year}), ABS(${sales_marketing_cost_qtd_last_year})) ;;
  }

  measure: sales_marketing_cost_qtd_this_year_target {
    label: "QTD sales marketing cost target"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes"]
    sql: ${sales_marketing_cost_target} ;;
  }

  measure: sales_marketing_cost_qtd_delta_target {
    label: "QTD delta target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_qtd_this_year}-${sales_marketing_cost_qtd_this_year_target}), ABS(${sales_marketing_cost_qtd_this_year_target})) ;;
  }

#SALES MARKETING COST - YTD
  measure: sales_marketing_cost_ytd_this_year {
    label: "YTD sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_ytd: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_ytd_last_year {
    label: "YTD last year sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${sales_marketing_cost} ;;
  }

  measure: sales_marketing_cost_ytd_yoy {
    label: "YTD YoY growth sales marketing cost"
    group_label: "Sales Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_ytd_this_year}-${sales_marketing_cost_ytd_last_year}), ABS(${sales_marketing_cost_ytd_last_year})) ;;
  }

  measure: sales_marketing_cost_ytd_this_year_target {
    label: "YTD sales marketing cost target"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${sales_marketing_cost_target} ;;
  }

  measure: sales_marketing_cost_ytd_delta_target {
    label: "YTD delta target sales marketing cost"
    group_label: "Sales Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_ytd_this_year}-${sales_marketing_cost_ytd_this_year_target}), ABS(${sales_marketing_cost_ytd_this_year_target})) ;;
  }

#SALES MARKETING COST PER ORDER - MTD
  measure: sales_marketing_cost_per_order_mtd_this_year {
    label: "MTD sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_mtd_this_year},${orders_mtd_this_year}) ;;
  }

  measure: sales_marketing_cost_per_order_mtd_last_year {
    label: "MTD last year sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_mtd_last_year},${orders_mtd_last_year}) ;;
  }

  measure: sales_marketing_cost_per_order_mtd_yoy {
    label: "MTD YoY growth sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_per_order_mtd_this_year}-${sales_marketing_cost_per_order_mtd_last_year}), ABS(${sales_marketing_cost_per_order_mtd_last_year})) ;;
  }

  measure: sales_marketing_cost_per_order_mtd_this_year_target {
    label: "MTD sales marketing cost per order target"
    group_label: "Sales Marketing Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_mtd_this_year_target},${orders_mtd_this_year_target}) ;;
  }

  measure: sales_marketing_cost_per_order_mtd_delta_target {
    label: "MTD delta target sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_per_order_mtd_this_year}-${sales_marketing_cost_per_order_mtd_this_year_target}), ABS(${sales_marketing_cost_per_order_mtd_this_year_target})) ;;
  }

#SALES MARKETING COST PER ORDER - QTD
  measure: sales_marketing_cost_per_order_qtd_this_year {
    label: "QTD sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_qtd_this_year},${orders_qtd_this_year}) ;;
  }

  measure: sales_marketing_cost_per_order_qtd_last_year {
    label: "QTD last year sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_qtd_last_year},${orders_qtd_last_year}) ;;
  }

  measure: sales_marketing_cost_per_order_qtd_yoy {
    label: "QTD YoY growth sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_per_order_qtd_this_year}-${sales_marketing_cost_per_order_qtd_last_year}), ABS(${sales_marketing_cost_per_order_qtd_last_year})) ;;
  }

  measure: sales_marketing_cost_per_order_qtd_this_year_target {
    label: "QTD sales marketing cost per order target"
    group_label: "Sales Marketing Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_qtd_this_year_target},${orders_qtd_this_year_target}) ;;
  }

  measure: sales_marketing_cost_per_order_qtd_delta_target {
    label: "QTD delta target sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_per_order_qtd_this_year}-${sales_marketing_cost_per_order_qtd_this_year_target}), ABS(${sales_marketing_cost_per_order_qtd_this_year_target})) ;;
  }

#SALES MARKETING COST PER ORDER - YTD
  measure: sales_marketing_cost_per_order_ytd_this_year {
    label: "YTD sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_ytd_this_year},${orders_ytd_this_year}) ;;
  }

  measure: sales_marketing_cost_per_order_ytd_last_year {
    label: "YTD last year sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_ytd_last_year},${orders_ytd_last_year}) ;;
  }

  measure: sales_marketing_cost_per_order_ytd_yoy {
    label: "YTD YoY growth sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_per_order_ytd_this_year}-${sales_marketing_cost_per_order_ytd_last_year}), ABS(${sales_marketing_cost_per_order_ytd_last_year})) ;;
  }

  measure: sales_marketing_cost_per_order_ytd_this_year_target {
    label: "YTD sales marketing cost per order target"
    group_label: "Sales Marketing Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_marketing_cost_ytd_this_year_target},${orders_ytd_this_year_target}) ;;
  }

  measure: sales_marketing_cost_per_order_ytd_delta_target {
    label: "YTD delta target sales marketing cost per order"
    group_label: "Sales Marketing Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_marketing_cost_per_order_ytd_this_year}-${sales_marketing_cost_per_order_ytd_this_year_target}), ABS(${sales_marketing_cost_per_order_ytd_this_year_target})) ;;
  }

#PARTNER MARKETING COST - WEEK
  measure: partner_marketing_cost_last_week_this_year {
    label: "Last week partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_last_week_last_year {
    label: "Last week last year partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_two_weeks_this_year {
    label: "Two weeks ago partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_wow {
    label: "Last week WoW growth partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${partner_marketing_cost_last_week_this_year}-${partner_marketing_cost_two_weeks_this_year}), ABS(${partner_marketing_cost_two_weeks_this_year})) ;;
  }

  measure: partner_marketing_cost_wow_abs {
    label: "Absolute WoW growth partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql:${partner_marketing_cost_last_week_this_year}-${partner_marketing_cost_two_weeks_this_year} ;;
  }

  measure: partner_marketing_cost_week_yoy {
    label: "Last week YoY growth partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${partner_marketing_cost_last_week_this_year}-${partner_marketing_cost_last_week_last_year}), ABS(${partner_marketing_cost_last_week_last_year})) ;;
  }

#PARTNER MARKETING COST - MONTH
  measure: partner_marketing_cost_last_month_this_year {
    label: "Last month partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_last_month_last_year {
    label: "Last month last year partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_two_months_this_year {
    label: "Two months ago partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${partner_marketing_cost} ;;
  }

  measure: partner_marketing_cost_mom_abs {
    label: "Absolute MoM growth partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${partner_marketing_cost_last_month_this_year}-${partner_marketing_cost_two_months_this_year} ;;
  }

  measure: partner_marketing_cost_mom {
    label: "Last month MoM growth partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${partner_marketing_cost_last_month_this_year}-${partner_marketing_cost_two_months_this_year}), ABS(${partner_marketing_cost_two_months_this_year})) ;;
  }

  measure: partner_marketing_cost_month_yoy {
    label: "Last month YoY growth partner marketing cost"
    group_label: "Partner Marketing Cost"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${partner_marketing_cost_last_month_this_year}-${partner_marketing_cost_last_month_last_year}), ABS(${partner_marketing_cost_last_month_last_year})) ;;
  }

  measure: partner_marketing_cost_month_delta_target {
    label: "Last month delta target partner marketing cost"
    group_label: "Partner Marketing Cost Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${partner_marketing_cost_last_month_this_year}-${additional_target_metrics.partner_marketing_cost_last_month_target}), ABS(${additional_target_metrics.partner_marketing_cost_last_month_target})) ;;
  }

#ADDITIONAL MARKETING INCOME - WEEK
  measure: additional_marketing_income_last_week_this_year {
    label: "Last week additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

  measure: additional_marketing_income_last_week_last_year {
    label: "Last week last year additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

  measure: additional_marketing_income_last_week_target {
    label: "Last week target additional marketing income"
    group_label: "Additional Marketing Income Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${additional_marketing_income_target} ;;
  }

  measure: additional_marketing_income_two_weeks_this_year {
    label: "Two weeks ago additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

  measure: additional_marketing_income_wow_abs {
    label: "Absolute WoW growth additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql:${additional_marketing_income_last_week_this_year}-${additional_marketing_income_two_weeks_this_year} ;;
  }

  measure: additional_marketing_income_wow {
    label: "Last week WoW growth additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${additional_marketing_income_last_week_this_year}-${additional_marketing_income_two_weeks_this_year}), ABS(${additional_marketing_income_two_weeks_this_year})) ;;
  }

  measure: additional_marketing_income_week_yoy {
    label: "Last week YoY growth additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${additional_marketing_income_last_week_this_year}-${additional_marketing_income_last_week_last_year}), ABS(${additional_marketing_income_last_week_last_year})) ;;
  }

  measure: additional_marketing_income_week_delta_target {
    label: "Last week delta target additional marketing income"
    group_label: "Additional Marketing Income Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${additional_marketing_income_last_week_this_year}-${additional_marketing_income_last_week_target}), ABS(${additional_marketing_income_last_week_target})) ;;
  }

#ADDITIONAL MARKETING INCOME - MONTH
  measure: additional_marketing_income_last_month_this_year {
    label: "Last month additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

  measure: additional_marketing_income_last_month_last_year {
    label: "Last month last year additional marketing income last month"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

  measure: additional_marketing_income_last_month_target {
    label: "Last month target additional marketing income"
    group_label: "Additional Marketing Income Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${additional_marketing_income_target} ;;
  }

  measure: additional_marketing_income_two_months_this_year {
    label: "Two months ago additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${additional_marketing_income_fixed_amount} ;;
  }

  measure: additional_marketing_income_mom_abs {
    label: "Absolute MoM growth additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${additional_marketing_income_last_month_this_year}-${additional_marketing_income_two_months_this_year} ;;
  }

  measure: additional_marketing_income_mom {
    label: "Last month MoM growth additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${additional_marketing_income_last_month_this_year}-${additional_marketing_income_two_months_this_year}), ABS(${additional_marketing_income_two_months_this_year})) ;;
  }

  measure: additional_marketing_income_month_yoy {
    label: "Last month YoY growth additional marketing income"
    group_label: "Additional Marketing Income"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${additional_marketing_income_last_month_this_year}-${additional_marketing_income_last_month_last_year}), ABS(${additional_marketing_income_last_month_last_year})) ;;
  }

  measure: additional_marketing_income_month_delta_target {
    label: "Last month delta target additional marketing income"
    group_label: "Additional Marketing Income Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${additional_marketing_income_last_month_this_year}-${additional_target_metrics.additional_marketing_income_last_month_target}), ABS(${additional_target_metrics.additional_marketing_income_last_month_target})) ;;
  }

#VARIABLE COST - WEEK
  measure: variable_cost_last_week_this_year {
    label: "Last week variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_last_week_last_year {
    label: "Last week last year variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_target_last_week_this_year {
    label: "Last week target variable cost"
    group_label: "Variable Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${invoice_variable_cost_target} ;;
  }

  measure: variable_cost_two_weeks_this_year {
    label: "Two weeks ago variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

#VARIABLE COST - MONTH
  measure: variable_cost_last_month_this_year {
    label: "Last month variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_last_month_last_year {
    label: "Last month last year variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_target_last_month_this_year {
    label: "Last month target variable cost"
    group_label: "Variable Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${invoice_variable_cost_target} ;;
  }

  measure: variable_cost_two_months_this_year {
    label: "Two months ago variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

#VARIABLE COST - YEAR
  measure: variable_cost_this_year {
    label: "Current year variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year:"yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_this_year_not_iso {
    label: "Current (non iso) year variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso:"yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_last_year {
    label: "Last year variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_last_year_not_iso {
    label: "Last (non iso) year variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_this_year_target {
    label: "Current year target variable cost"
    group_label: "Variable Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${invoice_variable_cost_target} ;;
  }

  measure: variable_cost_this_year_target_not_iso {
    label: "Current (non iso) year target variable cost"
    group_label: "Variable Cost Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${invoice_variable_cost_target} ;;
  }

  measure: variable_cost_two_years_ago {
    label: "Two years ago variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago:"yes"]
    sql: ${invoice_variable_cost} ;;
  }

  measure: variable_cost_two_years_ago_not_iso {
    label: "Two (non iso) years ago variable cost"
    group_label: "Variable Cost"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${invoice_variable_cost} ;;
  }

#VARIABLE COST PER ORDER - WEEK
  measure: variable_cost_per_order_last_week_this_year {
    label: "Last week variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_last_week_this_year},${orders_last_week_this_year}) ;;
  }

  measure: variable_cost_per_order_last_week_last_year {
    label: "Last week last year variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${variable_cost_last_week_last_year},${orders_last_week_last_year}) ;;
  }

  measure: variable_cost_per_order_last_week_target {
    label: "Last week target variable cost per order"
    group_label: "Variable Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${variable_cost_target_last_week_this_year},${orders_target_last_week_this_year}) ;;
  }

  measure: variable_cost_per_order_two_weeks_this_year {
    label: "Two weeks ago variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${variable_cost_two_weeks_this_year},${orders_two_weeks_this_year}) ;;
  }

  measure: variable_cost_per_order_wow_abs {
    label: "Absolute WoW growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${variable_cost_per_order_last_week_this_year}-${variable_cost_per_order_two_weeks_this_year} ;;
  }

  measure: variable_cost_per_order_wow {
    label: "Last week WoW variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${variable_cost_per_order_last_week_this_year}-${variable_cost_per_order_two_weeks_this_year}), ABS(${variable_cost_per_order_two_weeks_this_year})) ;;
  }

  measure: variable_cost_per_order_week_yoy {
    label: "Last week YoY growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${variable_cost_per_order_last_week_this_year}-${variable_cost_per_order_last_week_last_year}), ABS(${variable_cost_per_order_last_week_last_year})) ;;
  }

  measure: variable_cost_per_order_week_yoy_abs {
    label: "Absolute YoY growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${variable_cost_per_order_last_week_this_year},0)-IFNULL(${variable_cost_per_order_last_week_last_year},0) ;;
  }

  measure: variable_cost_per_order_week_delta_target {
    label: "Last week delta target variable cost per order"
    group_label: "Variable Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${variable_cost_per_order_last_week_this_year}-${variable_cost_per_order_last_week_target}), ABS(${variable_cost_per_order_last_week_target})) ;;
  }

#VARIABLE COST PER ORDER - MONTH
  measure: variable_cost_per_order_this_year_target_not_iso {
    label: "Current (non iso) year target variable cost per order"
    group_label: "Variable Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_this_year_target_not_iso},${orders_this_year_target_not_iso}) ;;
  }

  measure: variable_cost_per_order_last_month_this_year {
    label: "Last month variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_last_month_this_year},${orders_last_month_this_year}) ;;
  }

  measure: variable_cost_per_order_last_month_last_year {
    label: "Last month last year variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${variable_cost_last_month_last_year},${orders_last_month_last_year}) ;;
  }

  measure: variable_cost_per_order_last_month_target {
    label: "Last month target variable cost per order"
    group_label: "Variable Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${variable_cost_target_last_month_this_year},${orders_target_last_month_this_year}) ;;
  }

  measure: variable_cost_per_order_two_months_this_year {
    label: "Two months ago variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${variable_cost_two_months_this_year},${orders_two_months_this_year}) ;;
  }

  measure: variable_cost_per_order_mom_abs {
    label: "Absolute MoM growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql:${variable_cost_per_order_last_month_this_year}-${variable_cost_per_order_two_months_this_year} ;;
  }

  measure: variable_cost_per_order_mom {
    label: "Last month MoM growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${variable_cost_per_order_last_month_this_year}-${variable_cost_per_order_two_months_this_year}), ABS(${variable_cost_per_order_two_months_this_year})) ;;
  }

  measure: variable_cost_per_order_month_yoy {
    label: "Last month YoY growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${variable_cost_per_order_last_month_this_year}-${variable_cost_per_order_last_month_last_year}), ABS(${variable_cost_per_order_last_month_last_year})) ;;
  }

  measure: variable_cost_per_order_month_yoy_abs {
    label: "Absolute YoY growth variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${variable_cost_per_order_last_month_this_year}-${variable_cost_per_order_last_month_last_year} ;;
  }

  measure: variable_cost_per_order_month_delta_target {
    label: "Last month delta target variable cost per order"
    group_label: "Variable Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${variable_cost_per_order_last_month_this_year}-${variable_cost_per_order_last_month_target}), ABS(${variable_cost_per_order_last_month_target})) ;;
  }

#VARIABLE COST PER ORDER - YEAR
  measure: variable_cost_per_order_this_year {
    label: "Current year variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_this_year},${orders_this_year}) ;;
  }

  measure: variable_cost_per_order_this_year_not_iso {
    label: "Current (non iso) year variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_this_year_not_iso},${orders_this_year_not_iso}) ;;
  }

  measure: variable_cost_per_order_last_year {
    label: "Last year variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_last_year},${orders_last_year}) ;;
  }

  measure: variable_cost_per_order_last_year_not_iso {
    label: "Last (non iso) year variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_last_year_not_iso},${orders_last_year_not_iso}) ;;
  }

  measure: variable_cost_per_order_this_year_target {
    label: "Current year target variable cost per order"
    group_label: "Variable Cost per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_this_year_target},${orders_this_year_target}) ;;
  }

  measure: variable_cost_per_order_two_years_ago {
    label: "Two years ago variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_two_years_ago},${orders_two_years_ago}) ;;
  }

  measure: variable_cost_per_order_two_years_ago_not_iso {
    label: "Two (non iso) years ago variable cost per order"
    group_label: "Variable Cost per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${variable_cost_two_years_ago_not_iso},${orders_two_years_ago_not_iso}) ;;
  }

#AVERAGE SALES PRICE - YESTERDAY
  measure: average_sales_price_yesterday_this_year {
    label: "Yesterday average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_yesterday_this_year},${products_sold_yesterday_this_year}) ;;
  }

#AVERAGE SALES PRICE - WEEK
  measure: average_sales_price_last_week_this_year {
    label: "Last week average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_last_week_this_year},${products_sold_last_week_this_year}) ;;
  }

  measure: average_sales_price_last_week_last_year {
    label: "Last week last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${sales_last_week_last_year},${products_sold_last_week_last_year}) ;;
  }

  measure: average_sales_price_last_week_target {
    label: "Last week target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${sales_last_week_target},${products_sold_last_week_target}) ;;
  }

  measure: average_sales_price_two_weeks_this_year {
    label: "Two weeks ago average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${sales_two_weeks_this_year},${products_sold_two_weeks_this_year}) ;;
  }

  measure: average_sales_price_wow_abs {
    label: "Absolute WoW growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: IFNULL(${average_sales_price_last_week_this_year},0)-IFNULL(${average_sales_price_two_weeks_this_year},0) ;;
  }

  measure: average_sales_price_wow {
    label: "Last week WoW growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${average_sales_price_last_week_this_year}-${average_sales_price_two_weeks_this_year}), ABS(${average_sales_price_two_weeks_this_year})) ;;
  }

  measure: average_sales_price_week_yoy_abs {
    label: "Absolute YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${average_sales_price_last_week_this_year},0)- IFNULL(${average_sales_price_last_week_last_year},0) ;;
  }

  measure: average_sales_price_week_yoy {
    label: "Last week YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${average_sales_price_last_week_this_year}-${average_sales_price_last_week_last_year}), ABS(${average_sales_price_last_week_last_year})) ;;
  }

  measure: average_sales_price_week_delta_target_abs {
    label: "Absolute delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${average_sales_price_last_week_this_year}-${average_sales_price_last_week_target} ;;
  }

  measure: average_sales_price_week_delta_target {
    label: "Last week delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${average_sales_price_last_week_this_year}-${average_sales_price_last_week_target}), ABS(${average_sales_price_last_week_target})) ;;
  }

#AVERAGE SALES PRICE - WTD
  measure: average_sales_price_wtd_this_year {
    label: "WTD average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_wtd_this_year},${products_sold_wtd_this_year}) ;;
  }

  measure: average_sales_price_wtd_last_week_this_year {
    label: "WTD last week average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_wtd_last_week_this_year},${products_sold_wtd_last_week_this_year}) ;;
  }

  measure: average_sales_price_wtd_last_year {
    label: "WTD last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_wtd_last_year},${products_sold_wtd_last_year}) ;;
  }

  measure: average_sales_price_wtd_yoy {
    label: "WTD YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${average_sales_price_wtd_this_year}-${average_sales_price_wtd_last_year}), ABS(${average_sales_price_wtd_last_year})) ;;
  }

  measure: average_sales_price_wtd_wow {
    label: "WTD WoW growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${average_sales_price_wtd_this_year}-${average_sales_price_wtd_last_week_this_year}), ABS(${average_sales_price_wtd_last_week_this_year})) ;;
  }

#AVERAGE SALES PRICE - MONTH
  measure: average_sales_price_last_month_this_year {
    label: "Last month average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_last_month_this_year},${products_sold_last_month_this_year}) ;;
  }

  measure: average_sales_price_last_month_last_year {
    label: "Last month last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${sales_last_month_last_year},${products_sold_last_month_last_year}) ;;
  }

  measure: average_sales_price_last_month_target {
    label: "Last month target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${sales_last_month_target},${products_sold_last_month_target}) ;;
  }

  measure: average_sales_price_two_months_this_year {
    label: "Two months ago average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${sales_two_months_this_year},${products_sold_two_months_this_year}) ;;
  }

  measure: average_sales_price_mom_abs {
    label: "Absolute MoM growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${average_sales_price_last_month_this_year}-${average_sales_price_two_months_this_year} ;;
  }

  measure: average_sales_price_mom {
    label: "Last month MoM growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${average_sales_price_last_month_this_year}-${average_sales_price_two_months_this_year}), ABS(${average_sales_price_two_months_this_year})) ;;
  }

  measure: average_sales_price_month_yoy {
    label: "Last month YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${average_sales_price_last_month_this_year}-${average_sales_price_last_month_last_year}), ABS(${average_sales_price_last_month_last_year})) ;;
  }

  measure: average_sales_price_month_yoy_abs {
    label: "Last month absolute YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${average_sales_price_last_month_this_year}-${average_sales_price_last_month_last_year} ;;
  }

  measure: average_sales_price_month_delta_target {
    label: "Last month delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${average_sales_price_last_month_this_year}-${average_sales_price_last_month_target}), ABS(${average_sales_price_last_month_target})) ;;
  }

  measure: average_sales_price_month_delta_target_abs {
    label: "Last month absolute delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${average_sales_price_last_month_this_year}-${average_sales_price_last_month_target} ;;
  }

#AVERAGE SALES PRICE - MTD
  measure: average_sales_price_mtd_this_year {
    label: "MTD average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_mtd_this_year},${products_sold_mtd_this_year}) ;;
  }

  measure: average_sales_price_mtd_last_year {
    label: "MTD last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_mtd_last_year},${products_sold_mtd_last_year}) ;;
  }

  measure: average_sales_price_mtd_yoy {
    label: "MTD YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${average_sales_price_mtd_this_year}-${average_sales_price_mtd_last_year}), ABS(${average_sales_price_mtd_last_year})) ;;
  }

  measure: average_sales_price_mtd_this_year_target {
    label: "MTD average sales price target"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_mtd_this_year_target},${products_sold_mtd_this_year_target}) ;;
  }

  measure: average_sales_price_mtd_delta_target {
    label: "MTD delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${average_sales_price_mtd_this_year}-${average_sales_price_mtd_this_year_target}), ABS(${average_sales_price_mtd_this_year_target})) ;;
  }

#AVERAGE SALES PRICE - QTD
  measure: average_sales_price_qtd_this_year {
    label: "QTD average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_qtd_this_year},${products_sold_qtd_this_year}) ;;
  }

  measure: average_sales_price_qtd_last_year {
    label: "QTD last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_qtd_last_year},${products_sold_qtd_last_year}) ;;
  }

  measure: average_sales_price_qtd_yoy {
    label: "QTD YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${average_sales_price_qtd_this_year}-${average_sales_price_qtd_last_year}), ABS(${average_sales_price_qtd_last_year})) ;;
  }

  measure: average_sales_price_qtd_this_year_target {
    label: "QTD average sales price target"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_qtd_this_year_target},${products_sold_qtd_this_year_target}) ;;
  }

  measure: average_sales_price_qtd_delta_target {
    label: "QTD delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${average_sales_price_qtd_this_year}-${average_sales_price_qtd_this_year_target}), ABS(${average_sales_price_qtd_this_year_target})) ;;
  }

#AVERAGE SALES PRICE - YEAR
  measure: average_sales_price_this_year {
    label: "Current year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_this_year},${products_sold_this_year}) ;;
  }

  measure: average_sales_price_this_year_not_iso {
    label: "Current (non iso) year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_this_year_not_iso},${products_sold_this_year_not_iso}) ;;
  }

  measure: average_sales_price_last_year {
    label: "Last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_last_year},${products_sold_last_year}) ;;
  }

  measure: average_sales_price_last_year_not_iso {
    label: "Last (non iso) year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_last_year_not_iso},${products_sold_last_year_not_iso}) ;;
  }

  measure: average_sales_price_two_years_ago {
    label: "Two years ago average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_two_years_ago},${products_sold_two_years_ago}) ;;
  }

  measure: average_sales_price_two_years_ago_not_iso {
    label: "Two (non iso) years ago average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_two_years_ago_not_iso},${products_sold_two_years_ago_not_iso}) ;;
  }

  measure: average_sales_price_this_year_target {
    label: "Current year target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_this_year_target},${products_sold_this_year_target}) ;;
  }

  measure: average_sales_price_this_year_target_not_iso {
    label: "Current (non iso) year target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_this_year_target_not_iso},${products_sold_this_year_target_not_iso}) ;;
  }

#AVERAGE SALES PRICE - YTD
  measure: average_sales_price_ytd_this_year {
    label: "YTD average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_ytd_this_year},${products_sold_ytd_this_year}) ;;
  }
  measure: average_sales_price_ytd_last_year {
    label: "YTD last year average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${sales_ytd_last_year},${products_sold_ytd_last_year}) ;;
  }

  measure: average_sales_price_ytd_yoy {
    label: "YTD YoY growth average sales price"
    group_label: "Average Sales Price"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${average_sales_price_ytd_this_year}-${average_sales_price_ytd_last_year}), ABS(${average_sales_price_ytd_last_year})) ;;
  }

  measure: average_sales_price_ytd_this_year_target {
    label: "YTD average sales price target"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: SAFE_DIVIDE(${sales_ytd_this_year_target},${products_sold_ytd_this_year_target}) ;;
  }

  measure: average_sales_price_ytd_delta_target {
    label: "YTD delta target average sales price"
    group_label: "Average Sales Price Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${average_sales_price_ytd_this_year}-${average_sales_price_ytd_this_year_target}), ABS(${average_sales_price_ytd_this_year_target})) ;;
  }

#PRIMARY MARGIN - YESTERDAY
  measure: primary_margin_yesterday_this_year {
    label: "Yesterday primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

#PRIMARY MARGIN - WEEK
  measure: primary_margin_this_week_last_year {
    label: "Current week last year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_isoweek_last_year: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_last_week_this_year {
    label: "Last week primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_last_week_last_year {
    label: "Last week last year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_target_last_week_this_year {
    label: "Last week target primary margin"
    group_label: "Primary Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${primary_product_margin_incl_ssa_target} ;;
  }

  measure: primary_margin_two_weeks_this_year {
    label: "Two weeks ago primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

#PRIMARY MARGIN - WTD
  measure: primary_margin_wtd_this_year {
    label: "WTD primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_wtd_last_year {
    label: "WTD last year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_wtd_last_week_this_year {
    label: "WTD last week primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_wtd_wow {
    label: "WTD WoW growth primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${primary_margin_wtd_this_year}-${primary_margin_wtd_last_week_this_year}), ABS(${primary_margin_wtd_last_week_this_year})) ;;
  }

  measure: primary_margin_wtd_yoy {
    label: "WTD YoY growth primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE(${primary_margin_wtd_this_year}-${primary_margin_wtd_last_year}, ABS(${primary_margin_wtd_last_year})) ;;
  }

#PRIMARY MARGIN - MONTH
  measure: primary_margin_last_month_this_year {
    label: "Last month primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_last_month_last_year {
    label: "Primary margin last month last year"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_target_last_month_this_year {
    label: "Last month target primary margin"
    group_label: "Primary Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${primary_product_margin_incl_ssa_target} ;;
  }

  measure: primary_margin_two_months_this_year {
    label: "Two months ago primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_month_yoy {
    label: "Last month YoY growth primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_last_month_this_year} - ${primary_margin_last_month_last_year}), ABS(${primary_margin_last_month_last_year})) ;;
  }

  measure: primary_margin_month_yoy_abs {
    label: "Absolute YoY primary margin last month"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${primary_margin_last_month_this_year} - ${primary_margin_last_month_last_year} ;;
  }

#PRIMARY MARGIN - YEAR
  measure: primary_margin_this_year {
    label: "Current year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_this_year_not_iso {
    label: "Current (non iso) year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_last_year {
    label: "Last year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_last_year_not_iso {
    label: "Last (non iso) year primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_this_year_target {
    label: "Current year target primary margin target"
    group_label: "Primary Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${primary_product_margin_incl_ssa_target} ;;
  }

  measure: primary_margin_this_year_target_not_iso {
    label: "Current (non iso) year target primary margin target"
    group_label: "Primary Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${primary_product_margin_incl_ssa_target} ;;
  }

  measure: primary_margin_two_years_ago {
    label: "Two years ago primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago:"yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

  measure: primary_margin_two_years_ago_not_iso {
    label: "Two (non iso) years ago primary margin"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${primary_margin_incl_ssa} ;;
  }

#PRIMARY MARGIN PER ORDER - WEEK
  measure: primary_margin_per_order_last_week_this_year {
    label: "Last week primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${primary_margin_last_week_this_year},${orders_last_week_this_year}) ;;
  }

  measure: primary_margin_per_order_last_week_last_year {
    label: "Last week last year primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${primary_margin_last_week_last_year},${orders_last_week_last_year}) ;;
  }

  measure: primary_margin_per_order_last_week_target {
    label: "Last week target primary margin per order"
    group_label: "Primary Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${primary_margin_target_last_week_this_year},${orders_target_last_week_this_year}) ;;
  }

  measure: primary_margin_per_order_two_weeks_this_year {
    label: "Two weeks ago primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${primary_margin_two_weeks_this_year},${orders_two_weeks_this_year}) ;;
  }

  measure: primary_margin_per_order_wow_abs {
    label: "Absolute WoW growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${primary_margin_per_order_last_week_this_year}-${primary_margin_per_order_two_weeks_this_year} ;;
  }

  measure: primary_margin_per_order_wow {
    label: "Last week WoW growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_per_order_last_week_this_year}-${primary_margin_per_order_two_weeks_this_year}), ABS(${primary_margin_per_order_two_weeks_this_year})) ;;
  }

  measure: primary_margin_per_order_week_yoy {
    label: "Last week YoY growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_per_order_last_week_this_year}-${primary_margin_per_order_last_week_last_year}), ABS(${primary_margin_per_order_last_week_last_year})) ;;
  }

  measure: primary_margin_per_order_week_yoy_abs {
    label: "Absolute YoY growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${primary_margin_per_order_last_week_this_year},0)-IFNULL(${primary_margin_per_order_last_week_last_year},0) ;;
  }

  measure: primary_margin_per_order_week_delta_target {
    label: "Last week delta target primary margin per order"
    group_label: "Primary Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_per_order_last_week_this_year}-${primary_margin_per_order_last_week_target}), ABS(${primary_margin_per_order_last_week_target})) ;;
  }

#PRIMARY MARGIN PER ORDER - MONTH
  measure: primary_margin_per_order_last_month_this_year {
    label: "Last month primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${primary_margin_last_month_this_year},${orders_last_month_this_year}) ;;
  }

  measure: primary_margin_per_order_last_month_last_year {
    label: "Last month last year primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${primary_margin_last_month_last_year},${orders_last_month_last_year}) ;;
  }

  measure: primary_margin_per_order_last_month_target {
    label: "Last month target primary margin per order"
    group_label: "Primary Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${primary_margin_target_last_month_this_year},${orders_target_last_month_this_year}) ;;
  }

  measure: primary_margin_per_order_two_months_this_year {
    label: "Two months ago primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${primary_margin_two_months_this_year},${orders_two_months_this_year}) ;;
  }

  measure: primary_margin_per_order_mom_abs {
    label: "Absolute MoM growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${primary_margin_per_order_last_month_this_year}-${primary_margin_per_order_two_months_this_year} ;;
  }

  measure: primary_margin_per_order_mom {
    label: "Last month MoM growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_per_order_last_month_this_year}-${primary_margin_per_order_two_months_this_year}), ABS(${primary_margin_per_order_two_months_this_year})) ;;
  }

  measure: primary_margin_per_order_month_yoy {
    label: "Last month YoY growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_per_order_last_month_this_year}-${primary_margin_per_order_last_month_last_year}), ABS(${primary_margin_per_order_last_month_last_year})) ;;
  }

  measure: primary_margin_per_order_month_yoy_abs {
    label: "Absolute YoY growth primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${primary_margin_per_order_last_month_this_year}-${primary_margin_per_order_last_month_last_year} ;;
  }

  measure: primary_margin_per_order_month_delta_target {
    label: "Last month delta target primary margin per order"
    group_label: "Primary Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${primary_margin_per_order_last_month_this_year}-${primary_margin_per_order_last_month_target}), ABS(${primary_margin_per_order_last_month_target})) ;;
  }

#PRIMARY MARGIN PER ORDER - YEAR
  measure: primary_margin_per_order_this_year {
    label: "Current year primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${primary_margin_this_year},${orders_this_year}) ;;
  }

  measure: primary_margin_per_order_this_year_not_iso {
    label: "Current (non iso) year primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${primary_margin_this_year_not_iso},${orders_this_year_not_iso}) ;;
  }

  measure: primary_margin_per_order_last_year {
    label: "Last year primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${primary_margin_last_year},${orders_last_year}) ;;
  }

  measure: primary_margin_per_order_last_year_not_iso {
    label: "Last (non iso) year primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${primary_margin_last_year_not_iso},${orders_last_year_not_iso}) ;;
  }

  measure: primary_margin_per_order_this_year_target {
    label: "Current year target primary margin per order"
    group_label: "Primary Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${primary_margin_this_year_target},${orders_this_year_target}) ;;
  }

  measure: primary_margin_per_order_this_year_target_not_iso {
    label: "Current (non iso) year target primary margin per order"
    group_label: "Primary Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${primary_margin_this_year_target_not_iso},${orders_this_year_target_not_iso}) ;;
  }

  measure: primary_margin_per_order_two_years_ago {
    label: "Two years ago primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${primary_margin_two_years_ago},${orders_two_years_ago}) ;;
  }

  measure: primary_margin_per_order_two_years_ago_not_iso {
    label: "Two (non iso) years ago primary margin per order"
    group_label: "Primary Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${primary_margin_two_years_ago_not_iso},${orders_two_years_ago_not_iso}) ;;
  }

#PRIMARY MARGIN AS PERCENT OF SALES - YESTERDAY
  measure: primary_margin_perc_sales_yesterday_this_year {
    label: "Yesterday primary margin % sales"
    group_label: "Primary Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${primary_margin_yesterday_this_year},${primary_sales_yesterday_this_year}) ;;
  }

#PRIMARY MARGIN AS PERCENT OF SALES - WTD
  measure: primary_margin_perc_sales_wtd_this_year {
    label: "WTD primary margin % sales"
    group_label: "Primary Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${primary_margin_wtd_this_year},${primary_sales_wtd_this_year}) ;;
  }

  measure: primary_margin_perc_sales_wtd_last_week_this_year {
    label: "WTD last week primary margin % sales"
    group_label: "Primary Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    sql: SAFE_DIVIDE(${primary_margin_wtd_last_week_this_year},${primary_sales_wtd_last_week_this_year}) ;;
  }

  measure: primary_margin_perc_sales_wtd_last_year {
    label: "WtD last year primary margin % sales"
    group_label: "Primary Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    sql: SAFE_DIVIDE(${primary_margin_wtd_last_year},${primary_sales_wtd_last_year}) ;;
  }

  measure: primary_margin_perc_sales_wtd_yoy_abs {
    label: "WTD YoY growth primary margin % sales"
    group_label: "Primary Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: ${primary_margin_perc_sales_wtd_this_year}-${primary_margin_perc_sales_wtd_last_year} ;;
  }

  measure: primary_margin_perc_sales_wtd_wow_abs {
    label: "WTD WoW growth primary margin % sales"
    group_label: "Primary Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: ${primary_margin_perc_sales_wtd_this_year}-${primary_margin_perc_sales_wtd_last_week_this_year} ;;
  }

#ATTACHED MARGIN - YESTERDAY
  measure: attached_margin_yesterday_this_year {
    label: "Yesterday attached Margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

#ATTACHED MARGIN - WEEK
  measure: attached_margin_last_week_this_year {
    label: "Last week attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_last_week_last_year {
    label: "Last week last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_target_last_week_this_year {
    label: "Last week target attached margin"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

  measure: attached_margin_two_weeks_this_year {
    label: "Two weeks ago attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

#ATTACHED MARGIN - WTD
  measure: attached_margin_wtd_this_year {
    label: "WTD attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_wtd_last_year {
    label: "WTD last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_wtd_last_week_this_year {
    label: "WTD last week attached Margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

#ATTACHED MARGIN - MONTH
  measure: attached_margin_last_month_this_year {
    label: "Last month attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_last_month_last_year {
    label: "Last month last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_target_last_month_this_year {
    label: "Last month target attached margin"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

  measure: attached_margin_two_months_this_year {
    label: "Two months ago attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_yoy {
    label: "Last month YoY growth attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_last_month_this_year} - ${attached_margin_last_month_last_year}), ABS(${attached_margin_last_month_last_year})) ;;
  }

  measure: attached_margin_yoy_abs {
    label: "Absolute YoY attached margin for last month"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${attached_margin_last_month_this_year} - ${attached_margin_last_month_last_year} ;;
  }

#ATTACHED MARGIN - MTD
  measure: attached_margin_mtd_this_year {
    label: "MTD attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_mtd_last_year {
    label: "MTD last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_mtd_this_year_target {
    label: "MTD attached margin target"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

#ATTACHED MARGIN - QTD
  measure: attached_margin_qtd_this_year {
    label: "QTD attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_qtd_last_year {
    label: "QTD last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_qtd_this_year_target {
    label: "QTD attached margin target"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

#ATTACHED MARGIN - YEAR
  measure: attached_margin_this_year {
    label: "Current year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_this_year_not_iso {
    label: "Current (non iso) year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_last_year {
    label: "Last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_last_year_not_iso {
    label: "Last (non iso) year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_this_year_target {
    label: "Current year target attached margin"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

  measure: attached_margin_this_year_target_not_iso {
    label: "Current (non iso) year target attached margin"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

  measure: attached_margin_two_years_ago {
    label: "Two years ago attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago:"yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_two_years_ago_not_iso {
    label: "Two (non iso) years ago attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

#ATTACHED MARGIN - YTD
  measure: attached_margin_ytd_this_year {
    label: "YTD attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_ytd_last_year {
    label: "YTD last year attached margin"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${attached_margin_incl_ssa} ;;
  }

  measure: attached_margin_ytd_this_year_target {
    label: "YTD attached margin target"
    group_label: "Attached Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${attached_margin_incl_ssa_target} ;;
  }

#ATTACHED MARGIN PER ORDER - YESTERDAY
  measure: attached_margin_per_order_yesterday_this_year {
    label: "Yesterday attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_yesterday_this_year},${orders_yesterday_this_year}) ;;
  }

#ATTACHED MARGIN PER ORDER - WEEK
  measure: attached_margin_per_order_last_week_this_year {
    label: "Last week attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_last_week_this_year},${orders_last_week_this_year}) ;;
  }

  measure: attached_margin_per_order_last_week_last_year {
    label: "Last week last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${attached_margin_last_week_last_year},${orders_last_week_last_year}) ;;
  }

  measure: attached_margin_per_order_last_week_target {
    label: "Last week target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${attached_margin_target_last_week_this_year},${orders_target_last_week_this_year}) ;;
  }

  measure: attached_margin_per_order_two_weeks_this_year {
    label: "Two weeks ago attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${attached_margin_two_weeks_this_year},${orders_two_weeks_this_year}) ;;
  }

  measure: attached_margin_per_order_wow_abs {
    label: "Absolute WoW growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${attached_margin_per_order_last_week_this_year}-${attached_margin_per_order_two_weeks_this_year} ;;
  }

  measure: attached_margin_per_order_wow {
    label: "Last week WoW growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_per_order_last_week_this_year}-${attached_margin_per_order_two_weeks_this_year}), ABS(${attached_margin_per_order_two_weeks_this_year})) ;;
  }

  measure: attached_margin_per_order_week_yoy {
    label: "Last week YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_per_order_last_week_this_year}-${attached_margin_per_order_last_week_last_year}), ABS(${attached_margin_per_order_last_week_last_year})) ;;
  }

  measure: attached_margin_per_order_week_yoy_abs {
    label: "Absolute YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${attached_margin_per_order_last_week_this_year},0)-IFNULL(${attached_margin_per_order_last_week_last_year},0) ;;
  }

  measure: attached_margin_per_order_week_delta_target {
    label: "Last week delta target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_per_order_last_week_this_year}-${attached_margin_per_order_last_week_target}), ABS(${attached_margin_per_order_last_week_target})) ;;
  }

#ATTACHED MARGIN PER ORDER - WTD
  measure: attached_margin_per_order_wtd_this_year {
    label: "WTD attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_wtd_this_year},${orders_wtd_this_year}) ;;
  }

  measure: attached_margin_per_order_wtd_last_week_this_year {
    label: "WTD last week attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_wtd_last_week_this_year},${orders_wtd_last_week_this_year}) ;;
  }

  measure: attached_margin_per_order_wtd_last_year {
    label: "WTD last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_wtd_last_year},${orders_wtd_last_year}) ;;
  }

  measure: attached_margin_per_order_wtd_yoy {
    label: "WTD YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${attached_margin_per_order_wtd_this_year}-${attached_margin_per_order_wtd_last_year}), ABS(${attached_margin_per_order_wtd_last_year})) ;;
  }

  measure: attached_margin_per_order_wtd_wow {
    label: "WTD WoW growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${attached_margin_per_order_wtd_this_year}-${attached_margin_per_order_wtd_last_week_this_year}), ABS(${attached_margin_per_order_wtd_last_week_this_year})) ;;
  }

#ATTACHED MARGIN PER ORDER - MONTH
  measure: attached_margin_per_order_last_month_this_year {
    label: "Last month attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_last_month_this_year},${orders_last_month_this_year}) ;;
  }

  measure: attached_margin_per_order_last_month_last_year {
    label: "Last month last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${attached_margin_last_month_last_year},${orders_last_month_last_year}) ;;
  }

  measure: attached_margin_per_order_last_month_target {
    label: "Last month target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${attached_margin_target_last_month_this_year},${orders_target_last_month_this_year}) ;;
  }

  measure: attached_margin_per_order_two_months_this_year {
    label: "Two months ago attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${attached_margin_two_months_this_year},${orders_two_months_this_year}) ;;
  }

  measure: attached_margin_per_order_mom_abs {
    label: "Absolute MoM growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${attached_margin_per_order_last_month_this_year}-${attached_margin_per_order_two_months_this_year} ;;
  }

  measure: attached_margin_per_order_mom {
    label: "Last month MoM growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_per_order_last_month_this_year}-${attached_margin_per_order_two_months_this_year}), ABS(${attached_margin_per_order_two_months_this_year})) ;;
  }

  measure: attached_margin_per_order_month_yoy {
    label: "Last month YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_per_order_last_month_this_year}-${attached_margin_per_order_last_month_last_year}), ABS(${attached_margin_per_order_last_month_last_year})) ;;
  }

  measure: attached_margin_per_order_month_yoy_abs {
    label: "Absolute YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${attached_margin_per_order_last_month_this_year}-${attached_margin_per_order_last_month_last_year} ;;
  }

  measure: attached_margin_per_order_month_delta_target {
    label: "Last month delta target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${attached_margin_per_order_last_month_this_year}-${attached_margin_per_order_last_month_target}), ABS(${attached_margin_per_order_last_month_target})) ;;
  }

#ATTACHED MARGIN PER ORDER - MTD
  measure: attached_margin_per_order_mtd_this_year {
    label: "MTD attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_mtd_this_year},${orders_mtd_this_year}) ;;
  }

  measure: attached_margin_per_order_mtd_last_year {
    label: "MTD last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_mtd_last_year},${orders_mtd_last_year}) ;;
  }

  measure: attached_margin_per_order_mtd_yoy {
    label: "MTD YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${attached_margin_per_order_mtd_this_year}-${attached_margin_per_order_mtd_last_year}), ABS(${attached_margin_per_order_mtd_last_year})) ;;
  }

  measure: attached_margin_per_order_mtd_this_year_target {
    label: "MTD attached margin per order target"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_mtd_this_year_target},${orders_mtd_this_year_target}) ;;
  }

  measure: attached_margin_per_order_mtd_delta_target {
    label: "MTD delta target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${attached_margin_per_order_mtd_this_year}-${attached_margin_per_order_mtd_this_year_target}), ABS(${attached_margin_per_order_mtd_this_year_target})) ;;
  }

#ATTACHED MARGIN PER ORDER - QTD
  measure: attached_margin_per_order_qtd_this_year {
    label: "QTD attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_qtd_this_year},${orders_qtd_this_year}) ;;
  }

  measure: attached_margin_per_order_qtd_last_year {
    label: "QTD last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_qtd_last_year},${orders_qtd_last_year}) ;;
  }

  measure: attached_margin_per_order_qtd_yoy {
    label: "QTD YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${attached_margin_per_order_qtd_this_year}-${attached_margin_per_order_qtd_last_year}), ABS(${attached_margin_per_order_qtd_last_year})) ;;
  }

  measure: attached_margin_per_order_qtd_this_year_target {
    label: "QTD attached margin per order target"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_qtd_this_year_target},${orders_qtd_this_year_target}) ;;
  }

  measure: attached_margin_per_order_qtd_delta_target {
    label: "QTD delta target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${attached_margin_per_order_qtd_this_year}-${attached_margin_per_order_qtd_this_year_target}), ABS(${attached_margin_per_order_qtd_this_year_target})) ;;
  }

#ATTACHED MARGIN PER ORDER - YEAR
  measure: attached_margin_per_order_this_year {
    label: "Current year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${attached_margin_this_year},${orders_this_year}) ;;
  }

  measure: attached_margin_per_order_this_year_not_iso {
    label: "Current (non iso) year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${attached_margin_this_year_not_iso},${orders_this_year_not_iso}) ;;
  }

  measure: attached_margin_per_order_last_year {
    label: "Last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${attached_margin_last_year},${orders_last_year}) ;;
  }

  measure: attached_margin_per_order_last_year_not_iso {
    label: "Last (non iso) year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${attached_margin_last_year_not_iso},${orders_last_year_not_iso}) ;;
  }

  measure: attached_margin_per_order_this_year_target {
    label: "Current year target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${attached_margin_this_year_target},${orders_this_year_target}) ;;
  }

  measure: attached_margin_per_order_this_year_target_not_iso {
    label: "Current (non iso) year target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0.00"
    sql: SAFE_DIVIDE(${attached_margin_this_year_target_not_iso},${orders_this_year_target_not_iso}) ;;
  }

  measure: attached_margin_per_order_two_years_ago {
    label: "Two years ago attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_two_years_ago},${orders_two_years_ago}) ;;
  }

  measure: attached_margin_per_order_two_years_ago_not_iso {
    label: "Two (non iso) years ago attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_two_years_ago_not_iso},${orders_two_years_ago_not_iso}) ;;
  }

#ATTACHED MARGIN PER ORDER - YTD
  measure: attached_margin_per_order_ytd_this_year {
    label: "YTD attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_ytd_this_year},${orders_ytd_this_year}) ;;
  }

  measure: attached_margin_per_order_ytd_last_year {
    label: "YTD last year attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_ytd_last_year},${orders_ytd_last_year}) ;;
  }

  measure: attached_margin_per_order_ytd_yoy {
    label: "YTD YoY growth attached margin per order"
    group_label: "Attached Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${attached_margin_per_order_ytd_this_year}-${attached_margin_per_order_ytd_last_year}), ABS(${attached_margin_per_order_ytd_last_year})) ;;
  }

  measure: attached_margin_per_order_ytd_this_year_target {
    label: "YTD attached margin per order target"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${attached_margin_ytd_this_year_target},${orders_ytd_this_year_target}) ;;
  }

  measure: attached_margin_per_order_ytd_delta_target {
    label: "YTD delta target attached margin per order"
    group_label: "Attached Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${attached_margin_per_order_ytd_this_year}-${attached_margin_per_order_ytd_this_year_target}), ABS(${attached_margin_per_order_ytd_this_year_target})) ;;
  }

#SALES - YESTERDAY
  measure: sales_yesterday_this_year {
    label: "Yesterday sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_yesterday_last_year {
    label: "Yesterday last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_yesterday_yoy {
    label: "Yesterday YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${sales_yesterday_this_year}-${sales_yesterday_last_year}), ABS(${sales_yesterday_last_year})) ;;
  }

#SALES - WEEK
  measure: sales_last_week_this_year {
    label: "Last week sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_this_week_last_year {
    label: "Current week last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_isoweek_last_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_last_week_last_year {
    group_label: "Sales"
    label: "Last week last year sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_two_weeks_this_year {
    label: "Two weeks ago sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_last_week_target {
    label: "Last week target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_week_delta_target {
    label: "Last week delta target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_last_week_this_year}-${sales_last_week_target}), ABS(${sales_last_week_target})) ;;
  }

  measure: sales_week_deviation_target {
    label: "Last week difference target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_last_week_this_year}-${sales_last_week_target} ;;
  }

  measure: sales_wow_abs {
    label: "Absolute WoW growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_last_week_this_year}-${sales_two_weeks_this_year} ;;
  }

  measure: sales_wow_abs_abs {
    label: "Absolute value of 'Sales WoW absolute'"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format:"€0.0,\" K\""
    sql: ABS(${sales_wow_abs}) ;;
  }

  measure: sales_week_yoy_abs_abs {
    label: "Absolute value of 'Sales YoY absolute'"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format:"€0.0,\" K\""
    sql: ABS(${sales_week_yoy_abs}) ;;
  }

  measure: sales_wow {
    label: "Last week WoW growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_last_week_this_year}-${sales_two_weeks_this_year}), ABS(${sales_two_weeks_this_year})) ;;
  }

  measure: sales_week_yoy {
    label: "Last week YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_last_week_this_year}-${sales_last_week_last_year}), ABS(${sales_last_week_last_year})) ;;
  }

  measure: sales_week_yoy_abs {
    label: "Absolute YoY sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_last_week_this_year}-${sales_last_week_last_year} ;;
  }

  measure: sales_last_week_and_wow {
    label: "Sales last week (WoW)"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: count
    html:
      {% if sales_wow._value > 0 %}
    {{ sales_last_week_this_year._rendered_value  }} ( {{ sales_wow._rendered_value  }} <font color="#00B900"> ▲ </font> )
      {% elsif sales_wow._value == 0 %}
    {{ sales_last_week_this_year._rendered_value  }} ( {{ sales_wow._rendered_value  }} <font color="#000000"> - </font> )
      {% elsif sales_wow._value < 0 %}
    {{ sales_last_week_this_year._rendered_value  }} ( {{ sales_wow._rendered_value  }} <font color="#E50000"> ▼ </font> )
      {% endif %}
 ;;
  }

  measure: sales_last_week {
    label: "Last completed week sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_week: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_last_year_last_week {
    label: "Last week last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_week_last_year: "yes"]
    sql: ${sales} ;;
  }

#SALES - WTD
  measure: sales_wtd_this_year {
    label: "WTD sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    drill_fields: [date_date,date_day_of_week,sales_wtd_this_year]
    filters: [is_wtd: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_wtd_last_week_this_year {
    label: "WTD last week sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_wtd_last_year {
    label: "WTD last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_wtd_yoy {
    label: "WTD YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${sales_wtd_this_year}-${sales_wtd_last_year}), ABS(${sales_wtd_last_year})) ;;
  }

  measure: sales_wtd_yoy_abs {
    label: "WTD YoY absolute growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${sales_wtd_this_year}-${sales_wtd_last_year} ;;
  }

  measure: sales_wtd_wow {
    label: "WTD WoW growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${sales_wtd_this_year}-${sales_wtd_last_week_this_year}), ABS(${sales_wtd_last_week_this_year})) ;;
  }

  measure: sales_wtd_wow_abs {
    label: "WTD WoW absolute growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${sales_wtd_this_year}-${sales_wtd_last_week_this_year} ;;
  }

#SALES - MONTH
  measure: sales_last_month_this_year {
    label: "Last month sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_last_month_last_year {
    label: "Last month last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_two_months_this_year {
    label: "Two months ago sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_last_month_target {
    label: "Last month target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_month_delta_target {
    label: "Last month delta target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_last_month_this_year}-${sales_last_month_target}), ABS(${sales_last_month_target})) ;;
  }

  measure: sales_month_deviation_target {
    label: "Last month difference target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_last_month_this_year}-${sales_last_month_target} ;;
  }

  measure: sales_mom {
    label: "Last month MoM growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_last_month_this_year}-${sales_two_months_this_year}), ABS(${sales_two_months_this_year})) ;;
  }

  measure: sales_mom_abs {
    label: "Absolute MoM growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_last_month_this_year}-${sales_two_months_this_year} ;;
  }

  measure: sales_mom_abs_abs {
    label: "Absolute value of 'Absolute MoM growth sales'"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format:"€0.0,\" K\""
    sql: ABS(${sales_mom_abs}) ;;
  }

  measure: sales_month_yoy {
    label: "Last month YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${sales_last_month_this_year}-${sales_last_month_last_year}), ABS(${sales_last_month_last_year})) ;;
  }

  measure: sales_month_yoy_abs {
    label: "Absolute YoY sales for last month"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${sales_last_month_this_year}-${sales_last_month_last_year} ;;
  }

  measure: sales_month_yoy_abs_abs {
    label: "Absolute value of 'Sales Monthly YoY absolute'"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format:"€0.0,\" K\""
    sql: ABS(${sales_month_yoy_abs}) ;;
  }

#ORDER-LEVEL SALES - MONTH
  measure: order_level_sales_last_month_this_year {
    hidden: no
    label: "Last month order-level sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: IFNULL(${primary_sales},0) + IFNULL(${attached_sales},0) ;;
  }

  measure: order_level_sales_last_month_last_year {
    label: "Last month last year order-level sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: IFNULL(${primary_sales},0) + IFNULL(${attached_sales},0) ;;
  }

  measure: order_level_sales_month_yoy {
    hidden: no
    label: "Last month YoY growth order-level sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${order_level_sales_last_month_this_year}-${order_level_sales_last_month_last_year}), ABS(${order_level_sales_last_month_last_year})) ;;
  }

  measure: order_level_sales_month_yoy_abs {
    hidden: no
    label: "Absolute YoY order-level sales for last month"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${order_level_sales_last_month_this_year}-${order_level_sales_last_month_last_year} ;;
  }

#SALES - MTD
  measure: sales_mtd_this_year {
    label: "MTD sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_mtd_last_year {
    label: "MTD last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_mtd_yoy {
    label: "MTD YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_0
    sql: SAFE_DIVIDE((${sales_mtd_this_year}-${sales_mtd_last_year}), ABS(${sales_mtd_last_year})) ;;
  }

  measure: sales_mtd_this_year_target {
    label: "MTD sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_mtd_delta_target {
    label: "MTD delta target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_mtd_this_year}-${sales_mtd_this_year_target}), ABS(${sales_mtd_this_year_target})) ;;
  }

#SALES - QTD
  measure: sales_qtd_this_year {
    label: "QTD sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_qtd: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_qtd_last_year {
    label: "QTD last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_qtd_yoy {
    label: "QTD YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_qtd_this_year}-${sales_qtd_last_year}), ABS(${sales_qtd_last_year})) ;;
  }

  measure: sales_qtd_this_year_target {
    label: "QTD sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_qtd_delta_target {
    label: "QTD delta target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_qtd_this_year}-${sales_qtd_this_year_target}), ABS(${sales_qtd_this_year_target})) ;;
  }

#SALES - YEAR
  measure: sales_this_year {
    label: "Current year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes", hide_current_week: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_this_year_not_iso {
    label: "Current (non iso) year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_this_year_target {
    label: "Current year target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_this_year_target_not_iso {
    label: "Current (non iso) year target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_last_year {
    label: "Last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_last_year_not_iso {
    label: "Last (non iso) year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_two_years_ago {
    label: "Two years ago sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_two_years_ago_not_iso {
    label: "Two (non iso) years ago sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago_not_iso: "yes"]
    sql: ${sales} ;;
  }

#SALES - YTD
  measure: sales_ytd_this_year {
    label: "YTD sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_ytd_last_year {
    label: "YTD last year sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_ytd_yoy {
    label: "YTD YoY growth sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_ytd_this_year}-${sales_ytd_last_year}), ABS(${sales_ytd_last_year})) ;;
  }

  measure: sales_ytd_yoy_abs {
    label: "YTD YoY growth sales abs"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${sales_ytd_this_year}-${sales_ytd_last_year} ;;
  }

  measure: sales_ytd_this_year_target {
    label: "YTD sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_ytd_delta_target {
    label: "YTD delta target sales"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_ytd_this_year}-${sales_ytd_this_year_target}), ABS(${sales_ytd_this_year_target})) ;;
  }

  measure: sales_ytd_delta_target_abs {
    label: "YTD delta target sales absolute"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_ytd_this_year}-${sales_ytd_this_year_target} ;;
  }

  measure: sales_ytd_this_year_last_month {
    label: "YTD sales last month"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_ytd_last_year_last_month {
    label: "YTD last year sales last month"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month_previous_year: "yes"]
    sql: ${sales} ;;
  }

  measure: sales_ytd_yoy_last_month {
    label: "YTD YoY growth sales last month"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_ytd_this_year_last_month}-${sales_ytd_last_year_last_month}), ABS(${sales_ytd_last_year_last_month})) ;;
  }

  measure: sales_ytd_yoy_abs_last_month {
    label: "YTD YoY growth sales abs last month"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${sales_ytd_this_year_last_month}-${sales_ytd_last_year_last_month} ;;
  }

  measure: sales_ytd_this_year_target_last_month {
    label: "YTD sales target last month"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${sales_target} ;;
  }

  measure: sales_ytd_delta_target_last_month {
    label: "YTD delta target sales last month"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${sales_ytd_this_year_last_month}-${sales_ytd_this_year_target_last_month}), ABS(${sales_ytd_this_year_target_last_month})) ;;
  }

  measure: sales_ytd_delta_target_abs_last_month {
    label: "YTD delta target sales absolute last month"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name:eur_0
    sql: ${sales_ytd_this_year_last_month}-${sales_ytd_this_year_target_last_month} ;;
  }

#STORE SALES - MTD
  measure: store_sales_mtd_this_year {
    label: "MTD store sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes", outlettype: "Store"]
    sql: ${sales} ;;
  }

  measure: store_sales_mtd_last_year {
    label: "MTD last year store sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes", outlettype: "Store"]
    sql: ${sales} ;;
  }

  measure: store_sales_mtd_this_year_target {
    label: "MTD store sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes", outlettype: "Store"]
    sql: ${sales_target} ;;
  }

#STORE SALES - QTD
  measure: store_sales_qtd_this_year {
    label: "QTD store sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes", outlettype: "Store"]
    sql: ${sales} ;;
  }

  measure: store_sales_qtd_last_year {
    label: "QTD last year store sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes", outlettype: "Store"]
    sql: ${sales} ;;
  }

  measure: store_sales_qtd_this_year_target {
    label: "QTD store sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes", outlettype: "Store"]
    sql: ${sales_target} ;;
  }

#STORE SALES - YTD
  measure: store_sales_ytd_this_year {
    label: "YTD store sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes", outlettype: "Store"]
    sql: ${sales} ;;
  }

  measure: store_sales_ytd_last_year {
    label: "YTD last year store sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes", outlettype: "Store"]
    sql: ${sales} ;;
  }

  measure: store_sales_ytd_this_year_target {
    label: "YTD store sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes", outlettype: "Store"]
    sql: ${sales_target} ;;
  }

#STORE SALES SHARE - MTD
  measure: store_sales_share_mtd_this_year {
    label: "MTD store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_mtd_this_year},${sales_mtd_this_year}) ;;
  }

  measure: store_sales_share_mtd_last_year {
    label: "MTD last year store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_mtd_last_year},${sales_mtd_last_year}) ;;
  }

  measure: store_sales_share_mtd_yoy {
    label: "MTD YoY growth store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${store_sales_share_mtd_this_year}-${store_sales_share_mtd_last_year}) ;;
  }

  measure: store_sales_share_mtd_this_year_target {
    label: "MTD store sales share target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_mtd_this_year_target},${sales_mtd_this_year_target}) ;;
  }

  measure: store_sales_share_mtd_delta_target {
    label: "MTD delta target store sales share"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${store_sales_share_mtd_this_year}-${store_sales_share_mtd_this_year_target}) ;;
  }

#STORE SALES SHARE - QTD
  measure: store_sales_share_qtd_this_year {
    label: "QTD store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_qtd_this_year},${sales_qtd_this_year}) ;;
  }

  measure: store_sales_share_qtd_last_year {
    label: "QTD last year store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_qtd_last_year},${sales_qtd_last_year}) ;;
  }

  measure: store_sales_share_qtd_yoy {
    label: "QTD YoY growth store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${store_sales_share_qtd_this_year}-${store_sales_share_qtd_last_year}) ;;
  }

  measure: store_sales_share_qtd_this_year_target {
    label: "QTD store sales share target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_qtd_this_year_target},${sales_qtd_this_year_target}) ;;
  }

  measure: store_sales_share_qtd_delta_target {
    label: "QTD delta target store sales share"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${store_sales_share_qtd_this_year}-${store_sales_share_qtd_this_year_target}) ;;
  }

#STORE SALES SHARE - YTD
  measure: store_sales_share_ytd_this_year {
    label: "YTD store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_ytd_this_year},${sales_ytd_this_year}) ;;
  }

  measure: store_sales_share_ytd_last_year {
    label: "YTD last year store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_ytd_last_year},${sales_ytd_last_year}) ;;
  }

  measure: store_sales_share_ytd_yoy {
    label: "YTD YoY growth store sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${store_sales_share_ytd_this_year}-${store_sales_share_ytd_last_year}) ;;
  }

  measure: store_sales_share_ytd_this_year_target {
    label: "YTD store sales share target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${store_sales_ytd_this_year_target},${sales_ytd_this_year_target}) ;;
  }

  measure: store_sales_share_ytd_delta_target {
    label: "YTD delta target store sales share"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${store_sales_share_ytd_this_year}-${store_sales_share_ytd_this_year_target}) ;;
  }

#ONLINE SALES - MTD
  measure: online_sales_mtd_this_year {
    label: "MTD online sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes", outlettype: "Website"]
    sql: ${sales} ;;
  }

  measure: online_sales_mtd_last_year {
    label: "MTD last year online sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes", outlettype: "Website"]
    sql: ${sales} ;;
  }

  measure: online_sales_mtd_this_year_target {
    label: "MTD online sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes", outlettype: "Website"]
    sql: ${sales_target} ;;
  }

#ONLINE SALES - QTD
  measure: online_sales_qtd_this_year {
    label: "QTD online sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes", outlettype: "Website"]
    sql: ${sales} ;;
  }

  measure: online_sales_qtd_last_year {
    label: "QTD last year online sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes", outlettype: "Website"]
    sql: ${sales} ;;
  }

  measure: online_sales_qtd_this_year_target {
    label: "QTD online sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes", outlettype: "Website"]
    sql: ${sales_target} ;;
  }

#ONLINE SALES - YTD
  measure: online_sales_ytd_this_year {
    label: "YTD online sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes", outlettype: "Website"]
    sql: ${sales} ;;
  }

  measure: online_sales_ytd_last_year {
    label: "YTD last year online sales"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes", outlettype: "Website"]
    sql: ${sales} ;;
  }

  measure: online_sales_ytd_this_year_target {
    label: "YTD online sales target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes", outlettype: "Website"]
    sql: ${sales_target} ;;
  }

#ONLINE SALES SHARE - MTD
  measure: online_sales_share_mtd_this_year {
    label: "MTD online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_mtd_this_year},${sales_mtd_this_year}) ;;
  }

  measure: online_sales_share_mtd_last_year {
    label: "MTD last year online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_mtd_last_year},${sales_mtd_last_year}) ;;
  }

  measure: online_sales_share_mtd_yoy {
    label: "MTD YoY growth online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${online_sales_share_mtd_this_year}-${online_sales_share_mtd_last_year}) ;;
  }

  measure: online_sales_share_mtd_this_year_target {
    label: "MTD online sales share target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_mtd_this_year_target},${sales_mtd_this_year_target}) ;;
  }

  measure: online_sales_share_mtd_delta_target {
    label: "MTD delta target online sales share"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${online_sales_share_mtd_this_year}-${online_sales_share_mtd_this_year_target}) ;;
  }

#ONLINE SALES SHARE - QTD
  measure: online_sales_share_qtd_this_year {
    label: "QTD online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_qtd_this_year},${sales_qtd_this_year}) ;;
  }

  measure: online_sales_share_qtd_last_year {
    label: "QTD last year online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_qtd_last_year},${sales_qtd_last_year}) ;;
  }

  measure: online_sales_share_qtd_yoy {
    label: "QTD YoY growth online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${online_sales_share_qtd_this_year}-${online_sales_share_qtd_last_year}) ;;
  }

  measure: online_sales_share_qtd_this_year_target {
    label: "QTD online sales share target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_qtd_this_year_target},${sales_qtd_this_year_target}) ;;
  }

  measure: online_sales_share_qtd_delta_target {
    label: "QTD delta target online sales share"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${online_sales_share_qtd_this_year}-${online_sales_share_qtd_this_year_target}) ;;
  }

#ONLINE SALES SHARE - YTD
  measure: online_sales_share_ytd_this_year {
    label: "YTD online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_ytd_this_year},${sales_ytd_this_year}) ;;
  }

  measure: online_sales_share_ytd_last_year {
    label: "YTD last year online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_ytd_last_year},${sales_ytd_last_year}) ;;
  }

  measure: online_sales_share_ytd_yoy {
    label: "YTD YoY growth online sales share"
    group_label: "Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${online_sales_share_ytd_this_year}-${online_sales_share_ytd_last_year}) ;;
  }

  measure: online_sales_share_ytd_this_year_target {
    label: "YTD online sales share target"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${online_sales_ytd_this_year_target},${sales_ytd_this_year_target}) ;;
  }

  measure: online_sales_share_ytd_delta_target {
    label: "YTD delta target online sales share"
    group_label: "Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${online_sales_share_ytd_this_year}-${online_sales_share_ytd_this_year_target}) ;;
  }

#PRIMARY SALES - YESTERDAY
  measure: primary_sales_yesterday_this_year {
    label: "Yesterday primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${primary_sales} ;;
  }

  measure: primary_sales_yesterday_last_year {
    label: "Yesterday last year primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday_previous_year: "yes"]
    sql: ${primary_sales} ;;
  }

  measure: primary_sales_yesterday_yoy {
    label: "Yesterday YoY growth primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${primary_sales_yesterday_this_year}-${primary_sales_yesterday_last_year}), ABS(${primary_sales_yesterday_last_year})) ;;
  }

#PRIMARY SALES - WTD
  measure: primary_sales_wtd_this_year {
    label: "WTD primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd: "yes"]
    sql: ${primary_sales} ;;
  }

  measure: primary_sales_wtd_last_year {
    label: "WTD last year primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${primary_sales} ;;
  }

  measure: primary_sales_wtd_last_week_this_year {
    label: "Last week primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${primary_sales} ;;
  }

#PRIMARY SALES - LAST MONTH
  measure: primary_sales_last_month_this_year {
    label: "Last month primary sales"
    group_label: "Primary Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${primary_sales} ;;
  }

#PRIMARY SALES - MTD
  measure: primary_sales_mtd_this_year {
    label: "MTD primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql: ${primary_sales} ;;
  }

  measure: primary_sales_mtd_last_year {
    label: "MTD last year primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${primary_sales} ;;
  }

  measure: primary_sales_mtd_yoy {
    label: "MTD YoY growth primary sales"
    group_label: "Primary Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_0
    sql: SAFE_DIVIDE((${primary_sales_mtd_this_year}-${primary_sales_mtd_last_year}), ABS(${primary_sales_mtd_last_year})) ;;
  }

#ATTACHED SALES - YESTERDAY
  measure: attached_sales_yesterday_this_year {
    label: "Yesterday attached sales"
    group_label: "Attached Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${attached_sales} ;;
  }

  measure: attached_sales_yesterday_last_year {
    label: "Yesterday last year attached sales"
    group_label: "Attached Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday_previous_year: "yes"]
    sql: ${attached_sales} ;;
  }

  measure: attached_sales_yesterday_yoy {
    label: "Yesterday YoY growth attached sales"
    group_label: "Attached Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${attached_sales_yesterday_this_year}-${attached_sales_yesterday_last_year}), ABS(${attached_sales_yesterday_last_year})) ;;
  }

#ATTACHED SALES - LAST MONTH
  measure: attached_sales_last_month_this_year {
    label: "Last month attached sales"
    group_label: "Attached Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${attached_sales} ;;
  }

#ATTACHED SALES - MTD
  measure: attached_sales_mtd_this_year {
    label: "MTD attached sales"
    group_label: "Attached Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql: ${attached_sales} ;;
  }

  measure: attached_sales_mtd_last_year {
    label: "MTD last year attached sales"
    group_label: "Attached Sales"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${attached_sales} ;;
  }

  measure: attached_sales_mtd_yoy {
    label: "MTD YoY growth attached sales"
    group_label: "Attached Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_0
    sql: SAFE_DIVIDE((${attached_sales_mtd_this_year}-${attached_sales_mtd_last_year}), ABS(${attached_sales_mtd_last_year})) ;;
  }

#MARGIN - YESTERDAY
  measure: margin_yesterday_this_year {
    label: "Yesterday margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_yesterday_last_year {
    label: "Yesterday last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday_previous_year: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

#MARGIN - WEEK
  measure: margin_this_week_last_year {
    label: "Current week last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_isoweek_last_year:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_week_this_year {
    label: "Last week margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_two_weeks_this_year {
    label: "Two weeks ago margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_week_target {
    label: "Last week target margin incl. SAs"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek:"yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_last_week_last_year {
    label: "Last week last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_week {
    label: "Last completed week margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_week:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_year_last_week {
    label: "Last week last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_week_last_year:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_wow {
    label: "WoW growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_last_week_this_year}-${margin_two_weeks_this_year}), ABS(${margin_two_weeks_this_year})) ;;
  }

  measure: margin_week_yoy {
    label: "YoY growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_last_week_this_year}-${margin_last_week_last_year}), ABS(${margin_last_week_last_year})) ;;
  }

  measure: margin_week_delta_target {
    label: "Delta target last week margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_last_week_this_year}-${margin_last_week_target}), ABS(${margin_last_week_target})) ;;
  }

#MARGIN - WTD
  measure: margin_wtd_this_year {
    label: "WTD margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_wtd: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_wtd_last_week_this_year {
    label: "WTD last week margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_wtd_last_year {
    label: "WTD last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql:  ${product_margin_incl_ssa} ;;
  }

  measure: margin_wtd_wow {
    label: "WTD WoW margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${margin_wtd_this_year}-${margin_wtd_last_week_this_year}), ABS(${margin_wtd_last_week_this_year})) ;;
  }

  measure: margin_wtd_yoy {
    label: "WTD YoY margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${margin_wtd_this_year}-${margin_wtd_last_year}), ABS(${margin_wtd_last_year})) ;;
  }

#MARGIN - MONTH
  measure: margin_last_month_this_year {
    label: "Last month margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_month_last_year {
    label: "Last month last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_two_months_ago {
    label: "2 months ago margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_month_target {
    label: "Last month target margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_mom {
    label: "MoM growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_last_month_this_year}-${margin_two_months_ago}), ABS(${margin_two_months_ago})) ;;
  }

  measure: margin_month_yoy {
    label: "YoY growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_last_month_this_year}-${margin_last_month_last_year}), ABS(${margin_last_month_last_year})) ;;
  }

  measure: margin_month_delta_target {
    label: "Delta target last month margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_last_month_this_year}-${margin_last_month_target}), ABS(${margin_last_month_target})) ;;
  }

#MARGIN - MTD
  measure: margin_mtd_this_year {
    label: "MTD margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_mtd_last_year {
    label: "MTD last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_mtd_yoy {
    label: "MTD YoY growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_mtd_this_year}-${margin_mtd_last_year}), ABS(${margin_mtd_last_year})) ;;
  }

  measure: margin_mtd_this_year_target {
    label: "MTD margin target"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_mtd_delta_target {
    label: "MTD delta target margin"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_mtd_this_year}-${margin_mtd_this_year_target}), ABS(${margin_mtd_this_year_target})) ;;
  }

#MARGIN - QTD
  measure: margin_qtd_this_year {
    label: "QTD margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_qtd: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_qtd_last_year {
    label: "QTD last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_qtd_yoy {
    label: "QTD YoY growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_qtd_this_year}-${margin_qtd_last_year}), ABS(${margin_qtd_last_year})) ;;
  }

  measure: margin_qtd_this_year_target {
    label: "QTD margin target"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_qtd_delta_target {
    label: "QTD delta target margin"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_qtd_this_year}-${margin_qtd_this_year_target}), ABS(${margin_qtd_this_year_target})) ;;
  }

#MARGIN - YEAR
  measure: margin_this_year {
    label: "Current year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_this_year_not_iso {
    label: "Current (non iso) year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_year {
    label: "Last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_last_year_not_iso {
    label: "Last (non iso) year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_this_year_target {
    label: "Current year target margin incl. SAs"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year:"yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_this_year_target_not_iso {
    label: "Current (non iso) year target margin incl. SAs"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso:"yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_two_years_ago {
    label: "Two years ago margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_two_years_ago_not_iso {
    label: "Two (non iso) years ago margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

#MARGIN - YTD
  measure: margin_ytd_this_year {
    label: "YTD margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_ytd: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_ytd_last_year {
    label: "YTD last year margin incl. SAs"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_ytd_yoy {
    label: "YTD YoY growth margin"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_ytd_this_year}-${margin_ytd_last_year}), ABS(${margin_ytd_last_year})) ;;
  }

  measure: margin_ytd_this_year_target {
    label: "YTD margin target"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

  measure: margin_ytd_delta_target {
    label: "YTD delta target margin"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${margin_ytd_this_year}-${margin_ytd_this_year_target}), ABS(${margin_ytd_this_year_target})) ;;
  }

  measure: margin_ytd_this_year_last_month {
    label: "YTD margin incl. SAs last month"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_ytd_last_year_last_month {
    label: "YTD last year margin incl. SAs last month"
    group_label: "Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month_previous_year: "yes"]
    sql: ${product_margin_incl_ssa} ;;
  }

  measure: margin_ytd_this_year_target_last_month {
    label: "YTD margin target last month"
    group_label: "Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${invoice_product_margin_incl_ssa_target} ;;
  }

#MARGIN AS PERCENT OF SALES - YESTERDAY
  measure: margin_perc_yesterday_this_year {
    label: "Yesterday margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_yesterday_this_year},${sales_yesterday_this_year}) ;;
  }

  measure: margin_perc_yesterday_last_year {
    label: "Yesterday last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_yesterday_last_year},${sales_yesterday_last_year}) ;;
  }

  measure: margin_perc_yesterday_yoy {
    label: "Yesterday YoY growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_yesterday_this_year}-${margin_perc_yesterday_last_year}) ;;
  }

#MARGIN AS PERCENT OF SALES - WEEK
  measure: margin_perc_this_week_last_year {
    label: "Current week last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format:  "0.0%"
    sql: SAFE_DIVIDE(${margin_this_week_last_year},${sales_this_week_last_year}) ;;
  }

  measure: margin_perc_last_week_this_year {
    label: "Last week margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_week_this_year},${sales_last_week_this_year}) ;;
  }

  measure: margin_perc_two_weeks_this_year {
    label: "Two weeks ago margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_two_weeks_this_year},${sales_two_weeks_this_year}) ;;
  }

  measure: margin_perc_last_week_target {
    label: "Last week target margin incl. SAs as % of sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_week_target},${sales_last_week_target}) ;;
  }

  measure: margin_perc_last_week_last_year {
    label: "Last week last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_week_last_year},${sales_last_week_last_year}) ;;
  }

  measure: margin_perc_yoy_week {
    label: "Last week YoY growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: IFNULL(${margin_perc_last_week_this_year},0)-IFNULL(${margin_perc_last_week_last_year},0) ;;
  }

  measure: margin_perc_wow_abs {
    label: "Absolute WoW growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: IFNULL(${margin_perc_last_week_this_year},0)-IFNULL(${margin_perc_two_weeks_this_year},0) ;;
  }

  measure: margin_perc_delta_target {
    label: "Last week delta target margin incl. SAs as % of sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: ${margin_perc_last_week_this_year}-${margin_perc_last_week_target} ;;
  }

  measure: margin_perc_last_week {
    label: "Last completed week margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${margin_last_week},${sales_last_week}) ;;
  }

  measure: margin_perc_last_year_last_week {
    label: "Last week last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${margin_last_year_last_week},${sales_last_year_last_week}) ;;
  }

#MARGIN AS PERCENT OF SALES - WTD
  measure: margin_perc_wtd_this_year {
    label: "WTD margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${margin_wtd_this_year},${sales_wtd_this_year}) ;;
  }

  measure: margin_perc_wtd_last_year {
    label: "WTD last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${margin_wtd_last_year},${sales_wtd_last_year}) ;;
  }

  measure: margin_perc_wtd_last_week_this_year {
    label: "WTD last week margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${margin_wtd_last_week_this_year},${sales_wtd_last_week_this_year}) ;;
  }

  measure: margin_perc_wtd_wow_abs {
    label: "WTD WoW growth margin % sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: IFNULL(${margin_perc_wtd_this_year},0)-IFNULL(${margin_perc_wtd_last_week_this_year},0) ;;
  }

  measure: margin_perc_wtd_yoy_abs {
    label: "WTD YoY growth margin % sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: IFNULL(${margin_perc_wtd_this_year},0)-IFNULL(${margin_perc_wtd_last_year},0) ;;
  }

#MARGIN AS PERCENT OF SALES - MONTH
  measure: margin_perc_last_month_this_year {
    label: "Last month margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_month_this_year},${sales_last_month_this_year}) ;;
  }

  measure: margin_perc_last_month_last_year {
    label: "Last month last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_month_last_year},${sales_last_month_last_year}) ;;
  }

  measure: margin_perc_two_months_this_year {
    label: "Two months ago margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_two_months_ago},${sales_two_months_this_year}) ;;
  }

  measure: margin_perc_last_month_target {
    label: "Last month target margin incl. SAs as % of sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_month_target},${sales_last_month_target}) ;;
  }

  measure: margin_perc_yoy_month {
    label: "Last month YoY growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: IFNULL(${margin_perc_last_month_this_year},0)-IFNULL(${margin_perc_last_month_last_year},0) ;;
  }

  measure: margin_perc_mom_abs {
    label: "Absolute MoM growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: IFNULL(${margin_perc_last_month_this_year},0)-IFNULL(${margin_perc_two_months_this_year},0) ;;
  }

  measure: margin_perc_month_delta_target {
    label: "Last month delta target margin incl. SAs as % of sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: ${margin_perc_last_month_this_year}-${margin_perc_last_month_target} ;;
  }

#MARGIN AS PERCENT OF SALES - MTD
  measure: margin_perc_mtd_this_year {
    label: "MTD margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_mtd_this_year},${sales_mtd_this_year}) ;;
  }

  measure: margin_perc_mtd_last_year {
    label: "MTD last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_mtd_last_year},${sales_mtd_last_year}) ;;
  }

  measure: margin_perc_mtd_yoy {
    label: "MTD YoY growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_mtd_this_year}-${margin_perc_mtd_last_year}) ;;
  }

  measure: margin_perc_mtd_this_year_target {
    label: "MTD margin % sales target"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_mtd_this_year_target},${sales_mtd_this_year_target}) ;;
  }

  measure: margin_perc_mtd_delta_target {
    label: "MTD delta target margin % sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_mtd_this_year}-${margin_perc_mtd_this_year_target}) ;;
  }

#MARGIN AS PERCENT OF SALES - QTD
  measure: margin_perc_qtd_this_year {
    label: "QTD margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_qtd_this_year},${sales_qtd_this_year}) ;;
  }

  measure: margin_perc_qtd_last_year {
    label: "QTD last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_qtd_last_year},${sales_qtd_last_year}) ;;
  }

  measure: margin_perc_qtd_yoy {
    label: "QTD YoY growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_qtd_this_year}-${margin_perc_qtd_last_year}) ;;
  }

  measure: margin_perc_qtd_this_year_target {
    label: "QTD margin % sales target"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_qtd_this_year_target},${sales_qtd_this_year_target}) ;;
  }

  measure: margin_perc_qtd_delta_target {
    label: "QTD delta target margin % sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_qtd_this_year}-${margin_perc_qtd_this_year_target}) ;;
  }

#MARGIN AS PERCENT OF SALES - YEAR
  measure: margin_perc_this_year_target {
    label: "Current year target margin incl. SAs as % of sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql:SAFE_DIVIDE(${margin_this_year_target},${sales_this_year_target}) ;;
  }

  measure: margin_perc_this_year_target_not_iso {
    label: "Current (non iso) year target margin incl. SAs as % of sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql:SAFE_DIVIDE(${margin_this_year_target_not_iso},${sales_this_year_target_not_iso}) ;;
  }

  measure: margin_perc_this_year {
    label: "Current year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_this_year},${sales_this_year}) ;;
  }

  measure: margin_perc_this_year_not_iso {
    label: "Current (non iso) year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_this_year_not_iso},${sales_this_year_not_iso}) ;;
  }

  measure: margin_perc_last_year {
    label: "Last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_year},${sales_last_year}) ;;
  }

  measure: margin_perc_last_year_not_iso {
    label: "Last (non iso) year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_last_year_not_iso},${sales_last_year_not_iso}) ;;
  }

  measure: margin_perc_two_years_ago{
    label: "Two years ago margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_two_years_ago},${sales_two_years_ago}) ;;
  }

  measure: margin_perc_two_years_ago_not_iso{
    label: "Two (non iso) years ago margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_two_years_ago_not_iso},${sales_two_years_ago_not_iso}) ;;
  }

#MARGIN AS PERCENT OF SALES - YTD
  measure: margin_perc_ytd_this_year {
    label: "YTD margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_ytd_this_year},${sales_ytd_this_year}) ;;
  }

  measure: margin_perc_ytd_last_year {
    label: "YTD last year margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_ytd_last_year},${sales_ytd_last_year}) ;;
  }

  measure: margin_perc_ytd_yoy {
    label: "YTD YoY growth margin incl. SAs as % of sales"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_ytd_this_year}-${margin_perc_ytd_last_year}) ;;
  }

  measure: margin_perc_ytd_this_year_target {
    label: "YTD margin % sales target"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_ytd_this_year_target},${sales_ytd_this_year_target}) ;;
  }

  measure: margin_perc_ytd_delta_target {
    label: "YTD delta target margin % sales"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_ytd_this_year}-${margin_perc_ytd_this_year_target}) ;;
  }

  measure: margin_perc_ytd_this_year_last_month {
    label: "YTD margin incl. SAs as % of sales last month"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_ytd_this_year_last_month},${sales_ytd_this_year_last_month}) ;;
  }

  measure: margin_perc_ytd_last_year_last_month {
    label: "YTD last year margin incl. SAs as % of sales last month"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_ytd_last_year_last_month},${sales_ytd_last_year_last_month}) ;;
  }

  measure: margin_perc_ytd_yoy_last_month {
    label: "YTD YoY growth margin incl. SAs as % of sales last month"
    group_label: "Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_ytd_this_year_last_month}-${margin_perc_ytd_last_year_last_month}) ;;
  }

  measure: margin_perc_ytd_this_year_target_last_month {
    label: "YTD margin % sales target last month"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${margin_ytd_this_year_target_last_month},${sales_ytd_this_year_target_last_month}) ;;
  }

  measure: margin_perc_ytd_delta_target_last_month {
    label: "YTD delta target margin % sales last month"
    group_label: "Margin % Sales Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: (${margin_perc_ytd_this_year_last_month}-${margin_perc_ytd_this_year_target_last_month}) ;;
  }

#ORDERS - YESTERDAY
  measure: orders_yesterday_this_year {
    label: "Yesterday orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_yesterday_last_year {
    label: "Yesterday last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_yesterday_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_yesterday_yoy {
    label: "Yesterday YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${orders_yesterday_this_year}-${orders_yesterday_last_year}), ABS(${orders_yesterday_last_year})) ;;
  }

#ORDERS - WEEK
  measure: orders_last_week_this_year {
    label: "Last week orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_target_last_week_this_year {
    label: "Last week target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_last_week_last_year {
    label: "Last week last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_two_weeks_this_year {
    label: "Two weeks ago orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_wow_abs {
    label: "Absolute WoW growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: decimal_0
    sql: ${orders_last_week_this_year}-${orders_two_weeks_this_year} ;;
  }

  measure: orders_wow {
    label: "Last week WoW growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${orders_last_week_this_year}-${orders_two_weeks_this_year}), ABS(${orders_two_weeks_this_year})) ;;
  }

  measure: orders_week_yoy {
    label: "Last week YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${orders_last_week_this_year}-${orders_last_week_last_year}), ABS(${orders_last_week_last_year})) ;;
  }

  measure: orders_week_yoy_abs {
    label: "Absolute YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: decimal_0
    sql: IFNULL(${orders_last_week_this_year},0)-IFNULL(${orders_last_week_last_year},0) ;;
  }

  measure: orders_week_delta_target {
    label: "Last week delta target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${orders_last_week_this_year}-${orders_target_last_week_this_year}), ABS(${orders_target_last_week_this_year})) ;;
  }

  measure: orders_last_week {
    label: "Last completed week orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_week: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_last_year_last_week {
    label: "Last week last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_week_last_year: "yes"]
    sql: ${orders} ;;
  }

#ORDERS - WTD
  measure: orders_wtd_this_year {
    label: "WTD orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_wtd: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_wtd_last_year {
    label: "WTD last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_wtd_last_week_this_year {
    label: "WTD last week orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_wtd_wow {
    label: "WTD WoW orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${orders_wtd_this_year}-${orders_wtd_last_week_this_year}), ABS(${orders_wtd_last_week_this_year})) ;;
  }

  measure: orders_wtd_yoy {
    label: "WTD YoY orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${orders_wtd_this_year}-${orders_wtd_last_year}), ABS(${orders_wtd_last_year})) ;;
  }

#ORDERS - MONTH
  measure: orders_last_month_this_year {
    label: "Last month orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_last_month: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_target_last_month_this_year {
    label: "Last month target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_month: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_last_month_last_year {
    label: "Last month last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_two_months_this_year {
    label: "Two months ago orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_mom_abs {
    label: "Absolute MoM growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql:${orders_last_month_this_year}-${orders_two_months_this_year} ;;
  }

  measure: orders_mom {
    label: "Last month MoM growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${orders_last_month_this_year}-${orders_two_months_this_year}), ABS(${orders_two_months_this_year})) ;;
  }

  measure: orders_month_yoy {
    label: "Last month YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${orders_last_month_this_year}-${orders_last_month_last_year}), ABS(${orders_last_month_last_year})) ;;
  }

  measure: orders_month_yoy_abs {
    label: "Absolute YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur_0
    sql: ${orders_last_month_this_year}-${orders_last_month_last_year} ;;
  }

  measure: orders_month_delta_target {
    label: "Last month delta target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${orders_last_month_this_year}-${orders_target_last_month_this_year}), ABS(${orders_target_last_month_this_year})) ;;
  }

#ORDERS - MTD
  measure: orders_mtd_this_year {
    label: "MTD orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_mtd: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_mtd_last_year {
    label: "MTD last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_mtd_yoy {
    label: "MTD YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${orders_mtd_this_year}-${orders_mtd_last_year}), ABS(${orders_mtd_last_year})) ;;
  }

  measure: orders_mtd_this_year_target {
    label: "MTD orders target"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_mtd: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_mtd_delta_target {
    label: "MTD delta target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${orders_mtd_this_year}-${orders_mtd_this_year_target}), ABS(${orders_mtd_this_year_target})) ;;
  }

#ORDERS - QTD
  measure: orders_qtd_this_year {
    label: "QTD orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_qtd: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_qtd_last_year {
    label: "QTD last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_qtd_yoy {
    label: "QTD YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${orders_qtd_this_year}-${orders_qtd_last_year}), ABS(${orders_qtd_last_year})) ;;
  }

  measure: orders_qtd_this_year_target {
    label: "QTD orders target"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_qtd: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_qtd_delta_target {
    label: "QTD delta target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${orders_qtd_this_year}-${orders_qtd_this_year_target}), ABS(${orders_qtd_this_year_target})) ;;
  }

#ORDERS - YEAR
  measure: orders_this_year {
    label: "Current year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year: "yes", hide_current_week: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_this_year_not_iso {
    label: "Current (non iso) year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_this_year_target {
    label: "Current year target orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_this_year_target_not_iso {
    label: "Current (non iso) year target orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_last_year {
    label: "Last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_last_year_not_iso {
    label: "Last (non iso) year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_two_years_ago {
    label: "Two years ago orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_years_ago:"yes"]
    sql: ${orders} ;;
  }

  measure: orders_two_years_ago_not_iso {
    label: "Two (non iso) years ago orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${orders} ;;
  }

#ORDERS - YTD
  measure: orders_ytd_this_year {
    label: "YTD orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_ytd_last_year {
    label: "YTD last year orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_ytd_yoy {
    label: "YTD YoY growth orders"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${orders_ytd_this_year}-${orders_ytd_last_year}), ABS(${orders_ytd_last_year})) ;;
  }

  measure: orders_ytd_this_year_target {
    label: "YTD orders target"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd: "yes"]
    sql: ${orders_target} ;;
  }

  measure: orders_ytd_delta_target {
    label: "YTD delta target orders"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${orders_ytd_this_year}-${orders_ytd_this_year_target}), ABS(${orders_ytd_this_year_target})) ;;
  }

  measure: orders_ytd_this_year_last_month {
    label: "YTD orders last month"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_ytd_last_year_last_month {
    label: "YTD last year orders last month"
    group_label: "Orders"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd_last_month_previous_year: "yes"]
    sql: ${orders} ;;
  }

  measure: orders_ytd_this_year_target_last_month {
    label: "YTD orders target last month"
    group_label: "Orders Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${orders_target} ;;
  }

#TRANSACTION MARGIN - YESTERDAY
  measure: transaction_margin_wtd_this_year {
    label: "WTD transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_yesterday_this_year {
    label: "Yesterday transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_yesterday_last_year {
    label: "Yesterday last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_yesterday_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_yesterday_yoy {
    label: "Yesterday YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_yesterday_this_year}-${transaction_margin_yesterday_last_year}), ABS(${transaction_margin_yesterday_last_year})) ;;
  }

#TRANSACTION MARGIN - WEEK
  measure: transaction_margin_this_week_last_year {
    label: "Current week last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_isoweek_last_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_week_this_year {
    label: "Last week transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_week_last_year {
    label: "Last week last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_target_last_week_this_year {
    label: "Last week target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${transaction_margin_target} ;;
  }

  measure: transaction_margin_two_weeks_this_year {
    label: "Two weeks ago transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_week_yoy {
    label: "Last week YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_last_week_this_year}-${transaction_margin_last_week_last_year}), ABS(${transaction_margin_last_week_last_year})) ;;
  }

  measure: transaction_margin_last_week_yoy_abs {
    label: "Absolute YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_last_week_this_year}-${transaction_margin_last_week_last_year} ;;
  }

  measure: transaction_margin_last_week_yoy_abs_abs {
    label: "Absolute value of 'Absolute YoY growth transaction margin'"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ABS(${transaction_margin_last_week_yoy_abs}) ;;
  }

  measure: transaction_margin_wow {
    label: "Last week WoW growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_last_week_this_year}-${transaction_margin_two_weeks_this_year}), ABS(${transaction_margin_two_weeks_this_year})) ;;
  }

  measure: transaction_margin_wow_abs {
    label: "Absolute WoW growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_last_week_this_year}-${transaction_margin_two_weeks_this_year} ;;
  }

  measure: transaction_margin_wow_abs_abs {
    label: "Absolute value of 'Transaction Margin WoW abs'"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ABS(${transaction_margin_wow_abs}) ;;
  }

  measure: transaction_margin_week_delta_target {
    label: "Last week delta target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_last_week_this_year}-${transaction_margin_target_last_week_this_year}), ABS(${transaction_margin_target_last_week_this_year})) ;;
  }

  measure: transaction_margin_week_deviation_target {
    label: "Last week difference target transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_last_week_this_year}-${transaction_margin_target_last_week_this_year} ;;
  }

  measure: transaction_margin_last_week {
    label: "Last completed week transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_week: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_year_last_week {
    label: "Last week last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_week_last_year: "yes"]
    sql: ${transaction_margin} ;;
  }

#TRANSACTION MARGIN - WTD
  measure: transaction_margin_wtd_last_year {
    label: "WTD last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_wtd_yoy_abs {
    label: "WTD YoY absolute growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_wtd_this_year}-${transaction_margin_wtd_last_year} ;;
  }

  measure: transaction_margin_wtd_yoy {
    label: "WTD YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE(${transaction_margin_wtd_this_year}-${transaction_margin_wtd_last_year}, ABS(${transaction_margin_wtd_last_year})) ;;
  }

  measure: transaction_margin_wtd_last_week_this_year {
    label: "WTD last week transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_wtd_wow {
    label: "WTD WoW growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_wtd_this_year}-${transaction_margin_wtd_last_week_this_year}), ABS(${transaction_margin_wtd_last_week_this_year})) ;;
  }

  measure: transaction_margin_wtd_wow_abs {
    label: "WTD WoW absolute growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_wtd_this_year}-${transaction_margin_wtd_last_week_this_year} ;;
  }

#TRANSACTION MARGIN - MONTH
  measure: transaction_margin_last_month_this_year {
    label: "Last month transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_month_last_year {
    label: "Last month last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_target_last_month_this_year {
    label: "Last month target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${transaction_margin_target} ;;
  }

  measure: transaction_margin_two_months_this_year {
    label: "Two months ago transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_month_yoy {
    label: "Last month YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_last_month_this_year}-${transaction_margin_last_month_last_year}), ABS(${transaction_margin_last_month_last_year})) ;;
  }

  measure: transaction_margin_last_month_yoy_abs {
    label: "Last month absolute YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_last_month_this_year}-${transaction_margin_last_month_last_year} ;;
  }

  measure: transaction_margin_last_month_yoy_abs_abs {
    label: "Absolute value of 'Last month absolute YoY growth transaction margin'"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ABS(${transaction_margin_last_month_yoy_abs}) ;;
  }

  measure: transaction_margin_mom {
    label: "Last month MoM growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_last_month_this_year}-${transaction_margin_two_months_this_year}), ABS(${transaction_margin_two_months_this_year})) ;;
  }

  measure: transaction_margin_mom_abs {
    label: "Absolute MoM growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_last_month_this_year}-${transaction_margin_two_months_this_year} ;;
  }

  measure: transaction_margin_mom_abs_abs {
    label: "Absolute value of 'Transaction Margin MoM abs'"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ABS(${transaction_margin_mom_abs}) ;;
  }

  measure: transaction_margin_month_delta_target {
    label: "Last month delta target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_last_month_this_year}-${transaction_margin_target_last_month_this_year}), ABS(${transaction_margin_target_last_month_this_year})) ;;
  }

  measure: transaction_margin_month_deviation_target {
    label: "Last month difference target transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: ${transaction_margin_last_month_this_year}-${transaction_margin_target_last_month_this_year} ;;
  }

#TRANSACTION MARGIN - MTD
  measure: transaction_margin_mtd_this_year {
    label: "MTD transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_mtd: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_mtd_last_year {
    label: "MTD last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_mtd_yoy {
    label: "MTD YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_0
    sql: SAFE_DIVIDE((${transaction_margin_mtd_this_year}-${transaction_margin_mtd_last_year}), ABS(${transaction_margin_mtd_last_year})) ;;
  }

  measure: transaction_margin_mtd_this_year_target {
    label: "MTD transaction margin target"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_mtd: "yes"]
    sql: ${transaction_margin_target} ;;
  }

  measure: transaction_margin_mtd_delta_target {
    label: "MTD delta target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_mtd_this_year}-${transaction_margin_mtd_this_year_target}), ABS(${transaction_margin_mtd_this_year_target})) ;;
  }

#TRANSACTION MARGIN - QTD
  measure: transaction_margin_qtd_this_year {
    label: "QTD transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_qtd: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_qtd_last_year {
    label: "QTD last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_qtd_yoy {
    label: "QTD YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_qtd_this_year}-${transaction_margin_qtd_last_year}), ABS(${transaction_margin_qtd_last_year})) ;;
  }

  measure: transaction_margin_qtd_this_year_target {
    label: "QTD transaction margin target"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_qtd: "yes"]
    sql: ${transaction_margin_target} ;;
  }

  measure: transaction_margin_qtd_delta_target {
    label: "QTD delta target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_qtd_this_year}-${transaction_margin_qtd_this_year_target}), ABS(${transaction_margin_qtd_this_year_target})) ;;
  }

#TRANSACTION MARGIN - YEAR
  measure: transaction_margin_this_year {
    label: "Current year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes", hide_current_week: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_this_year_not_iso {
    label: "Current (non iso) year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_year {
    label: "Last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_last_year_not_iso {
    label: "Last (non iso) year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_two_years_ago {
    label: "Two years ago transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago:"yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_two_years_ago_not_iso {
    label: "Two (non iso) years ago transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_this_year_target {
    label: "Current year target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year: "yes"]
    sql: ${transaction_margin_target} ;;
  }

  measure: transaction_margin_this_year_target_not_iso {
    label: "Current (non iso) year target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${transaction_margin_target} ;;
  }

#TRANSACTION MARGIN - YTD
  measure: transaction_margin_ytd_this_year {
    label: "YTD transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_ytd: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_ytd_last_year {
    label: "YTD last year transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_ytd_yoy {
    label: "YTD YoY growth transaction margin"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_ytd_this_year}-${transaction_margin_ytd_last_year}), ABS(${transaction_margin_ytd_last_year})) ;;
  }

  measure: transaction_margin_ytd_this_year_target {
    label: "YTD transaction margin target"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd: "yes"]
    sql: ${transaction_margin_target} ;;
  }

  measure: transaction_margin_ytd_delta_target {
    label: "YTD delta target transaction margin"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_ytd_this_year}-${transaction_margin_ytd_this_year_target}), ABS(${transaction_margin_ytd_this_year_target})) ;;
  }

  measure: transaction_margin_ytd_this_year_last_month {
    label: "YTD transaction margin last month"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "[>=1000000]€0.00,,\"M\";[>=10000]€0,\"K\";€0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_ytd_last_year_last_month {
    label: "YTD last year transaction margin last month"
    group_label: "Transaction Margin"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month_previous_year: "yes"]
    sql: ${transaction_margin} ;;
  }

  measure: transaction_margin_ytd_this_year_target_last_month {
    label: "YTD transaction margin target last month"
    group_label: "Transaction Margin Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_ytd_last_month: "yes"]
    sql: ${transaction_margin_target} ;;
  }

#TRANSACTION MARGIN AS PERCENT OF SALES
  measure: transaction_margin_perc_last_week_this_year {
    label: "Last week transaction margin % sales"
    group_label: "Transaction Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${transaction_margin_last_week_this_year},${sales_last_week_this_year}) ;;
  }

  measure: transaction_margin_perc_last_week_last_year {
    label: "Last week last year transaction margin % sales"
    group_label: "Transaction Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%"
    sql: SAFE_DIVIDE(${transaction_margin_last_week_last_year},${sales_last_week_last_year}) ;;
  }

  measure: transaction_margin_perc_yoy_week {
    label: "Last week YoY growth transaction margin % sales"
    group_label: "Transaction Margin % Sales"
    view_label: "Period on period calculations"
    type: number
    value_format: "0.0%\"p\""
    sql: ${transaction_margin_perc_last_week_this_year} - ${transaction_margin_perc_last_week_last_year};;
  }

#TRANSACTION MARGIN PER ORDER - YESTERDAY
  measure: transaction_margin_per_order_yesterday_this_year {
    label: "Yesterday transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_yesterday_this_year},${orders_yesterday_this_year}) ;;
  }

#TRANSACTION MARGIN PER ORDER - WEEK
  measure: transaction_margin_per_order_last_week_this_year {
    label: "Last week transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_last_week_this_year},${orders_last_week_this_year}) ;;
  }

  measure: transaction_margin_per_order_last_week_last_year {
    label: "Last week last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${transaction_margin_last_week_last_year},${orders_last_week_last_year}) ;;
  }

  measure: transaction_margin_per_order_last_week_target {
    label: "Last week target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_target_last_week_this_year},${orders_target_last_week_this_year}) ;;
  }

  measure: transaction_margin_per_order_two_weeks_this_year {
    label: "Two weeks ago transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_two_weeks_this_year},${orders_two_weeks_this_year}) ;;
  }

  measure: transaction_margin_per_order_wow_abs {
    label: "Absolute WoW growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${transaction_margin_per_order_last_week_this_year},0)-IFNULL(${transaction_margin_per_order_two_weeks_this_year},0);;
  }

  measure: transaction_margin_per_order_wow {
    label: "Last week WoW growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${transaction_margin_per_order_last_week_this_year}-${transaction_margin_per_order_two_weeks_this_year}), ABS(${transaction_margin_per_order_two_weeks_this_year})) ;;
  }

  measure: transaction_margin_per_order_week_yoy {
    label: "Last week YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${transaction_margin_per_order_last_week_this_year}-${transaction_margin_per_order_last_week_last_year}), ABS(${transaction_margin_per_order_last_week_last_year})) ;;
  }

  measure: transaction_margin_per_order_week_yoy_abs {
    label: "Absolute YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${transaction_margin_per_order_last_week_this_year},0)-IFNULL(${transaction_margin_per_order_last_week_last_year},0) ;;
  }

  measure: transaction_margin_per_order_week_delta_target {
    label: "Last week delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${transaction_margin_per_order_last_week_this_year}-${transaction_margin_per_order_last_week_target}), ABS(${transaction_margin_per_order_last_week_target})) ;;
  }

  measure: transaction_margin_per_order_week_delta_target_abs {
    label: "Absolute delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: ${transaction_margin_per_order_last_week_this_year}-${transaction_margin_per_order_last_week_target} ;;
  }

  measure: transaction_margin_per_order_last_week {
    label: "Last completed week transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${transaction_margin_last_week},${orders_last_week}) ;;
  }

  measure: transaction_margin_per_order_last_year_last_week {
    label: "Last week last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${transaction_margin_last_year_last_week},${orders_last_year_last_week}) ;;
  }

#TRANSACTION MARGIN PER ORDER - WTD
  measure: transaction_margin_per_order_wtd_this_year {
    label: "WTD transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_wtd_this_year},${orders_wtd_this_year}) ;;
  }

  measure: transaction_margin_per_order_wtd_last_week_this_year {
    label: "WTD last week transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_wtd_last_week_this_year},${orders_wtd_last_week_this_year}) ;;
  }

  measure: transaction_margin_per_order_wtd_last_year {
    label: "WTD last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_wtd_last_year},${orders_wtd_last_year}) ;;
  }

  measure: transaction_margin_per_order_wtd_wow {
    label: "WTD WoW growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_per_order_wtd_this_year}-${transaction_margin_per_order_wtd_last_week_this_year}), ABS(${transaction_margin_per_order_wtd_last_week_this_year})) ;;
  }

  measure: transaction_margin_per_order_wtd_wow_abs {
    label: "WTD absolute WoW transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${transaction_margin_per_order_wtd_this_year},0)-IFNULL(${transaction_margin_per_order_wtd_last_week_this_year},0) ;;
  }

  measure: transaction_margin_per_order_wtd_yoy {
    label: "WTD YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${transaction_margin_per_order_wtd_this_year}-${transaction_margin_per_order_wtd_last_year}), ABS(${transaction_margin_per_order_wtd_last_year})) ;;
  }

  measure: transaction_margin_per_order_wtd_yoy_abs {
    label: "WTD absolute YoY transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${transaction_margin_per_order_wtd_this_year},0)-IFNULL(${transaction_margin_per_order_wtd_last_year},0) ;;
  }

#TRANSACTION MARGIN PER ORDER - MONTH
  measure: transaction_margin_per_order_last_month_this_year {
    label: "Last month transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_last_month_this_year},${orders_last_month_this_year}) ;;
  }

  measure: transaction_margin_per_order_last_month_last_year {
    label: "Last month last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_last_month_last_year},${orders_last_month_last_year}) ;;
  }

  measure: transaction_margin_per_order_last_month_target {
    label: "Last month target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_target_last_month_this_year},${orders_target_last_month_this_year}) ;;
  }

  measure: transaction_margin_per_order_two_months_this_year {
    label: "Two months ago transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format: "€#,##0"
    sql: SAFE_DIVIDE(${transaction_margin_two_months_this_year},${orders_two_months_this_year}) ;;
  }

  measure: transaction_margin_per_order_mom_abs {
    label: "Absolute MoM growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: ${transaction_margin_per_order_last_month_this_year}-${transaction_margin_per_order_two_months_this_year} ;;
  }

  measure: transaction_margin_per_order_mom {
    label: "Last month MoM growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${transaction_margin_per_order_last_month_this_year}-${transaction_margin_per_order_two_months_this_year}), ABS(${transaction_margin_per_order_two_months_this_year})) ;;
  }

  measure: transaction_margin_per_order_month_yoy {
    label: "Last month YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${transaction_margin_per_order_last_month_this_year}-${transaction_margin_per_order_last_month_last_year}), ABS(${transaction_margin_per_order_last_month_last_year})) ;;
  }

  measure: transaction_margin_per_order_month_yoy_abs {
    label: "Last month absolute YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: ${transaction_margin_per_order_last_month_this_year}-${transaction_margin_per_order_last_month_last_year} ;;
  }

  measure: transaction_margin_per_order_month_delta_target {
    label: "Last month delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${transaction_margin_per_order_last_month_this_year}-${transaction_margin_per_order_last_month_target}), ABS(${transaction_margin_per_order_last_month_target})) ;;
  }

  measure: transaction_margin_per_order_month_delta_target_abs {
    label: "Last month absolute delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: ${transaction_margin_per_order_last_month_this_year}-${transaction_margin_per_order_last_month_target} ;;
  }

#TRANSACTION MARGIN PER ORDER - MTD
  measure: transaction_margin_per_order_mtd_this_year {
    label: "MTD transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_mtd_this_year},${orders_mtd_this_year}) ;;
  }

  measure: transaction_margin_per_order_mtd_last_year {
    label: "MTD last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_mtd_last_year},${orders_mtd_last_year}) ;;
  }

  measure: transaction_margin_per_order_mtd_yoy {
    label: "MTD YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_mtd_this_year}-${transaction_margin_per_order_mtd_last_year}), ABS(${transaction_margin_per_order_mtd_last_year})) ;;
  }

  measure: transaction_margin_per_order_mtd_this_year_target {
    label: "MTD transaction margin per order target"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_mtd_this_year_target},${orders_mtd_this_year_target}) ;;
  }

  measure: transaction_margin_per_order_mtd_delta_target {
    label: "MTD delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_mtd_this_year}-${transaction_margin_per_order_mtd_this_year_target}), ABS(${transaction_margin_per_order_mtd_this_year_target})) ;;
  }

#TRANSACTION MARGIN PER ORDER - QTD
  measure: transaction_margin_per_order_qtd_this_year {
    label: "QTD transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_qtd_this_year},${orders_qtd_this_year}) ;;
  }

  measure: transaction_margin_per_order_qtd_last_year {
    label: "QTD last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_qtd_last_year},${orders_qtd_last_year}) ;;
  }

  measure: transaction_margin_per_order_qtd_yoy {
    label: "QTD YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_qtd_this_year}-${transaction_margin_per_order_qtd_last_year}), ABS(${transaction_margin_per_order_qtd_last_year})) ;;
  }

  measure: transaction_margin_per_order_qtd_this_year_target {
    label: "QTD transaction margin per order target"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_qtd_this_year_target},${orders_qtd_this_year_target}) ;;
  }

  measure: transaction_margin_per_order_qtd_delta_target {
    label: "QTD delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_qtd_this_year}-${transaction_margin_per_order_qtd_this_year_target}), ABS(${transaction_margin_per_order_qtd_this_year_target})) ;;
  }

#TRANSACTION MARGIN PER ORDER - YEAR
  measure: transaction_margin_per_order_this_year {
    label: "Current year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_this_year},${orders_this_year}) ;;
  }

  measure: transaction_margin_per_order_this_year_not_iso {
    label: "Current (non iso) year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_this_year_not_iso},${orders_this_year_not_iso}) ;;
  }

  measure: transaction_margin_per_order_last_year {
    label: "Last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_last_year},${orders_last_year}) ;;
  }

  measure: transaction_margin_per_order_last_year_not_iso {
    label: "Last (non iso) year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_last_year_not_iso},${orders_last_year_not_iso}) ;;
  }

  measure: transaction_margin_per_order_two_years_ago {
    label: "Two years ago transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_two_years_ago},${orders_two_years_ago}) ;;
  }

  measure: transaction_margin_per_order_two_years_ago_not_iso {
    label: "Two (non iso) years ago transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_two_years_ago_not_iso},${orders_two_years_ago_not_iso}) ;;
  }

  measure: transaction_margin_per_order_this_year_target {
    label: "Current year target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_this_year_target},${orders_this_year_target}) ;;
  }

  measure: transaction_margin_per_order_this_year_target_not_iso{
    label: "Current (non iso) year target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_this_year_target_not_iso},${orders_this_year_target_not_iso}) ;;
  }

#TRANSACTION MARGIN PER ORDER - YTD
  measure: transaction_margin_per_order_ytd_this_year {
    label: "YTD transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_ytd_this_year},${orders_ytd_this_year}) ;;
  }

  measure: transaction_margin_per_order_ytd_last_year {
    label: "YTD last year transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_ytd_last_year},${orders_ytd_last_year}) ;;
  }

  measure: transaction_margin_per_order_ytd_yoy {
    label: "YTD YoY growth transaction margin per order"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_ytd_this_year}-${transaction_margin_per_order_ytd_last_year}), ABS(${transaction_margin_per_order_ytd_last_year})) ;;
  }

  measure: transaction_margin_per_order_ytd_yoy_abs {
    label: "YTD YoY growth transaction margin per order absolute"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${transaction_margin_per_order_ytd_this_year},0)-IFNULL(${transaction_margin_per_order_ytd_last_year},0) ;;
  }

  measure: transaction_margin_per_order_ytd_this_year_target {
    label: "YTD transaction margin per order target"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_ytd_this_year_target},${orders_ytd_this_year_target}) ;;
  }

  measure: transaction_margin_per_order_ytd_delta_target {
    label: "YTD delta target transaction margin per order"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_ytd_this_year}-${transaction_margin_per_order_ytd_this_year_target}), ABS(${transaction_margin_per_order_ytd_this_year_target})) ;;
  }

  measure: transaction_margin_per_order_ytd_delta_target_abs {
    label: "YTD delta target transaction margin per order absolute"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: ${transaction_margin_per_order_ytd_this_year}-${transaction_margin_per_order_ytd_this_year_target} ;;
  }

  measure: transaction_margin_per_order_ytd_this_year_last_month {
    label: "YTD transaction margin per order last month"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_ytd_this_year_last_month},${orders_ytd_this_year_last_month}) ;;
  }

  measure: transaction_margin_per_order_ytd_last_year_last_month {
    label: "YTD last year transaction margin per order last month"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_ytd_last_year_last_month},${orders_ytd_last_year_last_month}) ;;
  }

  measure: transaction_margin_per_order_ytd_yoy_last_month {
    label: "YTD YoY growth transaction margin per order last month"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_ytd_this_year_last_month}-${transaction_margin_per_order_ytd_last_year_last_month}), ABS(${transaction_margin_per_order_ytd_last_year_last_month})) ;;
  }

  measure: transaction_margin_per_order_ytd_yoy_abs_last_month {
    label: "YTD YoY growth transaction margin per order absolute last month"
    group_label: "Transaction Margin per Order"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: IFNULL(${transaction_margin_per_order_ytd_this_year_last_month},0)-IFNULL(${transaction_margin_per_order_ytd_last_year_last_month},0) ;;
  }

  measure: transaction_margin_per_order_ytd_this_year_target_last_month {
    label: "YTD transaction margin per order target last month"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: SAFE_DIVIDE(${transaction_margin_ytd_this_year_target_last_month},${orders_ytd_this_year_target_last_month}) ;;
  }

  measure: transaction_margin_per_order_ytd_delta_target_last_month {
    label: "YTD delta target transaction margin per order last month"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${transaction_margin_per_order_ytd_this_year_last_month}-${transaction_margin_per_order_ytd_this_year_target_last_month}), ABS(${transaction_margin_per_order_ytd_this_year_target_last_month})) ;;
  }

  measure: transaction_margin_per_order_ytd_delta_target_abs_last_month {
    label: "YTD delta target transaction margin per order absolute last month"
    group_label: "Transaction Margin per Order Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: eur
    sql: ${transaction_margin_per_order_ytd_this_year_last_month}-${transaction_margin_per_order_ytd_this_year_target_last_month} ;;
  }

#PRODUCTS SOLD - YESTERDAY
  measure: products_sold_yesterday_this_year {
    label: "Yesterday products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_yesterday: "yes"]
    sql: ${products_sold} ;;
  }

#PRODUCTS SOLD - WEEK
  measure: products_sold_last_week_this_year {
    label: "Last week products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_last_week_last_year {
    label: "Last week last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_isoweek_last_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_two_weeks_this_year {
    label: "Two weeks ago products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_isoweeks_ago: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_wow {
    label: "Last week WoW growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${products_sold_last_week_this_year}-${products_sold_two_weeks_this_year}), ABS(${products_sold_two_weeks_this_year})) ;;
  }

  measure: products_sold_wow_abs {
    label: "Absolute WoW growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ${products_sold_last_week_this_year}-${products_sold_two_weeks_this_year} ;;
  }

  measure: products_sold_wow_abs_abs {
    label: "Absolute value of 'Products sold WoW absolute'"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ABS(${products_sold_wow_abs}) ;;
  }

  measure: products_sold_week_yoy {
    label: "Last week YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${products_sold_last_week_this_year}-${products_sold_last_week_last_year}), ABS(${products_sold_last_week_last_year})) ;;
  }

  measure: products_sold_week_yoy_abs {
    label: "Absolute YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ${products_sold_last_week_this_year}-${products_sold_last_week_last_year} ;;
  }

  measure: products_sold_week_yoy_abs_abs {
    label: "Absolute value of 'Products sold YoY absolute'"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ABS(${products_sold_week_yoy_abs}) ;;
  }

  measure: products_sold_last_week_and_wow {
    label: "Products sold last week (WoW)"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: count
    html:
      {% if sales_wow._value > 0 %}
    {{ products_sold_last_week_this_year._rendered_value  }} ( {{ products_sold_wow._rendered_value  }} <font color="#00B900"> ▲ </font> )
      {% elsif products_sold_wow._value == 0 %}
    {{ products_sold_last_week_this_year._rendered_value  }} ( {{ products_sold_wow._rendered_value  }} <font color="#000000"> - </font> )
      {% elsif products_sold_wow._value < 0 %}
    {{ products_sold_last_week_this_year._rendered_value  }} ( {{ products_sold_wow._rendered_value  }} <font color="#E50000"> ▼ </font> )
      {% endif %}
 ;;
  }

#PRODUCTS SOLD - WTD
  measure: products_sold_wtd_this_year {
    label: "WTD products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    drill_fields: [date_date,date_day_of_week,products_sold_wtd_this_year,]
    filters: [is_wtd: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_wtd_last_week_this_year {
    label: "WTD last week products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_wtd_last_week: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_wtd_last_year {
    label: "WTD last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_wtd_previous_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_wtd_yoy {
    label: "WTD YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${products_sold_wtd_this_year}-${products_sold_wtd_last_year}), ABS(${products_sold_wtd_last_year})) ;;
  }

  measure: products_sold_wtd_wow {
    label: "WTD WoW growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "0%"
    sql: SAFE_DIVIDE((${products_sold_wtd_this_year}-${products_sold_wtd_last_week_this_year}), ABS(${products_sold_wtd_last_week_this_year})) ;;
  }

#PRODUCTS SOLD - MONTH
  measure: products_sold_last_month_this_year {
    label: "Last month products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_month: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_last_month_last_year {
    label: "Last month last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_month_previous_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_two_months_this_year {
    label: "Two months ago products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_months_ago: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_month_yoy_abs_abs {
    label: "Absolute value of Products sold YoY absolute"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ABS(${products_sold_month_yoy_abs}) ;;
  }

  measure: products_sold_mom_abs {
    label: "Absolute MoM growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ${products_sold_last_month_this_year}-${products_sold_two_months_this_year} ;;
  }

  measure: products_sold_mom {
    label: "Last month MoM growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${products_sold_last_month_this_year}-${products_sold_two_months_this_year}), ABS(${products_sold_two_months_this_year})) ;;
  }

  measure: products_sold_mom_abs_abs {
    label: "Absolute value of 'Absolute MoM growth products sold'"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ABS(${products_sold_mom_abs}) ;;
  }

  measure: products_sold_month_yoy {
    label: "Last month YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${products_sold_last_month_this_year}-${products_sold_last_month_last_year}), ABS(${products_sold_last_month_last_year})) ;;
  }

  measure: products_sold_month_yoy_abs {
    label: "Absolute YoY growth products sold for last month"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ${products_sold_last_month_this_year}-${products_sold_last_month_last_year} ;;
  }

  measure: products_sold_last_week_target {
    label: "Last week target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_isoweek: "yes"]
    sql: ${products_sold_target} ;;
  }

  measure: products_sold_last_month_target {
    label: "Last month target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "€#,##0"
    filters: [is_last_month: "yes"]
    sql: ${products_sold_target} ;;
  }

  measure: products_sold_week_delta_target {
    label: "Last week delta target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${products_sold_last_week_this_year}-${products_sold_last_week_target}), ABS(${products_sold_last_week_target})) ;;
  }

  measure: products_sold_week_delta_target_abs {
    label: "Absolute delta target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ${products_sold_last_week_this_year}-${products_sold_last_week_target} ;;
  }

  measure: products_sold_month_delta_target {
    label: "Last month delta target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${products_sold_last_month_this_year}-${products_sold_last_month_target}), ABS(${products_sold_last_month_target})) ;;
  }

  measure: products_sold_month_delta_target_abs {
    label: "Absolute delta target products sold for last month"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format: "#,##0"
    sql: ${products_sold_last_month_this_year}-${products_sold_last_month_target} ;;
  }

#PRODUCTS SOLD - MTD
  measure: products_sold_mtd_this_year  {
    label: "MTD products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_mtd: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_mtd_last_year  {
    label: "MTD last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_mtd_previous_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_mtd_yoy {
    label: "MTD YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${products_sold_mtd_this_year}-${products_sold_mtd_last_year}), ABS(${products_sold_mtd_last_year})) ;;
  }

  measure: products_sold_mtd_this_year_target {
    label: "MTD products sold target"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_mtd: "yes"]
    sql: ${products_sold_target} ;;
  }

  measure: products_sold_mtd_delta_target {
    label: "MTD delta target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${products_sold_mtd_this_year}-${products_sold_mtd_this_year_target}), ABS(${products_sold_mtd_this_year_target})) ;;
  }
#PRODUCTS SOLD - QTD
  measure: products_sold_qtd_this_year {
    label: "QTD products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_qtd: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_qtd_last_year {
    label: "QTD last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_qtd_previous_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_qtd_yoy {
    label: "QTD YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${products_sold_qtd_this_year}-${products_sold_qtd_last_year}), ABS(${products_sold_qtd_last_year})) ;;
  }

  measure: products_sold_qtd_this_year_target {
    label: "QTD products sold target"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_qtd: "yes"]
    sql: ${products_sold_target} ;;
  }

  measure: products_sold_qtd_delta_target {
    label: "QTD delta target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${products_sold_qtd_this_year}-${products_sold_qtd_this_year_target}), ABS(${products_sold_qtd_this_year_target})) ;;
  }

#PRODUCTS SOLD - YEAR
  measure: products_sold_this_year {
    label: "Current year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year: "yes", hide_current_week: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_this_year_not_iso {
    label: "Current (non iso) year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_last_year {
    label: "Last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_last_year_not_iso {
    label: "Last (non iso) year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_last_year_not_iso: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_two_years_ago {
    label: "Two years ago products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_years_ago: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_two_years_ago_not_iso {
    label: "Two (non iso) years ago products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_two_years_ago_not_iso: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_this_year_target {
    label: "Current year target products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year: "yes"]
    sql: ${products_sold_target} ;;
  }

  measure: products_sold_this_year_target_not_iso {
    label: "Current (non iso) year target products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_current_year_not_iso: "yes"]
    sql: ${products_sold_target} ;;
  }

#PRODUCTS SOLD - YTD
  measure: products_sold_ytd_this_year {
    label: "YTD products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_ytd_last_year {
    label: "YTD last year products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd_previous_year: "yes"]
    sql: ${products_sold} ;;
  }

  measure: products_sold_ytd_yoy {
    label: "YTD YoY growth products sold"
    group_label: "Products Sold"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${products_sold_ytd_this_year}-${products_sold_ytd_last_year}), ABS(${products_sold_ytd_last_year})) ;;
  }

  measure: products_sold_ytd_this_year_target {
    label: "YTD products sold target"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: sum
    value_format: "#,##0"
    filters: [is_ytd: "yes"]
    sql: ${products_sold_target} ;;
  }

  measure: products_sold_ytd_delta_target {
    label: "YTD delta target products sold"
    group_label: "Products Sold Target"
    view_label: "Period on period calculations"
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE((${products_sold_ytd_this_year}-${products_sold_ytd_this_year_target}), ABS(${products_sold_ytd_this_year_target})) ;;
  }

#PRIMARY PRODUCTS SOLD - YEAR
  measure: primary_products_sold_this_year {
    label: "Current year primary products sold"
    group_label: "Primary Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_current_year: "yes"]
    sql: ${primary_products_sold} ;;
  }

  measure: primary_products_sold_this_year_not_iso {
    label: "Current (non iso) year primary products sold"
    group_label: "Primary Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_current_year_not_iso: "yes"]
    sql: ${primary_products_sold} ;;
  }

  measure: primary_products_sold_last_year {
    label: "Last year primary products sold"
    group_label: "Primary Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_last_year: "yes"]
    sql: ${primary_products_sold} ;;
  }

  measure: primary_products_sold_last_year_not_iso {
    label: "Last (non iso) year primary products sold"
    group_label: "Primary Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_last_year_not_iso: "yes"]
    sql: ${primary_products_sold} ;;
  }

  measure: primary_products_two_years_ago {
    label: "Two years ago primary products sold"
    group_label: "Primary Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_two_years_ago:"yes"]
    sql: ${primary_products_sold} ;;
  }

  measure: primary_products_two_years_ago_not_iso {
    label: "Two (non iso) years ago primary products sold"
    group_label: "Primary Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${primary_products_sold} ;;
  }

#ATTACHED PRODUCTS SOLD - YEAR
  measure: products_sold_as_attached_this_year {
    label: "Current year products sold as attached"
    group_label: "Products Sold as Attached"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_current_year: "yes"]
    sql: ${products_sold_as_attached} ;;
  }

  measure: products_sold_as_attached_this_year_not_iso {
    label: "Current (non iso) year products sold as attached"
    group_label: "Products Sold as Attached"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_current_year_not_iso: "yes"]
    sql: ${products_sold_as_attached} ;;
  }

  measure: attached_products_sold_this_year {
    label: "Current year attached products sold"
    group_label: "Attached Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_current_year: "yes"]
    sql: ${attached_products_sold} ;;
  }

  measure: products_sold_as_attached_sold_last_year {
    label: "Last year products sold as attached"
    group_label: "Products Sold as Attached"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_last_year: "yes"]
    sql: ${products_sold_as_attached} ;;
  }

  measure: products_sold_as_attached_sold_last_year_not_iso {
    label: "Last (non iso) year products sold as attached"
    group_label: "Products Sold as Attached"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_last_year_not_iso: "yes"]
    sql: ${products_sold_as_attached} ;;
  }

  measure: attached_products_sold_last_year {
    label: "Last year attached products"
    group_label: "Attached Products Sold"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_last_year: "yes"]
    sql: ${attached_products_sold} ;;
  }

  measure: products_sold_as_attached_two_years_ago {
    label: "Two years ago products sold as attached"
    group_label: "Products Sold as Attached"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_two_years_ago:"yes"]
    sql: ${products_sold_as_attached} ;;
  }

  measure: products_sold_as_attached_two_years_ago_not_iso {
    label: "Two (non iso) years ago products sold as attached"
    group_label: "Products Sold as Attached"
    view_label: "Period on period calculations"
    type: sum
    filters: [is_two_years_ago_not_iso:"yes"]
    sql: ${products_sold_as_attached} ;;
  }

# ---------------------------- Sets to define for aggregate tables --------------------------#
# Standard measures that we want to aggregate in the aggregate table

  set: commercial_results_pop_dimension_set {
    fields: [
      week_filter_yesterdays_results,
    ]
  }

  set: agg_measure_set_wtd_comparisons {
    fields: [
      sales_yesterday_this_year,
      sales_wtd_this_year,
      sales_wtd_last_year,
      sales_wtd_last_week_this_year,
      sales_last_week,
      sales_last_year_last_week,
      sales_wtd_wow,
      sales_wtd_wow_abs,
      sales_wtd_yoy,
      sales_wtd_yoy_abs,
      products_sold_yesterday_this_year,
      products_sold_wtd_this_year,
      products_sold_wtd_wow,
      products_sold_wtd_yoy,
      average_sales_price_yesterday_this_year,
      average_sales_price_wtd_this_year,
      average_sales_price_wtd_wow,
      average_sales_price_wtd_yoy,
      margin_perc_this_week_last_year,
      margin_perc_last_week_this_year,
      margin_perc_wtd_this_year,
      margin_perc_last_week,
      margin_perc_last_year_last_week,
      transaction_margin_yesterday_this_year,
      transaction_margin_wtd_this_year,
      transaction_margin_last_week,
      transaction_margin_last_year_last_week,
      transaction_margin_wtd_wow,
      transaction_margin_wtd_yoy,
      transaction_margin_per_order_wtd_this_year,
      transaction_margin_per_order_last_week,
      transaction_margin_per_order_last_year_last_week,
    ]
  }

  set: agg_measure_set_week_comparisons {
    fields: [
      sales_wtd_this_year,
      sales_this_week_last_year,
      sales_last_week_last_year,
      sales_last_week_this_year,
      sales_two_weeks_this_year,
      sales_wow_abs,
      sales_wow,
      sales_week_yoy,
      sales_week_yoy_abs,
      sales_week_yoy_abs_abs,
      sales_week_deviation_target,
      products_sold_last_week_this_year,
      products_sold_last_week_last_year,
      products_sold_two_weeks_this_year,
      products_sold_wow_abs,
      products_sold_wow,
      products_sold_week_yoy_abs,
      products_sold_week_yoy_abs_abs,
      products_sold_week_yoy,
      products_sold_week_delta_target,
      products_sold_week_delta_target_abs,
      average_sales_price_last_week_this_year,
      average_sales_price_last_week_last_year,
      average_sales_price_two_weeks_this_year,
      average_sales_price_wow_abs,
      average_sales_price_wow,
      average_sales_price_week_yoy_abs,
      average_sales_price_week_yoy,
      average_sales_price_week_delta_target_abs,
      margin_perc_two_weeks_this_year,
      margin_perc_last_week_this_year,
      margin_perc_last_week_last_year,
      margin_perc_delta_target,
      margin_perc_yoy_week,
      margin_perc_wow_abs,
      transaction_margin_last_week_this_year,
      transaction_margin_week_deviation_target,
      transaction_margin_wow_abs,
      transaction_margin_wow_abs_abs,
      transaction_margin_last_week_yoy_abs,
      transaction_margin_last_week_yoy_abs_abs,
      transaction_margin_last_week_yoy,
      transaction_margin_per_order_two_weeks_this_year,
      transaction_margin_per_order_last_week_this_year,
      transaction_margin_per_order_last_week_last_year,
      transaction_margin_per_order_week_delta_target_abs,
      transaction_margin_per_order_week_yoy_abs,
      transaction_margin_per_order_wow_abs,
      primary_margin_per_order_last_week_this_year,
      primary_margin_per_order_wow_abs,
      primary_margin_per_order_week_yoy_abs,
      attached_margin_per_order_last_week_this_year,
      attached_margin_per_order_wow_abs,
      attached_margin_per_order_week_yoy_abs,
      variable_cost_per_order_last_week_this_year,
      variable_cost_per_order_wow_abs,
      variable_cost_per_order_week_yoy_abs,
      orders_last_week_this_year,
      orders_wow_abs,
      orders_week_yoy_abs,
    ]
  }

  set: agg_measure_set_month_comparisons {
    fields: [
      sales_last_month_this_year,
      order_level_sales_last_month_this_year,
      sales_mom,
      sales_mom_abs,
      sales_mom_abs_abs,
      sales_month_delta_target,
      sales_month_deviation_target,
      sales_month_yoy,
      order_level_sales_month_yoy,
      sales_month_yoy_abs,
      order_level_sales_month_yoy_abs,
      sales_month_yoy_abs_abs,
      products_sold_last_month_this_year,
      products_sold_month_yoy,
      products_sold_month_yoy_abs,
      products_sold_month_yoy_abs_abs,
      products_sold_mom,
      products_sold_mom_abs,
      products_sold_mom_abs_abs,
      products_sold_month_delta_target_abs,
      transaction_margin_last_month_this_year,
      transaction_margin_mom,
      transaction_margin_mom_abs,
      transaction_margin_mom_abs_abs,
      transaction_margin_month_deviation_target,
      transaction_margin_last_month_yoy,
      transaction_margin_last_month_yoy_abs,
      transaction_margin_last_month_yoy_abs_abs,
      average_sales_price_last_month_this_year,
      average_sales_price_mom,
      average_sales_price_mom_abs,
      average_sales_price_month_delta_target_abs,
      average_sales_price_month_yoy_abs,
      margin_perc_two_months_this_year,
      margin_perc_last_month_this_year,
      margin_perc_last_month_last_year,
      margin_perc_mom_abs,
      margin_perc_yoy_month,
      transaction_margin_per_order_two_months_this_year,
      transaction_margin_per_order_last_month_this_year,
      transaction_margin_per_order_last_month_last_year,
      transaction_margin_per_order_mom_abs,
      transaction_margin_per_order_month_yoy_abs,
      primary_margin_per_order_last_month_this_year,
      primary_margin_per_order_mom_abs,
      primary_margin_per_order_month_yoy_abs,
      attached_margin_per_order_last_month_this_year,
      attached_margin_per_order_mom_abs,
      attached_margin_per_order_month_yoy_abs,
      variable_cost_per_order_last_month_this_year,
      variable_cost_per_order_mom_abs,
      variable_cost_per_order_month_yoy_abs,
      orders_last_month_this_year,
      orders_mom_abs,
      orders_month_yoy_abs,
    ]
  }

  set: agg_measure_set_year_comparisons {
    fields: [
      sales_this_year,
      sales_this_year_not_iso,
      sales_this_year_target,
      sales_this_year_target_not_iso,
      products_sold_this_year,
      products_sold_this_year_not_iso,
      products_sold_this_year_target,
      products_sold_this_year_target_not_iso,
      primary_products_sold_this_year,
      primary_products_sold_this_year_not_iso,
      products_sold_as_attached_this_year,
      products_sold_as_attached_this_year_not_iso,
      attached_products_sold_this_year,
      average_sales_price_this_year,
      average_sales_price_this_year_not_iso,
      average_sales_price_this_year_target,
      average_sales_price_this_year_target_not_iso,
      margin_perc_this_year,
      margin_perc_this_year_not_iso,
      margin_perc_this_year_target,
      margin_perc_this_year_target_not_iso,
      transaction_margin_this_year,
      transaction_margin_this_year_target,
      transaction_margin_this_year_not_iso,
      transaction_margin_last_year_not_iso,
      transaction_margin_per_order_this_year,
      transaction_margin_per_order_this_year_not_iso,
      transaction_margin_per_order_this_year_target,
      transaction_margin_per_order_this_year_target_not_iso,
      orders_this_year,
      orders_this_year_not_iso,
      orders_this_year_target,
      orders_this_year_target_not_iso,
      primary_margin_per_order_this_year,
      primary_margin_per_order_this_year_not_iso,
      primary_margin_per_order_this_year_target,
      primary_margin_per_order_this_year_target_not_iso,
      primary_margin_per_order_two_years_ago,
      primary_margin_per_order_two_years_ago_not_iso,
      attached_margin_per_order_this_year,
      attached_margin_per_order_this_year_not_iso,
      attached_margin_per_order_this_year_target,
      attached_margin_per_order_this_year_target_not_iso,
      attached_margin_per_order_two_years_ago,
      attached_margin_per_order_two_years_ago_not_iso,
      variable_cost_per_order_this_year,
      variable_cost_per_order_this_year_not_iso,
      variable_cost_per_order_this_year_target,
      variable_cost_per_order_this_year_target_not_iso,
      variable_cost_per_order_two_years_ago,
      variable_cost_per_order_two_years_ago_not_iso,
      gross_profit_impact_distributed_this_year,
      gross_profit_impact_distributed_this_year_not_iso,
      gross_profit_impact_distributed_this_year_target,
      gross_profit_impact_distributed_this_year_target_not_iso,
      sales_last_year,
      sales_last_year_not_iso,
      products_sold_last_year,
      products_sold_last_year_not_iso,
      primary_products_sold_last_year,
      primary_products_sold_last_year_not_iso,
      products_sold_as_attached_sold_last_year,
      products_sold_as_attached_sold_last_year_not_iso,
      attached_products_sold_last_year,
      average_sales_price_last_year,
      average_sales_price_last_year_not_iso,
      margin_perc_last_year,
      margin_perc_last_year_not_iso,
      transaction_margin_last_year,
      transaction_margin_per_order_last_year,
      transaction_margin_per_order_last_year_not_iso,
      orders_last_year,
      orders_last_year_not_iso,
      primary_margin_per_order_last_year,
      primary_margin_per_order_last_year_not_iso,
      attached_margin_per_order_last_year,
      attached_margin_per_order_last_year_not_iso,
      variable_cost_per_order_last_year,
      variable_cost_per_order_last_year_not_iso,
      gross_profit_impact_distributed_last_year,
      gross_profit_impact_distributed_last_year_not_iso,
      sales_two_years_ago,
      sales_two_years_ago_not_iso,
      products_sold_two_years_ago,
      products_sold_two_years_ago_not_iso,
      primary_products_two_years_ago,
      primary_products_two_years_ago_not_iso,
      products_sold_as_attached_two_years_ago,
      products_sold_as_attached_two_years_ago_not_iso,
      average_sales_price_two_years_ago,
      average_sales_price_two_years_ago_not_iso,
      margin_perc_two_years_ago,
      margin_perc_two_years_ago_not_iso,
      transaction_margin_two_years_ago,
      transaction_margin_two_years_ago_not_iso,
      transaction_margin_per_order_two_years_ago,
      transaction_margin_per_order_two_years_ago_not_iso,
      orders_two_years_ago,
      orders_two_years_ago_not_iso,
    ]
  }

  set: agg_measure_set_ytd_comparisons {
    fields: [
      sales_ytd_this_year,
      sales_ytd_last_year,
      sales_ytd_yoy,
      sales_ytd_yoy_abs,
      sales_ytd_delta_target,
      sales_ytd_delta_target_abs,
      average_sales_price_ytd_this_year,
      average_sales_price_ytd_last_year,
      average_sales_price_ytd_yoy,
      margin_perc_ytd_this_year,
      margin_perc_ytd_last_year,
      margin_perc_ytd_yoy,
      margin_perc_ytd_delta_target,
      transaction_margin_per_order_ytd_delta_target,
      transaction_margin_per_order_ytd_delta_target_abs,
      transaction_margin_per_order_ytd_this_year,
      transaction_margin_per_order_ytd_yoy_abs,
      transaction_margin_per_order_ytd_yoy,
      orders_ytd_this_year,
      orders_ytd_last_year,
      gross_profit_impact_distributed_ytd_this_year,
      gross_profit_impact_distributed_ytd_yoy,
      gross_profit_impact_distributed_ytd_yoy_abs,
      sales_ytd_this_year_last_month,
      sales_ytd_last_year_last_month,
      sales_ytd_yoy_last_month,
      sales_ytd_yoy_abs_last_month,
      sales_ytd_this_year_target_last_month,
      sales_ytd_delta_target_last_month,
      sales_ytd_delta_target_abs_last_month,
      margin_perc_ytd_this_year_last_month,
      margin_perc_ytd_last_year_last_month,
      margin_perc_ytd_yoy_last_month,
      margin_perc_ytd_this_year_target_last_month,
      margin_perc_ytd_delta_target_last_month,
      margin_ytd_this_year_last_month,
      margin_ytd_last_year_last_month,
      margin_ytd_this_year_target_last_month,
      transaction_margin_per_order_ytd_this_year_last_month,
      transaction_margin_per_order_ytd_last_year_last_month,
      transaction_margin_per_order_ytd_yoy_last_month,
      transaction_margin_per_order_ytd_yoy_abs_last_month,
      transaction_margin_per_order_ytd_this_year_target_last_month,
      transaction_margin_per_order_ytd_delta_target_last_month,
      transaction_margin_per_order_ytd_delta_target_abs_last_month,
      transaction_margin_ytd_this_year_last_month,
      transaction_margin_ytd_last_year_last_month,
      transaction_margin_ytd_this_year_target_last_month,
      orders_ytd_this_year_last_month,
      orders_ytd_last_year_last_month,
      orders_ytd_this_year_target_last_month,
      gross_profit_impact_distributed_ytd_this_year_last_month,
      gross_profit_impact_distributed_ytd_last_year_last_month,
      gross_profit_impact_distributed_ytd_yoy_last_month,
      gross_profit_impact_distributed_ytd_yoy_abs_last_month,
    ]
  }

  set: agg_measure_set_yesterdays_results {
    fields: [
      sales_yesterday_this_year,
      sales_yesterday_yoy,
      sales_mtd_yoy,
      primary_sales,
      primary_sales_yesterday_this_year,
      primary_sales_yesterday_yoy,
      primary_sales_mtd_yoy,
      attached_sales,
      attached_sales_yesterday_this_year,
      attached_sales_yesterday_yoy,
      attached_sales_mtd_yoy,
      transaction_margin_yesterday_this_year,
      transaction_margin_yesterday_yoy,
      transaction_margin_mtd_yoy,
      orders_yesterday_this_year,
      orders_yesterday_yoy,
      orders_mtd_yoy,
      margin_perc_yesterday_this_year,
      margin_perc_yesterday_yoy,
      margin_perc_mtd_yoy,
      products_sold_yesterday_this_year,
      average_sales_price_yesterday_this_year,
      attached_margin_per_order_yesterday_this_year
    ]
  }

  set: agg_measures_set_aimy {
    fields: [
      total_sales_target,
      sales_mtd_this_year,
      sales_qtd_this_year,
      sales_ytd_this_year,
      sales_mtd_yoy,
      sales_qtd_yoy,
      sales_ytd_yoy,
      sales_mtd_delta_target,
      sales_qtd_delta_target,
      sales_ytd_delta_target,
      products_sold_mtd_this_year,
      products_sold_qtd_this_year,
      products_sold_ytd_this_year,
      products_sold_mtd_yoy,
      products_sold_qtd_yoy,
      products_sold_ytd_yoy,
      products_sold_mtd_delta_target,
      products_sold_qtd_delta_target,
      products_sold_ytd_delta_target,
      average_sales_price_mtd_this_year,
      average_sales_price_qtd_this_year,
      average_sales_price_ytd_this_year,
      average_sales_price_mtd_yoy,
      average_sales_price_qtd_yoy,
      average_sales_price_ytd_yoy,
      average_sales_price_mtd_delta_target,
      average_sales_price_qtd_delta_target,
      average_sales_price_ytd_delta_target,
      online_sales_share_mtd_this_year,
      online_sales_share_qtd_this_year,
      online_sales_share_ytd_this_year,
      online_sales_share_mtd_yoy,
      online_sales_share_qtd_yoy,
      online_sales_share_ytd_yoy,
      online_sales_share_mtd_delta_target,
      online_sales_share_qtd_delta_target,
      online_sales_share_ytd_delta_target,
      store_sales_share_mtd_this_year,
      store_sales_share_qtd_this_year,
      store_sales_share_ytd_this_year,
      store_sales_share_mtd_yoy,
      store_sales_share_qtd_yoy,
      store_sales_share_ytd_yoy,
      store_sales_share_mtd_delta_target,
      store_sales_share_qtd_delta_target,
      store_sales_share_ytd_delta_target,
      margin_mtd_this_year,
      margin_qtd_this_year,
      margin_ytd_this_year,
      margin_mtd_yoy,
      margin_qtd_yoy,
      margin_ytd_yoy,
      margin_mtd_delta_target,
      margin_qtd_delta_target,
      margin_ytd_delta_target,
      margin_perc_mtd_this_year,
      margin_perc_qtd_this_year,
      margin_perc_ytd_this_year,
      margin_perc_mtd_yoy,
      margin_perc_qtd_yoy,
      margin_perc_ytd_yoy,
      margin_perc_mtd_delta_target,
      margin_perc_qtd_delta_target,
      margin_perc_ytd_delta_target,
      attached_margin_per_order_mtd_this_year,
      attached_margin_per_order_qtd_this_year,
      attached_margin_per_order_ytd_this_year,
      attached_margin_per_order_mtd_yoy,
      attached_margin_per_order_qtd_yoy,
      attached_margin_per_order_ytd_yoy,
      attached_margin_per_order_mtd_delta_target,
      attached_margin_per_order_qtd_delta_target,
      attached_margin_per_order_ytd_delta_target,
      transaction_margin_mtd_this_year,
      transaction_margin_qtd_this_year,
      transaction_margin_ytd_this_year,
      transaction_margin_mtd_yoy,
      transaction_margin_qtd_yoy,
      transaction_margin_ytd_yoy,
      transaction_margin_mtd_delta_target,
      transaction_margin_qtd_delta_target,
      transaction_margin_ytd_delta_target,
      transaction_margin_per_order_mtd_this_year,
      transaction_margin_per_order_qtd_this_year,
      transaction_margin_per_order_ytd_this_year,
      transaction_margin_per_order_mtd_yoy,
      transaction_margin_per_order_qtd_yoy,
      transaction_margin_per_order_ytd_yoy,
      transaction_margin_per_order_mtd_delta_target,
      transaction_margin_per_order_qtd_delta_target,
      transaction_margin_per_order_ytd_delta_target,
      orders_mtd_this_year,
      orders_mtd_this_year_target,
      orders_qtd_this_year,
      orders_qtd_this_year_target,
      orders_ytd_this_year,
      orders_ytd_this_year_target,
      orders_mtd_yoy,
      orders_qtd_yoy,
      orders_ytd_yoy,
      orders_mtd_delta_target,
      orders_qtd_delta_target,
      orders_ytd_delta_target,
      sales_marketing_cost_mtd_this_year,
      sales_marketing_cost_qtd_this_year,
      sales_marketing_cost_ytd_this_year,
      sales_marketing_cost_mtd_yoy,
      sales_marketing_cost_qtd_yoy,
      sales_marketing_cost_ytd_yoy,
      sales_marketing_cost_mtd_delta_target,
      sales_marketing_cost_qtd_delta_target,
      sales_marketing_cost_ytd_delta_target,
      sales_marketing_cost_per_order_mtd_this_year,
      sales_marketing_cost_per_order_qtd_this_year,
      sales_marketing_cost_per_order_ytd_this_year,
      sales_marketing_cost_per_order_mtd_yoy,
      sales_marketing_cost_per_order_qtd_yoy,
      sales_marketing_cost_per_order_ytd_yoy,
      sales_marketing_cost_per_order_mtd_delta_target,
      sales_marketing_cost_per_order_qtd_delta_target,
      sales_marketing_cost_per_order_ytd_delta_target,
      gross_profit_impact_distributed_mtd_this_year,
      gross_profit_impact_distributed_qtd_this_year,
      gross_profit_impact_distributed_ytd_this_year,
      gross_profit_impact_distributed_mtd_yoy,
      gross_profit_impact_distributed_qtd_yoy,
      gross_profit_impact_distributed_ytd_yoy
    ]
  }

}
