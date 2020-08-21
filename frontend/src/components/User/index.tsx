/** @jsx jsx */
import React, { FC, useEffect } from "react";
import { jsx } from "@emotion/core";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../../domain/entity/rootState";

import Amplify, { I18n } from "aws-amplify";
import { AuthState, onAuthUIStateChange } from "@aws-amplify/ui-components";

import Authentication from "./Authentication";
import ProfileEdit from "./ProfileEdit";

import cognitoActions from "../../store/cognito/actions";
import { AMPLIFY_DICT, AMPLIFY_CONFIGURE } from "../../domain/services/amplify";
import { ExCognitoUser } from "../../domain/entity/cognito";

// Amplify Setting
Amplify.configure(AMPLIFY_CONFIGURE);
I18n.putVocabularies(AMPLIFY_DICT);
I18n.setLanguage("ja");

const User: FC = () => {
  const dispatch = useDispatch();
  const cognito = useSelector((state: RootState) => state.cognito);

  const dispatchSetCognitoUser = (authData: object) =>
    dispatch(cognitoActions.setCognitoUser(authData as ExCognitoUser));

  useEffect(() => {
    return onAuthUIStateChange((nextAuthState, authData) => {
      dispatch(cognitoActions.setCognitoAuth(nextAuthState));
      authData
        ? dispatchSetCognitoUser(authData)
        : dispatch(cognitoActions.initCognitoUser({}));
    });
  }, []);

  const SignedInAndCognitoUser =
    cognito.auth === AuthState.SignedIn && cognito.user !== undefined;

  return SignedInAndCognitoUser ? <ProfileEdit /> : <Authentication />;
};

export default User;
