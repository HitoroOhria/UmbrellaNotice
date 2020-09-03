/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { Button as FButton } from "@material-ui/core";

type Props = {
  submitText: string;
  onClick?: () => any;
  contained?: boolean;
};

const Button: FC<Props> = ({ submitText, onClick, contained }) => {
  return (
    <div css={{ textAlign: "center" }}>
      <FButton
        style={{ width: "70%", margin: "32px auto" }}
        onClick={onClick}
        variant={contained ? "contained" : "outlined"}
        color="primary"
      >
        {submitText}
      </FButton>
    </div>
  );
};

export default Button;
