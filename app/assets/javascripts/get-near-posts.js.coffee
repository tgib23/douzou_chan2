$(document).ready( ->
 
    callGetNearPosts = ->
        post_id = window.location.href.split("/").pop()
        console.log post_id
        $.ajax({
            url: "/posts/get_near_posts",
            data: 'post_id=' + post_id
        })

    callGetNearPosts()
)

