package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleFilter;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.util.StopWords;

import java.util.HashSet;
import java.util.Set;
public class TermTupleFilter extends AbstractTermTupleFilter {
    private Set<String> stopWords;
    public TermTupleFilter(AbstractTermTupleStream input) {
        super(input);
        stopWords = new HashSet<>();
        for(String s: StopWords.STOP_WORDS){
            stopWords.add(s);
        }
    }

    @Override
    public AbstractTermTuple next() {
        AbstractTermTuple tuple = null;
        tuple = input.next();
        while(tuple != null && stopWords.contains(tuple.term.getContent())){
            tuple = input.next();
        }
        return tuple;
    }

}