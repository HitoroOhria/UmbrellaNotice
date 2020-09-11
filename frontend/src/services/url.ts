import { isProd } from "constants/app";
import { ORIGIN } from "constants/url";
import { Resource } from "types/services/backendApi";

const makeCreateBackendUrl = (resource: Resource) => {
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

export const createBackendUrl = {
  users: makeCreateBackendUrl("users"),
  lineUsers: makeCreateBackendUrl("line_users"),
  weathers: makeCreateBackendUrl("weathers"),
};
