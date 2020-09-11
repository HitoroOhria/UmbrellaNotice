/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { Paper as FPaper } from "@material-ui/core";

import { PaperProps } from "types/components/organisms";

const Paper: FC<PaperProps> = ({ children }) => {
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
