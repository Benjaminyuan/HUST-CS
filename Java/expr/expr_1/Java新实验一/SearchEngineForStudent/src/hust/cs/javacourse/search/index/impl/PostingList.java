package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractPosting;
import hust.cs.javacourse.search.index.AbstractPostingList;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Collections;
import java.util.List;

public class PostingList extends AbstractPostingList {

    private static final long serialVersionUID = 1L;

    @Override
    public void add(AbstractPosting posting) {
        if(!this.list.contains(posting)){
            this.list.add(posting);
        }
    }

    @Override
    public String toString() {
        StringBuilder s = new StringBuilder("PostingList:[");
        list.forEach(e->{
            s.append(" ").append(e.toString()).append(",");});
        s.deleteCharAt(s.length()-1);
        s.append("]");
        return s.toString();
    }
    @Override
    public void add(List<AbstractPosting> postings) {
        for(AbstractPosting p : postings){
            add(p);
        }
    }

    @Override
    public AbstractPosting get(int index) {
        if(index < this.list.size() && index >= 0){
            return this.list.get(index);
        }
        return null;
    }

    @Override
    public int indexOf(AbstractPosting posting) {
        return this.list.indexOf(posting);
    }

    @Override
    public int indexOf(int docId) {
        int index = -1;
        for(int i=0;i<list.size();i++){
            AbstractPosting p = list.get(i);
            if(p.getDocId() == docId){
                index = i;
                break;
            }
        }
        return index;
    }

    @Override
    public boolean contains(AbstractPosting posting) {
        return list.contains(posting);
    }

    @Override
    public void remove(int index) {
        list.remove(index);
    }

    @Override
    public void remove(AbstractPosting posting) {
        list.remove(posting);
    }

    @Override
    public int size() {
        return list.size();
    }

    @Override
    public void clear() {
        list.clear();
    }

    @Override
    public boolean isEmpty() {
        return list.isEmpty();
    }

    @Override
    public void sort() {
        list.sort(AbstractPosting::compareTo);
        list.forEach(AbstractPosting::sort);
    }

    @Override
    public void writeObject(ObjectOutputStream out) {
        try{
            out.writeObject(list.size());
            for(AbstractPosting p : list ){
                p.writeObject(out);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void readObject(ObjectInputStream in) {
        try{
            int size = ( int )in.readObject();
            list.clear();
            for(int i=0;i<size;i++){
                AbstractPosting p = new Posting();
                p.readObject(in);
                list.add(p);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
