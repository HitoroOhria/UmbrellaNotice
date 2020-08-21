import actionCreatorFactory from "typescript-fsa";
import { WeatherState } from "../../domain/entity/weather";

const actionCreator = actionCreatorFactory();

const weatherActions = {
  setWeatherValue: actionCreator<Partial<WeatherState>>("SET_WEATHER_VALUE"),
  toggleSilentNotice: actionCreator<{}>('TOGGLE_SILENT_NOTICE')
};

export default weatherActions;
