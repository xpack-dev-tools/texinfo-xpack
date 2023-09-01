#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Safety settings (see https://gist.github.com/ilg-ul/383869cbb01f61a51c4d).

if [[ ! -z ${DEBUG} ]]
then
  set ${DEBUG} # Activate the expand mode if DEBUG is anything but empty.
else
  DEBUG=""
fi

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# -----------------------------------------------------------------------------
# Identify the script location, to reach, for example, the helper scripts.

script_path="$0"
if [[ "${script_path}" != /* ]]
then
  # Make relative path absolute.
  script_path="$(pwd)/$0"
fi

script_name="$(basename "${script_path}")"

script_folder_path="$(dirname "${script_path}")"
script_folder_name="$(basename "${script_folder_path}")"

# =============================================================================

if [ $# -lt 1 ]
then
  echo "usage: bash ${script_name} file [file...]"
  exit 1
fi

initial_path=""

for f in "$@"
do
  if grep -e 'my $datadir = .*/application/share' "${f}" >/dev/null
  then
    initial_path="$(grep -e 'my $datadir = .*/application/share' "${f}" | sed -e "s|.*my \$datadir = [']\(.*\)/share['].*|\1|")"
    break
  fi
done

if [ -z "${initial_path}" ]
then
  echo 'error: "my $datadir = .../application/share" not found'
  exit 1
fi

actual_path="$(pwd)/.content"

echo "changing ${initial_path} -> ${actual_path}"
for f in "$@"
do
  sed -i.bak -e "s|${initial_path}|${actual_path}|g" "${f}"
done

exit 0

# -----------------------------------------------------------------------------

