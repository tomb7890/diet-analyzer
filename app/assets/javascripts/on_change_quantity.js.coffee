# Dynamically update the nutrient values upon change in food measure

$ ->
  $(document).on 'change', '#quantity', (evt) ->
        $("#Energy").  val("")
        $("#Water").   val("")
        $("#Carbs").   val("")
        $("#Fiber").   val("")
        $("#Protein"). val("")
        $("#Fat").     val("")


        $.ajax 'update_nutrients',
              type: 'GET'
              dataType: 'script'
              data: {
                      ndbno: $("#food_type_id option:selected").val()
                      measure: $("#food_measure_id").val()
                      quantity: $("#quantity").val()
              }
              error: (jqXHR, textStatus, errorThrown) ->
                      console.log("AJAX on_change_quantity  Error: #{textStatus}")
              success: (data, textStatus, jqXHR) ->
                      console.log("AJAX on_change_quantity  select OK!")
