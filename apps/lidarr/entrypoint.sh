#!/usr/bin/env bash

#shellcheck disable=SC1091
source "/shim/umask.sh"
source "/shim/vpn.sh"

# Discover existing configuration settings for backwards compatibility
if [[ -f /config/config.xml ]]; then
    current_log_level="$(xmlstarlet sel -t --value "//LogLevel" -nl /config/config.xml)"
    current_url_base="$(xmlstarlet sel -t --value "//UrlBase" -nl /config/config.xml)"
    current_branch="$(xmlstarlet sel -t --value "//Branch" -nl /config/config.xml)"
    current_api_key="$(xmlstarlet sel -t --value "//ApiKey" -nl /config/config.xml)"
    current_authentication_method="$(xmlstarlet sel -t --value "//AuthenticationMethod" -nl /config/config.xml)"
    current_authentication_required="$(xmlstarlet sel -t --value "//AuthenticationRequired" -nl /config/config.xml)"
    current_instance_name="$(xmlstarlet sel -t --value "//InstanceName" -nl /config/config.xml)"
    current_postgres_user="$(xmlstarlet sel -t --value "//PostgresUser" -nl /config/config.xml)"
    current_postgres_password="$(xmlstarlet sel -t --value "//PostgresPassword" -nl /config/config.xml)"
    current_postgres_port="$(xmlstarlet sel -t --value "//PostgresPort" -nl /config/config.xml)"
    current_postgres_host="$(xmlstarlet sel -t --value "//PostgresHost" -nl /config/config.xml)"
    current_postgres_main_db="$(xmlstarlet sel -t --value "//PostgresMainDb" -nl /config/config.xml)"
    current_postgres_log_db="$(xmlstarlet sel -t --value "//PostgresLogDb" -nl /config/config.xml)"
    current_application_url="$(xmlstarlet sel -t --value "//ApplicationUrl" -nl /config/config.xml)"
fi

# Update config.xml with environment variables
/usr/local/bin/envsubst < /app/config.xml.tmpl > /config/config.xml

# Override configuation values from existing config.xml if there are no LIDARR__ variables set
[[ -z "${LIDARR__LOG_LEVEL}" && -n "${current_log_level}" ]] && xmlstarlet edit --inplace --update //LogLevel --value "${current_log_level}" /config/config.xml
[[ -z "${LIDARR__URL_BASE}" && -n "${current_url_base}" ]] && xmlstarlet edit --inplace --update //UrlBase --value "${current_url_base}" /config/config.xml
[[ -z "${LIDARR__BRANCH}" && -n "${current_branch}" ]] && xmlstarlet edit --inplace --update //Branch --value "${current_branch}" /config/config.xml
[[ -z "${LIDARR__API_KEY}" && -n "${current_api_key}" ]] && xmlstarlet edit --inplace --update //ApiKey --value "${current_api_key}" /config/config.xml
[[ -z "${LIDARR__AUTHENTICATION_METHOD}" && -n "${current_authentication_method}" ]] && xmlstarlet edit --inplace --update //AuthenticationMethod --value "${current_authentication_method}" /config/config.xml
[[ -z "${LIDARR__AUTHENTICATION_REQUIRED}" && -n "${current_authentication_required}" ]] && xmlstarlet edit --inplace --update //AuthenticationRequired --value "${current_authentication_required}" /config/config.xml
[[ -z "${LIDARR__INSTANCE_NAME}" && -n "${current_instance_name}" ]] && xmlstarlet edit --inplace --update //InstanceName --value "${current_instance_name}" /config/config.xml
[[ -z "${LIDARR__POSTGRES_USER}" && -n "${current_postgres_user}" ]] && xmlstarlet edit --inplace --update //PostgresUser --value "${current_postgres_user}" /config/config.xml
[[ -z "${LIDARR__POSTGRES_PASSWORD}" && -n "${current_postgres_password}" ]] && xmlstarlet edit --inplace --update //PostgresPassword --value "${current_postgres_password}" /config/config.xml
[[ -z "${LIDARR__POSTGRES_PORT}" && -n "${current_postgres_port}" ]] && xmlstarlet edit --inplace --update //PostgresPort --value "${current_postgres_port}" /config/config.xml
[[ -z "${LIDARR__POSTGRES_HOST}" && -n "${current_postgres_host}" ]] && xmlstarlet edit --inplace --update //PostgresHost --value "${current_postgres_host}" /config/config.xml
[[ -z "${LIDARR__POSTGRES_MAIN_DB}" &&  -n "${current_postgres_main_db}" ]] && xmlstarlet edit --inplace --update //PostgresMainDb --value "${current_postgres_main_db}" /config/config.xml
[[ -z "${LIDARR__POSTGRES_MAIN_LOG}" && -n "${current_postgres_log_db}" ]] && xmlstarlet edit --inplace --update //PostgresLogDb --value "${current_postgres_log_db}" /config/config.xml
[[ -z "${LIDARR__APPLICATION_URL}" && -n "${current_application_url}" ]] && xmlstarlet edit --inplace --update //ApplicationUrl --value "${current_application_url}" /config/config.xml

# BindAddress, LaunchBrowser, Port, EnableSsl, SslPort, SslCertPath, SslCertPassword, UpdateMechanism
# have been omited because their configuration is not really needed in a container environment

if [[ "${LIDARR__LOG_LEVEL}" == "debug" || "${current_log_level}" == "debug" ]]; then
    echo "Starting with the following configuration..."
    xmlstarlet format --omit-decl /config/config.xml
fi

exec /app/Lidarr --nobrowser --data=/config ${EXTRA_ARGS}
