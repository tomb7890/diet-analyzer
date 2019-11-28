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
    hashx = JSON.parse($('#macros-piechart').attr('data-piechart'))
    data = new Array
    labels = new Array
    for key of hashx
        labels.push key
        data.push hashx[key]
        
    config =
        type: 'pie'
        data:
            datasets: [{
                data: data 
                backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f"]
                }]
            labels: labels
        options: tooltips: callbacks: label: format_pie_chart

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
        options: tooltips: callbacks: label: format_bar_chart
        elements:
            rectangle:
                borderWidth: 2 

    myPieChart = new Chart(ctx,config) 


formatdata = (tooltipItem, data ) -> 
    Math.round(data.datasets[0].data[tooltipItem.index])
    
format_pie_chart = (tooltipItem, data ) ->
    x = formatdata(tooltipItem, data )
    "Calories from " + data.labels[tooltipItem.index] + " : " + x.toString()
    
format_bar_chart = (tooltipItem, data ) ->
    x = formatdata(tooltipItem, data ) 
    x.toString() + " calories per pound "

 
    
    
