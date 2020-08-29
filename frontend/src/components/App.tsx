/** @jsx jsx */
import React, { FC } from "react";
import { Switch, Route } from "react-router-dom";
import { jsx } from "@emotion/core";

import { URL_PATH } from "../domain/services/url";

import Alert from "./Alert";
import Header from "./Header";
import MenuDrawer from "./MenuDrawer";
import Footer from "./Footer";
import Home from "./Home";
import Terms from "./Terms";
import Policy from "./Policy";
import User from "./User";

const App: FC = () => {
  return (
    <div
      css={{
        p: { lineHeight: 1.7 },
        li: { lineHeight: 1.7 },
        h1: {
          fontWeight: "lighter",
          span: { paddingBottom: 10, borderBottom: "2px solid #ccc" },
        },
      }}
    >
      <Alert />
      <Header />
      <MenuDrawer />
      <Switch>
        <Route path={URL_PATH.USER}>
          <User />
        </Route>
        <Route path={URL_PATH.TERMS}>
          <Terms />
        </Route>
        <Route path={URL_PATH.POLICY}>
          <Policy />
        </Route>
        <Route path="/">
          <Home />
        </Route>
      </Switch>
      <Footer />
    </div>
  );
};

export default App;
