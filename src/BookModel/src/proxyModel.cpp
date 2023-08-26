#include "headers/proxyModel.h"
#include "headers/bookModel.h"

// Default ctor
BookProxyModel::BookProxyModel(QObject *parent) : QSortFilterProxyModel(parent) {
}

// Default destructor
BookProxyModel::~BookProxyModel() = default;

// Used for sorting, based on internal flags set with customSort
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

// Used for filtering, based on colorDivisor set by toggleColorFilter
bool BookProxyModel::filterAcceptsRow(int row, const QModelIndex &parent) const {
    auto idx = sourceModel()->index(row, 0, parent);
    bool textCond =
            sourceModel()->data(idx, BookModel::RoleNames::TextRole).toString().contains(filterRegularExpression()) ||
            sourceModel()->data(idx, BookModel::RoleNames::TitleRole).toString().contains(filterRegularExpression());
    bool colorCond = sourceModel()->data(idx, BookModel::RoleNames::ColorRole).toInt() % colorDivisor == 0;
    return textCond && colorCond;
}

// Sorts the model with fields optionally enabled
void BookProxyModel::customSort(bool useDate, bool useTitle, Qt::SortOrder order) {
    this->dateEnabled = useDate;
    this->titleEnabled = useTitle;
    this->sort(0, order);
    layoutChanged();
}

// Updates model filter by toggling filter on highlight color
void BookProxyModel::toggleColorFilter(int weight) {
    layoutAboutToBeChanged();
    if (colorDivisor % weight == 0) {
        colorDivisor /= weight;
    } else {
        colorDivisor *= weight;
    }
    invalidateRowsFilter();
    layoutChanged();
}
