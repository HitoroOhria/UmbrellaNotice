import queryString from "query-string";

export const get = async (baseUrl: string, queryParams?: object) => {
  const queryStr = queryParams ? queryString.stringify(queryParams) : "";
  const url = baseUrl + "?" + queryStr;
  const headers = {
    Accept: "application/json",
    "Content-Type": "application/json",
  };

  const resJson = await fetch(url, { headers }).then((res) => res.json());

  return resJson;
};

export const post = async (url: string, params?: object) => {
  const method = "POST";
  const body = JSON.stringify(params);
  const headers = {
    Accept: "application/json",
    "Content-Type": "application/json",
  };

  return await fetch(url, { method, body, headers }).then((res) => res.json());
};

export const put = async (url: string, params: object) => {
  const method = "PUT";
  const body = JSON.stringify(params);
  const headers = {
    Accept: "application/json",
    "Content-Type": "application/json",
  };

  console.log("reqUrl", url);
  console.log("body", body);

  return await fetch(url, { method, body, headers }).then((res) => res.json());
};

export const destroy = async (url: string) => {
  const method = "DELETE";
  const headers = {
    Accept: "application/json",
    "Content-Type": "application/json",
  };

  return await fetch(url, { method, headers }).then((res) => res.json());
};
