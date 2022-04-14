# Dynamically update the measures selection drop-down according to a food selection
$ ->
    $(document).on 'change', '#food_type_id', (evt) ->
        $("#food_amount"). val("1.0")
        $("#food_measure").empty()
        
        disable_control("#food_measure")
        disable_control(save_button())
        disable_control("#food_amount")

        $("#food_fdcid"). val($("#food_type_id option:selected").val() )

        reset_nutrients()

        $.ajax '/update_measures',
            type: 'GET'
            dataType: 'json'
            data: {
                fdcid: $("#food_fdcid").val()
            }
            error: (jqXHR, textStatus, errorThrown) ->
                console.log("AJAX Error: #{textStatus}")
            success: (data, textStatus, jqXHR) =>
                callback_handler(data, textStatus, jqXHR)


on_food_edit = ->
    pattern = /.*foods\/(\d+)\/edit.*/
    url =($(location).attr('href'))
    results =  (url.match(pattern))
    if results
        $.ajax '/update_measures',
            type: 'GET'
            dataType: 'json'
            data: {
                id: results[1]
                fdcid: $("#food_fdcid").val()
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
    enable_control("#food_amount")
    enable_control("#food_measure")
    maybe_enable_save_btn()
    
    $("#food_measure").empty()
    set_nutrients(data)
    for m in data.measures
        do ->
            $("#food_measure").append('<option>' + m + '</option>')

reset_nutrients = (data) ->
    $("#Energy").  text("")
    $("#Water").   text("")
    $("#Carbs").   text("")
    $("#Fiber").   text("")
    $("#Protein"). text("")
    $("#Fat").     text("")


set_nutrients = (data) ->
    $('#Energy').  text(data.nutrients['Energy'])
    $('#Water').   text(data.nutrients['Water'])
    $('#Carbs').   text(data.nutrients['Carbs'])
    $('#Fiber').   text(data.nutrients['Fiber'])
    $('#Protein'). text(data.nutrients['Protein'])
    $('#Fat').     text(data.nutrients['Fat'])


input_is_valid = =>
    text = $("#food_amount").val()
    return false if "" == text
    value = Number( text ) 
    return false if isNaN( value ) 
    return false if value <= 0 
    return true



save_button = () ->
    return 'input[name="commit"]'

disable_control = (ctrl) ->
    $(ctrl).prop('disabled', true);

enable_control = (ctrl) ->
    $(ctrl).prop('disabled', false);
    
maybe_enable_save_btn = ->
    if input_is_valid()
        enable_control(save_button())

ajax_wrapper = ->
        $.ajax '/update_nutrients',
            type: 'GET'
            dataType: 'json'
            data: {
                fdcid: $("#food_fdcid").val()
                measure: $("#food_measure").val()
                amount: $("#food_amount").val()
            }
            error: (jqXHR, textStatus, errorThrown) ->
                console.log("AJAX Error: #{textStatus}")
            success: (data, textStatus, jqXHR) ->
                set_nutrients(data)

# Dynamically update the nutrient values upon change in food measure
$ ->
    $(document).on 'change', '#food_measure', (evt) ->
        reset_nutrients()
        ajax_wrapper()


# Dynamically update the nutrient values upon change in food amount
$ ->
    $(document).on 'change', '#food_amount', (evt) ->
        reset_nutrients()
        ajax_wrapper()

    $(document).on 'input', '#food_amount', (evt) ->
        disable_control(save_button())
        maybe_enable_save_btn()
