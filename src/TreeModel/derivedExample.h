#ifndef DERIVED_H
#define DERIVED_H

#include <treeModel.h>
#include <treeItem.h>

class DerivedTree : public TreeModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    DerivedTree(QObject *parent = nullptr);

private:
    void setupModelData(const QStringList &lines, TreeItem *parent);
    void alternateSetup();
};
#endif