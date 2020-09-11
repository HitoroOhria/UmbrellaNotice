type Severity = "error" | "warning" | "info" | "success";

export type AlertState = {
  isLoading: boolean;
  severity: Severity;
  messages: string[];
  open: boolean;
};

export type AlertProps = {
  alert: AlertState
  onClose: () => void;
};
