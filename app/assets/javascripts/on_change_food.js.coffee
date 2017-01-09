# Dynamically update the measures selection drop-down according to a food selection

$ ->
  $(document).on 'change', '#food_type_id', (evt) ->
        $("#Energy").  val("")
        $("#Water").   val("")
        $("#Carbs").   val("")
        $("#Fiber").   val("")
        $("#Protein"). val("")
        $("#Fat").     val("")

        $("#quantity"). val("1.0")


        $.ajax 'update_measures',
              type: 'GET'
              dataType: 'script'
              data: {
                      ndbno: $("#food_type_id option:selected").val()
              }
              error: (jqXHR, textStatus, errorThrown) ->
                      console.log("AJAX Error: #{textStatus}")
              success: (data, textStatus, jqXHR) ->
                      console.log("Dynamic country select OK!")
