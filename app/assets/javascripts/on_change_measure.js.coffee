# Dynamically update the nutrient values upon change in food measure

$ ->
  $(document).on 'change', '#food_measure', (evt) ->
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
                      measure: $("#food_measure").val()
              }
              error: (jqXHR, textStatus, errorThrown) ->
                      console.log("AJAX Error: #{textStatus}")
              success: (data, textStatus, jqXHR) ->
                      console.log("Dynamic select OK!")
