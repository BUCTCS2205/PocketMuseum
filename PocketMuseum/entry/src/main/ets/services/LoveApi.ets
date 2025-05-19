import JsonLove from "../model/JsonLove";
import { deleteDataWithPayload, fetchData, postData } from "./HttpRequest";

const URL = "http://39.105.26.212:5000/api/loves";

export async function getLovesByArtifactId(id: number): Promise<JsonLove[]> {
  const idUrl = URL + "/artifact/" + encodeURIComponent(id);
  const result = fetchData<JsonLove[]>(idUrl, 200);
  return result;
}

export async function getLovesByUserId(id: number): Promise<JsonLove[]> {
  const idUrl = URL + "/mobile_user/" + encodeURIComponent(id);
  const result = fetchData<JsonLove[]>(idUrl, 200);
  return result;
}

export async function createLove(love: JsonLove): Promise<JsonLove> {
  const result = postData<JsonLove>(URL, love, 200);
  return result;
}

export async function deleteLove(love: JsonLove): Promise<boolean> {
  const result = deleteDataWithPayload<JsonLove>(URL, love, 204);
  return result;
}
