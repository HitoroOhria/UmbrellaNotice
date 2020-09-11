import { reducerWithInitialState } from "typescript-fsa-reducers";
import homeActions from "./actions";
import { HomeState } from "types/store";

const initState: HomeState = {
  isHomePage: false,
  topViewHeight: 0,
  scrollTop: 0,
};

const homeReucer = reducerWithInitialState(initState)
  .case(homeActions.isHomePage, (preState) => ({
    ...preState,
    isHomePage: true,
  }))
  .case(homeActions.isNotHomePage, (preState) => ({
    ...preState,
    isHomePage: false,
  }))
  .case(homeActions.setTopViewHeight, (preState, payload) => ({
    ...preState,
    topViewHeight: payload,
  }))
  .case(homeActions.setScrollTopValue, (preState, payload) => ({
    ...preState,
    scrollTop: payload,
  }));

export default homeReucer;
