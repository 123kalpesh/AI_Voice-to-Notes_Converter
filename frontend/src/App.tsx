import React, { useState } from "react";
import AudioUpload from "./components/AudioUpload";
import VoiceRecorder from "./components/VoiceRecorder";
import NotesEditor from "./components/NotesEditor";
import UrlConvertForm from "./components/UrlConvertForm";
import { uploadAudio } from "./services/api";

const App: React.FC = () => {
  const [transcription, setTranscription] = useState("");
  const [confidence, setConfidence] = useState<number | null>(null);

  const handleResult = (text: string, conf: number) => {
    setTranscription(text);
    setConfidence(conf);
  };

  const handleAudioFile = async (file: File) => {
    try {
      const res = await uploadAudio(file);
      handleResult(res.text, res.confidence);
    } catch (err) {
      console.error(err);
      alert("Failed to transcribe audio.");
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col">
      <header className="border-b border-slate-800 px-6 py-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold">AI Voice-to-Notes Converter</h1>
      </header>

      <main className="flex-1 px-6 py-4 grid gap-6 md:grid-cols-2">
        <section className="space-y-4">
          <h2 className="text-lg font-semibold">1. Record or Upload Audio</h2>
          <VoiceRecorder onAudioReady={handleAudioFile} />
          <AudioUpload onFileSelected={handleAudioFile} />
          <UrlConvertForm onResult={handleResult} />
          {confidence !== null && (
            <p className="text-sm text-slate-400">
              Model confidence: {(confidence * 100).toFixed(1)}%
            </p>
          )}
        </section>

        <section className="space-y-4">
          <h2 className="text-lg font-semibold">2. Review & Edit Notes</h2>
          <NotesEditor
            initialText={transcription}
            onTranscriptionChange={setTranscription}
          />
        </section>
      </main>
    </div>
  );
};

export default App;


