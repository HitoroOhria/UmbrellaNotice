import actionCreatorFactory from "typescript-fsa";
import {
  LineUserState,
  RelateUserByLineUserAttr,
  UpdateLineUserAttr,
} from "types/store";

const actionCreator = actionCreatorFactory();

const lineUserActions = {
  setValue: actionCreator<Partial<LineUserState>>("SET_LINE_USER_VALUE"),
  toggleSilentNotice: actionCreator<{}>("TOGGLE_SILENT_NOTICE"),
  fetchLineUser: actionCreator.async<{}, Partial<LineUserState>, {}>(
    "FETCH_LINE_USER"
  ),
  relateUser: actionCreator.async<{}, RelateUserByLineUserAttr, {}>(
    "RELATE_USER_BY_LINE_USER"
  ),
  releaseUser: actionCreator.async<{}, {}, {}>("RELEASE_USER_BY_LINE_USER"),
  updateValue: actionCreator.async<{}, UpdateLineUserAttr, {}>(
    "UPDATE_LINE_USER_VALUE"
  ),
};

export default lineUserActions;
