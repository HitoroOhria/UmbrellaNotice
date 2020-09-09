export type Resource = "users" | "line_users" | "weathers";

export type successRes = {
  success: true;
};

export type errorRes = {
  error: true;
  attributes: {
    [attribute: string]: string[];
  };
};

export type JsonAipResUser = {
  data: {
    id: string;
    type: "User";
    attributes: {
      email: string;
    };
    relationships: {
      lineUser: {
        data?: {
          id: number;
          type: "lineUser";
        };
      };
    };
  };
  included?: [JsonAipResLineUser["data"], JsonAipResWeather["data"]];
};

export type JsonAipResLineUser = {
  data: {
    id: string;
    type: "lineUser";
    attributes: {
      noticeTime: string;
      silentNotice: boolean;
    };
    relationships: {
      user: {
        data: {
          id: string;
          type: "User";
        };
      };
    };
  };
  included: [JsonAipResUser["data"], JsonAipResWeather["data"]];
};

export type JsonAipResWeather = {
  data: {
    id: string;
    type: "weather";
    attributes: {
      city: string;
      lat: string;
      lon: string;
    };
    relationships: {
      lineUser: {
        data: {
          id: string;
          type: "lineUser";
        };
      };
    };
  };
  included: [JsonAipResLineUser["data"], JsonAipResUser["data"]];
};

export type SerializedUser = {
  id: number;
  email: string;
};

export type SerializedLineUser = {
  id: number;
  noticeTime: string;
  silentNotice: boolean;
};

export type SerializedWeather = {
  id: number;
  city: string;
  lat: number;
  lon: number;
};

export type updateUserAttr = {
  email: string;
};

export type updateLineUserAttr = {
  notice_time: string;
  silent_notice: boolean;
};

export type updateWeatherAttr = {
  city: string;
  lat: number | string;
  lon: number | string;
};
