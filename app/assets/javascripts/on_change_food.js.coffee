# Dynamically update the measures selection drop-down according to a food selection
$ ->
    $(document).on 'change', '#food_type_id', (evt) ->
        $("#food_amount"). val("1.0")
        $("#food_ndbno"). val($("#food_type_id option:selected").val() )

        reset_nutrients()

        $.ajax 'update_measures',
            type: 'GET'
            dataType: 'json'
            data: {
                ndbno: $("#food_ndbno").val()
            }
            error: (jqXHR, textStatus, errorThrown) ->
                console.log("AJAX Error: #{textStatus}")
            success: (data, textStatus, jqXHR) =>
                callback_handler(data, textStatus, jqXHR)


on_food_edit = ->
    pattern = /foods.*edit/
    url =($(location).attr('href'))
    if (url.match(pattern))
        $.ajax 'update_measures',
            type: 'GET'
            dataType: 'json'
            data: {
                ndbno: $("#food_ndbno").val()
                amount: $("#food_amount").val()
            }
            error: (jqXHR, textStatus, errorThrown) ->
                console.log("AJAX Error: #{textStatus}")
            success: (data, textStatus, jqXHR) ->
                callback_handler(data, textStatus, jqXHR)
                $("#food_measure").val(data.selected_measure)


$ ->
    $(document).on('turbolinks:load', on_food_edit)

callback_handler = (data, textStatus, jqXHR )->
    $("#food_measure").empty()
    set_nutrients(data)
    for m in data.measures
        do ->
            $("#food_measure").append('<option>' + m + '</option>')

reset_nutrients = (data) ->
    $("#Energy").  val("")
    $("#Water").   val("")
    $("#Carbs").   val("")
    $("#Fiber").   val("")
    $("#Protein"). val("")
    $("#Fat").     val("")

set_nutrients = (data) ->
    $('#Energy').val(data.nutrients['Energy'])
    $('#Water').val(data.nutrients['Water'])
    $('#Carbs').val(data.nutrients['Carbs'])
    $('#Fiber').val(data.nutrients['Fiber'])
    $('#Protein').val(data.nutrients['Protein'])
    $('#Fat').val(data.nutrients['Fat'])

# Dynamically update the nutrient values upon change in food measure
$ ->
    $(document).on 'change', '#food_measure', (evt) ->
        reset_nutrients()

        $.ajax 'update_nutrients',
            type: 'GET'
            dataType: 'json'
            data: {
                ndbno: $("#food_ndbno").val()
                measure: $("#food_measure").val()
            }
            error: (jqXHR, textStatus, errorThrown) ->
                console.log("AJAX Error: #{textStatus}")
            success: (data, textStatus, jqXHR) ->
                set_nutrients(data)
                console.log("Dynamic select OK!")


# Dynamically update the nutrient values upon change in food amount
$ ->
    $(document).on 'change', '#food_amount', (evt) ->
        reset_nutrients()
        $.ajax 'update_nutrients',
            type: 'GET'
            dataType: 'json'
            data: {
                ndbno: $("#food_ndbno").val()
                measure: $("#food_measure").val()
                amount: $("#food_amount").val()
            }
            error: (jqXHR, textStatus, errorThrown) ->
                console.log("AJAX on_change_amount  Error: #{textStatus}")
            success: (data, textStatus, jqXHR) ->
                set_nutrients(data)
                console.log("AJAX on_change_amount  select OK!")
