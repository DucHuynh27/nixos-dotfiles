{
  config,
  pkgs,
  ...
}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      # Microsoft SQL Server 2022 (Developer Edition)
      mssql = {
        image = "mcr.microsoft.com/mssql/server:2022-latest";
        autoStart = false;
        ports = ["1433:1433"];
        environment = {
          ACCEPT_EULA = "Y";
          MSSQL_PID = "developer";
          MSSQL_SA_PASSWORD = "123123";
        };
        volumes = [
          "/var/lib/mssql_data:/var/opt/mssql"
        ];
      };

      # MySQL 8.0
      mysql = {
        image = "docker.io/library/mysql:8.0";
        autoStart = false;
        ports = ["3306:3306"];
        environment = {
          MYSQL_ROOT_PASSWORD = "SuperStrong!123";
          MYSQL_DATABASE = "nestdb"; # Tự tạo sẵn database nestdb cho NestJS
        };
        volumes = [
          "/var/lib/mysql_data:/var/lib/mysql"
        ];
      };

      # MongoDB 7.0
      mongodb = {
        image = "docker.io/library/mongo:7.0";
        autoStart = false;
        ports = ["27017:27017"];
        volumes = [
          "/var/lib/mongo_data:/data/db"
        ];
      };

      # PostgreSQL 17
      postgres = {
        image = "docker.io/library/postgres:17";
        autoStart = false;
        ports = ["127.0.0.1:5432:5432"];
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "postgres";
        };
        volumes = [
          "/var/lib/postgres_data:/var/lib/postgresql/data"
        ];
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/postgres_data 0700 root root -"
  ];

  # Cho phép user trong nhóm wheel bật/tắt service database không cần nhập mật khẩu
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.isInGroup("wheel")) {
        var unit = action.lookup("unit");
        if (unit == "podman-mssql.service" || unit == "podman-mysql.service" ||
            unit == "podman-mongodb.service" || unit == "podman-postgres.service" ||
            unit == "docker-mssql.service" || unit == "docker-mysql.service" ||
            unit == "docker-mongodb.service" || unit == "docker-postgres.service") {
          return polkit.Result.YES;
        }
      }
    });
  '';
}
