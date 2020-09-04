import { FC, ReactNode } from "react";
import Head from "next/head";

import Header from "./Header";
import HeaderOffset from "../components/HeaderOffset";
import Footer from "./Footer";
import MenuDrawer from "./MenuDrawer";
import Alert from "./Alert";

type Props = {
  children?: ReactNode;
  title?: string;
  unHeaderOffset?: boolean;
};

const createTitle = (title_prefix: string | undefined) =>
  title_prefix ? `${title_prefix} - Umbrella Notice` : "Umbrella Notice";

const Layout: FC<Props> = ({ children, title, unHeaderOffset }) => (
  <div>
    <Head>
      <title>{createTitle(title)}</title>

      <meta charSet="utf-8" />
      <meta name="viewport" content="initial-scale=1.0, width=device-width" />
      <meta
        name="description"
        content="Weather forecast App for remembering your umbrella."
      />

      <link rel="stylesheet" href="https://unpkg.com/ress/dist/ress.min.css" />
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Lemonada:wght@300&family=Noto+Serif+JP&display&display=swap"
      />
    </Head>

    <Header />
    {unHeaderOffset || <HeaderOffset />}
    {children}
    <Footer />
    <MenuDrawer />
    <Alert />
  </div>
);

export default Layout;
