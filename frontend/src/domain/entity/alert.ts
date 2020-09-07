export type AlertState = {
  isLoading: boolean;
  severity: "error" | "warning" | "info" | "success";
  messages: string[];
  open: boolean;
};
