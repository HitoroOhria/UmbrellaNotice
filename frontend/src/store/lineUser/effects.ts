import { Dispatch } from "redux";

import lineUserActions from "./actions";
import weatherActions from "../weather/actions";

import { loadingAlert, openAlert } from "../../domain/services/alert";
import { BACKEND_URL } from "../../domain/services/url";
import { get, post } from "../../domain/services/http";
import {
  serializeLineUser,
  serializeWeather,
} from "../../domain/services/serialize";

export const relateUser = (email: string, serialNumber: string) => async (
  dispatch: Dispatch
) => {
  loadingAlert(dispatch);

  const url = BACKEND_URL.USER(email, "relate_line_user");
  const params = { inherit_token: serialNumber };
  const json = await post(url, params);

  if (json.error) {
    openAlert(dispatch, "error", ["シリアル番号が間違っています。"]);
  } else {
    const url = BACKEND_URL.USER(email);
    const queryParams = { embed: "line_user.weather" };

    const json = await get(url, queryParams);

    const lineUser = serializeLineUser(json.line_user);
    const weather = serializeWeather(json.line_user.weather);

    dispatch(lineUserActions.relateUser.done({ result: lineUser, params: {} }));
    dispatch(weatherActions.relateUser.done({ result: weather, params: {} }));
    openAlert(dispatch, "success", ["連携に成功しました！"]);
  }
};

export const releaseUser = (email: string) => async (dispatch: Dispatch) => {
  loadingAlert(dispatch);

  const url = BACKEND_URL.USER(email, "release_line_user");

  await post(url);

  dispatch(lineUserActions.releaseUser.done({ result: {}, params: {} }));
  openAlert(dispatch, "success", ["連携を解除しました！"]);
};
