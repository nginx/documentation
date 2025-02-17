---
description: Control access or forward traffic to different upstream servers based
  on the client's geographical location, using the GeoIP2 dynamic module.
docs: DOCS-431
doctypes:
- task
title: Restricting Access by Geographical Location
toc: true
weight: 800
---

<span id="intro"></span>
## Introduction

F5 NGINX Plus can differentiate users based on their geographical location. For example, you can have different website content for different countries, or you can restrict content distribution to a particular country or city.

NGINX Plus uses third-party MaxMind databases to match the IP address of the user and its location. As soon as the geoposition is known, it is then possible to use geoip-based variables in the [map](https://nginx.org/en/docs/http/ngx_http_map_module.html) or the [split_clients](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html) module.

> **Note** MaxMind GeoLite Legacy databases are currently [discontinued](https://blog.maxmind.com/2018/01/discontinuation-of-the-geolite-legacy-databases), MaxMind GeoIP2 or GeoLite2 databases and NGINX Plus [GeoIP2 module]({{< relref "../dynamic-modules/geoip2.md" >}}) should be used instead.

Restricting by geographical location works both for HTTP and TCP/UDP protocols.


<span id="prereq"></span>
## Prerequisites

- NGINX Plus [GeoIP2 dynamic module]({{< relref "../dynamic-modules/geoip2.md" >}})
- [GeoIP2](https://www.maxmind.com/en/geoip2-databases) or [GeoLite2](https://dev.maxmind.com/geoip/geoip2/geolite2/) databases from MaxMind
- (optional) [mmdblookup](http://maxmind.github.io/libmaxminddb/mmdblookup.html) utility that looks up an IP address in a MaxMind Database file


<span id="db"></span>
## Getting the Databases

The GeoIP2 or GeoLite2 databases can be obtained from the [MaxMind download page](https://www.maxmind.com/en/geoip2-databases). In this example, the GeoLite2 free downloadable databases are used.

To get and unpack GeoLite2 Country database:

```shell
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
gunzip GeoLite2-Country.mmdb.gz
```

To get and unpack GeoLite2 City database:

```shell
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
gunzip GeoLite2-City.mmdb.gz
```


<span id="mmdblookup"></span>
## Understanding Database Structure

To see the available geodata, you can query the GeoLite2-Country and GeoLite2-City databases with the [mmdblookup](http://maxmind.github.io/libmaxminddb/mmdblookup.html) utility. The geodata is represented as the JSON tree.

Install the [libmaxminddb](http://maxmind.github.io/libmaxminddb/index.html) database utility:

- For Amazon Linux, CentOS, Oracle Linux, and RHEL:

  ```shell
  yum install libmaxminddb-devel
  ```

- For Debian and Ubuntu:

  ```shell
  apt-get install libmaxminddb-dev
  ```

- For SLES:

  ```shell
  zypper install libmaxminddb-devel
  ```

A query to the databases can be sent in the following format:

```none
mmdblookup –file [FILE PATH] –ip [IP ADDRESS] [DATA PATH]
```

For example, to get all available geodata for the `8.8.8.8` IP address, send the following command:

```shell
mmdblookup --file /usr/local/etc/geoip2/GeoLite2-Country.mmdb --ip 8.8.8.8
```

The output will be:

```json
{
    "continent":
      {
        "code":
          "NA" <utf8_string>
        "geoname_id":
          6255149 <uint32>
        "names":
          {
            "de":
              "Nordamerika" <utf8_string>
            "en":
              "North America" <utf8_string>
            "es":
              "Norteamérica" <utf8_string>
            "fr":
              "Amérique du Nord" <utf8_string>
            "ja":
              "北アメリカ" <utf8_string>
            "pt-BR":
              "América do Norte" <utf8_string>
            "ru":
              "Северная Америка" <utf8_string>
            "zh-CN":
              "北美洲" <utf8_string>
          }
      }
    "country":
      {
        "geoname_id":
          6252001 <uint32>
        "iso_code":
          "US" <utf8_string>
        "names":
          {
            "de":
              "USA" <utf8_string>
            "en":
              "United States" <utf8_string>
            "es":
              "Estados Unidos" <utf8_string>
            "fr":
              "États-Unis" <utf8_string>
            "ja":
              "アメリカ合衆国" <utf8_string>
            "pt-BR":
              "Estados Unidos" <utf8_string>
            "ru":
              "США" <utf8_string>
            "zh-CN":
              "美国" <utf8_string>
          }
      }
    "registered_country":
      {
        "geoname_id":
          6252001 <uint32>
        "iso_code":
          "US" <utf8_string>
        "names":
          {
            "de":
              "USA" <utf8_string>
            "en":
              "United States" <utf8_string>
            "es":
              "Estados Unidos" <utf8_string>
            "fr":
              "États-Unis" <utf8_string>
            "ja":
              "アメリカ合衆国" <utf8_string>
            "pt-BR":
              "Estados Unidos" <utf8_string>
            "ru":
              "США" <utf8_string>
            "zh-CN":
              "美国" <utf8_string>
          }
      }
  }
```

To get particular geodata, for example, only the ISO code of a particular country, add the `country iso_code` parameters to the end of the command:

```shell
mmdblookup --file /usr/local/etc/geoip2/GeoLite2-Country.mmdb --ip 8.8.8.8 country iso_code
```

These parameters are also used when creating variables in the GeoIP2 module for NGINX.


<span id="config"></span>
## Configuring GeoIP2 in NGINX Plus

1. Install the GeoIP2 dynamic module for NGINX Plus:

   For Amazon Linux, CentOS, Oracle Linux, and RHEL:

   ```shell
   yum install nginx-plus-module-geoip2
   ```

   For Debian and Ubuntu:

   ```shell
   apt-get install nginx-plus-module-geoip2
   ```

   For SLES:

   ```shell
   zypper install nginx-plus-module-geoip2
   ```

2. Enable the GeoIP2 dynamic module in the NGINX Plus configuration file with the [load_module](https://nginx.org/en/docs/ngx_core_module.html#load_module) directive specified in the `main` configuration level:

   ```nginx
   load_module modules/ngx_http_geoip2_module.so;
   load_module modules/ngx_stream_geoip2_module.so;

   http {
       # ...
   }
   ```

3. Add the paths to the country and city databases to the NGINX configuration with the `geoip2 {}` block for [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream), or both:

   ```nginx
   http {
       #...
       geoip2 GeoIP2/GeoLite2-Country.mmdb {
           #...
       }

       geoip2 GeoIP2/GeoLite2-City.mmdb {
           #...
       }
   }

   stream {
       #...
       geoip2 GeoIP2/GeoLite2-Country.mmdb {
           #...
       }

       geoip2 GeoIP2/GeoLite2-City.mmdb {
           #...
       }
   }
   ```

4. Basing on the [GeoIP database structure](#mmdblookup), create custom variables that will keep the data from the GeoIP2 database and then later pass the data to the [map](https://nginx.org/en/docs/http/ngx_http_map_module.html) or [split_clients](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html) directives (can be applied in both the [`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) and [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) contexts):


   ```nginx
   geoip2 GeoIP2/GeoLite2-City.mmdb {
       $geoip2_data_city_name   city names en;
       $geoip2_data_postal_code postal code;
       $geoip2_data_latitude    location latitude;
       $geoip2_data_longitude   location longitude;
       $geoip2_data_state_name  subdivisions 0 names en;
       $geoip2_data_state_code  subdivisions 0 iso_code;
   }

   geoip2 GeoIP2/GeoLite2-Country.mmdb {
       $geoip2_data_continent_code   continent code;
       $geoip2_data_country_iso_code country iso_code;
   }

   #...
   ```


<span id="scenario1"></span>
## Scenario: Choosing the Nearest Server

Using the geolocation data from the created variables, a client connection can be redirected to the closest server, thus reducing network latency and improving connection speed.

This can be achieved by using the continent code from the GeoIP2 database in a variable and the [map](https://nginx.org/en/docs/http/ngx_http_map_module.html) module that will create another variable whose value will be the closest server basing on a continent location. Basing on this value, NGINX will pass the request to the corresponding upstream server group.

1. Make sure you have configured the servers or [upstream server groups]({{< relref "../load-balancer/http-load-balancer.md" >}}) for each continent, for example, `eu` for Europe, `na` for North America, `all` for cases when the IP address cannot be matched against the GeoIP database:

   ```nginx
   upstream all {
       server all1.example.com:12345;
       server all2.example.com:12345;
   }

   upstream eu {
       server eu1.example.com:12345;
       server eu2.example.com:12345;
   }

   upstream na {
       server na1.example.com:12345;
       server na2.example.com:12345;
   }
   ```

2. Add the `geoip2 {}` block with a variable of any name (for example, `$geoip2_data_continent_code`) that obtains the continent code of the GeoIP2 database:

   ```nginx
   geoip2 GeoIP2/GeoLite2-Country.mmdb {
       $geoip2_data_continent_code continent code;
   }

   #...
   ```

3. Create the [map](https://nginx.org/en/docs/http/ngx_http_map_module.html) block that will create the `$nearest_server` variable:

   ```nginx
   #...
   map $geoip2_data_continent_code $nearest_server {
       default all;
       EU      eu;
       NA      na;
       AS      as;
       AF      af;
   }
   #...
   ```

3. Create the [`server {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) block which will pass the requests to one of the upstream server groups according to the value passed in the `$nearest_server` variable:

   ```nginx
   server {
       listen 12346;
       proxy_pass http://$nearest_server;
   }
   ```

If the continent is Europe, then the value of the `$nearest_server` will be `eu`, and the connection will be passed to the `eu` upstream via the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive:

```nginx
#...
server {
    listen 12346;
    proxy_pass http://$nearest_server;
}

upstream all {
    server all1.example.com:12345;
    server all2.example.com:12345;

upstream eu {
    server eu1.example.com:12345;
    server eu2.example.com:12345;
}
upstream na {
    server na1.example.com:12345;
    server na2.example.com:12345;
}
#...
```

<span id="example1"></span>
### Example

This example can be applied in both the [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) and [stream](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) contexts.

```nginx
# can be either "http {}" or "stream {}"
#...
geoip2 GeoIP2/GeoLite2-Country.mmdb {
    $geoip2_data_continent_code continent code;
}

map $geoip2_data_continent_code $nearest_server {
    default all;
    EU      eu;
    NA      na;
    AS      as;
    AF      af;
}

server {
    listen 12346;
    proxy_pass http://$nearest_server;
    }

upstream all {
    server all1.example.com:12345;
    server all2.example.com:12345;
}

upstream eu {
    server eu1.example.com:12345;
    server eu2.example.com:12345;
}

upstream na {
    server na1.example.com:12345;
    server na2.example.com:12345;
}
```

In this example, the IP address will be checked in the `GeoLite2-Country.mmdb` database, the result will be written to the `$geoip2_data_continent_code` variable. NGINX Plus will match the value of the variable against values in the [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map) directive and write the result in the custom variable, in our example `$nearest_server`. Basing on the value of the `$nearest_server`, the [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive will choose a corresponding upstream server.


<span id="info"></span>
## More Info

- [GeoIP2 Dynamic Module Installation Instructions]({{< relref "/nginx/admin-guide/dynamic-modules/geoip2.md" >}})

- [MaxMind GeoIP2 Databases](https://www.maxmind.com/en/geoip2-databases)

- [MaxMind Geolite2 Free Downloadable Databases](https://dev.maxmind.com/geoip/geoip2/geolite2/)
