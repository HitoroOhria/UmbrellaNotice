import { Dispatch } from "redux";
import { Auth } from "aws-amplify";
import { CognitoUser } from "amazon-cognito-identity-js";

import userActions from "./actions";
import lineUserActions from "../lineUser/actions";

import { AmplifyError } from "../../domain/entity/amplify";
import { LineUserState } from "../../domain/entity/lineUser";

import {
  serializeUser,
  serializeLineUser,
  serializeWeather,
} from "../../domain/services/serialize";
import { get, post } from "../../domain/services/http";
import { BACKEND_URL } from "../../domain/services/url";
import { loadingAlert, openAlert } from "../../domain/services/alert";
import weatherActions from "../weather/actions";

export const fetchData = (email: string | undefined) => async (
  dispatch: Dispatch
) => {
  const url = BACKEND_URL.USER(email && "undefined");
  const params = { embed: "line_user.weather" };
  const json = await get(url, params);

  if (json.error) {
    const postUrl = BACKEND_URL.USER();
    const postParams = { email: email };
    await post(postUrl, postParams);

    const getUrl = BACKEND_URL.USER(email);
    const json = await get(getUrl);
    const user = serializeUser(json);

    dispatch(userActions.fetchUser.done({ result: user, params: {} }));
  } else if (json.line_user) {
    const user = serializeUser(json);
    const lineUser: Partial<LineUserState> = serializeLineUser(json.line_user);
    lineUser.relatedUser = true;
    const weather = serializeWeather(json.line_user.weather);

    dispatch(userActions.fetchUser.done({ result: user, params: {} }));
    dispatch(
      lineUserActions.fetchLineUser.done({ result: lineUser, params: {} })
    );
    dispatch(weatherActions.fetchWeather.done({ result: weather, params: {} }));
  } else {
    const user = serializeUser(json);

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
