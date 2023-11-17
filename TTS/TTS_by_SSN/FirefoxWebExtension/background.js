var TTSAudio = document.getElementById("TTSAudio");

TTSAudio.addEventListener("canplaythrough", function (event) {
  TTSAudio.play();
});

function requestSynthesize(textToSynthesize, voice) {
  fetch("http://speech.ssn.edu.in/SpeechSynthesis/synthesise.php", {
    method: "post",
    headers: {
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    },
    body: "options=" + voice + "&word=" + textToSynthesize,
  })
    .then(function (response) {
      if (response.ok) {
        return response.text();
      } else {
        return Promise.reject(new Error(response.statusText));
      }
    })
    .then(function (resTxt) {
      var srcStartPosition = resTxt.search('src="wav');
      srcStartPosition = srcStartPosition + 9;
      var srcEndPosition = resTxt.search('type="audio/wav');
      srcEndPosition = srcEndPosition - 2;
      var wavFileName = resTxt.slice(srcStartPosition, srcEndPosition);

      TTSAudio.src =
        "http://speech.ssn.edu.in/SpeechSynthesis/wav/" + wavFileName;
      TTSAudio.play();
    });
}

function synthesizeSelectedMale(info, tab) {
  requestSynthesize(info.selectionText, "hts_tamil_male");
}
function synthesizeSelectedFemale(info, tab) {
  requestSynthesize(info.selectionText, "hts_tamil_female");
}

function createContextMenuEntry() {
  browser.contextMenus.removeAll();
  browser.contextMenus.create({
    title: "ஆன்",
    type: "normal",
    contexts: ["selection"],
    onclick: synthesizeSelectedMale,
  });

  browser.contextMenus.create({
    title: "பெண்",
    type: "normal",
    contexts: ["selection"],
    onclick: synthesizeSelectedFemale,
  });
}

createContextMenuEntry();
