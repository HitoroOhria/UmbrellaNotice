import actionCreatorFactory from "typescript-fsa";
import { WeatherState, UpdateWatherAttr } from "types/store";

const actionCreator = actionCreatorFactory();

const weatherActions = {
  setValue: actionCreator<Partial<WeatherState>>("SET_WEATHER_VALUE"),
  fetchWeather: actionCreator.async<{}, Partial<WeatherState>, {}>(
    "FETCH_WEATHER"
  ),
  relateUser: actionCreator.async<{}, WeatherState, {}>(
    "RELATE_USER_BY_WEAHTER"
  ),
  updateValue: actionCreator.async<{}, UpdateWatherAttr, {}>(
    "UPDATE_WEATHER_VALUE"
  ),
};

export default weatherActions;
