import { Dispatch } from "redux";

import weatherActions from "./actions";
import lineUserActions from "../lineUser/actions";

import { put } from "../../domain/services/http";
import { BACKEND_URL } from "../../domain/services/url";
import { loadingAlert, openAlert } from "../../domain/services/alert";
import {
  serializeLineUser,
  serializeWeather,
} from "../../domain/services/serialize";

import { LineUserState } from "../../domain/entity/lineUser";
import { WeatherState } from "../../domain/entity/weather";

export const updateWeather = (
  lineUser: LineUserState,
  weather: WeatherState
) => async (dispatch: Dispatch) => {
  loadingAlert(dispatch);

  const lineUserUrl = BACKEND_URL.LINE_USER(lineUser.id);
  const lineUserParams = {
    notice_time: lineUser.noticeTime,
    silent_notice: lineUser.silentNotice,
  };

  const weatherUrl = BACKEND_URL.WEATHER(weather.id);
  const weatherParams = {
    city: weather.city,
    lat: weather.lat,
    lon: weather.lon,
  };

  const [lineUserJson, weatherJson] = await Promise.all([
    put(lineUserUrl, lineUserParams),
    put(weatherUrl, weatherParams),
  ]);

  console.log("lineUserJson", lineUserJson);
  console.log("weatherJson", weatherJson);

  const lineUserAttr = serializeLineUser(lineUserJson);
  const weatherAttr = serializeWeather(weatherJson);

  dispatch(
    lineUserActions.updateValue.done({ result: lineUserAttr, params: {} })
  );
  dispatch(
    weatherActions.updateValue.done({ result: weatherAttr, params: {} })
  );
  openAlert(dispatch, "success", ["更新に成功しました！"]);
};
