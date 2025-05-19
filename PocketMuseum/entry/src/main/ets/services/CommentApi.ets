import JsonComment from "../model/JsonComment";
import { deleteData, fetchData, postData } from "./HttpRequest";

const URL = "http://39.105.26.212:5000/api/comments";

export async function getCommentsByArtifactId(id: number): Promise<JsonComment[]> {
  const idUrl = URL + "/artifact/" + encodeURIComponent(id);
  const result = fetchData<JsonComment[]>(idUrl, 200);
  return result;
}

export async function createComment(comment: JsonComment): Promise<JsonComment> {
  const result = postData<JsonComment>(URL, comment, 201);
  return result;
}

export async function deleteComment(id: number): Promise<boolean> {
  const idUrl = URL + "/" + encodeURIComponent(id);
  const result = deleteData(idUrl, 204);
  return result;
}
