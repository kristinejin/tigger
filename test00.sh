PATH="$PATH:$(pwd)"

# Create testing directory
tempDir="$(mktemp -d)"
cd "$tempDir" || exit 1


