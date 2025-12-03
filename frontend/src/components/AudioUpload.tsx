import React, { ChangeEvent } from "react";

interface Props {
  onFileSelected: (file: File) => void;
}

const AudioUpload: React.FC<Props> = ({ onFileSelected }) => {
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) onFileSelected(file);
  };

  return (
    <div className="border border-dashed border-slate-700 rounded-lg p-4">
      <label className="block text-sm mb-2">Upload audio file</label>
      <input
        type="file"
        accept="audio/*"
        onChange={handleChange}
        className="block w-full text-sm text-slate-200 file:mr-4 file:py-2 file:px-4
                   file:rounded-full file:border-0 file:text-sm file:font-semibold
                   file:bg-indigo-600 file:text-white hover:file:bg-indigo-500"
      />
      <p className="mt-1 text-xs text-slate-500">
        Supported: .wav, .mp3, .m4a (max ~25MB recommended)
      </p>
    </div>
  );
};

export default AudioUpload;


