package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractPosting;
import hust.cs.javacourse.search.index.AbstractPostingList;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.List;

public class PostingList extends AbstractPostingList {
    @Override
    public void add(AbstractPosting posting) {
        this.list.add(posting);
    }

    @Override
    public String toString() {
        StringBuilder s = new StringBuilder("PostingList:[ ");
        list.forEach(e->{s.append(e.toString()).append(", ");});
        s.append("]");
        return s.toString();
    }
    @Override
    public void add(List<AbstractPosting> postings) {

    }

    @Override
    public AbstractPosting get(int index) {
        return null;
    }

    @Override
    public int indexOf(AbstractPosting posting) {
        return 0;
    }

    @Override
    public int indexOf(int docId) {
        return 0;
    }

    @Override
    public boolean contains(AbstractPosting posting) {
        return false;
    }

    @Override
    public void remove(int index) {

    }

    @Override
    public void remove(AbstractPosting posting) {

    }

    @Override
    public int size() {
        return 0;
    }

    @Override
    public void clear() {

    }

    @Override
    public boolean isEmpty() {
        return false;
    }

    @Override
    public void sort() {

    }

    @Override
    public void writeObject(ObjectOutputStream out) {

    }

    @Override
    public void readObject(ObjectInputStream in) {

    }
}
