export const AMPLIFY_FORM = {
  SIGN_UP: [
    {
      type: "email",
      label: "メールアドレス",
      placeholder: "メールアドレスを入力して下さい",
      required: true,
    },
    {
      type: "password",
      label: "パスワード",
      placeholder: "パスワードを入力して下さい",
      required: true,
    },
  ],
  SIGN_IN: [
    {
      type: "email",
      label: "メールアドレス",
      placeholder: "メールアドレスを入力して下さい",
      required: true,
    },
    {
      type: "password",
      label: "パスワード",
      placeholder: "パスワードを入力して下さい",
      required: true,
    },
  ],
};

export const AMPLIFY_CONFIGURE = {
  Auth: {
    region: process.env.REACT_APP_AMPLIFY_REGION,
    userPoolId: process.env.REACT_APP_AMPLIFY_USER_POOL_ID,
    userPoolWebClientId: process.env.REACT_APP_AMPLIFY_WEB_CLIENT_ID,
    identityPoolId: process.env.REACT_APP_AMPLIFY_IDENTITY_POOL_ID,
    authenticationFlowType: "USER_PASSWORD_AUTH",
    // oauth: {
    //   domain: process.env.REACT_APP_AMPLIFY_DOMAIN,
    //   redirectSignIn: "https://localhost:3000/user",
    //   redirectSignOut: "https://localhost:3000/",
    //   scope: [
    //     "phone",
    //     "email",
    //     "profile",
    //     "openid",
    //     "aws.cognito.signin.user.admin",
    //   ],
    //   responseType: "code", // or 'token', note that REFRESH token will only be generated when the responseType is code
    // },
  },
};

export const AMPLIFY_DICT = {
  ja: {
    "Back to Sign In": "サインイン画面に戻る",
    Confirm: "確認",
    "Confirm Sign Up": "サインアップの確認",
    "Confirmation Code": "確認コード",
    "Create Account": "新規登録",
    "Create a new account": "アカウントの新規登録",
    "Create account": "新規登録",
    Email: "メールアドレス",
    "Email Address": "メールアドレス",
    "Enter your code": "確認コードを入力してください",
    "Enter your password": "パスワードを入力してください",
    "Enter your username": "ユーザー名を入力してください",
    "Enter your email address": "メールアドレスを入力してください",
    "Forget your password? ": "パスワードをお忘れの方 ",
    "Have an account? ": "アカウント登録済みの方 ",
    Hello: "こんにちは ",
    "Incorrect username or password": "ユーザー名またはパスワードが異なります",
    "Lost your code? ": "コードを紛失した方 ",
    "No account? ": "アカウント未登録の方 ",
    Password: "パスワード",
    "Phone Number": "電話番号",
    "Resend Code": "確認コードの再送",
    "Reset password": "パスワードのリセット",
    "Reset your password": "パスワードのリセット",
    "Send Code": "コードの送信",
    "Sign In": "サインイン",
    "Sign Out": "サインアウト",
    "Sign in": "サインイン",
    "Sign in to your account": "サインイン",
    "User does not exist": "ユーザーが存在しません",
    Username: "ユーザー名",
    "Username cannot be empty": "ユーザー名は必須入力です",
    "Username/client id combination not found.": "ユーザー名が見つかりません",
  },
};
