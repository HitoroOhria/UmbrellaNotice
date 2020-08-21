import actionCreatorFactory from "typescript-fsa";
import { AuthState } from "@aws-amplify/ui-components";
import { ExCognitoUser } from "../../domain/entity/cognito";

const actionCreator = actionCreatorFactory();

const cognitoActions = {
  setCognitoAuth: actionCreator<AuthState>("SET_COGNITO_AUTH"),
  initCognitoUser: actionCreator<{}>("INIT_COGNITO_USER"),
  setCognitoUser: actionCreator<ExCognitoUser>("SET_COGNITO_USER"),
};

export default cognitoActions;
