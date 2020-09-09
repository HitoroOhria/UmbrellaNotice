import { Dispatch } from "redux";

import lineUserActions from "./actions";
import weatherActions from "../weather/actions";

import { loadingAlert, openAlert } from "../../domain/services/alert";
import {
  callUserShow,
  callUserRelateLineUser,
  callUserReleaseLineUser,
  serializeLineUser,
  serializeWeather,
} from "../../domain/services/backendApi";

export const relateUser = (email: string, serialNumber: string) => async (
  dispatch: Dispatch
) => {
  loadingAlert(dispatch);

  const json = await callUserRelateLineUser(email, serialNumber);

  if ("error" in json) {
    openAlert(dispatch, "error", ["シリアル番号が間違っています。"]);
  } else {
    const json = await callUserShow(email, "line_user.weather");

    if ("error" in json) return;
    if (!json.included) return;

    const lineUser = serializeLineUser(json.included[0]);
    const weather = serializeWeather(json.included[1]);

    dispatch(lineUserActions.relateUser.done({ result: lineUser, params: {} }));
    dispatch(weatherActions.relateUser.done({ result: weather, params: {} }));
    openAlert(dispatch, "success", ["連携に成功しました！"]);
  }
};

export const releaseUser = (email: string) => async (dispatch: Dispatch) => {
  loadingAlert(dispatch);

  await callUserReleaseLineUser(email);

  dispatch(lineUserActions.releaseUser.done({ result: {}, params: {} }));
  openAlert(dispatch, "success", ["連携を解除しました！"]);
};
