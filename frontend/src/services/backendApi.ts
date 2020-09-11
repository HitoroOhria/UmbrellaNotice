import { post, get, put } from "./http";
import { createBackendUrl } from "./url";

import {
  errorRes,
  successRes,
  JsonAipResUser,
  JsonAipResLineUser,
  JsonAipResWeather,
  SerializedUser,
  SerializedLineUser,
  SerializedWeather,
  updateUserAttr,
  updateLineUserAttr,
  updateWeatherAttr,
} from "types/backendApi";

export const callUserCreate = async (
  email: string
): Promise<successRes | errorRes> => {
  const url = createBackendUrl.users();
  const params = { email };

  return await post(url, params);
};

export const callUserShow = async (
  email: string | undefined,
  embed?: string
): Promise<JsonAipResUser | errorRes> => {
  const url = createBackendUrl.users(email || "undefined");
  const params = { embed };

  return await get(url, params);
};

export const callUserUpdate = async (
  email: string,
  params: updateUserAttr
): Promise<JsonAipResUser | errorRes> => {
  const url = createBackendUrl.users(email);

  return await put(url, params);
};

export const callUserRelateLineUser = async (
  email: string,
  inherit_token: string
): Promise<successRes | errorRes> => {
  const url = createBackendUrl.users(email, "relate_line_user");
  const params = { inherit_token };

  return await post(url, params);
};

export const callUserReleaseLineUser = async (
  email: string
): Promise<successRes | errorRes> => {
  const url = createBackendUrl.users(email, "release_line_user");

  return await post(url);
};

export const callLineUserShow = async (
  id: number | string,
  embed: string
): Promise<JsonAipResLineUser | errorRes> => {
  const url = createBackendUrl.lineUsers(id);
  const params = { embed };

  return await get(url, params);
};

export const callLineUserUpdate = async (
  id: number,
  params: updateLineUserAttr
): Promise<JsonAipResLineUser | errorRes> => {
  const url = createBackendUrl.lineUsers(id);

  return await put(url, params);
};

export const callWeatherShow = async (
  id: number | string,
  embed: string
): Promise<JsonAipResWeather | errorRes> => {
  const url = createBackendUrl.lineUsers(id);
  const params = { embed };

  return await get(url, params);
};

export const callWeatherUpdate = async (
  id: number,
  params: updateWeatherAttr
): Promise<JsonAipResWeather | errorRes> => {
  const url = createBackendUrl.weathers(id);

  return await put(url, params);
};

export const serializeUser = (
  jsonData: JsonAipResUser["data"]
): SerializedUser => {
  const id = parseInt(jsonData.id);
  const email = jsonData.attributes.email;

  return { id, email };
};

export const serializeLineUser = (
  jsonData: JsonAipResLineUser["data"]
): SerializedLineUser => {
  const id = parseInt(jsonData.id);
  const noticeTime = jsonData.attributes.noticeTime;
  const silentNotice = jsonData.attributes.silentNotice;

  return { id, noticeTime, silentNotice };
};

export const serializeWeather = (
  jsonData: JsonAipResWeather["data"]
): SerializedWeather => {
  const id = parseInt(jsonData.id);
  const city = jsonData.attributes.city;
  const lat = parseFloat(jsonData.attributes.lat);
  const lon = parseFloat(jsonData.attributes.lon);

  return { id, city, lat, lon };
};
