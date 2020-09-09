/** @jsx jsx */
import { FC, ReactNode } from "react";
import { jsx } from "@emotion/core";

import { Paper as FPaper } from "@material-ui/core";

type Props = {
  children: ReactNode;
};

const Paper: FC<Props> = ({ children }) => {
  return (
    <FPaper elevation={3}>
      <div
        css={{
          backgroundColor: "#e0dede",
          textAlign: "center",
          padding: "30px 30px",
        }}
      >
        {children}
      </div>
    </FPaper>
  );
};

export default Paper;
