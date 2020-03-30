package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractPosting;

import javax.imageio.IIOException;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Posting extends AbstractPosting {
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
        positions.forEach(pos -> s.append(pos).append(", "));
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
        return new ArrayList<>(positions);
    }

    @Override
    public void setPositions(List<Integer> positions) {
        this.positions = new ArrayList<>(positions);
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
            out.writeInt(docId);
            out.writeInt(freq);
            out.writeInt(positions.size());
            for (int i:positions){
                out.writeInt(i);
            }
        }catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void readObject(ObjectInputStream in) {
        try {
            docId = in.readInt();
            freq = in.readInt();
            int size = in.readInt();
            positions.clear();
            for (int i = 0; i < size ; i++) {
                positions.add(in.readInt());
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
