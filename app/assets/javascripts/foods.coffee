# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
#
# 

$ ->
    $(document).on('turbolinks:load', on_turbolinks_load )

on_turbolinks_load = ->
    if $('#macros-piechart').length
        show_pie_chart()

    if $('#energy-barchart').length
        show_bar_chart()

show_pie_chart = ->
    ctx = document.getElementById('macros-piechart').getContext('2d')

    fetchvalues = -> 
        chartdata = $('#macros-piechart').attr('data-piechart')
        hashx = JSON.parse(chartdata)
        mylabels = new Array
        for key of hashx
            mylabels.push key
        mylabels

    fetchdata = ->
        chartdata = $('#macros-piechart').attr('data-piechart')
        hashx = JSON.parse(chartdata)
        mydatavals = new Array
        for key of hashx
            mydatavals.push hashx[key]
        mydatavals
        
    config =
        type: 'pie'
        data:
            datasets: [{
                data: fetchdata()
                backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f"]
                }]
        labels: fetchvalues()

    myPieChart = new Chart(ctx,config) 


    
show_bar_chart = -> 
    ctx = document.getElementById('energy-barchart').getContext('2d')
    chartdata = $('#energy-barchart').attr('data-energydensity')
    hashx = JSON.parse(chartdata)
    l1 = new Array
    d1 = new Array
    for key of hashx
        l1.push key
        d1.push hashx[key]

    horizontalBarChartData = 
        labels: l1
        datasets: [{
            backgroundColor: "rgba(255, 99, 132, 0.2)"
            borderColor: "rgb(255, 99, 132)" 
            borderWidth: 1
            data: d1
            }]

    config =
        type: 'horizontalBar'
        data: horizontalBarChartData
        labels: l1
        elements:
            rectangle:
                borderWidth: 2 

    myPieChart = new Chart(ctx,config) 


 
    
    
