/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Button from "@/atoms/Button";
import Input from "@/organisms/Input";
import Paper from "@/organisms/Paper";

import { INFO_TEXT } from "constants/information";

import { LineUserRelatorProps } from "types/user";

const LineUserRelator: FC<LineUserRelatorProps> = ({
  lineUser,
  onLineUserChange,
  onReleaseUserClick,
  onRelateUserClick,
}) => {
  return lineUser.relatedUser ? (
    <div css={{ marginTop: 20 }}>
      <Paper>
        <p>LINEアカウントと連携済みです！</p>
      </Paper>
      <Button submitText={"連携を解除する"} onClick={onReleaseUserClick} />
    </div>
  ) : (
    <div>
      <Input
        label={"シリアル番号"}
        value={lineUser.serialNumber}
        onChange={(event) =>
          onLineUserChange({ serialNumber: event.target.value })
        }
        info
        text={INFO_TEXT.SERIAL_NUMBER}
      />
      <Button submitText={"連携する"} onClick={onRelateUserClick} />
    </div>
  );
};

export default LineUserRelator;
