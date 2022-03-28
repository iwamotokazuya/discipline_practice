// for html
const record = document.getElementById('record');
const stop = document.getElementById('stop');
const play = document.getElementById("playid");

// for audio
let audio_sample_rate = null;
let scriptProcessor = null;
let audioContext = null;

// audio data
let audioData = [];
let bufferSize = 1024;

const soundClips = document.querySelector('.sound-clips');
const mainSection = document.querySelector('.main-controls');

stop.disabled = true;

let audioCtx = new AudioContext();

if (navigator.mediaDevices.getUserMedia) {
  console.log('getUserMedia supported.');

  const constraints = { audio: true };

  let onSuccess = function(stream) {
    const mediaRecorder = new MediaRecorder(stream);

    record.onclick = function() {
      mediaRecorder.start();
      console.log(mediaRecorder.state);
      console.log("recorder started");

      stop.disabled = false;
      const timeoutId = setTimeout(function() {
        console.log('stop!!!')
        stop.click();
      }, 5000);
    }

    stop.onclick = function() {
      mediaRecorder.stop();

      console.log(mediaRecorder.state);
      console.log("recorder stopped");

      stop.disabled = true;
      record.disabled = false;
      exportWAV(audioData);
    }

    play.onclick = function(e) {
      console.log("data available after MediaRecorder.stop() called.");

      const clipContainer = document.createElement('article');
      const clipLabel = document.createElement('p');
      const audio = document.createElement('audio');

      clipContainer.classList.add('clip');
      audio.setAttribute('controls', '');

      clipContainer.appendChild(audio);
      clipContainer.appendChild(clipLabel);
      soundClips.appendChild(clipContainer);

      audio.controls = true;
      const blob = new Blob(audioData, { 'type' : 'audio/ogg; codecs=opus' });
      audioData = [];
      const audioURL = window.URL.createObjectURL(blob);
      audio.src = audioURL;
      console.log("recorder stopped");
    }

    mediaRecorder.ondataavailable = function(e) {
      audioData.push(e.data);
    }
  }

  let onError = function(err) {
    console.log('The following error occured: ' + err);
  }

  navigator.mediaDevices.getUserMedia(constraints).then(onSuccess, onError);

} else {
   console.log('getUserMedia not supported on your browser!');
}

function visualize(stream) {
  if(!audioCtx) {
    audioCtx = new AudioContext();
  }

  const source = audioCtx.createMediaStreamSource(stream);

  const analyser = audioCtx.createAnalyser();
  analyser.fftSize = 2048;
  const bufferLength = analyser.frequencyBinCount;
  const dataArray = new Uint8Array(bufferLength);

  source.connect(analyser);

  draw()

  function draw() {

    requestAnimationFrame(draw);

    analyser.getByteTimeDomainData(dataArray);

    let sliceWidth = WIDTH * 1.0 / bufferLength;
    let x = 0;


    for(let i = 0; i < bufferLength; i++) {

      let v = dataArray[i] / 128.0;
      let y = v * HEIGHT/2;

      x += sliceWidth;
    }
  }
}


let exportWAV = function(audioData) {
  console.log('wav change');

  let encodeWAV = function(samples, sampleRate) {
    let buffer = new ArrayBuffer(44 + samples.length * 2);
    let view = new DataView(buffer);

    let writeString = function(view, offset, string) {
      for (let i = 0; i < string.length; i++){
        view.setUint8(offset + i, string.charCodeAt(i));
      }
    }

    let floatTo16BitPCM = function(output, offset, input) {
      for (let i = 0; i < input.length; i++, offset += 2){
        let s = Math.max(-1, Math.min(1, input[i]));
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
      }
    }

    writeString(view, 0, 'RIFF');  // RIFFヘッダ
    view.setUint32(4, 32 + samples.length * 2, true); // これ以降のファイルサイズ
    writeString(view, 8, 'WAVE'); // WAVEヘッダ
    writeString(view, 12, 'fmt '); // fmtチャンク
    view.setUint32(16, 16, true); // fmtチャンクのバイト数
    view.setUint16(20, 1, true); // フォーマットID
    view.setUint16(22, 1, true); // チャンネル数
    view.setUint32(24, sampleRate, true); // サンプリングレート
    view.setUint32(28, sampleRate * 2, true); // データ速度
    view.setUint16(32, 2, true); // ブロックサイズ
    view.setUint16(34, 16, true); // サンプルあたりのビット数
    writeString(view, 36, 'data'); // dataチャンク
    view.setUint32(40, samples.length * 2, true); // 波形データのバイト数
    floatTo16BitPCM(view, 44, samples); // 波形データ

    return view;
  }

  let mergeBuffers = function(audioData) {
    let sampleLength = 0;
    for (let i = 0; i < audioData.length; i++) {
      sampleLength += audioData[i].length;
    }
    let samples = new Float32Array(sampleLength);
    let sampleIdx = 0;
    for (let i = 0; i < audioData.length; i++) {
      for (let j = 0; j < audioData[i].length; j++) {
        samples[sampleIdx] = audioData[i][j];
        sampleIdx++;
      }
    }
    return samples;
  }

  let dataview = encodeWAV(mergeBuffers(audioData), audio_sample_rate);
  let blob = new Blob([dataview], { type: 'audio/wav' });
  let myURL = window.URL || window.webkitURL;
  let audioURL = myURL.createObjectURL(blob);
  console.log('change wav');
  return audioURL
}
