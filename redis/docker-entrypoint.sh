#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	chown -R redis .
	exec su-exec redis "$0" "$@"
fi

# RUN_MODE = master / slave / sentinel
if [[ $RUN_MODE = 'sentinel' ]]; then
	if [ ! -f /data/redis-sentinel.conf ]; then
		echo "generating redis-sentinel.conf ....";

		echo "port 26379" > /data/redis-sentinel.conf;
		echo "dir /tmp" >> /data/redis-sentinel.conf;
		echo "protected-mode no" >> /data/redis-sentinel.conf;
		echo "sentinel monitor ${MASTER_NAME} ${MASTER_HOST} ${MASTER_PORT} ${SENTINEL_MASTER_QUORUM}" >> /data/redis-sentinel.conf;
		echo "sentinel down-after-milliseconds ${MASTER_NAME} ${SENTINEL_DOWN_AFTER_MS}" >> /data/redis-sentinel.conf;
		echo "sentinel parallel-syncs ${MASTER_NAME} ${SENTINEL_PARALLEL_SYNCS}" >> /data/redis-sentinel.conf;
		echo "sentinel failover-timeout ${MASTER_NAME} ${SENTINEL_FAILOVER_TIMEOUT}" >> /data/redis-sentinel.conf;
		if [[ "$MASTER_PASSWORD" ]]; then
			echo "sentinel auth-pass ${MASTER_NAME} ${MASTER_PASSWORD}" >> /data/redis-sentinel.conf;
		fi

		cat /data/redis-sentinel.conf;

		echo "generated redis-sentinel.conf";
	fi

	shift # "redis-server"
	set -- redis-sentinel /data/redis-sentinel.conf "$@"

fi

if [[ $RUN_MODE = 'slave' ]]; then
	doSlaveof=1
	configFile=
	if [ -f "$2" ]; then
		configFile="$2"
		if grep -q '^slaveof' "$configFile"; then
			# if a config file is supplied and explicitly specifies "slave", let it win
			doSlaveof=
		fi
	fi

	if [ "$doSlaveof" ]; then
		shift # "redis-server"
		if [ "$configFile" ]; then
			shift
		fi
		set -- --slaveof "$MASTER_HOST" "$MASTER_PORT" "$@"
		if [ "$configFile" ]; then
			set -- "$configFile" "$@"
		fi
		set -- redis-server "$@" # redis-server [config file] --protected-mode no [other options]
		# if this is supplied again, the "latest" wins, so "--protected-mode no --protected-mode yes" will result in an enabled status
	fi
fi

if [ "$1" = 'redis-server' ]; then
	# Disable Redis protected mode [1] as it is unnecessary in context
	# of Docker. Ports are not automatically exposed when running inside
	# Docker, but rather explicitely by specifying -p / -P.
	# [1] https://github.com/antirez/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
	doProtectedMode=1
	configFile=
	if [ -f "$2" ]; then
		configFile="$2"
		if grep -q '^protected-mode' "$configFile"; then
			# if a config file is supplied and explicitly specifies "protected-mode", let it win
			doProtectedMode=
		fi
	fi
	if [ "$doProtectedMode" ]; then
		shift # "redis-server"
		if [ "$configFile" ]; then
			shift
		fi
		set -- --protected-mode no "$@"
		if [ "$configFile" ]; then
			set -- "$configFile" "$@"
		fi
		set -- redis-server "$@" # redis-server [config file] --protected-mode no [other options]
		# if this is supplied again, the "latest" wins, so "--protected-mode no --protected-mode yes" will result in an enabled status
	fi

fi

echo "CMD : $@"

exec "$@"