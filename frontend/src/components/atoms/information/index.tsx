/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { Tooltip, IconButton } from "@material-ui/core";
import { Info } from "@material-ui/icons";

type Props = {
  text: string;
};

const Information: FC<Props> = ({ text }) => {
  return (
    <Tooltip css={{ maxWidth: 300 }} title={text} placement="right">
      <IconButton aria-label="information">
        <Info style={{ color: "#000" }} fontSize="small" />
      </IconButton>
    </Tooltip>
  );
};

export default Information;
