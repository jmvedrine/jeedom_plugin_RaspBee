#!/bin/bash
echo $1
cd $1
touch /tmp/RaspBEE_dep
echo "Début de l'installation"
echo 0 > /tmp/RaspBEE_dep
DIRECTORY="/var/www"
if [ ! -d "$DIRECTORY" ]; then
  echo "Création du home www-data pour npm"
  sudo mkdir $DIRECTORY
fi
sudo chown -R www-data $DIRECTORY
echo 10 > /tmp/RaspBEE_dep
actual=`nodejs -v`;
echo "Version actuelle : ${actual}"

if [[ $actual == "v8."* || $actual == "v9."* || $actual == "v10."* ]]
then
  echo "Ok, version suffisante";
else
  echo "KO, version obsolète à upgrader";
  echo "Suppression du Nodejs existant et installation du paquet recommandé"
  sudo apt-get -y --purge autoremove nodejs npm
  arch=`arch`;
  echo 30 > /tmp/RaspBEE_dep
  if [[ $arch == "armv6l" ]]
  then
    echo "Raspberry 1 détecté, utilisation du paquet pour armv6l"
    sudo rm -f /etc/apt/sources.list.d/nodesource.list &>/dev/null
    wget http://node-arm.herokuapp.com/node_latest_armhf.deb
    sudo dpkg -i node_latest_armhf.deb
    sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs
    rm node_latest_armhf.deb
    
  else
    echo "Utilisation du dépot officiel"
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-key update
    sudo apt-get install -y nodejs  
  fi

  new=`nodejs -v`;
  echo "Version actuelle : ${new}"

fi

echo 70 > /tmp/RaspBEE_dep

cd ../daemon/
npm cache clean
sudo npm cache clean
sudo rm -rf node_modules

echo 85 > /tmp/RaspBEE_dep
sudo npm install --save
echo 90 > /tmp/RaspBEE_dep

sudo chown -R www-data *

rm /tmp/RaspBEE_dep

echo "Fin de l'installation"
