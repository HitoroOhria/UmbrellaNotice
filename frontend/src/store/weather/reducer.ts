import { reducerWithInitialState } from "typescript-fsa-reducers";
import weatherActions from "./actions";
import { WeatherState } from "../../domain/entity/weather";

const initState: WeatherState = {
  id: 0,
  city: "",
  lat: undefined,
  lon: undefined,
};

const weatherReucer = reducerWithInitialState(initState)
  .case(weatherActions.setValue, (preState, payload) => ({
    ...preState,
    ...payload,
  }))
  .case(weatherActions.fetchWeather.done, (preState, payload) => ({
    ...preState,
    ...payload.result
  }))
  .case(weatherActions.relateUser.done, (_preState, payload) => ({
    ...payload.result,
  })).case(weatherActions.updateValue.done, (preState, payload) => ({
    ...preState,
    ...payload.result
  }));

export default weatherReucer;
