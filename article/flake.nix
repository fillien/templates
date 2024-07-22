{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        name = "research-paper";
        packages = with pkgs; [
          (texlive.combine { inherit (texlive) scheme-full pgfplots; })
        ];
      };
      packages.default = pkgs.stdenv.mkDerivation {
        name = "research-paper";
        buildInputs = with pkgs; [
          (texlive.combine { inherit (texlive) scheme-full pgfplots; })
        ];
        buildPhase = ''
          	    pdflatex article
          	    bibtex article
          	    pdflatex article
          	    pdflatex article
          	'';
        installPhase = ''
          	    mkdir -p $out
          	    cp article.pdf $out/
          	'';
        src = ./.;
      };
    });
}
