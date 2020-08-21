import { reducerWithInitialState } from "typescript-fsa-reducers";
import userActions from "./actions";
import { UserState } from "../../domain/entity/user";

const initState: UserState = {
  email: "",
  oldPassword: "",
  newPassword: "",
  showOldPassword: false,
  showNewPassword: false,
};

const userReucer = reducerWithInitialState(initState)
  .case(userActions.setUserValue, (preState, payload) => ({
    ...preState,
    ...payload,
  }))
  .case(userActions.initPasswords, (preState, _payload) => ({
    ...preState,
    oldPassword: "",
    newPassword: "",
  }))
  .case(userActions.toggleShowOldPassword, (preState, _payload) => ({
    ...preState,
    showOldPassword: !preState.showOldPassword,
  }))
  .case(userActions.toggleShowNewPassword, (preState, _payload) => ({
    ...preState,
    showNewPassword: !preState.showNewPassword,
  }));

export default userReucer;
