export const makeDisplayArticle = () => {
  let article: number = 0;
  return () => {
    article++;
    return `第${article}条`;
  };
};
