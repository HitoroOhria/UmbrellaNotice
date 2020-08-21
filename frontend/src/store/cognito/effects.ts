import { Dispatch } from "redux";
import { Auth } from "aws-amplify";
import cognitoActions from "./actions";

import alertActions from "../alert/actions";
import { AlertState } from "../../domain/entity/alert";

export const signOut = () => async (dispatch: Dispatch) => {
  console.log("click sign out");

  await Auth.signOut().then(() => {
    const alert: Omit<AlertState, "open"> = {
      severity: "success",
      messages: ["ログアウトしました！"],
    };

    dispatch(alertActions.openAlert(alert));
  });
};
