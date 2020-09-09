import { isProd, DOMAIN } from "./app";
import { Resource } from "../entity/backendApi";

export const ORIGIN = {
  DEV: `http://${DOMAIN.DEV}`,
  PROD: `https://${DOMAIN.PROD}`,
  STATIC: `https://${DOMAIN.STATIC}`,
};

const backendUrlMaker = (resource: Resource) => {
  const origin = isProd ? ORIGIN.PROD : ORIGIN.DEV;
  const baseUrl = `${origin}/api/v1/${resource}`;

  return (identifier?: string | number, extraUrl?: string) => {
    if (identifier === undefined) return baseUrl;

    const encodedTdentifier = encodeURIComponent(identifier);

    return extraUrl
      ? baseUrl + "/" + encodedTdentifier + "/" + extraUrl
      : baseUrl + "/" + encodedTdentifier;
  };
};

export const BACKEND_URL = {
  USER: backendUrlMaker("users"),
  LINE_USER: backendUrlMaker("line_users"),
  WEATHER: backendUrlMaker("weathers"),
};

export const URL_PATH = {
  HOME: "/",
  TERMS: "/terms",
  POLICY: "/policy",
  USER: "/user",
};

export const OUTSIDE_URL = {
  LINE: { FOLLOW: " https://lin.ee/Q28r1Nv" },
  GOOGLE: {
    API_POLICY:
      "https://developers.google.com/terms/api-services-user-data-policy",
  },
};
