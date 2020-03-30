package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractDocument;
import hust.cs.javacourse.search.index.AbstractTermTuple;

import java.util.ArrayList;
import java.util.List;

public class Document extends AbstractDocument {
    @Override
    public int getDocId() {
        return docId;
    }

    @Override
    public void setDocId(int docId) {
        this.docId = docId;
    }

    @Override
    public String getDocPath() {
        return docPath;
    }

    @Override
    public void setDocPath(String docPath) {
        this.docPath = docPath;
    }

    @Override
    public List<AbstractTermTuple> getTuples() {
        return new ArrayList<>(tuples);
    }

    @Override
    public void addTuple(AbstractTermTuple tuple) {
        if (!this.contains(tuple)){
            tuples.add(tuple);
        }
    }

    @Override
    public boolean contains(AbstractTermTuple tuple) {
        return tuples.contains(tuple);
    }

    @Override
    public AbstractTermTuple getTuple(int index) {
        if(index < 0 || index >= tuples.size()){
            return null;
        }
        return tuples.get(index);
    }

    @Override
    public int getTupleSize() {
        return tuples.size();
    }

    @Override
    public String toString() {
        StringBuilder s = new StringBuilder("docID: "+docId+" docPath: "+docPath+" tuples:[ ");
        tuples.forEach(e->{s.append(e.toString()).append(", ");});
        s.append("]");
        return s.toString();
    }
}
