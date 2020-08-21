/** @jsx jsx */
import React, { FC } from "react";
import { jsx } from "@emotion/core";

const Footer: FC = () => {
  return (
    <footer
      css={{
        height: 50,
        marginTop: 50,
        color: "#fff",
        backgroundColor: "#2B2F4A",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <div>
        <small>&copy; 2020 Umbrella Notice</small>
      </div>
    </footer>
  );
};

export default Footer;
