#!/bin/bash

# --- App Environment -----------------
test -z $ENVIRON && export ITG_ENV="dev" || export ITG_ENV=$ENVIRON

export ITG_VERSION=$(<VERSION)


export ITG_DB_USER="cmsadmin"
export ITG_DB_HOST="localhost"

# TODO get from credstash
export ITG_DB_PASSWORD="password"

# TODO get from credstash
export ITG_SECRET_KEY="u$39#)!ksh@9fdsl+l^87=&jub7-zoz3)qp66s17j5j+%89z7r"

# --- spylogger -----------------------
export SPY_LOG_LOGGER="pretty"
export SPY_LOG_LEVEL="DEBUG"

# --- postgresql ----------------------
sed "s/{{ environ }}/$ITG_ENV/" < /opt/files/psql-setup.sql.j2 > /opt/files/psql-setup.sql
service postgresql start

su postgres -c "psql -d postgres -a -f /opt/files/psql-setup.sql"

if [[ $ITG_ENV == "test" || $ITG_ENV == "dev" ]]; then
    su postgres -c "psql -d postgres -c \"ALTER USER cmsadmin CREATEDB;\""
fi


# --- install node packages -----------
mkdir -p /opt/vendor
npm i font-awesome
mv node_modules/font-awesome /opt/vendor/font-awesome

# --- App Install ---------------------
make clean
make install

# if [[ $ITG_ENV == "dev" ]]; then
#     python manage.py changepassword admin
# fi

if [[ $ITG_ENV == "test" || $ITG_ENV == "dev" ]]; then
    pip install django-nose coverage
fi

# --- Ready ---------------------------
exec env "$@"
