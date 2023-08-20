#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick>
#include <QFontDatabase>
#include <kaeLib.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    KaeLib kaeLib;
    // TODO: add font file to here and cmake
    if (QFontDatabase::addApplicationFont("fonts/fontello.ttf") == -1)
        qWarning() << "Failed to load fontello.ttf";
    engine.rootContext()->setContextProperty("kaeLib", &kaeLib);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MainView", "Main");

    return app.exec();
}
