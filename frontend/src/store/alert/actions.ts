import actionCreatorFactory from "typescript-fsa";
import { AlertState } from "types/store";

const actionCreator = actionCreatorFactory();

type AlertPayload = Omit<AlertState, "open" | "isLoading">;

const alertActions = {
  openAlert: actionCreator<AlertPayload>("OPEN_ALERT"),
  closeAlert: actionCreator<{}>("CLOSE_ALERT"),
  loadingAlert: actionCreator<{}>("LOADING_ALERT")
};

export default alertActions;