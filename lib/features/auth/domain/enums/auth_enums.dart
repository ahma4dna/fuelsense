enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  passwordResetSent,
  passwordRecoveryMode,
  passwordUpdated,
  error,
}

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}
