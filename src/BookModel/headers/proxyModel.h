#ifndef PROXYMODEL_H
#define PROXYMODEL_H
/**
 * @file proxyModel.h
 * @author Adelyn Flowers (adelyn.flowers@gmail.com)
 * @brief A QSortFilterProxyModel to use with BookModel
 * @version 0.1
 * @date 2023-08-26
 *
 * @copyright Copyright (c) 2023 Adelyn Flowers
 *
 */
#include <QtCore>
#include <QtQml/qqmlregistration.h>
#include <QSortFilterProxyModel>

/**
 * @brief Exposes custom filtering and sorting to BookModel based on
 * titles, dates, annotations, and highlight colors.
 */
class BookProxyModel : public QSortFilterProxyModel {
Q_OBJECT

    QML_ELEMENT
public:
    /**
     * @brief Default constructor
     * @param parent
     */
    explicit BookProxyModel(QObject *parent = nullptr);

    /**
     * Default destructor
     */
    ~BookProxyModel() override;

    /**
     * @brief Sorts the model based on internal parameters.
     * Titles preferred to dates when both are enabled
     * @param dateEnabled enable sorting on date
     * @param titleEnabled enable sorting on title
     * @param order descending or ascending
     */
    void customSort(bool dateEnabled, bool titleEnabled, Qt::SortOrder order = Qt::AscendingOrder);

    /**
     * @brief Toggles the filter on a highlight color
     * @param weight color weight
     */
    void toggleColorFilter(int weight);

protected:
    /**
     * Override that uses dateEnabled and titleEnabled
     * as custom sort parameters.
     */
    bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const override;

    /**
     * Override that uses colorDivisor to filter on
     * highlight color.
     */
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

    // True to use title in sorting
    bool titleEnabled = true;
    // True to use date in sorting
    bool dateEnabled = true;
    // Highlight color values to filter on
    int colorDivisor = 1;
};

#endif // PROXYMODEL_H