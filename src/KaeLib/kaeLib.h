#ifndef KAELIB_H
#define KAELIB_H
/**
 * @file kaeLib.h
 * @author Adelyn Flowers (adelyn.flowers@gmail.com)
 * @brief The KaeLib class, which holds helper functions
 * for Kae to use in QML.
 * @version 0.1
 * @date 2023-08-12
 *
 * @copyright Copyright (c) 2023 Adelyn Flowers
 *
 */

#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <QClipboard>
#include <QGuiApplication>

/**
 * @brief A class containing helper
 * functions for the entire application.
 *
 */
class KaeLib : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE void hello()
    {
        qDebug() << "Hello world!";
    }
};

#endif // KAELIB_H
