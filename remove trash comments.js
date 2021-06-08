const getCommentsLol = function() {
    setTimeout(() => {
        getCommentsLol()
    }, 100);

    let bad_comments = document.querySelectorAll(".comment-content")

    for (let i = 0, len = bad_comments.length; i < len; i++) {
        if (bad_comments[i].innerHTML.search("/e") != -1) {
            bad_comments[i].innerHTML = ''
        }
    }
}

getCommentsLol()
