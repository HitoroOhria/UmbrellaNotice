import { reducerWithInitialState } from "typescript-fsa-reducers";
import menuDrawerActions from "./actions";
import { MenuDrawerState } from "../../domain/entity/menuDrawer";

const initState: MenuDrawerState = {
  isMenuDrawerOpen: false,
};

const menuDrawerReucer = reducerWithInitialState(initState)
  .case(menuDrawerActions.openMenuDrawer, (preState) => ({
    ...preState,
    isMenuDrawerOpen: true,
  }))
  .case(menuDrawerActions.closeMenuDrawer, (preState) => ({
    ...preState,
    isMenuDrawerOpen: false,
  }));

export default menuDrawerReucer;
