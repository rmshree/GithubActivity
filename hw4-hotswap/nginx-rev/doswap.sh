#/bin/bash

function killit {
      docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
}

function running {
  docker ps -a  > /tmp/yy_xx$$
  if grep --quiet "web1" /tmp/yy_xx$$
    then
      echo "Running web1"
      NOW=1
  elif grep --quiet "web2" /tmp/yy_xx$$
    then
      echo "Running web2"
      NOW=2
  else
      echo "Nothing is running"
      NOW=-1
  fi
}

NOW=
running

 if (( "$NOW" == "1"))
    then
 	docker run --name "web2" --network ecs189_default -d -P $1
 	sleep 10
    docker exec ecs189_proxy_1 /bin/bash /bin/"swap2".sh
    killit "web1"
 	echo "Swapped!"
 elif (( "$NOW" == "2"))
    then
 	docker run --name  "web1" --network ecs189_default -d -P $1
 	sleep 10
    docker exec ecs189_proxy_1 /bin/bash /bin/"swap1".sh
    killit "web2"
 	echo "Swapped!"
 else
     echo "Nothing is running"
 fi