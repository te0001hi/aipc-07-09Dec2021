user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

http {
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    upstream apps {
        least_conn;
        # the following list the container endlpoints
        %{ for p in ports }
        server ${docker_host}:${p};
        %{ endfor }
    }

    server {
        listen 80;
        location / {
            proxy_pass http://apps;
        }
    }
}
