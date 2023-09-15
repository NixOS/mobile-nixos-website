let
  # "Nixpkgs-free" fetchFromGitHub... we use that repo's pin on nixpkgs instead.
  # This is expected to be run in a CI/CD context.
  gh = {branch, repo, owner}:
    builtins.fetchTarball "https://github.com/${owner}/${repo}/archive/${branch}.tar.gz"
  ;
  mobile-nixos = gh {
    branch = "development";
    owner = "NixOS";
    repo = "mobile-nixos";
  };
  pkgs = import "${mobile-nixos}/pkgs.nix" { };
  site = import "${mobile-nixos}/doc" { inherit pkgs; };
  inherit (pkgs.lib) optionalString;

  inherit (pkgs) rsync;

  CNAME = "mobile.nixos.org";
in

  # Here we patch over the docs to insert the website contents.
  site.overrideAttrs(old: {
    buildInputs = old.buildInputs ++ [
      rsync
    ];

    postPatch = ''
      echo " :: Adding the website data to the docs source."
      rsync --recursive --verbose ${./.}/website/ ./
    '';

    postFixup = optionalString (CNAME != null) ''
      echo '${CNAME}' >> $out/CNAME
    '';
  })
