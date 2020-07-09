#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickView>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>
#include <QSettings>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("AppWorld");
    QCoreApplication::setOrganizationDomain("Software Engineering");
    
    QGuiApplication app(argc, argv);
    
    QQuickStyle::setStyle("Material");
   
    QString databaseDir = QCoreApplication::applicationDirPath();
    
    QQmlApplicationEngine engine;
    engine.setOfflineStoragePath(databaseDir);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
