import { FC } from "react";
import Head from "next/head";

import HeaderOffset from "@/organisms/HeaderOffset";

import { createTitle } from "services/layout";

import { LayoutProps } from "types/components/organisms";

const Layout: FC<LayoutProps> = ({ children, title, unHeaderOffset }) => (
  <div>
    <Head>
      <title>{createTitle(title)}</title>

      <meta name="viewport" content="initial-scale=1.0, width=device-width" />
    </Head>

    {unHeaderOffset || <HeaderOffset />}
    {children}
  </div>
);

export default Layout;
