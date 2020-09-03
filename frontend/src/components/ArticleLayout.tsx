/** @jsx jsx */
import { FC, ReactNode } from "react";
import { jsx } from "@emotion/core";

type Props = {
  children: ReactNode;
};

const Dialog: FC<Props> = ({ children }) => {
  return (
    <div
      css={{
        width: "80%",
        margin: "40px auto 0 auto",
        h3: { marginTop: 40 },
        p: { marginTop: 20 },
        ol: { margin: "20px 0 0 50px", listStylePosition: "outside" },
        ul: { margin: "20px 0 0 50px", listStylePosition: "outside" },
      }}
    >
      {children}
    </div>
  );
};

export default Dialog;
