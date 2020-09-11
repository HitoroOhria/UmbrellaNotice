import { reducerWithInitialState } from "typescript-fsa-reducers";
import menuDrawerActions from "./actions";
import { MenuDrawerState } from "types/menuDrawer";

const initState: MenuDrawerState = {
  isOpen: false,
};

const menuDrawerReucer = reducerWithInitialState(initState)
  .case(menuDrawerActions.openMenuDrawer, (preState) => ({
    ...preState,
    isOpen: true,
  }))
  .case(menuDrawerActions.closeMenuDrawer, (preState) => ({
    ...preState,
    isOpen: false,
  }));

export default menuDrawerReucer;
