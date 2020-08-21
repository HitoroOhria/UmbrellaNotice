import { AuthState } from "@aws-amplify/ui-components";
import { CognitoUser } from "amazon-cognito-identity-js";

export type ExCognitoUser = CognitoUser & {
  attributes: {
    email: string;
    email_verified: boolean;
    sub: string;
  };
};

export type CognitoState = {
  auth: AuthState;
  user: ExCognitoUser | undefined;
};

// CognitoUser = {
//   Session: null,
//   attributes: {
//     email: "xxxxxxxxxx@xxxxxx.xxx",
//     email_verified: true,
//     sub: "xxxxxxxxxxxxxxxxxxxxxx",
//   },
//   authenticationFlowType: "USER_SRP_AUTH",
//   client: Client {
//     endpoint: "https://cognito-idp.ap-northeast-1.amazonaws.com/",
//     fetchOptions: {},
//   },
//   keyPrefix: "CognitoIdentityServiceProvider.xxxxxxxxxxxxxxxxxxxxxx",
//   pool: CognitoUserPool {
//     userPoolId: "xxxxxxxxxxxxxxxxxxxxxx",
//     clientId: "xxxxxxxxxxxxxxxxxxxxxx",
//     client: Client {
//       endpoint: "https://cognito-idp.ap-northeast-1.amazonaws.com/",
//       fetchOptions: {},
//     },
//     advancedSecurityDataCollectionFlag: true,
//     storage: Storage,
//   },
//   preferredMFA: "NOMFA",
//   signInUserSession: CognitoUserSession {
//     idToken: CognitoIdToken,
//     refreshToken: CognitoRefreshToken,
//     accessToken: CognitoAccessToken,
//     clockDrift: 0
//     },
//   storage: Storage { ... },
//   userDataKey:
//     "CognitoIdentityServiceProvider.xxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxx@xxxxxx.xxx.userData",
//   username: "xxxxxxxxxx",
// };
