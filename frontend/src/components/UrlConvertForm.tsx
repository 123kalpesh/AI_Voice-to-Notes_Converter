import React, { useState } from "react";
import { convertFromUrl } from "../services/api";

interface Props {
  onResult: (text: string, confidence: number) => void;
}

const UrlConvertForm: React.FC<Props> = ({ onResult }) => {
  const [url, setUrl] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!url.trim()) return;
    setLoading(true);
    try {
      const res = await convertFromUrl(url.trim());
      onResult(res.text, res.confidence);
    } catch (err) {
      console.error(err);
      alert("Unable to convert audio from URL");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="border border-slate-700 rounded-lg p-4 space-y-2"
    >
      <label className="block text-sm">Or paste a public audio URL</label>
      <input
        type="url"
        placeholder="https://example.com/audio.mp3"
        className="w-full rounded-md bg-slate-900 border border-slate-800 px-3 py-2 text-sm text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
        value={url}
        onChange={(e) => setUrl(e.target.value)}
      />
      <button
        type="submit"
        disabled={loading || !url.trim()}
        className="w-full rounded-md bg-indigo-600 hover:bg-indigo-500 disabled:bg-slate-700 py-2 text-sm font-medium"
      >
        {loading ? "Converting..." : "Convert URL"}
      </button>
    </form>
  );
};

export default UrlConvertForm;


