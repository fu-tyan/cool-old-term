QT += qml quick widgets
TARGET = cool-retro-term 

DESTDIR = $$OUT_PWD/../
SOURCES = main.cpp

RESOURCES += qml/resources.qrc

#########################################
##              INTALLS
#########################################

target.path += /usr/bin/

INSTALLS += target
