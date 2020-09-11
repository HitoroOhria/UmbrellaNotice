/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { HeadingProps } from "types/components/organisms";

const Heading: FC<HeadingProps> = ({ children }) => {
  return (
    <h1 css={{ fontWeight: "lighter", textAlign: "center" }}>
      <span css={{ paddingBottom: 10, borderBottom: "2px solid #7e8a97" }}>
        {children}
      </span>
    </h1>
  );
};

export default Heading;
