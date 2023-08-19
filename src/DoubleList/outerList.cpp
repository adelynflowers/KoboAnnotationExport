#include <outerList.h>
#include <innerList.h>
#include <string>
NestedListViewModel::NestedListViewModel(QObject *parent) : QAbstractListModel(parent)
{
    roles[TitleRole] = "title";
    roles[SubmodelRole] = "submodel";

    for (int i = 0; i < 3; i++)
    {
        auto innerModel = new InnerModel();
        auto title = std::to_string(i);
        innerModel->setTitle(QString::fromStdString(title));
        models.push_back(innerModel);
    }
}

NestedListViewModel::~NestedListViewModel()
{
    qDeleteAll(models);
}

int NestedListViewModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return models.count();
}

QVariant NestedListViewModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    int row = index.row();
    switch (role)
    {
    case TitleRole:
        return models.at(row)->getTitle();
        break;
    case SubmodelRole:
        // qDebug() << "Asking for submodel at" << row << ", returning" << models[row] << "before casting";
        // qDebug() << "After casting, it becomes" << QVariant::fromValue<QObject *>(models[row]);
        return QVariant::fromValue<QObject *>(models[row]);
        break;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> NestedListViewModel::roleNames() const
{
    return roles;
}

QVariant NestedListViewModel::getInnerModelAt(int idx) const
{
    return QVariant::fromValue<QObject *>(models[idx]);
}