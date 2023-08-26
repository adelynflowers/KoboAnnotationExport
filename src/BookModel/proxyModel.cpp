#include <proxyModel.h>
#include <bookModel.h>

BookProxyModel::BookProxyModel(QObject *parent) : QSortFilterProxyModel(parent) {
}

BookProxyModel::~BookProxyModel() {
}

bool BookProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
    auto lTitle{sourceModel()->data(left, BookModel::RoleNames::TitleRole).toString()};
    auto rTitle{sourceModel()->data(right, BookModel::RoleNames::TitleRole).toString()};
    auto lDate{sourceModel()->data(left, BookModel::RoleNames::DateRole).toString()};
    auto rDate{sourceModel()->data(right, BookModel::RoleNames::DateRole).toString()};
    if (titleEnabled && dateEnabled) {
        return lTitle == rTitle ? lDate < rDate : lTitle < rTitle;
    } else if (titleEnabled && !dateEnabled) {
        return lTitle < rTitle;
    } else if (!titleEnabled && dateEnabled) {
        return lDate < rDate;
    } else {
        //TODO: Don't fail silently!
        return true;
    }
}

bool BookProxyModel::filterAcceptsRow(int row, const QModelIndex &parent) const {
    auto idx = sourceModel()->index(row, 0, parent);
    bool textCond =
            sourceModel()->data(idx, BookModel::RoleNames::TextRole).toString().contains(filterRegularExpression()) ||
            sourceModel()->data(idx, BookModel::RoleNames::TitleRole).toString().contains(filterRegularExpression());
    bool colorCond = sourceModel()->data(idx, BookModel::RoleNames::ColorRole).toInt() % colorDivisor == 0;
    qDebug() << "filtering row with " << textCond << " && " << colorCond;
    return textCond && colorCond;
}

void BookProxyModel::customSort(bool useDate, bool useTitle, Qt::SortOrder order) {
    this->dateEnabled = useDate;
    this->titleEnabled = useTitle;
    this->sort(0, order);
    layoutChanged();
}

void BookProxyModel::toggleColorFilter(int weight) {
    layoutAboutToBeChanged();
    qDebug() << "toggling filter for weight " << weight << ", current divisor is " << colorDivisor;
    if (colorDivisor % weight == 0) {
        colorDivisor /= weight;
    } else {
        colorDivisor *= weight;
    }
    qDebug() << "divisor changed to " << colorDivisor;
    invalidateRowsFilter();
    layoutChanged();
}
