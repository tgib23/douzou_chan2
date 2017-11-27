myPosition = []
 
$(document).ready( ->
 
    getCurrent = ->
        navigator.geolocation.getCurrentPosition(
            onSuccess,
            onError,
                enableHighAccuracy: true,
                 timeout: 20000,
                 maximumAge: 120000
        )
 
    onSuccess = (position) ->
        console.log "SUCCESS!!!!!!"
        myPosition[0] = position.coords.latitude
        myPosition[1] = position.coords.longitude
        console.log myPosition[0]
        console.log myPosition[1]
        postData()
 
    onError = (err) ->
        console.log "ERRRORRR"
        switch err.code
            when 0 then message = 'Unknown error: ' + err.message
            when 1 then message = 'You denied permission to retrieve a position.'
            when 2 then message = 'The browser was unable to determine a position: ' + error.message
            when 3 then message = 'The browser timed out before retrieving the position.'
            else message = err.message
 
    postData = ->
        url_analysis = window.location.href.split("?")
        scale = 1
        if url_analysis.length == 2
          scale = url_analysis[1].split("=").pop();
        console.log myPosition[0]
        console.log myPosition[1]
        console.log scale
        $.ajax({
            url: "/home/search_nearby",
            data: 'lat=' + myPosition[0] + '&lon=' + myPosition[1] + '&scale=' + scale
        })
 
    getCurrent()
)
