{...}: {
  programs.mangohud = {
    enable = true;
    settings = {
      legacy_layout = false;
      round_corners = 10;
      background_alpha = 0.8;
      background_color = "303446";
      table_columns = 3;

      font_size = 24;
      text_color = "C6D0F5";
      text_outline_color = "414559";

      gpu_text = "GPU";
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      vram = true;
      gpu_color = "A6D189";
      gpu_load_change = true;
      gpu_load_color = ["C6D0F5" "EF9F76" "E78284"];

      cpu_text = "CPU";
      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;
      cpu_color = "8CAAEE";
      cpu_load_change = true;
      cpu_load_color = ["C6D0F5" "EF9F76" "E78284"];

      ram = true;
      ram_color = "F4B8E4";

      engine_color = "E78284";

      fps = true;
      fps_color_change = ["E78284" "E5C890" "A6D189"];

      wine = true;
      wine_color = "E78284";
      winesync = true;

      frame_timing = true;
      frametime_color = "A6D189";

      arch = true;
      fps_limit_method = "early";
      toggle_fps_limit = "Shift_L+F1";
    };
  };
}
