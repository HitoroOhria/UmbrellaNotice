import { Dispatch } from "redux";
import userActions from "./actions";
import { Auth } from "aws-amplify";
import { CognitoUser } from "amazon-cognito-identity-js";

import alertActions from "../alert/actions";
import { AlertState } from "../../domain/entity/alert";
import { AmplifyError } from "../../domain/entity/amplify";

type attributes = {
  email: string;
  [attribute: string]: string;
};

export const updateCognitoUser = (
  cognitoUser: CognitoUser,
  attributes: Partial<attributes>
) => async (dispatch: Dispatch) => {
  for (const key in attributes) {
    attributes[key] || delete attributes[key];
  }

  await Auth.updateUserAttributes(cognitoUser, attributes)
    .then((res: "SUCCESS" | string) => {
      const alert: Omit<AlertState, "open"> = {
        severity: "success",
        messages: ["変更に成功しました！"],
      };

      dispatch(alertActions.openAlert(alert));
    })
    .catch((error: AmplifyError) => {
      const alert: Omit<AlertState, "open"> = {
        severity: "error",
        messages: ["無効なメ−ルアドレスです"],
      };

      dispatch(alertActions.openAlert(alert));
    });
};

export const changeCognitoUserPassword = (
  cognitoUser: CognitoUser,
  oldPassword: string,
  newPassword: string
) => async (dispatch: Dispatch) => {
  await Auth.changePassword(cognitoUser, oldPassword, newPassword)
    .then((res: "SUCCESS" | string) => {
      const alert: Omit<AlertState, "open"> = {
        severity: "success",
        messages: ["変更に成功しました！"],
      };

      dispatch(userActions.initPasswords({}));
      dispatch(alertActions.openAlert(alert));
    })
    .catch((error: AmplifyError) => {
      const alert: Omit<AlertState, "open"> = {
        severity: "error",
        messages: ["パスワードが間違っています", error.message],
      };

      dispatch(alertActions.openAlert(alert));
    });
};
