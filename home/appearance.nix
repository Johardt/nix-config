{
  pkgs,
  apple-fonts,
  hatter,
  ...
}:

let
  desktop = import ../shared/desktop.nix;
  hatter-icon-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "hatter-icon-theme";
    version = "unstable-${hatter.shortRev}";
    src = hatter;
    dontBuild = true;
    propagatedBuildInputs = [ pkgs.adwaita-icon-theme ];
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons"
      cp -a Hatter "$out/share/icons/"
      runHook postInstall
    '';
    meta = {
      description = "Rounded square icon theme preserving application identities";
      homepage = "https://github.com/Mibea/Hatter";
      license = pkgs.lib.licenses.gpl3Only;
      platforms = pkgs.lib.platforms.linux;
    };
  };
in
{
  home.packages =
    (with pkgs; [
      geist-font
      inter
      nerd-fonts.adwaita-mono
      nerd-fonts.geist-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ])
    ++ [ apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro ];

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = desktop.cursor.theme;
    size = desktop.cursor.size;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Hatter";
      package = hatter-icon-theme;
    };
  };

  # Noctalia checks GSettings before the GTK settings files.
  dconf.settings."org/gnome/desktop/interface".icon-theme = "Hatter";
}
