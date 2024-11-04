---
- dashboard: value_tree__week
  title: Value tree - week
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: Wl4e0QLHBfXifzdDn3R3jJ
  elements:
  - title: GPI tile
    name: GPI tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.gross_profit_impact_distributed_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.gross_profit_impact_distributed_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 0
    col: 10
    width: 4
    height: 4
  - title: Sales marketing tile
    name: Sales marketing tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.sales_marketing_cost_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.sales_marketing_cost_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.sales_marketing_cost_html_week_target_wow_yoy: false
    title_placement_commercial_results.sales_marketing_cost_html_week_target_wow_yoy: above
    value_format_commercial_results.sales_marketing_cost_html_week_target_wow_yoy: ''
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 4
    col: 13
    width: 4
    height: 4
  - title: Additional media income tile
    name: Additional media income tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.additional_marketing_income_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.additional_marketing_income_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.additional_marketing_income_html_week_target_wow_yoy: false
    title_placement_commercial_results.additional_marketing_income_html_week_target_wow_yoy: above
    value_format_commercial_results.additional_marketing_income_html_week_target_wow_yoy: ''
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 4
    col: 9
    width: 4
    height: 4
  - title: TMpO tile
    name: TMpO tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.transaction_margin_per_order_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.transaction_margin_per_order_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 8
    col: 5
    width: 4
    height: 4
  - title: Orders tile
    name: Orders tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.orders_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.orders_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 8
    col: 12
    width: 4
    height: 4
  - title: Variable cost per order tile
    name: Variable cost per order tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.variable_cost_per_order_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.variable_cost_per_order_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 12
    col: 8
    width: 4
    height: 4
  - title: AMpO tile
    name: AMpO tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.attached_margin_per_order_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.attached_margin_per_order_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.attached_margin_per_order_html_week_target_wow_yoy: false
    title_placement_commercial_results.attached_margin_per_order_html_week_target_wow_yoy: above
    value_format_commercial_results.attached_margin_per_order_html_week_target_wow_yoy: ''
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 12
    col: 4
    width: 4
    height: 4
  - title: Primary margin per order tile
    name: Primary margin per order tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.primary_margin_per_order_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.primary_margin_per_order_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.primary_margin_per_order_html_week_target_wow_yoy: false
    title_placement_commercial_results.primary_margin_per_order_html_week_target_wow_yoy: above
    value_format_commercial_results.primary_margin_per_order_html_week_target_wow_yoy: ''
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 12
    col: 0
    width: 4
    height: 4
  - title: Sales tile
    name: Sales tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.sales_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.sales_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 20
    col: 2
    width: 4
    height: 4
  - title: SPQ tile
    name: SPQ tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.products_sold_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.products_sold_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 24
    col: 0
    width: 4
    height: 4
  - title: ASP tile
    name: ASP tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.average_sales_price_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.average_sales_price_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 24
    col: 4
    width: 4
    height: 4
  - title: Visibility cost tile
    name: Visibility cost tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.visibility_cost_distributed_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.visibility_cost_distributed_html_week_target_wow_yoy2: false
    show_title_commercial_results.visibility_cost_distributed_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#FF6600",
        font_color: !!null '', color_application: {collection_id: coolblue-colors,
          palette_id: coolblue-colors-sequential-0}, bold: false, italic: false, strikethrough: false,
        fields: !!null ''}]
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 4
    col: 21
    width: 3
    height: 4
  - title: Last Week header
    name: Last Week header
    model: commercial_planning_testing
    explore: commercial_results
    type: single_value
    fields: [commercial_results.last_week_tile]
    filters:
      commercial_results.is_last_isoweek: 'Yes'
    limit: 500
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 0
    col: 0
    width: 4
    height: 3
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ''
    row: 3
    col: 0
    width: 5
    height: 9
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 14
    width: 8
    height: 4
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 8
    width: 2
    height: 4
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "<div style=\" padding: 2px\">\n\n<a style=\"\ncolor: #000000;\nborder:\
      \ solid 1px #000000;\nfloat: left;\n\n    font-weight: 400;\n\n    width: 100px;\n\
      \n    text-align: center;\n\n    vertical-align: middle;\n\n    cursor: pointer;\n\
      \n    user-select: none;\n\n    padding: 10px;\n\n    margin: 5px;\n\n    font-size:\
      \ 2ex;\n\n    line-height: 1.2;\n\n    background-color:#D9E8FA;\n\n    border-radius:\
      \ 5px;\"\n\n    href=\"https://coolblue.cloud.looker.com/dashboards/879\">\n\
      \n    Weekview  \n\n</a>\n<a style=\"\ncolor: #000000;\nborder: solid 1px #BEBEBE;\n\
      float: left;\n\n    font-weight: 400;\n   width: 100px;\n    \ntext-align: center;\n\
      \n    vertical-align: middle;\n\n    cursor: pointer;\n\n    user-select: none;\n\
      \n    padding: 10px;\n\n    margin: 5px;\n\n    font-size: 2ex;\n\n    line-height:\
      \ 1.2;\n\n    background-color:#D9E8FA;\n\n    border-radius: 5px;\"\n\n   \
      \ href=\"https://coolblue.cloud.looker.com/dashboards/953\">\n\n    Monthview\n\
      \n</a>\n</div>"
    row: 0
    col: 4
    width: 4
    height: 3
  - title: Availability tile
    name: Availability tile
    model: stock_management
    explore: availability
    type: single_value
    fields: [availability.central_stock_availability_html_tile_wow_yoy]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_pivots: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: expanded
    note_display: above
    listen:
      Team: products.team_name
      Product Type: products.product_type_name
      Subproduct Type: products.subproduct_type_name
      Brand: products.brand_name
    row: 28
    col: 0
    width: 4
    height: 4
  - title: Partner marketing
    name: Partner marketing
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.partner_marketing_cost_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    show_title_commercial_results.partner_marketing_cost_html_week_target_wow_yoy: false
    show_title_commercial_results.visibility_cost_distributed_html_week_target_wow_yoy2: false
    show_title_commercial_results.visibility_cost_distributed_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#FF6600",
        font_color: !!null '', color_application: {collection_id: coolblue-colors,
          palette_id: coolblue-colors-sequential-0}, bold: false, italic: false, strikethrough: false,
        fields: !!null ''}]
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    hidden_pivots: {}
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 4
    col: 17
    width: 4
    height: 4
  - name: " (5)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ''
    row: 12
    col: 12
    width: 7
    height: 8
  - title: TM tile
    name: TM tile
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.transaction_margin_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.transaction_margin_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.transaction_margin_html_week_target_wow_yoy: false
    title_placement_commercial_results.transaction_margin_html_week_target_wow_yoy: above
    value_format_commercial_results.transaction_margin_html_week_target_wow_yoy: ''
    show_title_commercial_results.transaction_margin_per_order_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    hidden_pivots: {}
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 4
    col: 5
    width: 4
    height: 4
  - title: Margin %
    name: Margin %
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.margin_perc_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.margin_perc_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.margin_perc_html_week_target_wow_yoy: false
    title_placement_commercial_results.margin_perc_html_week_target_wow_yoy: above
    value_format_commercial_results.margin_perc_html_week_target_wow_yoy: ''
    show_title_commercial_results.sales_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    hidden_pivots: {}
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 16
    col: 4
    width: 4
    height: 4
  - title: Margin
    name: Margin
    model: commercial_planning_testing
    explore: commercial_results
    type: marketplace_viz_multiple_value::multiple_value-marketplace
    fields: [commercial_results.margin_html_week_target_wow_yoy]
    filters:
      commercial_results.date_week: 54 weeks
    limit: 500
    column_limit: 50
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: true
    font_size_main: ''
    orientation: auto
    style_commercial_results.margin_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.margin_html_week_target_wow_yoy: false
    title_placement_commercial_results.margin_html_week_target_wow_yoy: above
    value_format_commercial_results.margin_html_week_target_wow_yoy: ''
    style_commercial_results.margin_perc_html_week_target_wow_yoy: "#3A4245"
    show_title_commercial_results.margin_perc_html_week_target_wow_yoy: false
    title_placement_commercial_results.margin_perc_html_week_target_wow_yoy: above
    value_format_commercial_results.margin_perc_html_week_target_wow_yoy: ''
    show_title_commercial_results.sales_html_week_target_wow_yoy: false
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 0
    y_axes: []
    hidden_pivots: {}
    title_hidden: true
    listen:
      Customer type: commercial_results.customertype
      Focustype (Yes / No): commercial_results.focus_producttype
      Team: commercial_results.team
      Product Type: commercial_results.producttype
      Subproduct Type: commercial_results.subproducttype
      Brand: commercial_results.brand
      Region: commercial_results.region
      Country: commercial_results.subsidiary_country
    row: 20
    col: 6
    width: 4
    height: 4
  - title: visits
    name: visits
    model: webandapp_web
    explore: historical_traffic_stitched
    type: single_value
    fields: [historical_traffic_stitched.visits_html_tile_wow_yoy]
    filters:
      historical_traffic_stitched.date_raw: 2 weeks ago for 2 week, 54 weeks ago for
        4 week
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    y_axes: []
    listen:
      Team: products.team_name
      Product Type: products.product_type_name
      Subproduct Type: products.subproduct_type_name
      Brand: products.brand_name
      Region: historical_traffic_stitched.region
      Country: historical_traffic_stitched.subsidiary
    row: 20
    col: 11
    width: 4
    height: 4
  - title: conversion rate
    name: conversion rate
    model: webandapp_web
    explore: historical_traffic_stitched
    type: single_value
    fields: [historical_traffic_stitched.conversion_rate_html_tile_wow_yoy]
    filters:
      historical_traffic_stitched.date_raw: 2 weeks ago for 2 week, 54 weeks ago for
        4 week
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_pivots: {}
    defaults_version: 1
    y_axes: []
    listen:
      Team: products.team_name
      Product Type: products.product_type_name
      Subproduct Type: products.subproduct_type_name
      Brand: products.brand_name
      Region: historical_traffic_stitched.region
      Country: historical_traffic_stitched.subsidiary
    row: 20
    col: 15
    width: 4
    height: 4
  filters:
  - name: Team
    title: Team
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: []
    field: commercial_results.team
  - name: Product Type
    title: Product Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: [Team]
    field: commercial_results.producttype
  - name: Subproduct Type
    title: Subproduct Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: [Team, Product Type]
    field: commercial_results.subproducttype
  - name: Brand
    title: Brand
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: [Team, Product Type]
    field: commercial_results.brand
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: []
    field: commercial_results.subsidiary_country
  - name: Region
    title: Region
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: []
    field: commercial_results.region
  - name: Customer type
    title: Customer type
    type: field_filter
    default_value: B2B,Consumer,Business Consumer
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: []
    field: commercial_results.customertype
  - name: Focustype (Yes / No)
    title: Focustype (Yes / No)
    type: field_filter
    default_value: Yes,No
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: inline
    model: commercial_planning_testing
    explore: commercial_results
    listens_to_filters: []
    field: commercial_results.focus_producttype
