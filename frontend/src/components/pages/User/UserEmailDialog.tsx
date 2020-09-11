/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Dialog from "@/organisms/Dialog";

import { UserEmailDialogProps } from "types/components/pages";

const UserEmailDialog: FC<UserEmailDialogProps> = ({
  userEmail,
  userEmailDialogOpen,
  onUserEmailDialogClose,
  onUserEmailDialogNoClick,
  onUserEmailDialogYesClick,
}) => {
  return (
    <Dialog
      open={userEmailDialogOpen}
      title={"メールアドレスの変更"}
      onClose={onUserEmailDialogClose}
      onNoClick={onUserEmailDialogNoClick}
      onYesClick={onUserEmailDialogYesClick}
    >
      <p>次回のサインイン時にメールアドレスの承認が必要になります。</p>
      <p>打ち間違いがないかご確認下さい。</p>
      <div css={{ marginTop: 30, textAlign: "center" }}>
        <span css={{ borderBottom: "1px solid #ccc" }}>
          メールアドレス: {userEmail}
        </span>
      </div>
    </Dialog>
  );
};

export default UserEmailDialog;
