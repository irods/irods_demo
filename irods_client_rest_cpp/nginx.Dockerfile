FROM nginx:1.23.1

COPY irods_client_rest_cpp_reverse_proxy.conf /etc/nginx/conf.d/default.conf
