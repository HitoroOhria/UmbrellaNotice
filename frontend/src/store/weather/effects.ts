import { Dispatch } from "redux";

import weatherActions from "./actions";
import lineUserActions from "store/lineUser/actions";

import { LineUserState, WeatherState } from "types/store";
import { updateWeatherAttr } from "types/services/backendApi";

import { loadingAlert, openAlert } from "services/alert";
import {
  callLineUserUpdate,
  callWeatherUpdate,
  serializeLineUser,
  serializeWeather,
} from "services/backendApi";

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

  if ("error" in lineUserJson || "error" in weatherJson) {
    openAlert(dispatch, "error", [
      "無効な市名です。入力内容をご確認ください。",
    ]);
  } else {
    const lineUserAttr = serializeLineUser(lineUserJson.data);
    const weatherAttr = serializeWeather(weatherJson.data);

    dispatch(
      lineUserActions.updateValue.done({ result: lineUserAttr, params: {} })
    );
    dispatch(
      weatherActions.updateValue.done({ result: weatherAttr, params: {} })
    );
    openAlert(dispatch, "success", ["更新に成功しました！"]);
  }
};
