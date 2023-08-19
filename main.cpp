#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick>
#include <kaeLib.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    KaeLib kaeLib;
    engine.rootContext()->setContextProperty("kaeLib", &kaeLib);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MainView", "Main");

    return app.exec();
}
