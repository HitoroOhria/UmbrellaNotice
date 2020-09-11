import { Dispatch } from "redux";

import { AlertState } from "types/store";
import alertActions from "store/alert/actions";

export const loadingAlert = (dispatch: Dispatch) => {
  dispatch(alertActions.loadingAlert({}));
};

export const openAlert = (
  dispatch: Dispatch,
  severity: AlertState["severity"],
  messages: AlertState["messages"]
) => {
  dispatch(alertActions.openAlert({ severity, messages }));
};
