#include <derivedExample.h>

DerivedTree::DerivedTree(QObject *parent) : TreeModel(parent)
{
    alternateSetup();
}

void DerivedTree::alternateSetup()
{
    // First, setup the headers. We have 2
    addHeaderData("Number");
    addHeaderData("Squared");
    for (int i = 0; i < 3; i++)
    {
        auto row = rootItem->createChild();
        row->addData(i);
        row->addData(i * i);
        for (int j = 0; j < 3; j++)
        {
            auto child = row->createChild();
            child->addData(j);
            child->addData(j * j);
        }
    }
}

void DerivedTree::setupModelData(const QStringList &lines, TreeItem *parent)
{
    QList<TreeItem *> parents;
    QList<int> indentations;
    parents << parent;
    indentations << 0;

    int number = 0;

    while (number < lines.count())
    {
        int position = 0;
        while (position < lines[number].length())
        {
            if (lines[number].at(position) != ' ')
                break;
            ++position;
        }

        const QString lineData = lines[number].mid(position).trimmed();

        if (!lineData.isEmpty())
        {
            // Read the column data from the rest of the line.
            const QStringList columnStrings =
                lineData.split(QLatin1Char('\t'), Qt::SkipEmptyParts);
            QList<QVariant> columnData;
            columnData.reserve(columnStrings.size());
            for (const QString &columnString : columnStrings)
                columnData << columnString;

            if (position > indentations.last())
            {
                // The last child of the current parent is now the new parent
                // unless the current parent has no children.

                if (parents.last()->childCount() > 0)
                {
                    parents << parents.last()->child(parents.last()->childCount() - 1);
                    indentations << position;
                }
            }
            else
            {
                while (position < indentations.last() && parents.count() > 0)
                {
                    parents.pop_back();
                    indentations.pop_back();
                }
            }

            // Append a new item to the current parent's list of children.
            TreeItem *parent = parents.last();
            parent->insertChildren(parent->childCount(), 1, rootItem->columnCount());
            for (int column = 0; column < columnData.size(); ++column)
                parent->child(parent->childCount() - 1)->setData(column, columnData[column]);
        }
        ++number;
    }
}
