function openFunc(evt, Feature) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(Feature).style.display = "block";
    evt.currentTarget.className += " active";
}



function createPlaylist() {
    var playlistName = document.getElementById("playlist-name").value;
    var playlistItem = document.createElement("li");
    playlistItem.appendChild(document.createTextNode(playlistName));
    document.getElementById("file-list").appendChild(playlistItem);
}






document.getElementById("defaultOpen").click();