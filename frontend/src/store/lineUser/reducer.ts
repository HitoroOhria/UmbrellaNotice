import { reducerWithInitialState } from "typescript-fsa-reducers";
import lineUserActions from "./actions";
import { LineUserState } from "../../domain/entity/lineUser";

const initState: LineUserState = {
  related: false,
  serialNumber: ''
}; 

const lineUserReucer = reducerWithInitialState(initState)
.case(lineUserActions.setSerialNumber , (preState, payload) => ({
  ...preState,
  serialNumber: payload
}));

export default lineUserReucer;
