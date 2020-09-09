import { Dispatch } from "redux";

import weatherActions from "./actions";
import lineUserActions from "../lineUser/actions";

import { loadingAlert, openAlert } from "../../domain/services/alert";
import {
  callLineUserUpdate,
  callWeatherUpdate,
  serializeLineUser,
  serializeWeather,
} from "../../domain/services/backendApi";

import { LineUserState } from "../../domain/entity/lineUser";
import { WeatherState } from "../../domain/entity/weather";
import { updateWeatherAttr } from "../../domain/entity/backendApi";

export const updateWeather = (
  lineUser: LineUserState,
  weather: WeatherState
) => async (dispatch: Dispatch) => {
  loadingAlert(dispatch);

  const lineUserParams = {
    notice_time: lineUser.noticeTime,
    silent_notice: lineUser.silentNotice,
  };

  const weatherParams = {
    city: weather.city,
    lat: weather.lat,
    lon: weather.lon,
  };

  const [lineUserJson, weatherJson] = await Promise.all([
    callLineUserUpdate(lineUser.id, lineUserParams),
    callWeatherUpdate(weather.id, weatherParams as updateWeatherAttr),
  ]);

  if ("error" in lineUserJson) return;
  if ("error" in weatherJson) return;

  const lineUserAttr = serializeLineUser(lineUserJson.data);
  const weatherAttr = serializeWeather(weatherJson.data);

  dispatch(
    lineUserActions.updateValue.done({ result: lineUserAttr, params: {} })
  );
  dispatch(
    weatherActions.updateValue.done({ result: weatherAttr, params: {} })
  );
  openAlert(dispatch, "success", ["更新に成功しました！"]);
};
