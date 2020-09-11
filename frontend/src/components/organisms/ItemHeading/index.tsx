/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { ItemHeadingProps } from "types/itemHeading";

const ItemHeading: FC<ItemHeadingProps> = ({ itemName }) => {
  return (
    <h2
      css={{ margin: "32px 0 8px 0", color: "#30475e", fontWeight: "lighter" }}
    >
      {itemName}
    </h2>
  );
};

export default ItemHeading;
