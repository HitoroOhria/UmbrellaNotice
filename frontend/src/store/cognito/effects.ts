import { Dispatch } from "redux";
import { Auth } from "aws-amplify";

import { openAlert } from "../../domain/services/alert";

export const signIn = (email: string, password: string) => async (dispatch: Dispatch) => {
  await Auth.signIn(email, password).then(() => {
    openAlert(dispatch, "success", ["ログインしました！"]);
  });
}

export const signOut = () => async (dispatch: Dispatch) => {
  await Auth.signOut().then(() => {
    openAlert(dispatch, "success", ["ログアウトしました！"]);
  });
};
