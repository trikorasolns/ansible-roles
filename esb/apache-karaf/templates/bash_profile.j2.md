export JAVA_HOME=dirname $(dirname $(readlink -f $(which java)))
# export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.172-9.b11.fc28.x86_64/jre
PATH=$JAVA_HOME/bin:$PATH:$HOME/.local/bin:$HOME/bin
export PATH
