#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick>
#include <QFontDatabase>
#include <kaeLib.h>
#include <QFont>
int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("kae");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    KaeLib kaeLib;
    if (QFontDatabase::addApplicationFont(":/fonts/fontello.ttf") == -1)
        qWarning() << "Failed to load fontello.ttf";
    QFont fon("Arial");
    app.setFont(fon);
    engine.rootContext()->setContextProperty("kaeLib", &kaeLib);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MainView", "Main");

    return app.exec();
}
