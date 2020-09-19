/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import {mediaQuery} from "services/css"

const HeaderOffset: FC = () => {
  return <div css={mediaQuery({ height: [50, 64] })}></div>;
};

export default HeaderOffset;
