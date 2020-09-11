/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { Tooltip, IconButton } from "@material-ui/core";
import { Info } from "@material-ui/icons";

import { InformationProps } from "types/components/atoms";

const Information: FC<InformationProps> = ({ text }) => {
  return (
    <Tooltip css={{ maxWidth: 300 }} title={text} placement="right">
      <IconButton aria-label="information">
        <Info style={{ color: "#000" }} fontSize="small" />
      </IconButton>
    </Tooltip>
  );
};

export default Information;
