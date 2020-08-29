import { reducerWithInitialState } from "typescript-fsa-reducers";
import cognitoActinos from "./actions";
import { AuthState } from "@aws-amplify/ui-components";
import { CognitoState } from "../../domain/entity/cognito";

const initState: CognitoState = {
  auth: AuthState.SignedOut,
  user: undefined,
};

const cognitoReucer = reducerWithInitialState(initState)
  .case(cognitoActinos.setCognitoAuth, (preState, payload) => ({
    ...preState,
    auth: payload,
  }))
  .case(cognitoActinos.initCognitoUser, (preState, _payload) => ({
    ...preState,
    user: undefined,
  }))
  .case(cognitoActinos.setCognitoUser, (preState, payload) => ({
    ...preState,
    user: payload,
  }));

export default cognitoReucer;
