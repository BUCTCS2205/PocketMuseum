import http from '@ohos.net.http';

interface Message {
  message?: string;
}

export function getMessage(jsonStr: string | Object | undefined): string {
  try {
    const obj: Message = JSON.parse(jsonStr as string);
    return typeof obj.message === "string" ? obj.message : "";
  } catch {
    return "";
  }
}

export async function fetchData<T>(url: string, wantedCode: number): Promise<T> {
  const httpRequest = http.createHttp();

  return new Promise<T>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
      },
      (err, data) => {
        if (err || data.responseCode != wantedCode) {
          reject(new Error(getMessage(data.result)));
        }
        else {
          resolve(JSON.parse(data.result as string) as T);
        }
      }
    );
  });
}

export async function postData<T>(url: string, payload: T, wantedCode: number): Promise<T> {
  const httpRequest = http.createHttp();

  return new Promise<T>((resolve, reject) => {
    const data = JSON.stringify(payload);
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: data,
      },
      (err, data) => {
        if (err || data.responseCode != wantedCode) {
          reject(new Error(getMessage(data.result)));
        }
        else {
          resolve(JSON.parse(data.result as string) as T);
        }
      }
    );
  });
}

export async function putData<T>(url: string, payload: T, wantedCode: number): Promise<T> {
  const httpRequest = http.createHttp();

  return new Promise<T>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.PUT,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(payload),
      },
      (err, data) => {
        if (err || data.responseCode != wantedCode) {
          reject(new Error(getMessage(data.result)));
        }
        else {
          resolve(JSON.parse(data.result as string) as T);
        }
      }
    );
  });
}

export async function deleteData(url: string, wantedCode: number): Promise<boolean> {
  const httpRequest = http.createHttp();

  return new Promise<boolean>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.DELETE,
        header: { 'Content-Type': 'application/json' },
      },
      (err, data) => {
        if (err || data.responseCode != wantedCode) {
          reject(err);
        }
        else {
          resolve(true);
        }
      }
    );
  });
}

export async function deleteDataWithPayload<T>(url: string, payload: T, wantedCode: number): Promise<boolean> {
  const httpRequest = http.createHttp();

  return new Promise<boolean>((resolve, reject) => {
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.DELETE,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(payload),
      },
      (err, data) => {
        if (err || data.responseCode != wantedCode) {
          reject(err);
        }
        else {
          resolve(true);
        }
      }
    );
  });
}
