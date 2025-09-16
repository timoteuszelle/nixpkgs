{ lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  extra-cmake-modules,
  qt6Packages,
  sqlite,
  zlib,
  libsecret,
  libre-graph-api-cpp-qt-client,
  kdsingleapplication,
}:

stdenv.mkDerivation rec {
  pname = "stack-client";
  # Derived from the upstream redirect of stack-source-latest
  version = "5.3.1-20240731";

  src = fetchurl {
    url = "https://filehosting-client.transip.nl/packages/stack/v${version}/source/stack-v${version}.tar.gz";
    hash = "sha256-rGlpntsWGO8JTktkL+csh78V5lAmApSGvvUIJqdG4Zw=";
  };

  # The archive contains a top-level "client/" directory
  sourceRoot = "client";

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtsvg # systray icon
    qt6Packages.qtkeychain
    sqlite
    zlib
    libsecret
    libre-graph-api-cpp-qt-client
    kdsingleapplication
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DWITH_AUTO_UPDATER=OFF"
    "-DWITH_APPIMAGEUPDATER=OFF"
    "-DCMAKE_PREFIX_PATH=${extra-cmake-modules}"
  ];

  meta = with lib; {
    description = "TransIP STACK desktop client (ownCloud-based)";
    homepage = "https://www.transip.nl/stack/";
    changelog = "https://www.transip.nl/knowledgebase/artikel/5558-changelog-van-de-desktopapplicatie/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timoteuszelle ];
    platforms = platforms.linux;
    mainProgram = "stack";
  };
}
