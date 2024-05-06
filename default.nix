{ nixpkgs ? import ./nixpkgs.nix
, pkgs ? import nixpkgs {}
, version ? "dev"
}:

pkgs.buildGoModule rec {
  name = "morph-unstable-${version}";
  inherit version;

  nativeBuildInputs = with pkgs; [ go-bindata ];

  src = pkgs.nix-gitignore.gitignoreSource [] ./.;

  ldflags = [
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-KV+djwUYNfD7NqmYkanRVeKj2lAGfMjJhCUSRiC4/yM=";

  postPatch = ''
    go-bindata -pkg assets -o assets/assets.go data/
  '';

  postInstall = ''
    mkdir -p $lib
    cp -v ./data/*.nix $lib
  '';

  outputs = [ "out" "lib" ];

  meta = {
    homepage = "https://github.com/DBCDK/morph";
    description = "Morph is a NixOS host manager written in Golang.";
  };
}
