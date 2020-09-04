/** @jsx jsx */
import { FC, useEffect } from "react";
import { GetServerSideProps } from 'next'
import { jsx } from "@emotion/core";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../domain/entity/rootState";

import Amplify, { I18n } from "aws-amplify";
import { onAuthUIStateChange } from "@aws-amplify/ui-components";
import {
  AmplifyAuthenticator,
  AmplifySignUp,
  AmplifySignIn,
} from "@aws-amplify/ui-react";
import { CognitoUser } from "amazon-cognito-identity-js";

import Layout from "../components/Layout";
import Heading from "../components/Heading";
import ItemHeading from "../components/ItemHeading";
import Input from "../components/Input";
import DateInput from "../components/DateInput";
import PasswordInput from "../components/PasswordInput";
import Button from "../components/Button";
import Switch from "../components/Switch";
import Dialog from "../components/Dialog";

import userActions from "../store/user/actions";
import lineUserActions from "../store/lineUser/actions";
import weahterActions from "../store/weather/actions";
import dialogActinos from "../store/dialog/actions";
import cognitoActions from "../store/cognito/actions";

import {
  changeCognitoUserPassword,
  updateCognitoUser,
} from "../store/user/effects";

import { UserState } from "../domain/entity/user";
import { WeatherState } from "../domain/entity/weather";
import { ExCognitoUser } from "../domain/entity/cognito";

import {
  AMPLIFY_FORM,
  AMPLIFY_DICT,
  AMPLIFY_CONFIGURE,
} from "../domain/services/amplify";
import { USER_LABEL } from "../domain/services/user";
import { WEATHER_LABEL } from "../domain/services/weather";

// Amplify Setting
Amplify.configure(AMPLIFY_CONFIGURE);
I18n.putVocabularies(AMPLIFY_DICT);
I18n.setLanguage("ja");

export const getServerSideProps: GetServerSideProps = async (_context) => {
  return {
    props: {},
  }
}

const User: FC = () => {
  const dispatch = useDispatch();

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

  return (
    <Layout title={"Profile"}>
      <AmplifyAuthenticator usernameAlias="email">
        <AmplifySignUp
          slot="sign-up"
          usernameAlias="email"
          formFields={AMPLIFY_FORM.SIGN_UP}
        />
        <AmplifySignIn
          slot="sign-in"
          usernameAlias="email"
          formFields={AMPLIFY_FORM.SIGN_IN}
        />

        {/* Contnet of User Sgined In */}
        <div>
          <Heading>Profile Edit</Heading>
          <div
            css={{
              maxWidth: 400,
              margin: "40px auto 0 auto",
            }}
          >
            <ItemHeading itemName={"ユーザー"} />
            <EditUser />

            <ItemHeading itemName={"LINE アカウント"} />
            <EditLineUser />

            <ItemHeading itemName={"天気予報"} />
            <EditWeather />
          </div>
        </div>
      </AmplifyAuthenticator>
    </Layout>
  );
};

export default User;

const EditUser: FC = () => {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);

  const handleChange = (member: Partial<UserState>) =>
    dispatch(userActions.setUserValue(member));

  const handleEmailButtonClick = () =>
    dispatch(dialogActinos.openUserEmailDialog({}));

  const toggleOldShowPassword = () =>
    dispatch(userActions.toggleShowOldPassword({}));

  const toggleNewShowPassword = () =>
    dispatch(userActions.toggleShowNewPassword({}));

  const handlePasswordSave = () => {
    dispatch(
      changeCognitoUserPassword(
        cognitoUser as CognitoUser,
        user.oldPassword,
        user.newPassword
      )
    );
  };

  return (
    <div>
      {/* Email */}
      <Input
        label={USER_LABEL.EMAIL}
        value={user.email}
        onChange={(event) => handleChange({ email: event.target.value })}
      />
      <Button submitText={"確認する"} onClick={handleEmailButtonClick} />
      {/* Old Password */}
      <PasswordInput
        label={USER_LABEL.OLD_PASSWORD}
        showPassword={user.showOldPassword}
        value={user.oldPassword}
        onChange={(event) => handleChange({ oldPassword: event.target.value })}
        onIconClick={toggleOldShowPassword}
      />
      {/* New Password */}
      <PasswordInput
        label={USER_LABEL.NEW_PASSWORD}
        showPassword={user.showNewPassword}
        value={user.newPassword}
        onChange={(event) => handleChange({ newPassword: event.target.value })}
        onIconClick={toggleNewShowPassword}
      />
      <Button submitText={"変更する"} onClick={handlePasswordSave} />
      <UerEmailDialog />
    </div>
  );
};

const UerEmailDialog: FC = () => {
  const dispatch = useDispatch();
  const userEmail = useSelector((state: RootState) => state.user.email);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);
  const dialogOpen = useSelector(
    (state: RootState) => state.dialog.isUserEmailDialogOpen
  );

  const handleClose = () => dispatch(dialogActinos.closeUserEmailDialog({}));

  const handleAgree = () => {
    // sameEmail ? alertSameEmail : updateEmail
    dispatch(
      updateCognitoUser(cognitoUser as CognitoUser, {
        email: userEmail,
      })
    );
    handleClose();
  };

  return (
    <Dialog
      open={dialogOpen}
      title={"メールアドレスを変更しますか？"}
      onClose={handleClose}
      onNoClick={handleClose}
      onYesClick={handleAgree}
    >
      <p>次回のサインイン時にメールアドレスの承認が必要になります。</p>
      <p>打ち間違いがないかご確認下さい。</p>
      <div css={{ marginTop: 30, textAlign: "center" }}>
        <span css={{ borderBottom: "1px solid #ccc" }}>
          メールアドレス: {userEmail}
        </span>
      </div>
    </Dialog>
  );
};

const EditLineUser: FC = () => {
  const dispatch = useDispatch();
  const lineUser = useSelector((state: RootState) => state.lineUser);

  const handleChange = (serialNumber: string) => {
    dispatch(lineUserActions.setSerialNumber(serialNumber));
  };

  return lineUser.related ? (
    <div css={{ textAlign: "center" }}>
      <Button submitText={"連携済みです！"} contained />
    </div>
  ) : (
    <div>
      <Input
        label={"シリアル番号"}
        value={lineUser.serialNumber}
        onChange={(event) => handleChange(event.target.value)}
      />
      <Button submitText={"連携する"} />
    </div>
  );
};

const EditWeather: FC = () => {
  const dispatch = useDispatch();
  const weather = useSelector((state: RootState) => state.weather);

  const handleChange = (member: Partial<WeatherState>) =>
    dispatch(weahterActions.setWeatherValue(member));

  const toggleChecked = () => dispatch(weahterActions.toggleSilentNotice({}));

  return (
    <div>
      <Input
        label={WEATHER_LABEL.LOCATION}
        value={weather.location}
        onChange={(event) => handleChange({ location: event.target.value })}
      />
      <DateInput
        label={WEATHER_LABEL.NOTICE_TIME}
        value={weather.noticeTime}
        idPref={"line_user"}
        onChange={(event) => handleChange({ noticeTime: event.target.value })}
      />
      <Switch
        label={WEATHER_LABEL.SILENT_NOTICE}
        checked={weather.silentNotice}
        onChange={toggleChecked}
      />
      <Button
        submitText={"変更する"}
        // onClick={handleSave}
      />
    </div>
  );
};
