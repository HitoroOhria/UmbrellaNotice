import { createStore, combineReducers, applyMiddleware, compose } from "redux";
import thunk from "redux-thunk";

import { RootState } from "../domain/entity/rootState";
import alertReducer from "./alert/reducer";
import menuDrawerReucer from "./menuDrawer/reducer";
import dialogReducer from "./dialog/reducer";
import homeReducer from "./home/reducer";
import userReducer from "./user/reducer";
import weahterReducer from "./weather/reducer";
import lineUserReducer from "./lineUser/reducer";
import cognitoReucer from "./cognito/reducer";

const store = createStore(
  combineReducers<RootState>({
    alert: alertReducer,
    menuDrawer: menuDrawerReucer,
    dialog: dialogReducer,
    home: homeReducer,
    user: userReducer,
    weather: weahterReducer,
    lineUser: lineUserReducer,
    cognito: cognitoReucer,
  }),
  compose(
    applyMiddleware(thunk),
    (window as any).__REDUX_DEVTOOLS_EXTENSION__ &&
      (window as any).__REDUX_DEVTOOLS_EXTENSION__()
  )
);

export default store;
