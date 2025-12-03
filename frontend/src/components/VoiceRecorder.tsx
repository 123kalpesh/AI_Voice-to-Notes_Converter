import React, { useEffect, useRef, useState } from "react";

interface Props {
  onAudioReady: (file: File) => void;
}

const VoiceRecorder: React.FC<Props> = ({ onAudioReady }) => {
  const [recording, setRecording] = useState(false);
  const [supportError, setSupportError] = useState<string | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);

  useEffect(() => {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      setSupportError("Browser does not support audio recording.");
    }
  }, []);

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream);
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (event) => {
        chunksRef.current.push(event.data);
      };

      mediaRecorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: "audio/webm" });
        const file = new File([blob], `recording-${Date.now()}.webm`, {
          type: "audio/webm"
        });
        onAudioReady(file);
        stream.getTracks().forEach((t) => t.stop());
      };

      mediaRecorder.start();
      setRecording(true);
    } catch (err) {
      console.error(err);
      setSupportError("Unable to access microphone.");
    }
  };

  const stopRecording = () => {
    mediaRecorderRef.current?.stop();
    setRecording(false);
  };

  if (supportError) {
    return (
      <div className="p-4 border border-red-500 rounded-lg text-sm text-red-300">
        {supportError}
      </div>
    );
  }

  return (
    <div className="border border-slate-700 rounded-lg p-4 flex items-center justify-between">
      <div>
        <p className="text-sm mb-1">
          {recording ? "Recording..." : "Tap to start recording"}
        </p>
        <p className="text-xs text-slate-500">
          Use this for quick voice notes directly in the browser.
        </p>
      </div>
      <button
        onClick={recording ? stopRecording : startRecording}
        className={`px-4 py-2 rounded-full font-medium text-sm ${
          recording
            ? "bg-red-600 hover:bg-red-500"
            : "bg-emerald-600 hover:bg-emerald-500"
        }`}
      >
        {recording ? "Stop" : "Record"}
      </button>
    </div>
  );
};

export default VoiceRecorder;


