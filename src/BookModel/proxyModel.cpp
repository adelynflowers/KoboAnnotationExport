#include <proxyModel.h>
#include <bookModel.h>

BookProxyModel::BookProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
}
BookProxyModel::~BookProxyModel()
{
}

bool BookProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    auto lTitle{sourceModel()->data(left, BookModel::RoleNames::TitleRole).toString()};
    auto rTitle{sourceModel()->data(right, BookModel::RoleNames::TitleRole).toString()};
    auto lDate{sourceModel()->data(left, BookModel::RoleNames::DateRole).toString()};
    auto rDate{sourceModel()->data(right, BookModel::RoleNames::DateRole).toString()};
    if (lTitle == rTitle)
    {
        return lDate < rDate;
    }
    else
    {
        return lTitle < rTitle;
    }
}
bool BookProxyModel::filterAcceptsRow(int row, const QModelIndex &parent) const
{
    auto idx = sourceModel()->index(row, 0, parent);
    return sourceModel()->data(idx, BookModel::RoleNames::TextRole).toString().contains(filterRegularExpression()) ||
           sourceModel()->data(idx, BookModel::RoleNames::TitleRole).toString().contains(filterRegularExpression());
}