#include <innerList.h>

InnerModel::InnerModel(QObject *parent) : QAbstractListModel(parent)
{
    roles[AnnotationRole] = "annotation";
    this->appendData("a");
    this->appendData("b");
    this->appendData("c");
}

InnerModel::~InnerModel()
{
}

int InnerModel::rowCount(const QModelIndex &parent) const
{
    qDebug() << "inner list returning row count of " << annotations.count();
    return annotations.count();
}
QVariant InnerModel::data(const QModelIndex &index, int role) const
{
    qDebug() << "asking the inner model for data at " << index.row();
    if (!index.isValid())
        return QVariant();

    switch (role)
    {
    case AnnotationRole:
        return annotations.at(index.row());
        break;
    default:
        return QVariant();
    }
}
QHash<int, QByteArray> InnerModel::roleNames() const
{
    return roles;
}
QString InnerModel::getTitle()
{
    return title;
}
void InnerModel::setTitle(QString title)
{
    this->title = title;
}

void InnerModel::appendData(QString item)
{
    annotations.append(item);
}