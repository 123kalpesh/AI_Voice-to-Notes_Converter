import React, { useEffect, useState } from "react";
import { createNote } from "../services/api";

interface Props {
  initialText: string;
  onTranscriptionChange?: (text: string) => void;
}

const NotesEditor: React.FC<Props> = ({ initialText, onTranscriptionChange }) => {
  const [text, setText] = useState(initialText);
  const [saving, setSaving] = useState(false);
  const [lastSaved, setLastSaved] = useState<string | null>(null);

  useEffect(() => {
    setText(initialText);
  }, [initialText]);

  const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setText(e.target.value);
    onTranscriptionChange?.(e.target.value);
  };

  const handleSave = async () => {
    if (!text.trim()) return;
    setSaving(true);
    try {
      await createNote(text, text.slice(0, 30));
      setLastSaved(new Date().toLocaleTimeString());
    } catch (err) {
      console.error(err);
      alert("Failed to save note");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="flex flex-col h-full border border-slate-700 rounded-lg">
      <textarea
        className="flex-1 bg-slate-950 text-slate-100 p-3 text-sm rounded-t-lg outline-none resize-none"
        placeholder="Your transcribed notes will appear here..."
        value={text}
        onChange={handleChange}
      />
      <div className="flex items-center justify-between px-3 py-2 border-t border-slate-800">
        <button
          onClick={handleSave}
          disabled={saving || !text.trim()}
          className="px-4 py-1.5 rounded-full bg-indigo-600 hover:bg-indigo-500 disabled:bg-slate-700 text-sm font-medium"
        >
          {saving ? "Saving..." : "Save Note"}
        </button>
        <span className="text-xs text-slate-500">
          {lastSaved ? `Last saved at ${lastSaved}` : "Not saved yet"}
        </span>
      </div>
    </div>
  );
};

export default NotesEditor;


