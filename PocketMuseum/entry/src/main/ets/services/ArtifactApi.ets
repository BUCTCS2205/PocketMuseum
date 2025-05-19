import JsonArtifact from "../model/JsonArtifact";
import { fetchData } from "./HttpRequest";

const URL = "http://39.105.26.212:5000/api/artifacts"

export async function getArtifactById(id: number): Promise<JsonArtifact> {
  const idUrl = URL + "/" + encodeURIComponent(id);
  const result = await fetchData<JsonArtifact>(idUrl, 200);
  return result;
}

export async function searchArtifacts(name: string): Promise<JsonArtifact[]> {
  const nameUrl = URL + "/search?name=" + encodeURIComponent(name);
  const result = await fetchData<JsonArtifact[]>(nameUrl, 200);
  return result;
}
