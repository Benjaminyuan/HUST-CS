package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;

public class TermTuple extends AbstractTermTuple {
    @Override
    public boolean equals(Object obj) {
        if(obj instanceof AbstractTermTuple){
            AbstractTermTuple t = (AbstractTermTuple) obj;
            return t.curPos == this.curPos && t.term.equals(this.term);
        }
        return false;
    }
    @Override
    public int hashCode() {
        return this.term.hashCode();
    }
    @Override
    public String toString() {
        return String.format("curPos: %d, freq: %d, %s",curPos,freq,term);
    }
}
