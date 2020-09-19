export const BREAKPOINTS = [550];

export const MEDIA_QUERIES = BREAKPOINTS.map(
  (breakpoints) => `@media screen and (min-width: ${breakpoints}px)`
);
