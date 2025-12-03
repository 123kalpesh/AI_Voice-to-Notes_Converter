import axios from "axios";
import { API_BASE_URL } from "./config";

export interface TranscriptionResponse {
  text: string;
  confidence: number;
}

export interface Note {
  id: number;
  title: string | null;
  content: string;
  created_at: string;
  updated_at: string;
}

const api = axios.create({
  baseURL: `${API_BASE_URL}/api`,
  timeout: 60000
});

export async function uploadAudio(file: File): Promise<TranscriptionResponse> {
  const formData = new FormData();
  formData.append("file", file);

  const { data } = await api.post<TranscriptionResponse>(
    "/upload-audio",
    formData,
    {
      headers: { "Content-Type": "multipart/form-data" }
    }
  );
  return data;
}

export async function convertFromUrl(url: string): Promise<TranscriptionResponse> {
  const { data } = await api.post<TranscriptionResponse>("/convert", { url });
  return data;
}

export async function createNote(
  content: string,
  title?: string
): Promise<Note> {
  const { data } = await api.post<Note>("/notes", { title, content });
  return data;
}


