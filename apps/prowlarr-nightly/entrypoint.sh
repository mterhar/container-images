#!/usr/bin/env bash

#shellcheck disable=SC1091
source "/shim/umask.sh"
source "/shim/vpn.sh"

# Discover existing configuration settings for backwards compatibility
if [[ -f /config/config.xml ]]; then
    CURRENT_LOG_LEVEL="$(xmlstarlet sel -t --value "//LogLevel" -nl /config/config.xml)"
    CURRENT_URL_BASE="$(xmlstarlet sel -t --value "//UrlBase" -nl /config/config.xml)"
    CURRENT_BRANCH="$(xmlstarlet sel -t --value "//Branch" -nl /config/config.xml)"
    CURRENT_API_KEY="$(xmlstarlet sel -t --value "//ApiKey" -nl /config/config.xml)"
    CURRENT_AUTHENTICATION_METHOD="$(xmlstarlet sel -t --value "//AuthenticationMethod" -nl /config/config.xml)"
    CURRENT_AUTHENTICATION_REQUIRED="$(xmlstarlet sel -t --value "//AuthenticationRequired" -nl /config/config.xml)"
    CURRENT_INSTANCE_NAME="$(xmlstarlet sel -t --value "//InstanceName" -nl /config/config.xml)"
    CURRENT_POSTGRES_USER="$(xmlstarlet sel -t --value "//PostgresUser" -nl /config/config.xml)"
    CURRENT_POSTGRES_PASSWORD="$(xmlstarlet sel -t --value "//PostgresPassword" -nl /config/config.xml)"
    CURRENT_POSTGRES_PORT="$(xmlstarlet sel -t --value "//PostgresPort" -nl /config/config.xml)"
    CURRENT_POSTGRES_HOST="$(xmlstarlet sel -t --value "//PostgresHost" -nl /config/config.xml)"
    CURRENT_POSTGRES_MAIN_DB="$(xmlstarlet sel -t --value "//PostgresMainDb" -nl /config/config.xml)"
    CURRENT_POSTGRES_LOG_DB="$(xmlstarlet sel -t --value "//PostgresLogDb" -nl /config/config.xml)"
    CURRENT_APPLICATION_URL="$(xmlstarlet sel -t --value "//ApplicationUrl" -nl /config/config.xml)"
fi

# Update config.xml with environment variables
/usr/local/bin/envsubst < /app/config.xml.tmpl > /config/config.xml

# Override configuation values from existing config.xml if there are no PROWLARR__ variables set
[[ -n "${CURRENT_LOG_LEVEL}" && -z ${PROWLARR__LOG_LEVEL} ]] && xmlstarlet edit --inplace --update //LogLevel --value "${CURRENT_LOG_LEVEL}" /config/config.xml
[[ -n "${CURRENT_URL_BASE}" && -z ${PROWLARR__URL_BASE} ]] && xmlstarlet edit --inplace --update //UrlBase --value "${CURRENT_URL_BASE}" /config/config.xml
[[ -n "${CURRENT_BRANCH}" && -z ${PROWLARR__BRANCH} ]] && xmlstarlet edit --inplace --update //Branch --value "${CURRENT_BRANCH}" /config/config.xml
[[ -n "${CURRENT_API_KEY}" && -z ${PROWLARR__API_KEY} ]] && xmlstarlet edit --inplace --update //ApiKey --value "${CURRENT_API_KEY}" /config/config.xml
[[ -n "${CURRENT_AUTHENTICATION_METHOD}" && -z ${PROWLARR__AUTHENTICATION_METHOD} ]] && xmlstarlet edit --inplace --update //AuthenticationMethod --value "${CURRENT_AUTHENTICATION_METHOD}" /config/config.xml
[[ -n "${CURRENT_AUTHENTICATION_REQUIRED}" && -z ${PROWLARR__AUTHENTICATION_REQUIRED} ]] && xmlstarlet edit --inplace --update //AuthenticationRequired --value "${CURRENT_AUTHENTICATION_REQUIRED}" /config/config.xml
[[ -n "${CURRENT_INSTANCE_NAME}" && -z ${PROWLARR__INSTANCE_NAME} ]] && xmlstarlet edit --inplace --update //InstanceName --value "${CURRENT_INSTANCE_NAME}" /config/config.xml
[[ -n "${CURRENT_POSTGRES_USER}" && -z ${PROWLARR__POSTGRES_USER} ]] && xmlstarlet edit --inplace --update //PostgresUser --value "${CURRENT_POSTGRES_USER}" /config/config.xml
[[ -n "${CURRENT_POSTGRES_PASSWORD}" && -z ${PROWLARR__POSTGRES_PASSWORD} ]] && xmlstarlet edit --inplace --update //PostgresPassword --value "${CURRENT_POSTGRES_PASSWORD}" /config/config.xml
[[ -n "${CURRENT_POSTGRES_PORT}" && -z ${PROWLARR__POSTGRES_PORT} ]] && xmlstarlet edit --inplace --update //PostgresPort --value "${CURRENT_POSTGRES_PORT}" /config/config.xml
[[ -n "${CURRENT_POSTGRES_HOST}" && -z ${PROWLARR__POSTGRES_HOST} ]] && xmlstarlet edit --inplace --update //PostgresHost --value "${CURRENT_POSTGRES_HOST}" /config/config.xml
[[ -n "${CURRENT_POSTGRES_MAIN_DB}" && -z ${PROWLARR__POSTGRES_MAIN_DB} ]] && xmlstarlet edit --inplace --update //PostgresMainDb --value "${CURRENT_POSTGRES_MAIN_DB}" /config/config.xml
[[ -n "${CURRENT_POSTGRES_LOG_DB}" && -z ${PROWLARR__POSTGRES_MAIN_LOG} ]] && xmlstarlet edit --inplace --update //PostgresLogDb --value "${CURRENT_POSTGRES_LOG_DB}" /config/config.xml
[[ -n "${CURRENT_APPLICATION_URL}" && -z ${PROWLARR__APPLICATION_URL} ]] && xmlstarlet edit --inplace --update //ApplicationUrl --value "${CURRENT_APPLICATION_URL}" /config/config.xml

# BindAddress, LaunchBrowser, Port, EnableSsl, SslPort, SslCertPath, SslCertPassword, UpdateMechanism
# have been omited because their configuration is not really needed in a container environment

if [[ "${CURRENT_LOG_LEVEL}" == "debug" || "${PROWLARR__LOG_LEVEL}" == "debug" ]]; then
    echo "Starting with the following configuration..."
    xmlstarlet format --omit-decl /config/config.xml
fi

exec /app/Prowlarr --nobrowser --data=/config ${EXTRA_ARGS}
