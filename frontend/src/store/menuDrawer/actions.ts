import actionCreatorFactory from "typescript-fsa";

const actionCreator = actionCreatorFactory();

const menuDrawerActions = {
  openMenuDrawer: actionCreator<{}>("OPEN_MENU_DRAWER"),
  closeMenuDrawer: actionCreator<{}>("CLOSE_MENU_DRAWER"),
};

export default menuDrawerActions;
