# Intro
A docker image modified from [mesos/kafka](https://github.com/mesos/kafka/tree/master/src/docker), built on Oracle JRE 8 in Alpine;

`/opt/kafka-mesos` folder will contain following content:
- kafka*.tgz - kafka distro;
- kafka-mesos*.jar - kafka-mesos distro;
- kafka-mesos.sh - shell script to run kafka-mesos;

No default configuration file for kafka-mesos is provided. All configuration params should be
specified via cli options.

# Running image
Running image using docker. Required networking params should be provided. Image has no entry point,
so ./kafka-mesos.sh should be specified explicitly.

Example:
```
# sudo docker run -it -p 7000:7000 --add-host=master:192.168.3.5 yyqqing/kafka-mesos ./kafka-mesos.sh scheduler \
--master=master:5050 --zk=master:2181 --api=http://<accessible-ip>:7000 --storage=zk:/kafka-mesos
```
Where accessible-ip - is the IP address of running host, accessible from mesos nodes.

Note: if you want to inspect image content you can skip specifying `./kafka-mesos.sh` entry point.
In that case you will get shell access.

# Running image in Marathon
To run image in Marathon it is better to pre-pull image on all required nodes using:
```
# sudo docker pull <image-name>
```

After that, scheduler process could be created via Marathon API via POST /v2/apps call.
Example:
```
{
    "container": {
        "type": "DOCKER",
        "docker": {
            "network": "HOST",
            "image": "$imageName"
        }
    },
    "id":"kafka-mesos-scheduler",
    "cpus": 0.5,
    "mem": 256,
    "ports": [7000],
    "cmd": "./kafka-mesos.sh scheduler --master=master:5050 --zk=master:2181 --api=http://master:7000 --storage=zk:/kafka-mesos",
    "instances": 1,
    "constraints": [["hostname", "LIKE", "master"]]
}
```

Then the cli should be able to connect to url http://master:7000 from your api client machine
(typically different than the mesos slaves). Example:
```
# ./kafka-mesos.sh broker list --api=http://master:7000
no brokers
```
Now you can configure and start brokers.
