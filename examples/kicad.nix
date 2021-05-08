/*
 
  may 8 2021. 
  [nix-shell:~]$ nix-build -E 'with import <nixpkgs> {}; callPackage ./kicad.nix {}' 
  /nix/store/r2bsw9xr0wnm6qj0fdx249hq7shibb7b-kicad-5.1.10
  
  But see official update here,
  https://github.com/NixOS/nixpkgs/pull/119986

*/

{ wxGTK, lib, stdenv, fetchurl, fetchFromGitHub, cmake, libGLU, libGL, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp
, wrapGAppsHook
, oceSupport ? true, opencascade
, ngspiceSupport ? true, libngspice
, swig, python, pythonPackages
, lndir
, wxGTK30 
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let
  mkLib = version: name: sha256: attrs: stdenv.mkDerivation ({
    name = "kicad-${name}-${version}";
    src = fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-${name}";
      rev = version;
      inherit sha256 name;
    };
    nativeBuildInputs = [
      cmake
    ];
  } // attrs);

in stdenv.mkDerivation rec {
  pname = "kicad";
  series = "5.0";
  # version = "5.1.4";
  #version = "5.1.9";
  # launchpad doesn't have recent
  version = "5.1.10";

  src = fetchurl {
    #url = "https://launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
    # sha256 = "1r60dgh6aalbpq1wsmpyxkz0nn4ck8ydfdjcrblpl69k5rks5k2j";

    # JA
    url = "https://gitlab.com/kicad/code/kicad/-/archive/5.1.10/kicad-5.1.10.tar.gz";
    sha256 = "1vcmjv8q1wkkizq4nzaj94rsjdaq8amhwwjl3i57yb6s1brl2qr9";
  };

  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace no-vcs-found ${version}
  '';

  cmakeFlags = [
    "-DKICAD_SCRIPTING=ON"
    "-DKICAD_SCRIPTING_MODULES=ON"
    "-DKICAD_SCRIPTING_WXPYTHON=ON"
    # nix installs wxPython headers in wxPython package, not in wxwidget
    # as assumed. We explicitely set the header location.
    "-DCMAKE_CXX_FLAGS=-I${pythonPackages.wxPython}/include/wx-3.0"
    "-DwxPYTHON_INCLUDE_DIRS=${pythonPackages.wxPython}/include/wx-3.0"
  ] ++ optionals (oceSupport) [ "-DKICAD_USE_OCE=ON" "-DOCE_DIR=${opencascade}" ]
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON";

  nativeBuildInputs = [
    cmake
    doxygen
    pkgconfig
    wrapGAppsHook
    pythonPackages.wrapPython
    lndir
  ];
  pythonPath = [ pythonPackages.wxPython ];
  propagatedBuildInputs = [ pythonPackages.wxPython ];

  buildInputs = [
    # libGLU libGL zlib libX11   wxGTK pcre libXdmcp glew glm libpthreadstubs
    libGLU libGL zlib libX11   wxGTK30 pcre libXdmcp glew glm libpthreadstubs
    cairo curl openssl boost
    swig (python.withPackages (ps: with ps; [ wxPython ]))
  ] ++ optional (oceSupport) opencascade
    ++ optional (ngspiceSupport) libngspice;

  # this breaks other applications in kicad
  # JA.
  #dontWrapGApps = true;

  passthru = {
    i18n = mkLib version "i18n" "1dk7wis4cncmihl8fnic3jyhqcdzpifchzsp7hmf214h0vp199zr" {
      buildInputs = [
        gettext
      ];
      meta.license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
    };
    symbols = mkLib version "symbols" "1lna4xlvzrxif3569pkp6mrg7fj62z3a3ri5j97lnmnnzhiddnh3" {
      meta.license = licenses.cc-by-sa-40;
    };
    footprints = mkLib version "footprints" "0c0kcywxlaihzzwp9bi0dsr2v9j46zcdr85xmfpivmrk19apss6a" {
      meta.license = licenses.cc-by-sa-40;
    };
    templates = mkLib version "templates" "1bagb0b94cjh7zp9z0h23b60j45kwxbsbb7b2bdk98dmph8lmzbb" {
      meta.license = licenses.cc-by-sa-40;
      buildInputs = [
        # JA
        wrapGAppsHook
      ];
    };
    packages3d = mkLib version "packages3d" "0h2qjj8vf33jz6jhqdz90c80h5i1ydgfqnns7rn0fqphlnscb45g" {
      hydraPlatforms = []; # this is a ~1 GiB download, occupies ~5 GiB in store
      meta.license = licenses.cc-by-sa-40;
    };
  };

  modules = with passthru; [ i18n symbols footprints templates ];

  postInstall = ''
    mkdir -p $out/share
    for module in $modules; do
      lndir $module/share $out/share
    done
  '';

/*
/nix/store/ncrfkrcsrfg8n0ggvvdhy4m6cnrw2l2w-kicad-templates-5.1.10/share/kicad/template/ti-stellaris-boosterpack40_min/meta:
glibPreFixupPhase
post-installation fixup
/nix/store/qghrkvk86f9llfkcr1bxsypqbw1a4qmw-stdenv-linux/setup: line 100: wrapGApp: command not found
builder for '/nix/store/il85a5rh5w7d85dk16x1s1fvan58mklz-kicad-5.1.10.drv' failed with exit code 127
error: build of '/nix/store/il85a5rh5w7d85dk16x1s1fvan58mklz-kicad-5.1.10.drv' failed


    wrapGApp "$out/bin/kicad" --prefix LD_LIBRARY_PATH : "${libngspice}/lib"

, wrapGAppsHook

*/
  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--set PYTHONPATH "$program_PYTHONPATH")

    # JA
    # wrapGApp "$out/bin/kicad" --prefix LD_LIBRARY_PATH : "${libngspice}/lib"
  '';

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://www.kicad-pcb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
    broken = stdenv.isAarch64;
  };
}
