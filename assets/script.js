var video = document.getElementById('video');
var canvas = document.getElementById('motion');
var score = document.getElementById('score');




// Defining async function


function initSuccess() {

	DiffCamEngine.start();
}

function initError() {
	alert('Something went wrong.');
}


function capture(payload) {
	score.textContent = payload.score;
    if(parseInt(payload.score) > 0){
        var myVideo = document.getElementById("myVid");
        $('#live').css('display', 'none')
        $('#myVid').css('display', 'block')
        myVideo.play();
    }
}

document.getElementById('myVid').addEventListener('ended',myHandler,false);
function myHandler(e) {
    window.location.reload(false);
}



DiffCamEngine.init({

	video: video,
	motionCanvas: canvas,
	initSuccessCallback: initSuccess,
	initErrorCallback: initError,
	captureCallback: capture
});