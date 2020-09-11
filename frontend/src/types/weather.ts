export type WeatherState = {
  id: number;
  city: string;
  lat: Number | undefined;
  lon: Number | undefined;
};

export type UpdateWatherAttr = Omit<WeatherState, "id">;
