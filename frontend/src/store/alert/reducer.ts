import { reducerWithInitialState } from "typescript-fsa-reducers";
import alertActions from "./actions";
import { AlertState } from "../../domain/entity/alert";

const initState: AlertState = {
  severity: "error",
  messages: [""],
  open: false,
};

const alertReducer = reducerWithInitialState(initState)
  .case(alertActions.openAlert, (_preState, payload) => ({
    ...payload,
    open: true,
  }))
  .case(alertActions.closeAlert, (preState) => ({
    ...preState,
    messages: [""],
    open: false,
  }));

export default alertReducer;
