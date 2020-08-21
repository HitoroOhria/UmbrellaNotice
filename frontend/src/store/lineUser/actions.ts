import actionCreatorFactory from "typescript-fsa";

const actionCreator = actionCreatorFactory();

const lineUserActions = {
  setSerialNumber: actionCreator<string>("SET_SERILA_NUMBER"),
};

export default lineUserActions;