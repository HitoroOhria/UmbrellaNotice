import { reducerWithInitialState } from "typescript-fsa-reducers";
import alertActions from "./actions";
import { AlertState } from "types/store";

const initState: AlertState = {
  isLoading: false,
  severity: "error",
  messages: [""],
  open: false,
};

const alertReducer = reducerWithInitialState(initState)
  .case(alertActions.openAlert, (_preState, payload) => ({
    ...payload,
    open: true,
    isLoading: false,
  }))
  .case(alertActions.closeAlert, (preState) => ({
    ...preState,
    messages: [""],
    open: false,
    isLoading: false,
  }))
  .case(alertActions.loadingAlert, (preState, _payload) => ({
    ...preState,
    isLoading: true,
  }));

export default alertReducer;
