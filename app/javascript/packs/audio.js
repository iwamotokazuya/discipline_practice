import axios from 'axios';
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

const record = document.getElementById('record');
const sentence = document.getElementById('sentence');
let url = new URL(window.location.href);
let params = url.searchParams;

let stream = null;
let audio_sample_rate = null;
let scriptProcessor = null;
let audioContext = null;
let blob = null;
let audioCtx = null;
let audioStream = null;

let audioData = [];
let bufferSize = 1024;

let saveAudio = function () {
  exportWAV(audioData);
  audioCtx.close().then(function () {
  });
}

let exportWAV = function (audioData) {
  let encodeWAV = function (samples, sampleRate) {
    let buffer = new ArrayBuffer(44 + samples.length * 2);
    let view = new DataView(buffer);

    let writeString = function (view, offset, string) {
      for (let i = 0; i < string.length; i++) {
        view.setUint8(offset + i, string.charCodeAt(i));
      }
    };

    let floatTo16BitPCM = function (output, offset, input) {
      for (let i = 0; i < input.length; i++ , offset += 2) {
        let s = Math.max(-1, Math.min(1, input[i]));
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
      }
    };

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
  };

  let mergeBuffers = function (audioData) {
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
  };

  let dataview = encodeWAV(mergeBuffers(audioData), audioCtx.sampleRate);
  blob = new Blob([dataview], { type: 'audio/wav' });
  let myURL = window.URL || window.webkitURL;
  let url = myURL.createObjectURL(blob);
  return url;
};

let sendToResult = function() {
  let formdata = new FormData();
  formdata.append('record_voice', blob);
  if( params.has('begginer') ) {
    formdata.append('rank_id', 1);
  } else if( params.has('intermediate') ) {
    formdata.append('rank_id', 2);
  } else if( params.has('advanced') ) {
    formdata.append('rank_id', 3);
  }
  axios.post('/results?part=all', formdata, {
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

let sendToLoginResult = function() {
  let formdata = new FormData();
  formdata.append('record_voice', blob);
  if( params.has('begginer') ) {
    formdata.append('rank_id', 1);
  } else if( params.has('intermediate') ) {
    formdata.append('rank_id', 2);
  } else if( params.has('advanced') ) {
    formdata.append('rank_id', 3);
  }
  axios.post('/results?part=login', formdata, {
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

let onAudioProcess = function (e) {
  let input = e.inputBuffer.getChannelData(0);
  let bufferData = new Float32Array(bufferSize);
  for (var i = 0; i < bufferSize; i++) {
    bufferData[i] = input[i];
  }

  audioData.push(bufferData);
};

let handleSuccess = function (stream) {
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  audioCtx = new AudioContext({ sampleRate: 11025 });

  scriptProcessor = audioCtx.createScriptProcessor(bufferSize, 1, 1);
  var mediastreamsource = audioCtx.createMediaStreamSource(stream);
  mediastreamsource.connect(scriptProcessor);
  scriptProcessor.onaudioprocess = onAudioProcess;
  scriptProcessor.connect(audioCtx.destination);
  audioStream = stream;

  const timeoutId = setTimeout(function() {
    saveAudio();
    if( params.has('part') ) {
      sendToResult(blob);
    } else {
      sendToLoginResult(blob);
    }
  }, 5000);
};

record.addEventListener('click', () => {
  if (!stream) {
    let constraints = {
      audio: true,
      video: false,
    };
    navigator.mediaDevices.getUserMedia(constraints)
      .then((stream) => {
        audioStream = stream;
        handleSuccess(audioStream);
        return audioStream
      })
      .catch((error) => {
        console.error('error:', error);
      });
  }
  sentence.innerHTML = '〜録音中〜';
});
