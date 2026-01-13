#!/bin/bash

# Exit on error
set -e

echo "--- Installing and setting up Java 8 ---"
apt-get update
apt-get install -y openjdk-8-jdk
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64'

echo "--- Cloning and building jsonDoclet dependency ---"
cd /content
rm -rf jsonDoclet
git clone https://github.com/mchorse/jsonDoclet.git
cd /content/jsonDoclet
sed -i 's/5.2.0/2.0.4/' build.gradle
chmod +x gradlew
./gradlew build

echo "--- Building MappetRemasterRU ---"
cd /content/MappetRemasterRU
mkdir -p run
cp /content/jsonDoclet/build/libs/jsonDoclet-1.0.jar run/jsonDoclet.jar
chmod +x gradlew
./gradlew build
./gradlew scriptingJavadocs

echo "--- BUILD COMPLETE! ---"
