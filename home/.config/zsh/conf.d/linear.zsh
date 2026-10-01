# Linear API key retrieval.
#
# This file is in the PUBLIC dotfiles repo. It holds the lookup only;
# never paste a key in here.
#
# The key itself is never stored here, only the lookup. macOS keeps it in the
# login keychain, Linux in a GPG-encrypted file, because secret-tool wants
# D-Bus and an unlocked collection that a headless box does not have.
#
# Store it:
#   macOS   security add-generic-password -U -a "$USER" -s LINEAR_API_KEY -w
#           (-w last, with no value, so it prompts instead of landing in argv)
#   Linux   pass insert linear/api-key
#
# Deliberately not exported. An `export` would put the key in the environment
# of every process this user runs for the life of the shell, readable via
# /proc/<pid>/environ, which gives up the exposure the keychain was for. Fetch
# it per command instead:
#
#   LINEAR_API_KEY="$(linear-key)" ws new <linear-url> --repo <repo>
linear-key() {
  case "$(uname -s)" in
    Darwin)
      security find-generic-password -s LINEAR_API_KEY -w
      ;;
    Linux)
      # First line only: `pass show` prints the whole file, and the convention
      # is secret on line 1 with any notes below it.
      pass show linear/api-key | head -1
      ;;
    *)
      print -u2 "linear-key: no keychain backend for $(uname -s)"
      return 1
      ;;
  esac
}
