/** @jsx jsx */
import { FC, ReactNode } from "react";
import { jsx } from "@emotion/core";

type Props = {
  children: ReactNode;
};

const Heading: FC<Props> = ({ children }) => {
  return (
    <h1 css={{ fontWeight: "lighter", textAlign: "center" }}>
      <span css={{ paddingBottom: 10, borderBottom: "2px solid #7e8a97" }}>
        {children}
      </span>
    </h1>
  );
};

export default Heading;
