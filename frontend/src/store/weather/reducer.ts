import { reducerWithInitialState } from "typescript-fsa-reducers";
import weatherActions from "./actions";
import { WeatherState } from "../../domain/entity/weather";

const initState: WeatherState = {
  location: "",
  noticeTime: "",
  silentNotice: true,
};

const weatherReucer = reducerWithInitialState(initState)
  .case(weatherActions.setWeatherValue, (preState, payload) => ({
    ...preState,
    ...payload,
  }))
  .case(weatherActions.toggleSilentNotice, (preState, _payload) => ({
    ...preState,
    silentNotice: !preState.silentNotice,
  }));

export default weatherReucer;
