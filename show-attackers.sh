#!/bin/bash
#Javi Ubeda

#Variables
ruta_fitxer=$1
fitxer_log="syslog-sample"
intents_max=10

#Verifiquem que l'script rebi obligatoriament un parametre
if [ $# -eq 0 ];then
   echo No es pot obrir el fitxer de log:
   exit 1
 else
    #Es fara quan es pasi un parametre que no sigui el fitxer de logs
    if [ $ruta_fitxer != $fitxer_log ];then
	echo No es pot obrir el fitxer de log: $ruta_fitxer
        exit 1
    else
	#Filtrem per totes les IPs del fitxer, i les guardem a un fitxer ordenades i sense repetir
	grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $fitxer_log | sort | uniq > llistat_ips.txt

	echo "Count,IP,Location"
	while read ip
	do
	   #Guardem el nombre d'intents fallits de cada IP
	   intents=`cat $fitxer_log | grep "Failed" | grep $ip | wc -l`
	   #Guardem el nom del pais de cada IP
	   pais=$(geoiplookup $ip | cut -d " " -f5,6)

	  if [ $intents -gt $intents_max ];then
	    echo $intents , $ip , $pais >> ips_finals.txt #Guardem les IPs que hagin fallat mes de 10 intents en un fitxer
   	  fi
	done < llistat_ips.txt
	cat ips_finals.txt | sort -nr #Mostrem les IPs, ordenades pel numero d'intents de manera descendent
    fi
fi
