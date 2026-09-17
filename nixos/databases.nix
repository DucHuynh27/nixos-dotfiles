{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # Microsoft SQL Server 2022 (Developer Edition)
      mssql = {
        image = "mcr.microsoft.com/mssql/server:2022-latest";
        autoStart = false;
        ports = [ "1433:1433" ];
        environment = {
          ACCEPT_EULA = "Y";
          MSSQL_PID = "developer";
          MSSQL_SA_PASSWORD = "SuperStrong!123";
        };
        volumes = [
          "mssql_data:/var/opt/mssql"
        ];
      };

      # MySQL 8.0
      mysql = {
        image = "mysql:8.0";
        autoStart = false;
        ports = [ "3306:3306" ];
        environment = {
          MYSQL_ROOT_PASSWORD = "SuperStrong!123";
          MYSQL_DATABASE = "nestdb"; # Tự tạo sẵn database nestdb cho NestJS
        };
        volumes = [
          "mysql_data:/var/lib/mysql"
        ];
      };
    };
  };

  # Cho phép user trong nhóm wheel bật/tắt service database không cần nhập mật khẩu
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.isInGroup("wheel")) {
        var unit = action.lookup("unit");
        if (unit == "docker-mssql.service" || unit == "docker-mysql.service") {
          return polkit.Result.YES;
        }
      }
    });
  '';
}
