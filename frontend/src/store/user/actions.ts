import actionCreatorFactory from "typescript-fsa";
import { UserState } from "types/store";

const actionCreator = actionCreatorFactory();

const userActions = {
  setValue: actionCreator<Partial<UserState>>("SET_USER_VALUE"),
  initPasswords: actionCreator<{}>("INIT_PASSWORDS"),
  toggleShowOldPassword: actionCreator<{}>("TOGGLE_SHOW_OLD_PASSWORD"),
  toggleShowNewPassword: actionCreator<{}>("TOGGLE_SHOW_NEW_PASSWORD"),
  fetchUser: actionCreator.async<{},Partial<UserState> ,{}>("FETCH_USER")
};

export default userActions;
