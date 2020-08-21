import actionCreatorFactory from "typescript-fsa";

const actionCreator = actionCreatorFactory();

const dialogActions = {
  openUserEmailDialog: actionCreator<{}>("OPEN_USER_EMIAL_DIALOG"),
  closeUserEmailDialog: actionCreator<{}>("CLOSE_USER_EMIAL_DIALOG"),
};

export default dialogActions;
