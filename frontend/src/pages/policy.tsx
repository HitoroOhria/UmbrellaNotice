/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Policy from "@/pages/Policy";

import { makeDisplayArticle } from "../services/agreement";

const PolicyPage: FC = () => {
  const displayArticle = makeDisplayArticle();

  return <Policy displayArticle={displayArticle} />;
};

export default PolicyPage;
