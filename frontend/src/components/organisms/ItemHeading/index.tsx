/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { Typography } from "@material-ui/core";

type Props = {
  itemName: string;
};

const ItemHeading: FC<Props> = ({ itemName }: Props) => {
  return (
    <Typography
      style={{ margin: "32px 0 8px 0" }}
      variant="h4"
      component="h2"
      color="primary"
    >
      {itemName}
    </Typography>
  );
};

export default ItemHeading;
