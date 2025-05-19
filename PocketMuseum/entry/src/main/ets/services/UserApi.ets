import { fetchData, postData, putData } from "./HttpRequest"
import JsonUser from "../model/JsonUser";

const URL = "http://39.105.26.212:5000/api/mobile_users"

export async function getUserByNameOrEmail(nameOrEmail: string): Promise<JsonUser> {
  try {
    const nameUrl = URL + "/name?name=" + encodeURIComponent(nameOrEmail);
    const result = await fetchData<JsonUser>(nameUrl, 200);
    return result;
  } catch { }

  try {
    const emailUrl = URL + "/email?email=" + encodeURIComponent(nameOrEmail);
    const result = await fetchData<JsonUser>(emailUrl, 200);
    return result;
  } catch { }

  throw new Error("用户不存在");
}

export async function getUserById(id: number): Promise<JsonUser> {
  const requestUrl = URL + "/" + encodeURIComponent(id);
  const result = await fetchData<JsonUser>(requestUrl, 200);
  return result;
}

export async function createUser(jsonUser: JsonUser): Promise<JsonUser> {
  const result = await postData<JsonUser>(URL, jsonUser, 201);
  return result;
}

export async function updateUser(jsonUser: JsonUser): Promise<JsonUser> {
  const requestUrl = URL + "/" + encodeURIComponent(jsonUser.id);
  const result = await putData<JsonUser>(requestUrl, jsonUser, 200);
  return result;
}
