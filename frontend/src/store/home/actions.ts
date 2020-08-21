import actionCreatorFactory from "typescript-fsa";

const actionCreator = actionCreatorFactory();

const homeActions = {
  isHomePage: actionCreator<{}>("IS_HOME_PAGE"),
  isNotHomePage: actionCreator<{}>("IS_NOT_HOME_PAGE"),
  setTopViewHeight: actionCreator<number>("SET_TOP_VIEW_HEIGHT"),
  setScrollTopValue: actionCreator<number>("SET_WINDOW_TOP_VALUE"),
};

export default homeActions;
