/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import {
  AmplifyAuthenticator,
  AmplifySignUp,
  AmplifySignIn,
} from "@aws-amplify/ui-react";

import UserEditor from "./UserEditor";
import UserEmailDialog from "./UserEmailDialog";
import LineUserRelator from "./LineUserRelator";
import WeatherEditor from "./WeatherEditor";

import Button from "@/atoms/Button";
import Layout from "@/organisms/Layout";
import Heading from "@/organisms/Heading";
import ItemHeading from "@/organisms/ItemHeading";

import { AMPLIFY_FORM } from "constants/amplify";

import { UserProps } from "types/components/pages";

const User: FC<UserProps> = ({
  user,
  lineUser,
  weather,
  onUserChange,
  onLineUserChange,
  onWeatherChange,

  // UserEditor
  onMouseDownPasswod,
  onOldPasswordIconClick,
  onNewPasswordIconClick,
  onChangeEmailClick,
  onChangePasswordClick,

  // UserEmailDialog
  userEmailDialogOpen,
  onUserEmailDialogClose,
  onUserEmailDialogNoClick,
  onUserEmailDialogYesClick,

  // LineUserRelator
  onReleaseUserClick,
  onRelateUserClick,

  // WeatherEditor
  onSilentNoticeChange,
  onWeatherEditorClick,

  // TestUserLogIn
  signedIn,
  onTestLoginClick,
}) => {
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

        {/* Contnet for User Sgined In */}
        <section>
          <Heading>Profile Edit</Heading>
          <div
            css={{
              width: '80%',
              maxWidth: 400,
              margin: "40px auto 0 auto",
            }}
          >
            <section>
              <ItemHeading itemName={"ユーザー"} />
              <UserEditor
                user={user}
                onUserChange={onUserChange}
                onChangeEmailClick={onChangeEmailClick}
                onMouseDownPasswod={onMouseDownPasswod}
                onOldPasswordIconClick={onOldPasswordIconClick}
                onNewPasswordIconClick={onNewPasswordIconClick}
                onChangePasswordClick={onChangePasswordClick}
              />
            </section>

            <section>
              <ItemHeading itemName={"LINE アカウント"} />
              <LineUserRelator
                lineUser={lineUser}
                onLineUserChange={onLineUserChange}
                onReleaseUserClick={onReleaseUserClick}
                onRelateUserClick={onRelateUserClick}
              />
            </section>

            <section>
              <ItemHeading itemName={"天気予報"} />
              <WeatherEditor
                lineUser={lineUser}
                weather={weather}
                onLineUserChange={onLineUserChange}
                onWeatherChange={onWeatherChange}
                onSilentNoticeChange={onSilentNoticeChange}
                onWeatherEditorClick={onWeatherEditorClick}
              />
            </section>
          </div>
        </section>
        <UserEmailDialog
          userEmail={user.email}
          userEmailDialogOpen={userEmailDialogOpen}
          onUserEmailDialogClose={onUserEmailDialogClose}
          onUserEmailDialogNoClick={onUserEmailDialogNoClick}
          onUserEmailDialogYesClick={onUserEmailDialogYesClick}
        />
      </AmplifyAuthenticator>

      <div
        css={{
          margin: "20px auto 0 auto",
          maxWidth: 460,
          display: signedIn ? "none" : "block",
        }}
      >
        <Button
          submitText={"テストユーザーとしてログインする"}
          onClick={onTestLoginClick}
          contained
        />
      </div>
    </Layout>
  );
};

export default User;
