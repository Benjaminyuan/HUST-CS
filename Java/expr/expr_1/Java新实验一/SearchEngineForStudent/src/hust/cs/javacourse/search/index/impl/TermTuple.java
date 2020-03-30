package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.AbstractTerm;
import hust.cs.javacourse.search.index.AbstractTermTuple;

public class TermTuple extends AbstractTermTuple {
    @Override
    public boolean equals(Object obj) {
        if(obj instanceof AbstractTermTuple){
            AbstractTermTuple t = (AbstractTermTuple) obj;
            return t.curPos == this.curPos && t.term == this.term;
        }
        return false;
    }

    @Override
    public String toString() {
        return "curPos: "+curPos+",term: "+term;
    }
}
