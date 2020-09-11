import { Dispatch } from "redux";
import { Auth } from "aws-amplify";
import { CognitoUser } from "amazon-cognito-identity-js";

import userActions from "./actions";
import lineUserActions from "store/lineUser/actions";
import weatherActions from "store/weather/actions";

import { AmplifyError } from "types/amplify";

import {
  callUserShow,
  callUserCreate,
  serializeUser,
  serializeLineUser,
  serializeWeather,
} from "services/backendApi";
import { loadingAlert, openAlert } from "services/alert";

export const fetchAllData = (email: string) => async (dispatch: Dispatch) => {
  const json = await callUserShow(email, "line_user.weather");

  if ("error" in json) {
    await callUserCreate(email);
    const json = await callUserShow(email);

    if ("error" in json) return;

    const user = serializeUser(json.data);

    dispatch(userActions.fetchUser.done({ result: user, params: {} }));
  } else if (json.included) {
    const user = serializeUser(json.data);
    const lineUser = serializeLineUser(json.included[0]);
    const weather = serializeWeather(json.included[1]);

    dispatch(userActions.fetchUser.done({ result: user, params: {} }));
    dispatch(lineUserActions.relateUser.done({ result: lineUser, params: {} }));
    dispatch(weatherActions.fetchWeather.done({ result: weather, params: {} }));
  } else {
    const user = serializeUser(json.data);

    dispatch(userActions.fetchUser.done({ result: user, params: {} }));
  }
};

type attributes = {
  email: string;
  [attribute: string]: string;
};

export const updateCognitoUser = (
  cognitoUser: CognitoUser,
  attributes: Partial<attributes>
) => async (dispatch: Dispatch) => {
  loadingAlert(dispatch);

  for (const key in attributes) {
    attributes[key] || delete attributes[key];
  }

  await Auth.updateUserAttributes(cognitoUser, attributes)
    .then((_res: "SUCCESS" | string) => {
      openAlert(dispatch, "success", ["変更に成功しました！"]);
    })
    .catch((_error: AmplifyError) => {
      openAlert(dispatch, "error", ["無効なメ−ルアドレスです"]);
    });
};

export const changeCognitoUserPassword = (
  cognitoUser: CognitoUser,
  oldPassword: string,
  newPassword: string
) => async (dispatch: Dispatch) => {
  loadingAlert(dispatch);

  await Auth.changePassword(cognitoUser, oldPassword, newPassword)
    .then((_res: "SUCCESS" | string) => {
      dispatch(userActions.initPasswords({}));
      openAlert(dispatch, "success", ["変更に成功しました！"]);
    })
    .catch((error: AmplifyError) => {
      openAlert(dispatch, "error", [
        "パスワードが間違っています",
        error.message,
      ]);
    });
};
