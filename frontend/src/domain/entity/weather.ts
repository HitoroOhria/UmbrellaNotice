export type WeatherState = {
  id: number;
  city: string;
  lat: Number | undefined;
  lon: Number | undefined;
};

export type ApiResWeather = {
  id: number;
  city: string;
  lat: number;
  lon: number;
};

export type UpdateWatherAttr = Omit<WeatherState, "id">;
