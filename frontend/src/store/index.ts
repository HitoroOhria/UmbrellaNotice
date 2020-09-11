import { createStore, combineReducers, applyMiddleware, compose } from "redux";
import thunk from "redux-thunk";

import { RootState } from "types/store";

import alertReducer from "store/alert/reducer";
import menuDrawerReucer from "store/menuDrawer/reducer";
import dialogReducer from "store/dialog/reducer";
import homeReducer from "store/home/reducer";
import userReducer from "store/user/reducer";
import weahterReducer from "store/weather/reducer";
import lineUserReducer from "store/lineUser/reducer";
import cognitoReucer from "store/cognito/reducer";

const composeEnhancers = (() => {
  return (typeof window != 'undefined' && (window as any).__REDUX_DEVTOOLS_EXTENSION_COMPOSE__) || compose;
})();

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
  composeEnhancers(applyMiddleware(thunk))
);

export default store;
