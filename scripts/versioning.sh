#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2022 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function application_build_versioned_components()
{
  XBB_TEXINFO_VERSION="$(xbb_strip_version_pre_release "${XBB_RELEASE_VERSION}")"

  # Keep them in sync with the combo archive content.
  if [[ "${XBB_RELEASE_VERSION}" =~ 7[.]0[.].*-.* ]]
  then
    # -------------------------------------------------------------------------
    # Build the native dependencies.

    # None

    # -------------------------------------------------------------------------
    # Build the target dependencies.

    xbb_reset_env
    # Before set target (to possibly update CC & co variables).
    # xbb_activate_installed_bin

    xbb_set_target "requested"

    # https://ftp.gnu.org/pub/gnu/libiconv/
    libiconv_build "1.17"

    XBB_NCURSES_DISABLE_WIDEC="y"
    # https://ftp.gnu.org/gnu/ncurses/
    ncurses_build "6.4"

    # -------------------------------------------------------------------------
    # Build the application binaries.

    xbb_set_executables_install_path "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"
    # Note: libraries are also published.
    xbb_set_libraries_install_path "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"
    tests_add "xbb_set_libraries_install_path" "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"

    (
      xbb_activate_installed_bin

      # https://github.com/westes/texinfo/releases
      texinfo_build "${XBB_TEXINFO_VERSION}"
    )

    # -------------------------------------------------------------------------
  else
    echo "Unsupported ${XBB_APPLICATION_LOWER_CASE_NAME} version ${XBB_RELEASE_VERSION}"
    exit 1
  fi
}

# -----------------------------------------------------------------------------
