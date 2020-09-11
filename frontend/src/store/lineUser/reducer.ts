import { reducerWithInitialState } from "typescript-fsa-reducers";
import lineUserActions from "./actions";
import { LineUserState } from "types/store";

const initState: LineUserState = {
  id: 0,
  relatedUser: false,
  noticeTime: "",
  silentNotice: true,
  serialNumber: "",
};

const lineUserReucer = reducerWithInitialState(initState)
  .case(lineUserActions.setValue, (preState, payload) => ({
    ...preState,
    ...payload,
  }))

  .case(lineUserActions.toggleSilentNotice, (preState, _payload) => ({
    ...preState,
    silentNotice: !preState.silentNotice,
  }))
  .case(lineUserActions.fetchLineUser.done, (preState, payload) => ({
    ...preState,
    ...payload.result,
  }))
  .case(lineUserActions.relateUser.done, (preState, payload) => ({
    ...preState,
    ...payload.result,
    relatedUser: true,
  }))
  .case(lineUserActions.releaseUser.done, (preState, _payload) => ({
    ...preState,
    relatedUser: false,
  }))
  .case(lineUserActions.updateValue.done, (preState, payload) => ({
    ...preState,
    ...payload.result,
  }));

export default lineUserReucer;
