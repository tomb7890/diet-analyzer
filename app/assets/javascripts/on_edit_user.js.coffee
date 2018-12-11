CM_PER_FOOT = 30.48
CM_PER_INCH = 2.54 
LB_PER_KG = 2.204

$ ->
    $(document).on('turbolinks:load', on_user_edit)

on_user_edit = ->
        pattern = /.*users\/(\d+)\/edit.*/
        url =($(location).attr('href'))
        results = (url.match(pattern))
        set_weightlb_from_weightkg()
        set_feet_lbs_from_heightcm()
        set_gender_data()

        $('#weightlb').on 'change', (evt) ->
                set_weightkg_from_weightlb()

        $('#user_weightkg').on 'change', (evt) ->
                set_weightlb_from_weightkg()
                
        $('#feet_select').on 'change', () ->
                set_heightcm_from_feet_inches()

        $('#inches_select').on 'change', (evt) ->
                set_heightcm_from_feet_inches()
        
        $('#user_heightcm').on 'change', () ->
                set_feet_lbs_from_heightcm()

        $('#gender_male').on 'change', (evt) ->
                disable_extra_female_options()
                $('#user_gender').val("male")
                
        $('#gender_female').on 'change', (evt) ->
                enable_extra_female_options()
                $('#user_gender').val("female") 

set_weightlb_from_weightkg = ->
        weightkg = $('#user_weightkg').val()
        weightlb = Math.round(LB_PER_KG * weightkg)
        $('#weightlb').val(weightlb) 

set_weightkg_from_weightlb = ->
        weightlb = $('#weightlb').val()
        weightkg = Math.round(weightlb / LB_PER_KG)
        $('#user_weightkg').val(weightkg)

set_feet_lbs_from_heightcm = ->
        heightcm = $('#user_heightcm').val()
        feet = Math.floor(heightcm / CM_PER_FOOT)
        inches = Math.round(( heightcm - feet * CM_PER_FOOT ) / CM_PER_INCH)
        $('#feet_select').val(feet)
        $('#inches_select').val(inches) 
        
set_heightcm_from_feet_inches = ->
        feet = $('#feet_select').val()
        inches = $('#inches_select').val()
        heightcm = Math.round(feet * CM_PER_FOOT + inches * CM_PER_INCH)
        $('#user_heightcm').val(heightcm) 

set_gender_data = ->
        gender = $('#user_gender').val()
        if gender == "male" 
                $('#gender_male').prop('checked',true);
                disable_extra_female_options()
        else
                enable_extra_female_options()

disable_extra_female_options = -> 
        $("#gender_extra").val("Normal");
        $('#gender_extra').prop('disabled', 'disabled');

enable_extra_female_options = ->
        $('#gender_extra').prop('disabled', false);
                
