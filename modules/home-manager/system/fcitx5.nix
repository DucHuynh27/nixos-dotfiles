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
              FixUinputWithAck = "True";
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

  xdg.configFile."fcitx5" = lib.mkForce {
    source = let
      im = config.i18n.inputMethod.fcitx5;
      iniFormat = pkgs.formats.ini {};
      iniGlobalFormat = pkgs.formats.iniWithGlobalSection {};
      normalizeFcitx5Value = value:
        if lib.isAttrs value
        then lib.mapAttrs (_: normalizeFcitx5Value) value
        else if builtins.isList value
        then map normalizeFcitx5Value value
        else if builtins.isBool value
        then
          (
            if value
            then "True"
            else "False"
          )
        else value;
      optionalFile = p: f: v:
        lib.optionalAttrs (v != {}) {
          ${p} = f "fcitx5-${builtins.replaceStrings ["/"] ["-"] p}" v;
        };
      entries = lib.attrsets.mergeAttrsList [
        (optionalFile "config" iniFormat.generate (normalizeFcitx5Value im.settings.globalOptions))
        (optionalFile "profile" iniFormat.generate (normalizeFcitx5Value im.settings.inputMethod))
        (lib.concatMapAttrs (
            name: value:
              optionalFile "conf/${name}.conf" iniGlobalFormat.generate (normalizeFcitx5Value value)
          )
          im.settings.addons)
      ];
    in
      pkgs.linkFarm "fcitx-config" (entries
        // {
          "conf/lotus-app-rules.conf" = pkgs.writeText "fcitx5-lotus-app-rules.conf" ''
            # Mode ID: 0 = Off   1 = Uinput (Smooth)   3 = Uinput (Super Smooth) 4 = Surrounding Text   5 = Preedit   6 = Emoji   7 = Uinput (Select)

            # 1. Code Editor & IDE
            code=5

            # 2. Terminal (không hỗ trợ uinput/surrounding text)
            wezterm=5
            org.wezfurlong.wezterm=5

            # 3. Web Browser (Chromium)
            brave-browser=1,25,6,15
            com.brave.Browser=1,25,6,15

            # 4. WPS Office
            wps=1,25,6,15
            et=1,25,6,15
            wpp=1,25,6,15

            # 5. Chat & Social (Electron/Chromium)
            vesktop=1
            org.telegram.desktop=1
            cz.viceverse.serein=1,25,6,15

            # 6. Khác
            org.keepassxc.KeePassXC=5
            anki=5
            net.ankiweb.Anki=5

            # 7. Nhạc
            sonora=1
          '';
        });
  };
}
