/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Terms from "@/pages/Terms";

import { makeDisplayArticle } from "../services/agreement";

const TermsPages: FC = () => {
  const displayArticle = makeDisplayArticle();

  return <Terms displayArticle={displayArticle} />;
};

export default TermsPages;
