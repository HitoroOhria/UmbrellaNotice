import { reducerWithInitialState } from "typescript-fsa-reducers";
import userActions from "./actions";
import { UserState } from "types/user";

const initState: UserState = {
  id: 0,
  email: "",
  oldPassword: "",
  newPassword: "",
  showOldPassword: false,
  showNewPassword: false,
};

const userReucer = reducerWithInitialState(initState)
  .case(userActions.setValue, (preState, payload) => ({
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
  })).case(userActions.fetchUser.done, (preState, payload) => ({
    ...preState,
    ...payload.result
  }));

export default userReucer;
