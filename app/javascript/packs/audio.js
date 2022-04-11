import axios from 'axios';
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

// for html
const record = document.getElementById('record');
const stop = document.getElementById('stop');
const play = document.getElementById("playid");
const result = document.getElementById("result");

// for audio
let audio_sample_rate = null;
let audioContext = null;
let audioCtx = null;
let blob = null;

// audio data
let audioData = [];
let bufferSize = 1024;

const soundClips = document.querySelector('.sound-clips');
const mainSection = document.querySelector('.main-controls');

stop.disabled = true;

if (navigator.mediaDevices.getUserMedia) {
  console.log('getUserMedia supported.');
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  audioCtx = new AudioContext({ sampleRate: 11025 });

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
      saveAudio();
      
      console.log(mediaRecorder.state);
      console.log("recorder stopped");
      console.log(audioData);
      
      stop.disabled = true;

      record.disabled = false;
      // exportWAV(audioData);
      // sendToResult(blob);
      console.log(audioData);
      audioData = [];
    }

    result.onclick = function(e) {
      // exportWAV(audioData);
      sendToResult(blob);
    }

    let saveAudio = function () {
      exportWAV(audioData);
    }
    // save audio data
    var onAudioProcess = function (e) {
      console.log('save');
      var input = e.inputBuffer.getChannelData(0);
      var bufferData = new Float32Array(bufferSize);
      for (var i = 0; i < bufferSize; i++) {
        bufferData[i] = input[i];
      }

      audioData.push(bufferData);
      console.log(audioData);
    }
    
    play.onclick = function(e) {
      console.log("data available after MediaRecorder.stop() called.");
      console.log(audioData);

      const clipContainer = document.createElement('article');
      const clipLabel = document.createElement('p');
      const audio = document.createElement('audio');

      clipContainer.classList.add('clip');
      audio.setAttribute('controls', '');

      clipContainer.appendChild(audio);
      clipContainer.appendChild(clipLabel);
      soundClips.appendChild(clipContainer);

      audio.controls = true;
      blob = new Blob(audioData, { 'type' : 'audio/ogg; codecs=opus' });
      audioData = [];
      const audioURL = window.URL.createObjectURL(blob);
      audio.src = audioURL;
      console.log("recorder stopped");
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
    
      let dataview = encodeWAV(mergeBuffers(audioData), audioCtx.sampleRate);
      blob = new Blob([dataview], { type: 'audio/wav' });
      let myURL = window.URL || window.webkitURL;
      let audioURL = myURL.createObjectURL(blob);
      console.log('change wav');
      return audioURL
    }
    
    let sendToResult = function() {
      console.log('sendToResult');
      let formdata = new FormData();
      formdata.append('record_voice', blob);
      console.log(formdata.get('record_voice'));
      axios
        .post('/results', formdata, {
          headers: {
            'content-type': 'multipart/form-data',
          },
        })
        .then(function(response) {
          window.location.href = response.data.url
        })
        .catch(function(error) {
          console.log(error.response);
        })
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
