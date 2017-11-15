myPosition = []
 
$(document).ready( ->
 
    getWikiPre = ->
        post_id = window.location.href.split("/").pop()
        console.log post_id
        $.ajax({
            url: "/posts/get_wiki",
            data: 'post_id=' + post_id
        })

    getWikiPre()
)
