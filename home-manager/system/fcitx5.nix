# Fcitx5 Vietnamese Input Method (Lotus Engine) Module
{
  config,
  lib,
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        pkgs.fcitx5-lotus
        pkgs.fcitx5-gtk
        pkgs.qt6Packages.fcitx5-configtool
      ];
      settings = {
        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = "True";
            ModifierOnlyKeyTimeout = 250;
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
          };
          "Hotkey/AltTriggerKeys" = {
            "0" = "";
          };
          "Hotkey/EnumerateForwardKeys" = {
            "0" = "";
          };
          "Hotkey/EnumerateBackwardKeys" = {
            "0" = "";
          };
          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "";
          };
          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "";
          };
          "Hotkey/PrevPage" = {
            "0" = "Up";
          };
          "Hotkey/NextPage" = {
            "0" = "Down";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };
          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };
          Behavior = {
            ActiveByDefault = "False";
            resetStateWhenFocusIn = "No";
            ShareInputState = "No";
            PreeditEnabledByDefault = "True";
            ShowInputMethodInformation = "True";
            showInputMethodInformationWhenFocusIn = "False";
            CompactInputMethodInformation = "True";
            ShowFirstInputMethodInformation = "True";
            DefaultPageSize = 5;
            OverrideXkbOption = "False";
            PreloadInputMethod = "True";
            AllowInputMethodForPassword = "False";
            ShowPreeditForPassword = "False";
            AutoSavePeriod = 30;
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "lotus";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
          };
          "Groups/0/Items/1" = {
            Name = "lotus";
          };
          GroupOrder = {
            "0" = "Default";
          };
        };
        addons = {
          lotus = {
            globalSection = {
              Mode = "Preedit";
              InputMethod = "Telex";
              OutputCharset = "Unicode";
              CycleModeKey = "";
              W2U = "Non-Start";
              BracketTransform = "Non-Start";
              SpellCheck = "True";
              EnableMacro = "True";
              CapitalizeMacro = "True";
              MacroSkipTriggerModifier = "Disabled";
              AutoCapitalizeAfterPunctuation = "False";
              DoubleSpaceToPeriod = "False";
              DoubleHyphenToEmDash = "False";
              AutoNonVnRestore = "True";
              ModernStyle = "True";
              FreeMarking = "True";
              DdFreeStyle = "True";
              FixUinputWithAck = "False";
              UseLotusIcons = "True";
              EnableDictionary = "False";
              EnableCustomKeymap = "False";
              ShowModeSmooth = "True";
              ShortcutSmooth = "1";
              ShowModeUinput = "True";
              ShortcutUinput = "2";
              ShowModeSuperSmooth = "True";
              ShortcutSuperSmooth = "a";
              ShowModeMinecraft = "True";
              ShortcutMinecraft = "3";
              ShowModeSelect = "True";
              ShortcutSelect = "5";
              ShowModeSurroundingText = "True";
              ShortcutSurroundingText = "4";
              ShowModePreedit = "True";
              ShortcutPreedit = "q";
              ShowModeEmoji = "True";
              ShortcutEmoji = "w";
              ShowModeOff = "True";
              ShortcutOff = "e";
              ShowModeDefault = "True";
              ShortcutDefault = "r";
              EnableMacroInOffMode = "False";
              ModeOrder = "Smooth,Uinput,Minecraft,Select,SurroundingText,Preedit,Emoji,Off,SuperSmooth,Default";
              TimeFormat = "%H:%M";
              DateFormat = "%d/%m/%Y";
              IconTheme = "Dark";
            };
            sections = {
              ModeMenuKey = {
                "0" = "grave";
              };
            };
          };
        };
      };
    };
  };

  # Quy tắc chế độ gõ riêng theo từng ứng dụng (Lotus App Rules)
  # Mode ID:
  # 5 = Preedit (ổn định, dùng cho app có hỗ trợ IME)
  # 4 = Surrounding Text (không ổn định trên nhiều app)
  # 3 = Super Smooth / Uinput (chỉ dùng cho app không nhận IME, vd. game)
  #
  # LƯU Ý: module i18n.inputMethod.fcitx5 của home-manager link CẢ thư mục
  # ~/.config/fcitx5 vào một linkFarm trong /nix/store. Vì vậy KHÔNG thể dùng
  # xdg.configFile."fcitx5/<file>" (builder sẽ báo "outside $HOME").
  # Cách xử lý: tự dựng lại đúng linkFarm đó rồi gộp thêm file rules vào.
  xdg.configFile."fcitx5" = lib.mkForce {
    source =
      let
        im = config.i18n.inputMethod.fcitx5;
        iniFormat = pkgs.formats.ini { };
        iniGlobalFormat = pkgs.formats.iniWithGlobalSection { };
        normalizeFcitx5Value =
          value:
          if lib.isAttrs value then
            lib.mapAttrs (_: normalizeFcitx5Value) value
          else if builtins.isList value then
            map normalizeFcitx5Value value
          else if builtins.isBool value then
            (if value then "True" else "False")
          else
            value;
        optionalFile =
          p: f: v:
          lib.optionalAttrs (v != { }) {
            ${p} = f "fcitx5-${builtins.replaceStrings [ "/" ] [ "-" ] p}" v;
          };
        entries = lib.attrsets.mergeAttrsList [
          (optionalFile "config" iniFormat.generate (normalizeFcitx5Value im.settings.globalOptions))
          (optionalFile "profile" iniFormat.generate (normalizeFcitx5Value im.settings.inputMethod))
          (lib.concatMapAttrs (
            name: value:
            optionalFile "conf/${name}.conf" iniGlobalFormat.generate (normalizeFcitx5Value value)
          ) im.settings.addons)
        ];
      in
      pkgs.linkFarm "fcitx-config" (entries // {
        # lotus 5.x đọc rules tại $XDG_CONFIG_HOME/fcitx5/conf/lotus-app-rules.conf
        "conf/lotus-app-rules.conf" = pkgs.writeText "fcitx5-lotus-app-rules.conf" ''
          # App thuần Linux (Qt / GTK) -> Preedit (5)
          pcmanfm-qt=5
          lxqt-archiver=5
          telegram-desktop=5
          org.telegram.desktop=5
          zathura=5
          pavucontrol=5
          fcitx5-config-qt=5

          # App nền Web / Chromium / Electron -> Preedit (5)
          chromium=5
          google-chrome=5
          brave-browser=5
          obsidian=5
          postman=5
          vesktop=5
          discord=5
          bilibili=5

          # Terminal / IDE / Office -> Preedit (5)
          wezterm=5
          org.wezfurlong.wezterm=5
          kitty=5
          alacritty=5
          foot=5
          code=5
          code-url-handler=5
          libreoffice=5
          soffice.bin=5
          wps=5
          wpp=5
          et=5

          # Game / app không nhận IME -> Super Smooth Uinput (3)
          steam=3
          steamwebhelper=3
        '';
      });
  };
}
