package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractPosting;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.List;

public class Posting extends AbstractPosting {
    /**
     *
     */
    private static final long serialVersionUID = 1L;
    public Posting(){
    }

    public Posting(int docId, int freq, List<Integer> positions){
        super(docId,freq,positions);
    }
    @Override
    public boolean equals(Object obj) {
        if(obj instanceof AbstractPosting){
            AbstractPosting o = (AbstractPosting) obj;
            return this.docId == o.getDocId();
        }
        return false ;
    }

    @Override
    public String toString() {
        StringBuilder s = new StringBuilder("docID: "+ docId+" freq: "+freq+" position: [");
        positions.forEach(pos -> s.append(" "+pos).append(","));
        s.deleteCharAt(s.length()-1);
        s.append("]");
        return s.toString();
    }

    @Override
    public int getDocId() {
        return this.docId;
    }

    @Override
    public void setDocId(int docId) {
        this.docId = docId;
    }

    @Override
    public int getFreq() {
        return this.freq;
    }

    @Override
    public void setFreq(int freq) {
        this.freq = freq;
    }

    @Override
    public List<Integer> getPositions() {
        //这里考虑到拷贝的性能问题
        return positions;
    }

    @Override
    public void setPositions(List<Integer> positions) {
        this.positions = positions;
    }

    @Override
    public int compareTo(AbstractPosting o) {
        return this.docId > o.getDocId() ? 1:-1;
    }

    @Override
    public void sort() {
        positions.sort(Integer::compareTo);
    }

    @Override
    public void writeObject(ObjectOutputStream out) {
        try{
            out.writeObject(docId);
            out.writeObject(freq);
            out.writeObject(positions.size());
            for (int i:positions){
                out.writeObject(i);
            }
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void readObject(ObjectInputStream in) {
        try {
            docId = (int) in.readObject();
            freq = (int) in.readObject();
            int size = (int) in.readObject();
            positions.clear();
            for (int i = 0; i < size ; i++) {
                positions.add( (int) in.readObject());
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
