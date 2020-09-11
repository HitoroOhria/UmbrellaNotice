import { DOMAIN } from "./app";

export const ORIGIN = {
  DEV: `http://${DOMAIN.DEV}`,
  PROD: `https://${DOMAIN.PROD}`,
  STATIC: `https://${DOMAIN.STATIC}`,
};

export const PATH_NAME = {
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
