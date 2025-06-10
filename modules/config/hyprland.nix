{ newHome, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "HOME,${newHome}"
      ];
    };
  };
}
