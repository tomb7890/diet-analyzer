$("#food_measure_id").empty()
  .append("<%= escape_javascript(options_for_select(@measures)) %>")
