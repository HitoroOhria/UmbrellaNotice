import { reducerWithInitialState } from "typescript-fsa-reducers";
import dialogActions from "./actions";
import { DialogState } from "../../domain/entity/dialog";

const initState: DialogState = {
  isUserEmailDialogOpen: false,
};

const dialogReucer = reducerWithInitialState(initState)
  .case(dialogActions.openUserEmailDialog, (preState, payload) => ({
    ...preState,
    isUserEmailDialogOpen: true,
  }))
  .case(dialogActions.closeUserEmailDialog, (preState, payload) => ({
    ...preState,
    isUserEmailDialogOpen: false,
  }));

export default dialogReucer;
