require("dotenv").config();

const crypto = require("crypto");
const S = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
const N = 21;
const createRandomNum = () =>
  Array.from(crypto.randomFillSync(new Uint8Array(N)))
    .map((n) => S[n % S.length])
    .join("");

const env = process.env;
const isProd = env.NODE_ENV === "production";

const withImages = require("next-images");

module.exports = withImages({
  env: {
    REACT_APP_AMPLIFY_REGION: env.REACT_APP_AMPLIFY_REGION,
    REACT_APP_AMPLIFY_USER_POOL_ID: env.REACT_APP_AMPLIFY_USER_POOL_ID,
    REACT_APP_AMPLIFY_WEB_CLIENT_ID: env.REACT_APP_AMPLIFY_WEB_CLIENT_ID,
    REACT_APP_AMPLIFY_IDENTITY_POOL_ID: env.REACT_APP_AMPLIFY_IDENTITY_POOL_ID,
  },
  assetPrefix: isProd ? "https://static.umbrellanotice.work" : "",
  generateBuildId: async () => {
    return env.CIRCLE_SHA1 || createRandomNum();
  },
});
