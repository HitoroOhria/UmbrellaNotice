import _ from "lodash";

import { ApiResUser } from "../entity/user";
import { ApiResLineUser } from "../entity/lineUser";
import { ApiResWeather } from "../entity/weather";

export const serialize = (
  obj: { [attribute: string]: string | number },
  ...allowKeys: string[]
) => {
  const dupObj = Object.assign(obj);

  for (const key in dupObj) {
    if (allowKeys.includes(key)) {
      const value = dupObj[key];
      const newKey = _.camelCase(key);

      delete dupObj[key];
      dupObj[newKey] = value;
    } else {
      delete dupObj[key];
    }
  }

  return dupObj;
};

export const serializeUser = (obj: {
  [attribute: string]: string;
}): ApiResUser => serialize(obj, "id", "email");

export const serializeLineUser = (obj: {
  [attribute: string]: string;
}): ApiResLineUser => serialize(obj, "id", "notice_time", "silent_notice");

export const serializeWeather = (obj: {
  [attribute: string]: string;
}): ApiResWeather => serialize(obj, "id", "city", "lat", "lon");
