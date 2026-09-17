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
          MYSQL_DATABASE = "mydb";
        };
        volumes = [
          "mysql_data:/var/lib/mysql"
        ];
      };
    };
  };
}
